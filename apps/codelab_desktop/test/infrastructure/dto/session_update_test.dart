import 'package:codelab_desktop/infrastructure/dto/session_update.dart';
import 'package:codelab_desktop/infrastructure/dto/tool_call.dart';
import 'package:codelab_desktop/infrastructure/dto/plan.dart';
import 'package:codelab_desktop/infrastructure/dto/usage.dart';
import 'package:test/test.dart';

void main() {
  group('SessionUpdateParser', () {
    late SessionUpdateParser parser;

    setUp(() {
      parser = SessionUpdateParser();
    });

    test('parses agent_message_chunk', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'agent_message_chunk',
        raw: {
          'sessionUpdate': 'agent_message_chunk',
          'content': {'type': 'text', 'text': 'Hello'},
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<MessageChunkUpdate>());
      expect((result as MessageChunkUpdate).text, 'Hello');
    });

    test('parses agent_thought_chunk', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'agent_thought_chunk',
        raw: {
          'sessionUpdate': 'agent_thought_chunk',
          'content': {'type': 'text', 'text': 'Thinking...'},
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<ThoughtChunkUpdate>());
      expect((result as ThoughtChunkUpdate).text, 'Thinking...');
    });

    test('parses session_info_update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'session_info_update',
        raw: {
          'sessionUpdate': 'session_info_update',
          'title': 'New Title',
          'updatedAt': '2024-01-01T00:00:00Z',
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<SessionInfoUpdate>());
      expect((result as SessionInfoUpdate).title, 'New Title');
    });

    test('parses tool_call', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'tool_call',
        raw: {
          'sessionUpdate': 'tool_call',
          'toolCallId': 'tc-1',
          'title': 'Read file',
          'kind': 'read',
          'status': 'pending',
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<ToolCallCreatedUpdate>());
      expect((result as ToolCallCreatedUpdate).toolCallId, 'tc-1');
    });

    test('parses tool_call_update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'tool_call_update',
        raw: {
          'sessionUpdate': 'tool_call_update',
          'toolCallId': 'tc-1',
          'status': 'completed',
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<ToolCallStateUpdate>());
      expect((result as ToolCallStateUpdate).toolCallId, 'tc-1');
    });

    test('parses plan update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'plan',
        raw: {
          'sessionUpdate': 'plan',
          'entries': [
            {
              'content': 'Task 1',
              'priority': 'high',
              'status': 'pending',
            },
          ],
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<PlanUpdate>());
      expect((result as PlanUpdate).entries, hasLength(1));
    });

    test('parses usage_update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'usage_update',
        raw: {
          'sessionUpdate': 'usage_update',
          'usage': {
            'inputTokens': 100,
            'outputTokens': 50,
            'totalTokens': 150,
            'cost': 0.002,
          },
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<UsageUpdate>());
      expect((result as UsageUpdate).usage.inputTokens, 100);
    });

    test('parses current_mode_update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'current_mode_update',
        raw: {
          'sessionUpdate': 'current_mode_update',
          'currentModeId': 'code',
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<CurrentModeUpdate>());
      expect((result as CurrentModeUpdate).currentModeId, 'code');
    });

    test('parses available_commands_update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'available_commands_update',
        raw: {
          'sessionUpdate': 'available_commands_update',
          'availableCommands': [
            {'name': '/help', 'description': 'Show help'},
          ],
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<AvailableCommandsUpdate>());
      expect((result as AvailableCommandsUpdate).availableCommands, hasLength(1));
    });

    test('parses config_option_update', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'config_option_update',
        raw: {
          'sessionUpdate': 'config_option_update',
          'key': 'model',
          'value': 'gpt-4',
        },
      );

      final result = parser.parse(payload);

      expect(result, isA<ConfigOptionUpdate>());
      expect((result as ConfigOptionUpdate).key, 'model');
    });

    test('returns null for unknown update type', () {
      final payload = SessionUpdatePayload(
        sessionUpdate: 'unknown_type',
        raw: {'sessionUpdate': 'unknown_type'},
      );

      final result = parser.parse(payload);

      expect(result, isNull);
    });
  });
}
