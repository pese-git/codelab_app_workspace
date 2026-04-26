import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// Context panel tabs.
enum ContextPanelTab { details, activity, agent }

/// Context panel component (right sidebar).
class ContextPanel extends StatelessWidget {
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
  final ValueChanged<ContextPanelTab> onTabChanged;
  final String title;
  final List<ContextPanelItem> items;
  final ValueChanged<ContextPanelItem>? onItemTap;
  final bool isEmpty;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      width: AppDimensions.contextPanelWidth + 54,
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        border: Border(left: BorderSide(color: colors.borderBase)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 64,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.borderWeak)),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: 'Overview',
                  isSelected: activeTab == ContextPanelTab.details,
                  onTap: () => onTabChanged(ContextPanelTab.details),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 20, color: colors.iconWeak),
                  ),
                ),
              ],
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle(color: colors.textStrong),
                ),
                const SizedBox(width: 8),
                Icon(
                  fluent.FluentIcons.chevron_down,
                  size: 10,
                  color: colors.iconMuted,
                ),
              ],
            ),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _SegmentedHeader(
              activeTab: activeTab,
              onTabSelected: onTabChanged,
            ),
          ),
          const SizedBox(height: 18),
          // Content
          Expanded(
            child: isEmpty
                ? Center(
                    child: Text(
                      emptyMessage,
                      style: AppTypography.body(color: colors.textMuted),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.surfaceSelected : colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTypography.label(color: colors.textStrong),
        ),
      ),
    );
  }
}

class _SegmentedHeader extends StatelessWidget {
  const _SegmentedHeader({
    required this.activeTab,
    required this.onTabSelected,
  });

  final ContextPanelTab activeTab;
  final ValueChanged<ContextPanelTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Row(
      children: [
        GestureDetector(
          onTap: () => onTabSelected(ContextPanelTab.activity),
          child: Text(
            '0 Changes',
            style: AppTypography.small(
              color: activeTab == ContextPanelTab.activity
                  ? colors.textBase
                  : colors.textMuted,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const Spacer(),
        _SegmentButton(
          label: 'All files',
          isSelected: activeTab == ContextPanelTab.details,
          onTap: () => onTabSelected(ContextPanelTab.details),
        ),
        const SizedBox(width: 8),
        _SegmentButton(
          label: 'Agent',
          isSelected: activeTab == ContextPanelTab.agent,
          onTap: () => onTabSelected(ContextPanelTab.agent),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.surfaceSelected : colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: AppTypography.small(
            color: colors.textBase,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _FileListRow extends StatelessWidget {
  const _FileListRow({required this.item, this.onTap});

  final ContextPanelItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                fluent.FluentIcons.page,
                size: 13,
                color: colors.iconWeak,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.body(
                      color: colors.textBase,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (item.subtitle.isNotEmpty)
                    Text(
                      item.subtitle,
                      style: AppTypography.caption(color: colors.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
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
