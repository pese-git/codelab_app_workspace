import 'package:freezed_annotation/freezed_annotation.dart';

import 'tool_call_domain.dart';

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

  ToolCallRecord update({
    ToolCallStatus? status,
    String? title,
    ToolKind? kind,
    List<Map<String, dynamic>>? content,
    List<ToolCallLocation>? locations,
    Map<String, dynamic>? rawInput,
    Map<String, dynamic>? rawOutput,
  }) {
    return copyWith(
      status: status ?? this.status,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      locations: locations ?? this.locations,
      rawInput: rawInput ?? this.rawInput,
      rawOutput: rawOutput ?? this.rawOutput,
      completedAt: completedAt,
    );
  }

  ToolCallRecord markCompleted() {
    return copyWith(
      completedAt: DateTime.now().toUtc(),
    );
  }

  bool get isCompleted =>
      status == ToolCallStatus.completed ||
      status == ToolCallStatus.failed ||
      status == ToolCallStatus.cancelled;
}
