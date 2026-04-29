import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_call.freezed.dart';
part 'tool_call.g.dart';

enum ToolKind {
  @JsonValue('read') read,
  @JsonValue('edit') edit,
  @JsonValue('delete') delete,
  @JsonValue('move') move,
  @JsonValue('search') search,
  @JsonValue('execute') execute,
  @JsonValue('think') think,
  @JsonValue('fetch') fetch,
  @JsonValue('switch_mode') switchMode,
  @JsonValue('other') other,
}

enum ToolCallStatus {
  @JsonValue('pending') pending,
  @JsonValue('in_progress') inProgress,
  @JsonValue('completed') completed,
  @JsonValue('failed') failed,
  @JsonValue('cancelled') cancelled,
}

@freezed
abstract class ToolCallLocation with _$ToolCallLocation {
  const factory ToolCallLocation({
    required String path,
    int? line,
  }) = _ToolCallLocation;

  factory ToolCallLocation.fromJson(Map<String, dynamic> json) =>
      _$ToolCallLocationFromJson(json);
}

@freezed
abstract class ToolCallDiffContent with _$ToolCallDiffContent {
  const factory ToolCallDiffContent({
    @Default('diff') String type,
    required String path,
    required String newText,
    String? oldText,
  }) = _ToolCallDiffContent;

  factory ToolCallDiffContent.fromJson(Map<String, dynamic> json) =>
      _$ToolCallDiffContentFromJson(json);
}

@freezed
abstract class ToolCallTerminalContent with _$ToolCallTerminalContent {
  const factory ToolCallTerminalContent({
    @Default('terminal') String type,
    required String terminalId,
  }) = _ToolCallTerminalContent;

  factory ToolCallTerminalContent.fromJson(Map<String, dynamic> json) =>
      _$ToolCallTerminalContentFromJson(json);
}

Object? parseToolCallContent(Map<String, dynamic> json) {
  return switch (json['type'] as String?) {
    'diff' => ToolCallDiffContent.fromJson(json),
    'terminal' => ToolCallTerminalContent.fromJson(json),
    'content' => json['content'],
    _ => null,
  };
}

@freezed
abstract class ToolCallCreatedUpdate with _$ToolCallCreatedUpdate {
  const factory ToolCallCreatedUpdate({
    @Default('tool_call') String sessionUpdate,
    required String toolCallId,
    required String title,
    ToolKind? kind,
    ToolCallStatus? status,
    List<Map<String, dynamic>>? content,
    List<ToolCallLocation>? locations,
    Map<String, dynamic>? rawInput,
    Map<String, dynamic>? rawOutput,
  }) = _ToolCallCreatedUpdate;

  factory ToolCallCreatedUpdate.fromJson(Map<String, dynamic> json) =>
      _$ToolCallCreatedUpdateFromJson(json);
}

@freezed
abstract class ToolCallStateUpdate with _$ToolCallStateUpdate {
  const factory ToolCallStateUpdate({
    @Default('tool_call_update') String sessionUpdate,
    required String toolCallId,
    ToolCallStatus? status,
    String? title,
    ToolKind? kind,
    List<Map<String, dynamic>>? content,
    List<ToolCallLocation>? locations,
    Map<String, dynamic>? rawInput,
    Map<String, dynamic>? rawOutput,
  }) = _ToolCallStateUpdate;

  factory ToolCallStateUpdate.fromJson(Map<String, dynamic> json) =>
      _$ToolCallStateUpdateFromJson(json);
}
