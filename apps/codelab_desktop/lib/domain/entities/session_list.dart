import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list.freezed.dart';

@freezed
abstract class SessionListItem with _$SessionListItem {
  const factory SessionListItem({
    required String sessionId,
    required String cwd,
    String? title,
    String? updatedAt,
  }) = _SessionListItem;
}

@freezed
abstract class SessionListResult with _$SessionListResult {
  const factory SessionListResult({
    required List<SessionListItem> sessions,
    String? nextCursor,
  }) = _SessionListResult;
}
