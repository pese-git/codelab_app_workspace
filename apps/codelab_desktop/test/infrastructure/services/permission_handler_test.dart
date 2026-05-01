import 'dart:async';

import 'package:codelab_desktop/domain/entities/permission.dart';
import 'package:codelab_desktop/infrastructure/services/permission_handler.dart';
import 'package:codelab_desktop/infrastructure/transport/websocket_transport.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWebSocketTransport extends Mock implements WebSocketTransport {}

void main() {
  late PermissionHandler handler;
  late MockWebSocketTransport mockTransport;

  setUp(() {
    handler = PermissionHandler();
    mockTransport = MockWebSocketTransport();
    when(() => mockTransport.sendMessage(any())).thenAnswer((_) async {});
  });

  group('PermissionHandler', () {
    test('resolves permission with selected option', () async {
      final message = {
        'id': 'perm-1',
        'params': {
          'sessionId': 'session-1',
          'toolCall': {
            'toolCallId': 'tool-1',
            'title': 'Read file',
            'kind': 'read',
          },
          'options': [
            {'optionId': 'allow_once', 'name': 'Allow once', 'kind': 'allow_once'},
            {'optionId': 'reject_once', 'name': 'Reject', 'kind': 'reject_once'},
          ],
        },
      };

      final requestCompleter = Completer<PendingPermissionRequest>();

      handler.setUiCallback((request) {
        requestCompleter.complete(request);
      });

      unawaited(handler.handleRaw(message, mockTransport));

      final request = await requestCompleter.future.timeout(
        const Duration(seconds: 1),
      );

      expect(request.requestId, 'perm-1');
      expect(request.sessionId, 'session-1');
      expect(request.toolCall.toolCallId, 'tool-1');
      expect(request.options, hasLength(2));

      handler.resolve('perm-1', 'allow_once');

      await Future.delayed(const Duration(milliseconds: 200));

      verify(
        () => mockTransport.sendMessage(any()),
      ).called(1);
    });

    test('auto-cancels when no UI callback set', () async {
      final message = {
        'id': 'perm-3',
        'params': {
          'sessionId': 'session-1',
          'toolCall': {
            'toolCallId': 'tool-3',
            'title': 'Execute command',
            'kind': 'execute',
          },
          'options': [],
        },
      };

      await handler.handleRaw(message, mockTransport);

      expect(handler.pendingRequests, isEmpty);
    });
  });
}
