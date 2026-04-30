import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// Pill-style tabs component.
class PillTabs<T> extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<T> onChanged;

  /// Spacing between tabs
  final double spacing;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Row(
      mainAxisSize: fluent.MainAxisSize.min,
      children: tabs.entries.map((entry) {
        final isSelected = entry.key == selected;
        return fluent.Padding(
          padding: fluent.EdgeInsets.only(right: spacing),
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

class _PillTab extends fluent.StatefulWidget {
  const _PillTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final fluent.VoidCallback onTap;

  @override
  fluent.State<_PillTab> createState() => _PillTabState();
}

class _PillTabState extends fluent.State<_PillTab> {
  bool _isHovered = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: widget.onTap,
      child: fluent.MouseRegion(
        cursor: fluent.SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: fluent.AnimatedContainer(
          duration: AppDurations.fast,
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: fluent.BoxDecoration(
            color: widget.isSelected
                ? colors.accentSubtle
                : _isHovered
                ? colors.surfaceHover
                : colors.surfaceSubtle,
            borderRadius: AppRadius.fullAll,
          ),
          child: fluent.Text(
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
class IconPillTabs<T> extends fluent.StatelessWidget {
  const IconPillTabs({
    required this.tabs,
    required this.selected,
    required this.onChanged,
    this.spacing = AppSpacing.sm,
    super.key,
  });

  /// Map of tab values to (icon, label) pairs
  final Map<T, (fluent.IconData, String)> tabs;

  /// Currently selected tab
  final T selected;

  /// Tab change callback
  final fluent.ValueChanged<T> onChanged;

  /// Spacing between tabs
  final double spacing;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Row(
      mainAxisSize: fluent.MainAxisSize.min,
      children: tabs.entries.map((entry) {
        final isSelected = entry.key == selected;
        final (icon, label) = entry.value;

        return fluent.Padding(
          padding: fluent.EdgeInsets.only(right: spacing),
          child: fluent.GestureDetector(
            onTap: () => onChanged(entry.key),
            child: fluent.AnimatedContainer(
              duration: AppDurations.fast,
              padding: const fluent.EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: fluent.BoxDecoration(
                color: isSelected ? colors.accentSubtle : colors.surfaceSubtle,
                borderRadius: AppRadius.fullAll,
              ),
              child: fluent.Row(
                mainAxisSize: fluent.MainAxisSize.min,
                children: [
                  fluent.Icon(
                    icon,
                    size: 14,
                    color: isSelected ? colors.iconBase : colors.iconWeak,
                  ),
                  const fluent.SizedBox(width: AppSpacing.xs),
                  fluent.Text(
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

// MARK: - Previews

enum _SampleTab { all, active, archived }

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewPillTabsDefault() {
  return PillTabs<_SampleTab>(
    tabs: const {
      _SampleTab.all: 'All',
      _SampleTab.active: 'Active',
      _SampleTab.archived: 'Archived',
    },
    selected: _SampleTab.all,
    onChanged: (_) {},
  );
}

@Preview(name: 'Second Selected')
fluent.Widget previewPillTabsSecondSelected() {
  return PillTabs<_SampleTab>(
    tabs: const {
      _SampleTab.all: 'All',
      _SampleTab.active: 'Active',
      _SampleTab.archived: 'Archived',
    },
    selected: _SampleTab.active,
    onChanged: (_) {},
  );
}

enum _SampleIconTab { list, grid, calendar }

@Preview(name: 'Icon Tabs')
@Preview(name: 'Icon Tabs Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewIconPillTabs() {
  return IconPillTabs<_SampleIconTab>(
    tabs: const {
      _SampleIconTab.list: (fluent.FluentIcons.view_list, 'List'),
      _SampleIconTab.grid: (fluent.FluentIcons.view_dashboard, 'Grid'),
      _SampleIconTab.calendar: (fluent.FluentIcons.calendar, 'Calendar'),
    },
    selected: _SampleIconTab.list,
    onChanged: (_) {},
  );
}
