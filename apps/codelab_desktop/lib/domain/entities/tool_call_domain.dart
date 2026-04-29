import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_call_domain.freezed.dart';

enum ToolKind { read, edit, delete, move, search, execute, think, fetch, switchMode, other }

enum ToolCallStatus { pending, inProgress, completed, failed, cancelled }

@freezed
abstract class ToolCallLocation with _$ToolCallLocation {
  const factory ToolCallLocation({
    required String path,
    int? line,
  }) = _ToolCallLocation;
}
