import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';

/// Tab types for session region.
enum SessionRegionTab { files, review, terminal }

/// Session tabs component.
class SessionTabs extends fluent.StatelessWidget {
  const SessionTabs({
    required this.activeTab,
    required this.onTabChanged,
    super.key,
  });

  final SessionRegionTab activeTab;
  final fluent.ValueChanged<SessionRegionTab> onTabChanged;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      padding: const fluent.EdgeInsets.all(AppSpacing.md2),
      decoration: fluent.BoxDecoration(
        border: fluent.Border(
          bottom: fluent.BorderSide(color: colors.borderWeak),
        ),
      ),
      child: fluent.Row(
        children: [
          for (final tab in SessionRegionTab.values)
            fluent.Padding(
              padding: const fluent.EdgeInsets.only(right: AppSpacing.sm2),
              child: fluent.Button(
                style: fluent.ButtonStyle(
                  backgroundColor: fluent.WidgetStateProperty.all(
                    activeTab == tab
                        ? colors.surfaceAccent
                        : colors.surfaceBase,
                  ),
                  foregroundColor: fluent.WidgetStateProperty.all(
                    activeTab == tab ? colors.textStrong : colors.textWeak,
                  ),
                ),
                onPressed: () => onTabChanged(tab),
                child: fluent.Text(_label(tab)),
              ),
            ),
        ],
      ),
    );
  }

  String _label(SessionRegionTab tab) {
    switch (tab) {
      case SessionRegionTab.files:
        return 'Files';
      case SessionRegionTab.review:
        return 'Review';
      case SessionRegionTab.terminal:
        return 'Terminal';
    }
  }
}

// MARK: - Previews

@Preview(name: 'Files Active')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSessionTabsFiles() {
  return SessionTabs(
    activeTab: SessionRegionTab.files,
    onTabChanged: (tab) {},
  );
}

@Preview(name: 'Review Active')
fluent.Widget previewSessionTabsReview() {
  return SessionTabs(
    activeTab: SessionRegionTab.review,
    onTabChanged: (tab) {},
  );
}

@Preview(name: 'Terminal Active')
fluent.Widget previewSessionTabsTerminal() {
  return SessionTabs(
    activeTab: SessionRegionTab.terminal,
    onTabChanged: (tab) {},
  );
}
