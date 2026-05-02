import 'dart:async';

import 'package:structured_log/structured_log.dart';

/// Набор очередей для маршрутизации входящих сообщений
///
/// Аналог Python: infrastructure/services/routing_queues.py
class RoutingQueues {
  RoutingQueues();

  final _log = getLogger('RoutingQueues');
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
      _log.debug('queue_response_created', context: {
        'queue_type': 'response',
        'request_id': requestId,
        'total_queues': _responseQueues.length,
      });
    }
    return _responseQueues[requestId]!.stream;
  }

  /// Добавляет ответ в очередь для request_id
  void putResponse(String requestId, Map<String, dynamic> message) {
    final controller = _responseQueues[requestId];
    if (controller != null && !controller.isClosed) {
      controller.add(message);
      _log.debug('queue_response_added', context: {
        'queue_type': 'response',
        'request_id': requestId,
        'has_result': message.containsKey('result'),
        'has_error': message.containsKey('error'),
      });
    } else {
      _log.warning('queue_response_orphaned', context: {
        'queue_type': 'response',
        'request_id': requestId,
        'controller_exists': controller != null,
        'controller_closed': controller?.isClosed,
      });
    }
  }

  /// Добавляет notification в общую очередь
  void putNotification(Map<String, dynamic> message) {
    if (!_notificationController.isClosed) {
      _notificationController.add(message);
      _log.debug('queue_notification_added', context: {
        'queue_type': 'notification',
        'method': message['method'],
      });
    } else {
      _log.warning('queue_notification_dropped', context: {
        'queue_type': 'notification',
        'reason': 'controller_closed',
      });
    }
  }

  /// Добавляет permission request в отдельную очередь
  void putPermissionRequest(Map<String, dynamic> message) {
    if (!_permissionController.isClosed) {
      _permissionController.add(message);
      _log.debug('queue_permission_added', context: {
        'queue_type': 'permission',
        'method': message['method'],
      });
    } else {
      _log.warning('queue_permission_dropped', context: {
        'queue_type': 'permission',
        'reason': 'controller_closed',
      });
    }
  }

  /// Удаляет очередь ответов для request_id (cleanup после получения ответа)
  void cleanupResponseQueue(String requestId) {
    final controller = _responseQueues.remove(requestId);
    if (controller != null) {
      controller.close();
      _log.debug('queue_response_cleaned', context: {
        'queue_type': 'response',
        'request_id': requestId,
        'remaining_queues': _responseQueues.length,
      });
    }
  }

  /// Закрывает все очереди
  Future<void> dispose() async {
    _log.info('queue_dispose_start', context: {
      'response_queues_count': _responseQueues.length,
    });
    for (final controller in _responseQueues.values) {
      await controller.close();
    }
    _responseQueues.clear();
    await _notificationController.close();
    await _permissionController.close();
    _log.info('queue_dispose_complete');
  }
}
