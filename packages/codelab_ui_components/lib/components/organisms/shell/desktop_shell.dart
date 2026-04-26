import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../theme/tokens.dart';

/// Desktop shell layout component.
/// Provides the main app structure with title bar, rail, sidebar, content, and panels.
class DesktopShell extends fluent.StatelessWidget {
  const DesktopShell({
    required this.titleBar,
    required this.content,
    this.projectRail,
    this.sidebar,
    this.contextPanel,
    this.bottomPanel,
    this.showSidebar = true,
    this.showContextPanel = true,
    this.showBottomPanel = false,
    this.bottomPanelHeight = AppDimensions.bottomPanelHeight,
    super.key,
  });

  /// Title bar widget
  final fluent.Widget titleBar;

  /// Main content area
  final fluent.Widget content;

  /// Left project rail
  final fluent.Widget? projectRail;

  /// Left sidebar
  final fluent.Widget? sidebar;

  /// Right context panel
  final fluent.Widget? contextPanel;

  /// Bottom panel (terminal)
  final fluent.Widget? bottomPanel;

  /// Show/hide sidebar
  final bool showSidebar;

  /// Show/hide context panel
  final bool showContextPanel;

  /// Show/hide bottom panel
  final bool showBottomPanel;

  /// Bottom panel height
  final double bottomPanelHeight;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      color: colors.backgroundBase,
      child: fluent.Column(
        children: [
          // Title bar
          titleBar,
          // Main content area
          fluent.Expanded(
            child: fluent.Row(
              children: [
                // Project rail
                // ignore: use_null_aware_elements
                if (projectRail != null) projectRail!,
                // Sidebar
                if (sidebar != null && showSidebar) sidebar!,
                // Content + bottom panel
                fluent.Expanded(
                  child: fluent.Column(
                    children: [
                      // Main content
                      fluent.Expanded(
                        child: fluent.Container(
                          color: colors.surfaceBase,
                          child: content,
                        ),
                      ),
                      // Bottom panel
                      if (bottomPanel != null && showBottomPanel)
                        fluent.Container(
                          height: bottomPanelHeight,
                          decoration: fluent.BoxDecoration(
                            color: colors.backgroundSubtle,
                            border: fluent.Border(
                              top: fluent.BorderSide(color: colors.borderBase),
                            ),
                          ),
                          child: bottomPanel!,
                        ),
                    ],
                  ),
                ),
                // Context panel
                if (contextPanel != null && showContextPanel) contextPanel!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple shell layout without all panels.
class SimpleShell extends fluent.StatelessWidget {
  const SimpleShell({
    required this.child,
    this.titleBar,
    this.backgroundColor,
    super.key,
  });

  final fluent.Widget child;
  final fluent.Widget? titleBar;
  final fluent.Color? backgroundColor;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      color: backgroundColor ?? colors.backgroundBase,
      child: fluent.Column(
        children: [
          // ignore: use_null_aware_elements
          if (titleBar != null) titleBar!,
          fluent.Expanded(child: child),
        ],
      ),
    );
  }
}
