import 'routing_queues.dart';

/// Маршрутизатор входящих JSON-RPC сообщений
///
/// Определяет тип сообщения и направляет в соответствующую очередь.
/// Аналог Python: infrastructure/services/message_router.py
class MessageRouter {
  MessageRouter(this._queues);

  final RoutingQueues _queues;

  /// Маршрутизирует входящее сообщение
  void route(Map<String, dynamic> message) {
    final method = message['method'] as String?;
    final id = message['id'];

    if (method != null) {
      if (method == 'session/update') {
        _queues.putNotification(message);
      } else if (method == 'session/request_permission') {
        _queues.putPermissionRequest(message);
      } else if (id != null) {
        _queues.putNotification(message);
      } else {
        _queues.putNotification(message);
      }
    } else if (id != null) {
      final requestId = id.toString();
      _queues.putResponse(requestId, message);
    }
  }
}
