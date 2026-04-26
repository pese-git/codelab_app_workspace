import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A segmented control (tab bar style) component.
class SegmentedControl<T> extends fluent.StatelessWidget {
  const SegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.isDisabled = false,
    super.key,
  });

  /// Map of segment values to labels
  final Map<T, String> segments;

  /// Currently selected value
  final T selected;

  /// Selection change callback
  final fluent.ValueChanged<T> onChanged;

  /// Disabled state
  final bool isDisabled;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      padding: const fluent.EdgeInsets.all(AppSpacing.xs),
      decoration: fluent.BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: AppRadius.mdAll,
      ),
      child: fluent.Row(
        mainAxisSize: fluent.MainAxisSize.min,
        children: segments.entries.map((entry) {
          final isSelected = entry.key == selected;
          return _SegmentButton(
            label: entry.value,
            isSelected: isSelected,
            isDisabled: isDisabled,
            onPressed: () => onChanged(entry.key),
          );
        }).toList(),
      ),
    );
  }
}

class _SegmentButton extends fluent.StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final bool isDisabled;
  final fluent.VoidCallback onPressed;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: fluent.MouseRegion(
        cursor: isDisabled
            ? fluent.SystemMouseCursors.basic
            : fluent.SystemMouseCursors.click,
        child: fluent.AnimatedContainer(
          duration: AppDurations.fast,
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm2,
          ),
          decoration: fluent.BoxDecoration(
            color: isSelected ? colors.surfaceBase : fluent.Colors.transparent,
            borderRadius: AppRadius.smAll,
            boxShadow: isSelected ? AppShadows.light.subtle : null,
          ),
          child: fluent.Text(
            label,
            style: AppTypography.bodyMedium(
              color: isDisabled
                  ? colors.textMuted
                  : isSelected
                  ? colors.textStrong
                  : colors.textWeak,
            ),
          ),
        ),
      ),
    );
  }
}

/// A pill-style segmented control.
class PillSegmentedControl<T> extends fluent.StatelessWidget {
  const PillSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.spacing = AppSpacing.sm,
    super.key,
  });

  /// Map of segment values to labels
  final Map<T, String> segments;

  /// Currently selected value
  final T selected;

  /// Selection change callback
  final fluent.ValueChanged<T> onChanged;

  /// Spacing between pills
  final double spacing;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Row(
      mainAxisSize: fluent.MainAxisSize.min,
      children: segments.entries.map((entry) {
        final isSelected = entry.key == selected;
        return fluent.Padding(
          padding: fluent.EdgeInsets.only(right: spacing),
          child: fluent.GestureDetector(
            onTap: () => onChanged(entry.key),
            child: fluent.MouseRegion(
              cursor: fluent.SystemMouseCursors.click,
              child: fluent.AnimatedContainer(
                duration: AppDurations.fast,
                padding: const fluent.EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: fluent.BoxDecoration(
                  color: isSelected
                      ? colors.accentPrimary
                      : colors.surfaceSubtle,
                  borderRadius: AppRadius.fullAll,
                  border: fluent.Border.all(
                    color: isSelected
                        ? colors.accentPrimary
                        : colors.borderWeak,
                  ),
                ),
                child: fluent.Text(
                  entry.value,
                  style: AppTypography.bodyMedium(
                    color: isSelected ? colors.textOnAccent : colors.textBase,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
