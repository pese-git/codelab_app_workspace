import '../../domain/entities/plan_state.dart' show PlanState;
import '../../domain/entities/plan_domain.dart' as domain;
import '../dto/plan.dart' as dto;

class PlanStateMapper {
  static PlanState fromUpdate(PlanState current, dto.PlanUpdate dtoUpdate) {
    final entries = dtoUpdate.entries.map((e) => domain.PlanEntry(
      content: e.content,
      priority: _mapPriority(e.priority),
      status: _mapStatus(e.status),
    )).toList();

    return current.updateEntries(entries);
  }

  static domain.PlanEntryPriority _mapPriority(dto.PlanEntryPriority p) => switch (p) {
        dto.PlanEntryPriority.high => domain.PlanEntryPriority.high,
        dto.PlanEntryPriority.medium => domain.PlanEntryPriority.medium,
        dto.PlanEntryPriority.low => domain.PlanEntryPriority.low,
      };

  static domain.PlanEntryStatus _mapStatus(dto.PlanEntryStatus s) => switch (s) {
        dto.PlanEntryStatus.pending => domain.PlanEntryStatus.pending,
        dto.PlanEntryStatus.inProgress => domain.PlanEntryStatus.inProgress,
        dto.PlanEntryStatus.completed => domain.PlanEntryStatus.completed,
      };
}
