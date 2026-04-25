import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A segmented control (tab bar style) component.
class SegmentedControl<T> extends StatelessWidget {
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
  final ValueChanged<T> onChanged;

  /// Disabled state
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: MouseRegion(
        cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.surfaceBase : Colors.transparent,
            borderRadius: AppRadius.smAll,
            boxShadow: isSelected ? AppShadows.light.subtle : null,
          ),
          child: Text(
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
class PillSegmentedControl<T> extends StatelessWidget {
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
  final ValueChanged<T> onChanged;

  /// Spacing between pills
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: segments.entries.map((entry) {
        final isSelected = entry.key == selected;
        return Padding(
          padding: EdgeInsets.only(right: spacing),
          child: GestureDetector(
            onTap: () => onChanged(entry.key),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.accentPrimary : colors.surfaceSubtle,
                  borderRadius: AppRadius.fullAll,
                  border: Border.all(
                    color: isSelected ? colors.accentPrimary : colors.borderWeak,
                  ),
                ),
                child: Text(
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
