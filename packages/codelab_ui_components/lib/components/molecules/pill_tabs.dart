import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Pill-style tabs component.
class PillTabs<T> extends StatelessWidget {
  const PillTabs({
    required this.tabs,
    required this.selected,
    required this.onChanged,
    this.spacing = AppSpacing.sm,
    super.key,
  });

  /// Map of tab values to labels
  final Map<T, String> tabs;

  /// Currently selected tab
  final T selected;

  /// Tab change callback
  final ValueChanged<T> onChanged;

  /// Spacing between tabs
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tabs.entries.map((entry) {
        final isSelected = entry.key == selected;
        return Padding(
          padding: EdgeInsets.only(right: spacing),
          child: _PillTab(
            label: entry.value,
            isSelected: isSelected,
            onTap: () => onChanged(entry.key),
          ),
        );
      }).toList(),
    );
  }
}

class _PillTab extends StatefulWidget {
  const _PillTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_PillTab> createState() => _PillTabState();
}

class _PillTabState extends State<_PillTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colors.accentSubtle
                : _isHovered
                ? colors.surfaceHover
                : colors.surfaceSubtle,
            borderRadius: AppRadius.fullAll,
          ),
          child: Text(
            widget.label,
            style: AppTypography.bodyMedium(
              color: widget.isSelected ? colors.textStrong : colors.textWeak,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pill tabs with icons.
class IconPillTabs<T> extends StatelessWidget {
  const IconPillTabs({
    required this.tabs,
    required this.selected,
    required this.onChanged,
    this.spacing = AppSpacing.sm,
    super.key,
  });

  /// Map of tab values to (icon, label) pairs
  final Map<T, (IconData, String)> tabs;

  /// Currently selected tab
  final T selected;

  /// Tab change callback
  final ValueChanged<T> onChanged;

  /// Spacing between tabs
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tabs.entries.map((entry) {
        final isSelected = entry.key == selected;
        final (icon, label) = entry.value;

        return Padding(
          padding: EdgeInsets.only(right: spacing),
          child: GestureDetector(
            onTap: () => onChanged(entry.key),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.accentSubtle : colors.surfaceSubtle,
                borderRadius: AppRadius.fullAll,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isSelected ? colors.iconBase : colors.iconWeak,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    label,
                    style: AppTypography.bodyMedium(
                      color: isSelected ? colors.textStrong : colors.textWeak,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
