import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

enum PlanEntryPriority {
  @JsonValue('high') high,
  @JsonValue('medium') medium,
  @JsonValue('low') low,
}

enum PlanEntryStatus {
  @JsonValue('pending') pending,
  @JsonValue('in_progress') inProgress,
  @JsonValue('completed') completed,
}

@freezed
abstract class PlanEntry with _$PlanEntry {
  const factory PlanEntry({
    required String content,
    required PlanEntryPriority priority,
    required PlanEntryStatus status,
  }) = _PlanEntry;

  factory PlanEntry.fromJson(Map<String, dynamic> json) =>
      _$PlanEntryFromJson(json);
}

@freezed
abstract class PlanUpdate with _$PlanUpdate {
  const factory PlanUpdate({
    @Default('plan') String sessionUpdate,
    required List<PlanEntry> entries,
  }) = _PlanUpdate;

  factory PlanUpdate.fromJson(Map<String, dynamic> json) =>
      _$PlanUpdateFromJson(json);
}
