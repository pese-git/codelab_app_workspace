import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:structured_log/structured_log.dart';

/// Параметры подключения к ACP серверу
class AcpServerConfig {
  const AcpServerConfig({
    required this.host,
    required this.port,
    this.path = '/ws',
    this.connectTimeout = const Duration(seconds: 30),
  });

  final String host;
  final int port;
  final String path;
  final Duration connectTimeout;

  Uri get uri => Uri(scheme: 'ws', host: host, port: port, path: path);
}

/// Низкоуровневый WebSocket транспорт
///
/// Аналог Python: infrastructure/transport.py::WebSocketTransport
/// Отвечает ТОЛЬКО за соединение и передачу строк.
/// Никакой бизнес-логики здесь нет.
class WebSocketTransport {
  WebSocketTransport({required this.config});

  final _log = getLogger('WebSocketTransport');
  final AcpServerConfig config;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  bool _isConnected = false;

  final StreamController<Map<String, dynamic>> _incomingController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get incomingMessages =>
      _incomingController.stream;

  /// Устанавливает WebSocket соединение
  Future<void> connect() async {
    if (_isConnected) {
      _log.debug('Already connected to ${config.uri}');
      return;
    }

    try {
      _log.debug('Connecting to ${config.uri}');
      _channel = WebSocketChannel.connect(config.uri);

      // Ждём готовности соединения
      await _channel!.ready;

      _isConnected = true;
      _log.info('Connected to ${config.uri}');

      // Подписываемся на входящие сообщения
      _subscription = _channel!.stream.listen(
        _handleIncoming,
        onError: _handleError,
        onDone: _handleDone,
        cancelOnError: false,
      );
    } catch (e) {
      _isConnected = false;
      _channel = null;
      _log.error('Failed to connect to ${config.uri}: $e');
      rethrow;
    }
  }

  /// Отправляет JSON сообщение
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!_isConnected || _channel == null) {
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
    if (!_isConnected) return;

    try {
      await _subscription?.cancel();
      await _channel?.sink.close(ws_status.normalClosure);
      _log.info('Disconnected from ${config.uri}');
    } catch (e) {
      _log.warning('Error during disconnect: $e');
    } finally {
      _isConnected = false;
      _channel = null;
      _subscription = null;
    }
  }

  bool get isConnected => _isConnected;

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
    _isConnected = false;
    _incomingController.addError(error);
  }

  void _handleDone() {
    _log.info('WebSocket connection closed');
    _isConnected = false;
  }

  Future<void> dispose() async {
    await disconnect();
    await _incomingController.close();
  }
}
