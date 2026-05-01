import 'dart:async';

import 'package:codelab_desktop/infrastructure/transport/message_router.dart';
import 'package:codelab_desktop/infrastructure/transport/routing_queues.dart';
import 'package:test/test.dart';

void main() {
  late RoutingQueues queues;
  late MessageRouter router;

  setUp(() {
    queues = RoutingQueues();
    router = MessageRouter(queues);
  });

  tearDown(() async {
    await queues.dispose();
  });

  group('MessageRouter', () {
    test('routes response messages to response queue', () async {
      final stream = queues.getOrCreateResponseStream('test-123');
      final completer = Completer<Map<String, dynamic>>();

      stream.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      router.route({
        'jsonrpc': '2.0',
        'id': 'test-123',
        'result': {'status': 'ok'},
      });

      final result = await completer.future.timeout(
        const Duration(seconds: 1),
      );

      expect(result['result'], {'status': 'ok'});
    });

    test('routes session/update notifications to notification queue', () async {
      final completer = Completer<Map<String, dynamic>>();

      queues.notifications.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      router.route({
        'jsonrpc': '2.0',
        'method': 'session/update',
        'params': {'sessionId': 'test'},
      });

      final result = await completer.future.timeout(
        const Duration(seconds: 1),
      );

      expect(result['method'], 'session/update');
    });

    test('routes permission requests to permission queue', () async {
      final completer = Completer<Map<String, dynamic>>();

      queues.permissionRequests.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      router.route({
        'jsonrpc': '2.0',
        'method': 'session/request_permission',
        'id': 'perm-1',
        'params': {},
      });

      final result = await completer.future.timeout(
        const Duration(seconds: 1),
      );

      expect(result['method'], 'session/request_permission');
    });
  });
}
