import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_domain.freezed.dart';

enum PlanEntryPriority { high, medium, low }

enum PlanEntryStatus { pending, inProgress, completed }

@freezed
abstract class PlanEntry with _$PlanEntry {
  const factory PlanEntry({
    required String content,
    required PlanEntryPriority priority,
    required PlanEntryStatus status,
  }) = _PlanEntry;
}
