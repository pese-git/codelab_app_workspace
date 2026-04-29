import 'package:freezed_annotation/freezed_annotation.dart';

import '../../infrastructure/dto/plan.dart';

part 'plan_state.freezed.dart';

@freezed
abstract class PlanState with _$PlanState {
  const factory PlanState({
    @Default([]) List<PlanEntry> entries,
    DateTime? lastUpdatedAt,
  }) = _PlanState;

  const PlanState._();

  factory PlanState.empty() => const PlanState();

  PlanState updateEntries(List<PlanEntry> newEntries) {
    return copyWith(
      entries: newEntries,
      lastUpdatedAt: DateTime.now().toUtc(),
    );
  }

  int get completedCount =>
      entries.where((e) => e.status == PlanEntryStatus.completed).length;

  int get totalCount => entries.length;

  bool get isEmpty => entries.isEmpty;
}
