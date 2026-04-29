import 'package:freezed_annotation/freezed_annotation.dart';

import 'tool_call_domain.dart';
import '../../infrastructure/dto/tool_call.dart' as dto;

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

  factory ToolCallRecord.fromDto(dto.ToolCallCreatedUpdate d) {
    return ToolCallRecord(
      toolCallId: d.toolCallId,
      title: d.title,
      status: _mapStatus(d.status) ?? ToolCallStatus.pending,
      kind: _mapKind(d.kind),
      content: d.content,
      locations: d.locations?.map((l) => ToolCallLocation(path: l.path, line: l.line)).toList(),
      rawInput: d.rawInput,
      rawOutput: d.rawOutput,
      createdAt: DateTime.now().toUtc(),
    );
  }

  ToolCallRecord applyUpdate(dto.ToolCallStateUpdate d) {
    return copyWith(
      status: _mapStatus(d.status) ?? status,
      title: d.title ?? title,
      kind: _mapKind(d.kind) ?? kind,
      content: d.content ?? content,
      locations: d.locations?.map((l) => ToolCallLocation(path: l.path, line: l.line)).toList() ?? locations,
      rawInput: d.rawInput ?? rawInput,
      rawOutput: d.rawOutput ?? rawOutput,
      completedAt: (d.status == dto.ToolCallStatus.completed || d.status == dto.ToolCallStatus.failed)
          ? DateTime.now().toUtc()
          : completedAt,
    );
  }

  bool get isCompleted =>
      status == ToolCallStatus.completed ||
      status == ToolCallStatus.failed ||
      status == ToolCallStatus.cancelled;

  static ToolCallStatus? _mapStatus(dto.ToolCallStatus? s) => switch (s) {
        dto.ToolCallStatus.pending => ToolCallStatus.pending,
        dto.ToolCallStatus.inProgress => ToolCallStatus.inProgress,
        dto.ToolCallStatus.completed => ToolCallStatus.completed,
        dto.ToolCallStatus.failed => ToolCallStatus.failed,
        dto.ToolCallStatus.cancelled => ToolCallStatus.cancelled,
        null => null,
      };

  static ToolKind? _mapKind(dto.ToolKind? k) => switch (k) {
        dto.ToolKind.read => ToolKind.read,
        dto.ToolKind.edit => ToolKind.edit,
        dto.ToolKind.delete => ToolKind.delete,
        dto.ToolKind.move => ToolKind.move,
        dto.ToolKind.search => ToolKind.search,
        dto.ToolKind.execute => ToolKind.execute,
        dto.ToolKind.think => ToolKind.think,
        dto.ToolKind.fetch => ToolKind.fetch,
        dto.ToolKind.switchMode => ToolKind.switchMode,
        dto.ToolKind.other => ToolKind.other,
        null => null,
      };
}
