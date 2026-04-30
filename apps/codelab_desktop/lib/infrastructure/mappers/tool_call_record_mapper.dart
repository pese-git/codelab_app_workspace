import '../../domain/entities/tool_call_record.dart';
import '../../domain/entities/tool_call_domain.dart' as domain;
import '../dto/tool_call.dart' as dto;

class ToolCallRecordMapper {
  static ToolCallRecord fromCreatedUpdate(dto.ToolCallCreatedUpdate d) {
    return ToolCallRecord(
      toolCallId: d.toolCallId,
      title: d.title,
      status: _mapStatus(d.status),
      kind: _mapKind(d.kind),
      content: d.content,
      locations: d.locations
          ?.map((l) => domain.ToolCallLocation(path: l.path, line: l.line))
          .toList(),
      rawInput: d.rawInput,
      rawOutput: d.rawOutput,
      createdAt: DateTime.now().toUtc(),
    );
  }

  static ToolCallRecord applyUpdate(
    ToolCallRecord record,
    dto.ToolCallStateUpdate d,
  ) {
    final isCompleting =
        d.status == dto.ToolCallStatus.completed ||
        d.status == dto.ToolCallStatus.failed;

    return record.update(
      status: _mapStatus(d.status),
      title: d.title,
      kind: _mapKind(d.kind),
      content: d.content,
      locations: d.locations
          ?.map((l) => domain.ToolCallLocation(path: l.path, line: l.line))
          .toList(),
      rawInput: d.rawInput,
      rawOutput: d.rawOutput,
    ).copyWith(
      completedAt: isCompleting ? DateTime.now().toUtc() : record.completedAt,
    );
  }

  static domain.ToolCallStatus _mapStatus(dto.ToolCallStatus? s) => switch (s) {
        dto.ToolCallStatus.pending => domain.ToolCallStatus.pending,
        dto.ToolCallStatus.inProgress => domain.ToolCallStatus.inProgress,
        dto.ToolCallStatus.completed => domain.ToolCallStatus.completed,
        dto.ToolCallStatus.failed => domain.ToolCallStatus.failed,
        dto.ToolCallStatus.cancelled => domain.ToolCallStatus.cancelled,
        null => domain.ToolCallStatus.pending,
      };

  static domain.ToolKind? _mapKind(dto.ToolKind? k) => switch (k) {
        dto.ToolKind.read => domain.ToolKind.read,
        dto.ToolKind.edit => domain.ToolKind.edit,
        dto.ToolKind.delete => domain.ToolKind.delete,
        dto.ToolKind.move => domain.ToolKind.move,
        dto.ToolKind.search => domain.ToolKind.search,
        dto.ToolKind.execute => domain.ToolKind.execute,
        dto.ToolKind.think => domain.ToolKind.think,
        dto.ToolKind.fetch => domain.ToolKind.fetch,
        dto.ToolKind.switchMode => domain.ToolKind.switchMode,
        dto.ToolKind.other => domain.ToolKind.other,
        null => null,
      };
}
