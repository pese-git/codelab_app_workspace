import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// Tab types for session region.
enum SessionRegionTab { files, review, terminal }

/// Session tabs component.
class SessionTabs extends StatelessWidget {
  const SessionTabs({
    required this.activeTab,
    required this.onTabChanged,
    super.key,
  });

  final SessionRegionTab activeTab;
  final ValueChanged<SessionRegionTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderWeak),
        ),
      ),
      child: Row(
        children: [
          for (final tab in SessionRegionTab.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm2),
              child: fluent.Button(
                style: fluent.ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    activeTab == tab
                        ? colors.surfaceAccent
                        : colors.surfaceBase,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    activeTab == tab
                        ? colors.textStrong
                        : colors.textWeak,
                  ),
                ),
                onPressed: () => onTabChanged(tab),
                child: Text(_label(tab)),
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
