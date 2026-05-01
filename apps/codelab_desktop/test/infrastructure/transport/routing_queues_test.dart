import 'dart:async';

import 'package:codelab_desktop/infrastructure/transport/routing_queues.dart';
import 'package:test/test.dart';

void main() {
  late RoutingQueues queues;

  setUp(() {
    queues = RoutingQueues();
  });

  tearDown(() async {
    await queues.dispose();
  });

  group('RoutingQueues', () {
    test('creates and retrieves response stream', () async {
      final stream = queues.getOrCreateResponseStream('req-1');
      expect(stream, isA<Stream>());

      final completer = Completer<Map<String, dynamic>>();
      stream.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      queues.putResponse('req-1', {'result': 'ok'});

      final result = await completer.future.timeout(
        const Duration(seconds: 1),
      );
      expect(result['result'], 'ok');
    });

    test('broadcasts notifications', () async {
      final completer = Completer<Map<String, dynamic>>();

      queues.notifications.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      queues.putNotification({'method': 'session/update'});

      final result = await completer.future.timeout(
        const Duration(seconds: 1),
      );
      expect(result['method'], 'session/update');
    });

    test('broadcasts permission requests', () async {
      final completer = Completer<Map<String, dynamic>>();

      queues.permissionRequests.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      queues.putPermissionRequest({'method': 'session/request_permission'});

      final result = await completer.future.timeout(
        const Duration(seconds: 1),
      );
      expect(result['method'], 'session/request_permission');
    });

    test('cleanup closes response queue', () {
      final stream = queues.getOrCreateResponseStream('req-1');
      queues.cleanupResponseQueue('req-1');

      final secondStream = queues.getOrCreateResponseStream('req-1');
      expect(secondStream, isNot(same(stream)));
    });

    test('dispose closes all controllers', () async {
      queues.getOrCreateResponseStream('req-1');
      queues.getOrCreateResponseStream('req-2');

      await queues.dispose();

      expect(queues.notifications, emitsDone);
    });
  });
}
