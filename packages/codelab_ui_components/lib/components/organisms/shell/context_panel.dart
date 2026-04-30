import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';

/// Context panel tabs.
enum ContextPanelTab { details, activity, agent }

/// Context panel component (right sidebar).
class ContextPanel extends fluent.StatelessWidget {
  const ContextPanel({
    required this.activeTab,
    required this.onTabChanged,
    this.title = 'Changes',
    this.items = const [],
    this.onItemTap,
    this.isEmpty = false,
    this.emptyMessage = 'No changes',
    super.key,
  });

  final ContextPanelTab activeTab;
  final fluent.ValueChanged<ContextPanelTab> onTabChanged;
  final String title;
  final List<ContextPanelItem> items;
  final fluent.ValueChanged<ContextPanelItem>? onItemTap;
  final bool isEmpty;
  final String emptyMessage;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      width: AppDimensions.contextPanelWidth + 54,
      decoration: fluent.BoxDecoration(
        color: colors.surfaceBase,
        border: fluent.Border(
          left: fluent.BorderSide(color: colors.borderBase),
        ),
      ),
      child: fluent.Column(
        children: [
          // Header
          fluent.Container(
            height: 64,
            padding: const fluent.EdgeInsets.fromLTRB(16, 14, 16, 0),
            decoration: fluent.BoxDecoration(
              border: fluent.Border(
                bottom: fluent.BorderSide(color: colors.borderWeak),
              ),
            ),
            child: fluent.Row(
              children: [
                _TabButton(
                  label: 'Overview',
                  isSelected: activeTab == ContextPanelTab.details,
                  onTap: () => onTabChanged(ContextPanelTab.details),
                ),
                const fluent.SizedBox(width: 14),
                fluent.GestureDetector(
                  onTap: () {},
                  child: fluent.Text(
                    '+',
                    style: fluent.TextStyle(
                      fontSize: 20,
                      color: colors.iconWeak,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Title
          fluent.Padding(
            padding: const fluent.EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: fluent.Row(
              children: [
                fluent.Text(
                  title,
                  style: AppTypography.subtitle(color: colors.textStrong),
                ),
                const fluent.SizedBox(width: 8),
                fluent.Icon(
                  fluent.FluentIcons.chevron_down,
                  size: 10,
                  color: colors.iconMuted,
                ),
              ],
            ),
          ),
          // Tabs
          fluent.Padding(
            padding: const fluent.EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _SegmentedHeader(
              activeTab: activeTab,
              onTabSelected: onTabChanged,
            ),
          ),
          const fluent.SizedBox(height: 18),
          // Content
          fluent.Expanded(
            child: isEmpty
                ? fluent.Center(
                    child: fluent.Text(
                      emptyMessage,
                      style: AppTypography.body(color: colors.textMuted),
                    ),
                  )
                : fluent.ListView(
                    padding: const fluent.EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: items
                        .map(
                          (item) => _FileListRow(
                            item: item,
                            onTap: () => onItemTap?.call(item),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends fluent.StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final fluent.VoidCallback onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Container(
        padding: const fluent.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: fluent.BoxDecoration(
          color: isSelected ? colors.surfaceSelected : colors.surfaceSubtle,
          borderRadius: fluent.BorderRadius.circular(10),
        ),
        child: fluent.Text(
          label,
          style: AppTypography.label(color: colors.textStrong),
        ),
      ),
    );
  }
}

class _SegmentedHeader extends fluent.StatelessWidget {
  const _SegmentedHeader({
    required this.activeTab,
    required this.onTabSelected,
  });

  final ContextPanelTab activeTab;
  final fluent.ValueChanged<ContextPanelTab> onTabSelected;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Row(
      children: [
        fluent.Flexible(
          child: fluent.GestureDetector(
            onTap: () => onTabSelected(ContextPanelTab.activity),
            child: fluent.Text(
              '0 Changes',
              style: AppTypography.small(
                color: activeTab == ContextPanelTab.activity
                    ? colors.textBase
                    : colors.textMuted,
              ).copyWith(fontWeight: fluent.FontWeight.w600),
            ),
          ),
        ),
        const fluent.SizedBox(width: 8),
        _SegmentButton(
          label: 'All files',
          isSelected: activeTab == ContextPanelTab.details,
          onTap: () => onTabSelected(ContextPanelTab.details),
        ),
        const fluent.SizedBox(width: 8),
        _SegmentButton(
          label: 'Agent',
          isSelected: activeTab == ContextPanelTab.agent,
          onTap: () => onTabSelected(ContextPanelTab.agent),
        ),
      ],
    );
  }
}

class _SegmentButton extends fluent.StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final fluent.VoidCallback onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Container(
        padding: const fluent.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: fluent.BoxDecoration(
          color: isSelected ? colors.surfaceSelected : colors.surfaceSubtle,
          borderRadius: fluent.BorderRadius.circular(9),
        ),
        child: fluent.Text(
          label,
          style: AppTypography.small(
            color: colors.textBase,
          ).copyWith(fontWeight: fluent.FontWeight.w600),
        ),
      ),
    );
  }
}

class _FileListRow extends fluent.StatelessWidget {
  const _FileListRow({required this.item, this.onTap});

  final ContextPanelItem item;
  final fluent.VoidCallback? onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Padding(
      padding: const fluent.EdgeInsets.only(bottom: 12),
      child: fluent.GestureDetector(
        onTap: onTap,
        child: fluent.Row(
          crossAxisAlignment: fluent.CrossAxisAlignment.start,
          children: [
            fluent.Padding(
              padding: const fluent.EdgeInsets.only(top: 4),
              child: fluent.Icon(
                fluent.FluentIcons.page,
                size: 13,
                color: colors.iconWeak,
              ),
            ),
            const fluent.SizedBox(width: 10),
            fluent.Expanded(
              child: fluent.Column(
                crossAxisAlignment: fluent.CrossAxisAlignment.start,
                children: [
                  fluent.Text(
                    item.title,
                    style: AppTypography.body(
                      color: colors.textBase,
                    ).copyWith(fontWeight: fluent.FontWeight.w600),
                  ),
                  if (item.subtitle.isNotEmpty)
                    fluent.Text(
                      item.subtitle,
                      style: AppTypography.caption(color: colors.textMuted),
                      maxLines: 2,
                      overflow: fluent.TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            fluent.Text(
              item.trailing,
              style: AppTypography.caption(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Item for context panel list.
class ContextPanelItem {
  const ContextPanelItem({
    required this.title,
    this.subtitle = '',
    this.trailing = '',
  });

  final String title;
  final String subtitle;
  final String trailing;
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewContextPanelDefault() {
  return ContextPanel(
    activeTab: ContextPanelTab.details,
    onTabChanged: (_) {},
    items: const [
      ContextPanelItem(
        title: 'main.dart',
        subtitle: 'lib/src/main.dart',
        trailing: 'M',
      ),
      ContextPanelItem(
        title: 'utils.dart',
        subtitle: 'lib/src/utils/utils.dart',
        trailing: 'A',
      ),
      ContextPanelItem(
        title: 'config.yaml',
        subtitle: 'config/config.yaml',
        trailing: 'D',
      ),
    ],
    onItemTap: (_) {},
  );
}

@Preview(name: 'Empty')
fluent.Widget previewContextPanelEmpty() {
  return const ContextPanel(
    activeTab: ContextPanelTab.details,
    onTabChanged: _onTabChanged,
    isEmpty: true,
  );
}

@Preview(name: 'Activity Tab')
fluent.Widget previewContextPanelActivity() {
  return ContextPanel(
    activeTab: ContextPanelTab.activity,
    onTabChanged: (_) {},
    title: 'Activity',
    items: const [
      ContextPanelItem(
        title: 'File created',
        subtitle: 'main.dart was added to the project',
        trailing: '2m ago',
      ),
      ContextPanelItem(
        title: 'Code modified',
        subtitle: 'Updated widget tree in home_screen.dart',
        trailing: '5m ago',
      ),
    ],
    onItemTap: (_) {},
  );
}

void _onTabChanged(ContextPanelTab tab) {}
