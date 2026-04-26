import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// Desktop title bar component.
class TitleBar extends StatelessWidget {
  const TitleBar({
    this.onToggleSidebar,
    this.onBack,
    this.onForward,
    this.canBack = false,
    this.canForward = false,
    this.onSearch,
    this.onToggleTerminal,
    this.onNewWorkspace,
    this.onToggleContextPanel,
    this.isContextPanelVisible = true,
    this.searchPlaceholder = 'Search...',
    super.key,
  });

  final VoidCallback? onToggleSidebar;
  final VoidCallback? onBack;
  final VoidCallback? onForward;
  final bool canBack;
  final bool canForward;
  final VoidCallback? onSearch;
  final VoidCallback? onToggleTerminal;
  final VoidCallback? onNewWorkspace;
  final VoidCallback? onToggleContextPanel;
  final bool isContextPanelVisible;
  final String searchPlaceholder;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      height: AppDimensions.titleBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
        border: Border(bottom: BorderSide(color: colors.borderBase)),
      ),
      child: Row(
        children: [
          const _TrafficLights(),
          const SizedBox(width: 20),
          _TitleIconButton(
            icon: fluent.FluentIcons.side_panel,
            onTap: onToggleSidebar,
          ),
          const SizedBox(width: 10),
          _NavigationButton(
            icon: fluent.FluentIcons.chevron_left_small,
            enabled: canBack,
            onTap: onBack,
          ),
          const SizedBox(width: 6),
          _NavigationButton(
            icon: fluent.FluentIcons.chevron_right_small,
            enabled: canForward,
            onTap: onForward,
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onSearch,
                child: Container(
                  width: 360,
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderWeak),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          searchPlaceholder,
                          style: AppTypography.small(color: colors.textMuted),
                        ),
                      ),
                      Text(
                        '⌘K',
                        style: AppTypography.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _HeaderBadge(icon: fluent.FluentIcons.server_processes, onTap: () {}),
          const SizedBox(width: 10),
          _HeaderBadge(
            icon: fluent.FluentIcons.command_prompt,
            onTap: onToggleTerminal,
          ),
          const SizedBox(width: 10),
          _HeaderBadge(icon: fluent.FluentIcons.add, onTap: onNewWorkspace),
          const SizedBox(width: 10),
          _TitleIconButton(
            icon: isContextPanelVisible
                ? fluent.FluentIcons.open_pane_mirrored
                : fluent.FluentIcons.open_pane,
            onTap: onToggleContextPanel,
          ),
        ],
      ),
    );
  }
}

class _TrafficLights extends StatelessWidget {
  const _TrafficLights();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color color) {
      return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
    }

    return Row(
      children: [
        dot(const Color(0xFFFF5F57)),
        const SizedBox(width: 8),
        dot(const Color(0xFFFEBB2E)),
        const SizedBox(width: 8),
        dot(const Color(0xFF28C840)),
      ],
    );
  }
}

class _TitleIconButton extends StatelessWidget {
  const _TitleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: colors.iconBase),
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: colors.surfaceAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: colors.iconBase),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Icon(
          icon,
          size: 15,
          color: enabled ? colors.iconBase : colors.iconMuted,
        ),
      ),
    );
  }
}
