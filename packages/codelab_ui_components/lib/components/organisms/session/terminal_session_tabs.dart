import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';

class TerminalSessionTabData {
  const TerminalSessionTabData({
    required this.id,
    required this.title,
    this.isActive = false,
  });

  final String id;
  final String title;
  final bool isActive;
}

class TerminalSessionTabs extends fluent.StatelessWidget {
  const TerminalSessionTabs({
    required this.sessions,
    required this.activeSessionId,
    required this.onTabSelected,
    required this.onTabClosed,
    required this.onAddTab,
    super.key,
  });

  final List<TerminalSessionTabData> sessions;
  final String? activeSessionId;
  final fluent.ValueChanged<String> onTabSelected;
  final fluent.ValueChanged<String> onTabClosed;
  final fluent.VoidCallback onAddTab;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      height: 32,
      decoration: fluent.BoxDecoration(
        color: colors.surfaceSubtle,
        border: fluent.Border(
          bottom: fluent.BorderSide(color: colors.borderWeak),
        ),
      ),
      child: fluent.Row(
        children: [
          fluent.Expanded(
            child: fluent.ListView.builder(
              scrollDirection: fluent.Axis.horizontal,
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return _TerminalSessionTab(
                  id: session.id,
                  title: session.title,
                  isActive: session.id == activeSessionId,
                  onSelected: onTabSelected,
                  onClosed: onTabClosed,
                );
              },
            ),
          ),
          fluent.GestureDetector(
            onTap: onAddTab,
            child: fluent.Container(
              padding: const fluent.EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
              ),
              child: fluent.Icon(
                fluent.FluentIcons.add,
                size: 14,
                color: colors.iconWeak,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalSessionTab extends fluent.StatelessWidget {
  const _TerminalSessionTab({
    required this.id,
    required this.title,
    required this.isActive,
    required this.onSelected,
    required this.onClosed,
  });

  final String id;
  final String title;
  final bool isActive;
  final fluent.ValueChanged<String> onSelected;
  final fluent.ValueChanged<String> onClosed;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: () => onSelected(id),
      child: fluent.Container(
        padding: const fluent.EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
        ),
        margin: const fluent.EdgeInsets.only(right: 1),
        decoration: fluent.BoxDecoration(
          color: isActive ? colors.backgroundBase : fluent.Colors.transparent,
          border: fluent.Border(
            right: fluent.BorderSide(color: colors.borderWeak),
          ),
        ),
        child: fluent.Row(
          mainAxisSize: fluent.MainAxisSize.min,
          children: [
            fluent.Icon(
              fluent.FluentIcons.command_prompt,
              size: 12,
              color: isActive ? colors.iconBase : colors.iconWeak,
            ),
            const fluent.SizedBox(width: AppSpacing.xs),
            fluent.ConstrainedBox(
              constraints: const fluent.BoxConstraints(maxWidth: 120),
              child: fluent.Text(
                title,
                style: AppTypography.small(
                  color: isActive ? colors.textBase : colors.textMuted,
                ),
                overflow: fluent.TextOverflow.ellipsis,
              ),
            ),
            const fluent.SizedBox(width: AppSpacing.xs),
            fluent.GestureDetector(
              onTap: () => onClosed(id),
              child: fluent.Icon(
                fluent.FluentIcons.chrome_close,
                size: 12,
                color: colors.iconWeak,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewTerminalSessionTabsDefault() {
  return fluent.Container(
    color: fluent.Colors.white,
    child: TerminalSessionTabs(
      sessions: const [
        TerminalSessionTabData(id: '1', title: 'Terminal 1', isActive: true),
        TerminalSessionTabData(id: '2', title: 'Terminal 2'),
        TerminalSessionTabData(id: '3', title: 'build'),
      ],
      activeSessionId: '1',
      onTabSelected: (_) {},
      onTabClosed: (_) {},
      onAddTab: () {},
    ),
  );
}

@Preview(name: 'Empty')
fluent.Widget previewTerminalSessionTabsEmpty() {
  return fluent.Container(
    color: fluent.Colors.white,
    child: TerminalSessionTabs(
      sessions: const [],
      activeSessionId: null,
      onTabSelected: (_) {},
      onTabClosed: (_) {},
      onAddTab: () {},
    ),
  );
}
