import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:structured_log/structured_log.dart';

import '../../domain/entities/connection_state.dart';

import 'reconnection_policy.dart';

/// Параметры подключения к ACP серверу
class AcpServerConfig {
  const AcpServerConfig({
    required this.host,
    required this.port,
    this.path = '/ws',
    this.connectTimeout = const Duration(seconds: 30),
    this.autoReconnect = true,
  });

  final String host;
  final int port;
  final String path;
  final Duration connectTimeout;
  final bool autoReconnect;

  Uri get uri => Uri(scheme: 'ws', host: host, port: port, path: path);
}

/// Низкоуровневый WebSocket транспорт
///
/// Аналог Python: infrastructure/transport.py::WebSocketTransport
/// Отвечает ТОЛЬКО за соединение и передачу строк.
/// Никакой бизнес-логики здесь нет.
class WebSocketTransport {
  WebSocketTransport({
    required this.config,
    ReconnectionPolicy? reconnectionPolicy,
  }) : _reconnectionPolicy = reconnectionPolicy ?? ReconnectionPolicy();

  final _log = getLogger('WebSocketTransport');
  final AcpServerConfig config;
  final ReconnectionPolicy _reconnectionPolicy;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  ConnectionState _connectionState = ConnectionState.disconnected;
  Timer? _reconnectTimer;
  bool _disposed = false;

  final StreamController<Map<String, dynamic>> _incomingController =
      StreamController.broadcast();

  final StreamController<ConnectionState> _stateController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get incomingMessages =>
      _incomingController.stream;

  Stream<ConnectionState> get connectionStateStream =>
      _stateController.stream;

  ConnectionState get connectionState => _connectionState;

  bool get isConnected => _connectionState == ConnectionState.connected;

  /// Устанавливает WebSocket соединение
  Future<void> connect() async {
    if (_connectionState == ConnectionState.connected) {
      _log.debug('Already connected to ${config.uri}');
      return;
    }

    _reconnectionPolicy.reset();
    await _attemptConnect();
  }

  /// Отправляет JSON сообщение
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!isConnected || _channel == null) {
      throw StateError('Not connected to server');
    }

    try {
      final json = jsonEncode(message);
      _channel!.sink.add(json);
      _log.debug('Sent: ${message['method'] ?? 'response'} id=${message['id']}');
    } catch (e) {
      _log.error('Failed to send message: $e');
      rethrow;
    }
  }

  /// Закрывает соединение
  Future<void> disconnect() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectionPolicy.reset();

    await _closeConnection();
    _updateState(ConnectionState.disconnected);
    _log.info('Disconnected from ${config.uri}');
  }

  /// Принудительное переподключение
  Future<void> reconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectionPolicy.reset();

    await _closeConnection();
    await _attemptConnect();
  }

  void _updateState(ConnectionState state) {
    _connectionState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  Future<void> _attemptConnect() async {
    if (_disposed) return;

    _updateState(ConnectionState.connecting);

    try {
      _log.debug('Connecting to ${config.uri}');
      _channel = WebSocketChannel.connect(config.uri);

      await _channel!.ready;

      _updateState(ConnectionState.connected);
      _log.info('Connected to ${config.uri}');

      _subscription = _channel!.stream.listen(
        _handleIncoming,
        onError: _handleError,
        onDone: _handleDone,
        cancelOnError: false,
      );
    } catch (e) {
      _log.error('Failed to connect to ${config.uri}: $e');
      _handleConnectionFailure(e);
    }
  }

  void _handleConnectionFailure(Object error) {
    if (_disposed) return;

    if (!config.autoReconnect) {
      _updateState(ConnectionState.disconnected);
      _incomingController.addError(error);
      return;
    }

    _updateState(ConnectionState.reconnecting);

    final delay = _reconnectionPolicy.getNextDelay();

    if (_reconnectionPolicy.hasReachedMaxRetries()) {
      _log.error(
        'Max reconnection attempts reached. Giving up.',
      );
      _updateState(ConnectionState.disconnected);
      _incomingController.addError(error);
      return;
    }

    _log.info(
      'Reconnecting in ${delay.inSeconds}s '
      '(attempt ${_reconnectionPolicy.attempt}/${_reconnectionPolicy.maxRetries})',
    );

    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      _attemptConnect();
    });
  }

  void _handleIncoming(dynamic raw) {
    try {
      final decoded = jsonDecode(raw as String) as Map<String, dynamic>;
      _incomingController.add(decoded);
    } catch (e) {
      _log.warning('Failed to parse incoming message: $e');
    }
  }

  void _handleError(Object error) {
    _log.error('WebSocket error: $error');
    _handleConnectionFailure(error);
  }

  void _handleDone() {
    _log.info('WebSocket connection closed');
    if (!_disposed && config.autoReconnect) {
      _handleConnectionFailure('Connection closed');
    } else {
      _updateState(ConnectionState.disconnected);
    }
  }

  Future<void> _closeConnection() async {
    try {
      await _subscription?.cancel();
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (e) {
      _log.warning('Error during close: $e');
    } finally {
      _channel = null;
      _subscription = null;
    }
  }

  Future<void> dispose() async {
    await disconnect();
    await _incomingController.close();
    await _stateController.close();
  }
}
