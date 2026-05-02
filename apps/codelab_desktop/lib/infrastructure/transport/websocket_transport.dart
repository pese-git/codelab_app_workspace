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

  static const _payloadPreviewLimit = 200;

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
      _log.debug('ws_already_connected', context: {
        'uri': config.uri.toString(),
        'connection_state': _connectionState.name,
      });
      return;
    }

    _log.info('ws_connect', context: {
      'uri': config.uri.toString(),
      'auto_reconnect': config.autoReconnect,
    });

    _reconnectionPolicy.reset();
    await _attemptConnect();
  }

  /// Отправляет JSON сообщение
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!isConnected || _channel == null) {
      _log.error('Cannot send: not connected', context: {
        'connection_state': _connectionState.name,
        'has_channel': _channel != null,
      });
      throw StateError('Not connected to server');
    }

    try {
      final json = jsonEncode(message);
      _channel!.sink.add(json);
      _log.debug('ws_send', context: {
        'direction': 'send',
        'method': message['method'],
        'id': message['id'],
        'has_result': message.containsKey('result'),
        'has_error': message.containsKey('error'),
        'payload_size_bytes': json.length,
        'payload_preview': _truncatePayload(json),
      });
    } catch (e, st) {
      _log.error('ws_send_failed', context: {
        'direction': 'send',
        'method': message['method'],
        'id': message['id'],
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
      rethrow;
    }
  }

  /// Закрывает соединение
  Future<void> disconnect() async {
    _log.info('ws_disconnect', context: {
      'uri': config.uri.toString(),
      'current_state': _connectionState.name,
    });

    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectionPolicy.reset();

    await _closeConnection();
    _updateState(ConnectionState.disconnected);
    _log.info('ws_disconnected', context: {
      'uri': config.uri.toString(),
    });
  }

  /// Принудительное переподключение
  Future<void> reconnect() async {
    _log.info('ws_reconnect_requested', context: {
      'uri': config.uri.toString(),
    });

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

  static String _truncatePayload(String payload) {
    if (payload.length <= _payloadPreviewLimit) return payload;
    return '${payload.substring(0, _payloadPreviewLimit)}...';
  }

  Future<void> _attemptConnect() async {
    if (_disposed) return;

    _updateState(ConnectionState.connecting);

    try {
      _log.debug('ws_connecting', context: {
        'uri': config.uri.toString(),
      });
      _channel = WebSocketChannel.connect(config.uri);

      await _channel!.ready;

      _updateState(ConnectionState.connected);
      _log.info('ws_connected', context: {
        'uri': config.uri.toString(),
        'connection_state': _connectionState.name,
      });

      _subscription = _channel!.stream.listen(
        _handleIncoming,
        onError: _handleError,
        onDone: _handleDone,
        cancelOnError: false,
      );
    } catch (e, st) {
      _log.error('ws_connect_failed', context: {
        'uri': config.uri.toString(),
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
      _handleConnectionFailure(e);
    }
  }

  void _handleConnectionFailure(Object error) {
    if (_disposed) return;

    if (!config.autoReconnect) {
      _log.error('ws_connection_failed_no_reconnect', context: {
        'uri': config.uri.toString(),
        'error': error.toString(),
      });
      _updateState(ConnectionState.disconnected);
      _incomingController.addError(error);
      return;
    }

    _updateState(ConnectionState.reconnecting);

    final delay = _reconnectionPolicy.getNextDelay();

    if (_reconnectionPolicy.hasReachedMaxRetries()) {
      _log.error('ws_max_retries_reached', context: {
        'uri': config.uri.toString(),
        'max_retries': _reconnectionPolicy.maxRetries,
        'error': error.toString(),
      });
      _updateState(ConnectionState.disconnected);
      _incomingController.addError(error);
      return;
    }

    _log.info('ws_reconnecting', context: {
      'uri': config.uri.toString(),
      'delay_seconds': delay.inSeconds,
      'attempt': _reconnectionPolicy.attempt,
      'max_retries': _reconnectionPolicy.maxRetries,
    });

    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      _attemptConnect();
    });
  }

  void _handleIncoming(dynamic raw) {
    try {
      final decoded = jsonDecode(raw as String) as Map<String, dynamic>;
      final method = decoded['method'] as String?;
      final id = decoded['id'];
      final hasResult = decoded.containsKey('result');
      final hasError = decoded.containsKey('error');
      final rawSize = raw.length;

      _log.debug('ws_recv', context: {
        'direction': 'recv',
        'method': method,
        'id': id,
        'has_result': hasResult,
        'has_error': hasError,
        'payload_size_bytes': rawSize,
        'payload_preview': _truncatePayload(raw),
      });

      _incomingController.add(decoded);
    } catch (e, st) {
      _log.warning('ws_recv_parse_failed', context: {
        'direction': 'recv',
        'error': e.toString(),
        'stack_trace': st.toString(),
        'raw_preview': raw.toString().substring(0, raw.toString().length > 200 ? 200 : raw.toString().length),
      });
    }
  }

  void _handleError(Object error) {
    _log.error('ws_error', context: {
      'error': error.toString(),
    });
    _handleConnectionFailure(error);
  }

  void _handleDone() {
    _log.info('ws_connection_closed', context: {
      'disposed': _disposed,
      'auto_reconnect': config.autoReconnect,
    });
    if (!_disposed && config.autoReconnect) {
      _handleConnectionFailure('Connection closed');
    } else {
      _updateState(ConnectionState.disconnected);
    }
  }

  Future<void> _closeConnection() async {
    try {
      _log.debug('ws_closing', context: {
        'has_channel': _channel != null,
        'has_subscription': _subscription != null,
      });
      await _subscription?.cancel();
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (e, st) {
      _log.warning('ws_close_error', context: {
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
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
