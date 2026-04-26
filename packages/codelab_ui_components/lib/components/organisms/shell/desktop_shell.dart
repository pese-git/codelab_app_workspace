import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// Desktop shell layout component.
/// Provides the main app structure with title bar, rail, sidebar, content, and panels.
class DesktopShell extends StatelessWidget {
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
  final Widget titleBar;

  /// Main content area
  final Widget content;

  /// Left project rail
  final Widget? projectRail;

  /// Left sidebar
  final Widget? sidebar;

  /// Right context panel
  final Widget? contextPanel;

  /// Bottom panel (terminal)
  final Widget? bottomPanel;

  /// Show/hide sidebar
  final bool showSidebar;

  /// Show/hide context panel
  final bool showContextPanel;

  /// Show/hide bottom panel
  final bool showBottomPanel;

  /// Bottom panel height
  final double bottomPanelHeight;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      color: colors.backgroundBase,
      child: Column(
        children: [
          // Title bar
          titleBar,
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Project rail
                ?projectRail,
                // Sidebar
                if (sidebar != null && showSidebar) sidebar!,
                // Content + bottom panel
                Expanded(
                  child: Column(
                    children: [
                      // Main content
                      Expanded(
                        child: Container(
                          color: colors.surfaceBase,
                          child: content,
                        ),
                      ),
                      // Bottom panel
                      if (bottomPanel != null && showBottomPanel)
                        Container(
                          height: bottomPanelHeight,
                          decoration: BoxDecoration(
                            color: colors.backgroundSubtle,
                            border: Border(
                              top: BorderSide(color: colors.borderBase),
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
class SimpleShell extends StatelessWidget {
  const SimpleShell({
    required this.child,
    this.titleBar,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final Widget? titleBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      color: backgroundColor ?? colors.backgroundBase,
      child: Column(
        children: [
          ?titleBar,
          Expanded(child: child),
        ],
      ),
    );
  }
}
