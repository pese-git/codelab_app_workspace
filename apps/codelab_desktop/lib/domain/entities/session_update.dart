import 'package:freezed_annotation/freezed_annotation.dart';

import 'plan.dart';
import 'tool_call.dart';

part 'session_update.freezed.dart';
part 'session_update.g.dart';

@freezed
abstract class MessageChunkUpdate with _$MessageChunkUpdate {
  const factory MessageChunkUpdate({
    required String sessionUpdate,
    required Map<String, dynamic> content,
  }) = _MessageChunkUpdate;

  factory MessageChunkUpdate.fromJson(Map<String, dynamic> json) =>
      _$MessageChunkUpdateFromJson(json);

  const MessageChunkUpdate._();

  bool get isAgent => sessionUpdate == 'agent_message_chunk';

  String? get text {
    if (content['type'] == 'text') {
      return content['text'] as String?;
    }
    return null;
  }
}

@freezed
abstract class ThoughtChunkUpdate with _$ThoughtChunkUpdate {
  const factory ThoughtChunkUpdate({
    @Default('agent_thought_chunk') String sessionUpdate,
    required Map<String, dynamic> content,
  }) = _ThoughtChunkUpdate;

  factory ThoughtChunkUpdate.fromJson(Map<String, dynamic> json) =>
      _$ThoughtChunkUpdateFromJson(json);

  const ThoughtChunkUpdate._();

  String? get text {
    if (content['type'] == 'text') {
      return content['text'] as String?;
    }
    return null;
  }
}

@freezed
abstract class SessionInfoUpdate with _$SessionInfoUpdate {
  const factory SessionInfoUpdate({
    @Default('session_info_update') String sessionUpdate,
    String? title,
    String? updatedAt,
  }) = _SessionInfoUpdate;

  factory SessionInfoUpdate.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoUpdateFromJson(json);
}

@freezed
abstract class CurrentModeUpdate with _$CurrentModeUpdate {
  const factory CurrentModeUpdate({
    @Default('current_mode_update') String sessionUpdate,
    required String currentModeId,
  }) = _CurrentModeUpdate;

  factory CurrentModeUpdate.fromJson(Map<String, dynamic> json) =>
      _$CurrentModeUpdateFromJson(json);
}

@freezed
abstract class AvailableCommand with _$AvailableCommand {
  const factory AvailableCommand({
    required String name,
    required String description,
    Map<String, dynamic>? input,
  }) = _AvailableCommand;

  factory AvailableCommand.fromJson(Map<String, dynamic> json) =>
      _$AvailableCommandFromJson(json);
}

@freezed
abstract class AvailableCommandsUpdate with _$AvailableCommandsUpdate {
  const factory AvailableCommandsUpdate({
    @Default('available_commands_update') String sessionUpdate,
    required List<AvailableCommand> availableCommands,
  }) = _AvailableCommandsUpdate;

  factory AvailableCommandsUpdate.fromJson(Map<String, dynamic> json) =>
      _$AvailableCommandsUpdateFromJson(json);
}

@freezed
abstract class SessionUpdatePayload with _$SessionUpdatePayload {
  const factory SessionUpdatePayload({
    required String sessionUpdate,
    required Map<String, dynamic> raw,
  }) = _SessionUpdatePayload;

  factory SessionUpdatePayload.fromJson(Map<String, dynamic> json) =>
      SessionUpdatePayload(
        sessionUpdate: json['sessionUpdate'] as String,
        raw: json,
      );
}

@freezed
abstract class SessionUpdateParams with _$SessionUpdateParams {
  const factory SessionUpdateParams({
    required String sessionId,
    required SessionUpdatePayload update,
  }) = _SessionUpdateParams;

  factory SessionUpdateParams.fromJson(Map<String, dynamic> json) =>
      SessionUpdateParams(
        sessionId: json['sessionId'] as String,
        update: SessionUpdatePayload.fromJson(
          json['update'] as Map<String, dynamic>,
        ),
      );
}

class SessionUpdateParser {
  Object? parse(SessionUpdatePayload payload) {
    return switch (payload.sessionUpdate) {
      'agent_message_chunk' ||
      'user_message_chunk' =>
        MessageChunkUpdate.fromJson(payload.raw),
      'agent_thought_chunk' => ThoughtChunkUpdate.fromJson(payload.raw),
      'session_info_update' => SessionInfoUpdate.fromJson(payload.raw),
      'current_mode_update' => CurrentModeUpdate.fromJson(payload.raw),
      'available_commands_update' =>
        AvailableCommandsUpdate.fromJson(payload.raw),
      'tool_call' => ToolCallCreatedUpdate.fromJson(payload.raw),
      'tool_call_update' => ToolCallStateUpdate.fromJson(payload.raw),
      'plan' => PlanUpdate.fromJson(payload.raw),
      _ => null,
    };
  }
}
