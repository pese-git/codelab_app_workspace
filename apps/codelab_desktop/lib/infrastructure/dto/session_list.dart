import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list.freezed.dart';
part 'session_list.g.dart';

@freezed
abstract class SessionListItem with _$SessionListItem {
  const factory SessionListItem({
    required String sessionId,
    required String cwd,
    String? title,
    String? updatedAt,
  }) = _SessionListItem;

  factory SessionListItem.fromJson(Map<String, dynamic> json) =>
      _$SessionListItemFromJson(json);
}

@freezed
abstract class SessionListResult with _$SessionListResult {
  const factory SessionListResult({
    required List<SessionListItem> sessions,
    String? nextCursor,
  }) = _SessionListResult;

  factory SessionListResult.fromJson(Map<String, dynamic> json) =>
      _$SessionListResultFromJson(json);
}
