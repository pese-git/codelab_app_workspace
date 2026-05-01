import 'dart:async';

import 'package:codelab_desktop/domain/entities/permission.dart';
import 'package:codelab_desktop/infrastructure/dto/tool_call.dart';
import 'package:codelab_desktop/infrastructure/services/permission_handler.dart';
import 'package:codelab_desktop/infrastructure/transport/websocket_transport.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockTransport extends Mock implements WebSocketTransport {}

void main() {
  group('PermissionHandler', () {
    late PermissionHandler handler;
    late MockTransport mockTransport;

    setUp(() {
      handler = PermissionHandler();
      mockTransport = MockTransport();
      when(() => mockTransport.sendMessage(any())).thenAnswer((_) async {});
    });

    test('receives permission request via callback', () async {
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
          ],
        },
      };

      final completer = Completer<PendingPermissionRequest>();

      handler.setUiCallback((req) {
        completer.complete(req);
      });

      handler.handleRaw(message, mockTransport);

      final req = await completer.future.timeout(const Duration(seconds: 1));
      expect(req.requestId, 'perm-1');
      expect(req.sessionId, 'session-1');
      expect(req.toolCall.toolCallId, 'tool-1');
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
