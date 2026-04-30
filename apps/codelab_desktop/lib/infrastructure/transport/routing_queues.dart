import 'dart:async';

/// Набор очередей для маршрутизации входящих сообщений
///
/// Аналог Python: infrastructure/services/routing_queues.py
class RoutingQueues {
  RoutingQueues();

  final Map<String, StreamController<Map<String, dynamic>>> _responseQueues = {};

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController.broadcast();

  final StreamController<Map<String, dynamic>> _permissionController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get notifications =>
      _notificationController.stream;

  Stream<Map<String, dynamic>> get permissionRequests =>
      _permissionController.stream;

  /// Получает или создаёт очередь ответов для request_id
  Stream<Map<String, dynamic>> getOrCreateResponseStream(String requestId) {
    if (!_responseQueues.containsKey(requestId)) {
      _responseQueues[requestId] =
          StreamController<Map<String, dynamic>>.broadcast();
    }
    return _responseQueues[requestId]!.stream;
  }

  /// Добавляет ответ в очередь для request_id
  void putResponse(String requestId, Map<String, dynamic> message) {
    final controller = _responseQueues[requestId];
    if (controller != null && !controller.isClosed) {
      controller.add(message);
    }
  }

  /// Добавляет notification в общую очередь
  void putNotification(Map<String, dynamic> message) {
    if (!_notificationController.isClosed) {
      _notificationController.add(message);
    }
  }

  /// Добавляет permission request в отдельную очередь
  void putPermissionRequest(Map<String, dynamic> message) {
    if (!_permissionController.isClosed) {
      _permissionController.add(message);
    }
  }

  /// Удаляет очередь ответов для request_id (cleanup после получения ответа)
  void cleanupResponseQueue(String requestId) {
    final controller = _responseQueues.remove(requestId);
    controller?.close();
  }

  /// Закрывает все очереди
  Future<void> dispose() async {
    for (final controller in _responseQueues.values) {
      await controller.close();
    }
    _responseQueues.clear();
    await _notificationController.close();
    await _permissionController.close();
  }
}
