import 'package:structured_log/structured_log.dart';

import 'routing_queues.dart';

/// Маршрутизатор входящих JSON-RPC сообщений
///
/// Определяет тип сообщения и направляет в соответствующую очередь.
/// Аналог Python: infrastructure/services/message_router.py
class MessageRouter {
  MessageRouter(this._queues);

  final _log = getLogger('MessageRouter');
  final RoutingQueues _queues;

  /// Маршрутизирует входящее сообщение
  void route(Map<String, dynamic> message) {
    final method = message['method'] as String?;
    final id = message['id'];

    if (method != null) {
      if (method == 'session/update') {
        _log.debug('msg_route_notification', context: {
          'message_type': 'notification',
          'method': method,
          'id': id,
        });
        _queues.putNotification(message);
      } else if (method == 'session/request_permission') {
        _log.debug('msg_route_permission', context: {
          'message_type': 'permission_request',
          'method': method,
          'id': id,
        });
        _queues.putPermissionRequest(message);
      } else if (id != null) {
        _log.debug('msg_route_notification_with_id', context: {
          'message_type': 'notification',
          'method': method,
          'id': id,
        });
        _queues.putNotification(message);
      } else {
        _log.debug('msg_route_notification_no_id', context: {
          'message_type': 'notification',
          'method': method,
        });
        _queues.putNotification(message);
      }
    } else if (id != null) {
      final requestId = id.toString();
      _log.debug('msg_route_response', context: {
        'message_type': 'response',
        'request_id': requestId,
      });
      _queues.putResponse(requestId, message);
    } else {
      _log.warning('msg_route_unrecognized', context: {
        'method': method,
        'id': id,
      });
    }
  }
}
