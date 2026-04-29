import 'package:freezed_annotation/freezed_annotation.dart';

import '../../infrastructure/dto/tool_call.dart';

part 'tool_call_record.freezed.dart';

@freezed
abstract class ToolCallRecord with _$ToolCallRecord {
  const factory ToolCallRecord({
    required String toolCallId,
    required String title,
    required ToolCallStatus status,
    ToolKind? kind,
    List<Map<String, dynamic>>? content,
    List<ToolCallLocation>? locations,
    Map<String, dynamic>? rawInput,
    Map<String, dynamic>? rawOutput,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ToolCallRecord;

  const ToolCallRecord._();

  factory ToolCallRecord.fromDto(ToolCallCreatedUpdate dto) {
    return ToolCallRecord(
      toolCallId: dto.toolCallId,
      title: dto.title,
      status: dto.status ?? ToolCallStatus.pending,
      kind: dto.kind,
      content: dto.content,
      locations: dto.locations,
      rawInput: dto.rawInput,
      rawOutput: dto.rawOutput,
      createdAt: DateTime.now().toUtc(),
    );
  }

  ToolCallRecord applyUpdate(ToolCallStateUpdate update) {
    return copyWith(
      status: update.status ?? status,
      title: update.title ?? title,
      kind: update.kind ?? kind,
      content: update.content ?? content,
      locations: update.locations ?? locations,
      rawInput: update.rawInput ?? rawInput,
      rawOutput: update.rawOutput ?? rawOutput,
      completedAt: (update.status == ToolCallStatus.completed ||
              update.status == ToolCallStatus.failed)
          ? DateTime.now().toUtc()
          : completedAt,
    );
  }

  bool get isCompleted =>
      status == ToolCallStatus.completed ||
      status == ToolCallStatus.failed ||
      status == ToolCallStatus.cancelled;
}
