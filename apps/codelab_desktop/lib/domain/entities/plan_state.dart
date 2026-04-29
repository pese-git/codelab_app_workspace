import 'package:freezed_annotation/freezed_annotation.dart';

import 'plan_domain.dart';
import '../../infrastructure/dto/plan.dart' as dto;

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

  PlanState updateFromDto(dto.PlanUpdate d) {
    return updateEntries(
      d.entries.map((e) => PlanEntry(
            content: e.content,
            priority: _mapPriority(e.priority),
            status: _mapStatus(e.status),
          )).toList(),
    );
  }

  int get completedCount =>
      entries.where((e) => e.status == PlanEntryStatus.completed).length;

  int get totalCount => entries.length;

  bool get isEmpty => entries.isEmpty;

  static PlanEntryPriority _mapPriority(dto.PlanEntryPriority p) => switch (p) {
        dto.PlanEntryPriority.high => PlanEntryPriority.high,
        dto.PlanEntryPriority.medium => PlanEntryPriority.medium,
        dto.PlanEntryPriority.low => PlanEntryPriority.low,
      };

  static PlanEntryStatus _mapStatus(dto.PlanEntryStatus s) => switch (s) {
        dto.PlanEntryStatus.pending => PlanEntryStatus.pending,
        dto.PlanEntryStatus.inProgress => PlanEntryStatus.inProgress,
        dto.PlanEntryStatus.completed => PlanEntryStatus.completed,
      };
}
