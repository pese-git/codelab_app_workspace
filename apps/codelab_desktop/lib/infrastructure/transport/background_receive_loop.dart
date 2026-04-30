import 'dart:async';

import 'package:structured_log/structured_log.dart';

import 'message_router.dart';
import 'websocket_transport.dart';

/// Фоновый цикл получения сообщений от ACP сервера
///
/// Единственный потребитель WebSocket stream.
/// Перенаправляет все сообщения в MessageRouter.
/// Аналог Python: infrastructure/services/background_receive_loop.py
class BackgroundReceiveLoop {
  BackgroundReceiveLoop({
    required WebSocketTransport transport,
    required MessageRouter router,
  })  : _transport = transport,
        _router = router;

  final _log = getLogger('BackgroundReceiveLoop');
  final WebSocketTransport _transport;
  final MessageRouter _router;

  StreamSubscription<Map<String, dynamic>>? _subscription;
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  /// Запускает фоновый цикл получения сообщений
  void start() {
    if (_isRunning) {
      _log.debug('Background receive loop already running');
      return;
    }

    _isRunning = true;
    _log.debug('Starting background receive loop');

    _subscription = _transport.incomingMessages.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDone,
      cancelOnError: false,
    );

    _log.info('Background receive loop started');
  }

  /// Останавливает фоновый цикл
  Future<void> stop() async {
    if (!_isRunning) return;

    _isRunning = false;
    await _subscription?.cancel();
    _subscription = null;
    _log.info('Background receive loop stopped');
  }

  void _handleMessage(Map<String, dynamic> message) {
    try {
      final method = message['method'] as String?;
      final id = message['id'];
      _log.debug(
        'Received message: method=$method, id=$id',
      );
      _router.route(message);
    } catch (e) {
      _log.error('Error routing message: $e');
    }
  }

  void _handleError(Object error) {
    _log.error('Background loop error: $error');
    _isRunning = false;
  }

  void _handleDone() {
    _log.info('Background loop: stream closed');
    _isRunning = false;
  }
}
