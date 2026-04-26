import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../theme/tokens.dart';

/// Desktop title bar component.
class TitleBar extends fluent.StatelessWidget {
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

  final fluent.VoidCallback? onToggleSidebar;
  final fluent.VoidCallback? onBack;
  final fluent.VoidCallback? onForward;
  final bool canBack;
  final bool canForward;
  final fluent.VoidCallback? onSearch;
  final fluent.VoidCallback? onToggleTerminal;
  final fluent.VoidCallback? onNewWorkspace;
  final fluent.VoidCallback? onToggleContextPanel;
  final bool isContextPanelVisible;
  final String searchPlaceholder;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      height: AppDimensions.titleBarHeight,
      padding: const fluent.EdgeInsets.symmetric(horizontal: 14),
      decoration: fluent.BoxDecoration(
        color: colors.backgroundElevated,
        border: fluent.Border(bottom: fluent.BorderSide(color: colors.borderBase)),
      ),
      child: fluent.Row(
        children: <fluent.Widget>[
          const _TrafficLights(),
          const fluent.SizedBox(width: 20),
          _TitleIconButton(
            icon: fluent.FluentIcons.side_panel,
            onTap: onToggleSidebar,
          ),
          const fluent.SizedBox(width: 10),
          _NavigationButton(
            icon: fluent.FluentIcons.chevron_left_small,
            enabled: canBack,
            onTap: onBack,
          ),
          const fluent.SizedBox(width: 6),
          _NavigationButton(
            icon: fluent.FluentIcons.chevron_right_small,
            enabled: canForward,
            onTap: onForward,
          ),
          const fluent.Spacer(),
          fluent.Center(
            child: fluent.GestureDetector(
              onTap: onSearch,
                child: fluent.Container(
                  width: 360,
                  height: 32,
                  padding: const fluent.EdgeInsets.symmetric(horizontal: 12),
                  decoration: fluent.BoxDecoration(
                    color: colors.surfaceSubtle,
                    borderRadius: fluent.BorderRadius.circular(10),
                    border: fluent.Border.all(color: colors.borderWeak),
                  ),
                    child: fluent.Row(
                    children: [
                      fluent.Expanded(
                        child: fluent.Text(
                          searchPlaceholder,
                          style: AppTypography.small(color: colors.textMuted),
                        ),
                      ),
                      fluent.Text(
                        '⌘K',
                        style: AppTypography.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const fluent.Spacer(),
          _HeaderBadge(icon: fluent.FluentIcons.server_processes, onTap: () {}),
          const fluent.SizedBox(width: 10),
          _HeaderBadge(
            icon: fluent.FluentIcons.command_prompt,
            onTap: onToggleTerminal,
          ),
          const fluent.SizedBox(width: 10),
          _HeaderBadge(icon: fluent.FluentIcons.add, onTap: onNewWorkspace),
          const fluent.SizedBox(width: 10),
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

class _TrafficLights extends fluent.StatelessWidget {
  const _TrafficLights();

  @override
  fluent.Widget build(fluent.BuildContext context) {
    fluent.Widget dot(fluent.Color color) {
      return fluent.Container(
        width: 14,
        height: 14,
        decoration: fluent.BoxDecoration(color: color, shape: fluent.BoxShape.circle),
      );
    }

    return fluent.Row(
      children: [
        dot(const fluent.Color(0xFFFF5F57)),
        const fluent.SizedBox(width: 8),
        dot(const fluent.Color(0xFFFEBB2E)),
        const fluent.SizedBox(width: 8),
        dot(const fluent.Color(0xFF28C840)),
      ],
    );
  }
}

class _TitleIconButton extends fluent.StatelessWidget {
  const _TitleIconButton({required this.icon, required this.onTap});

  final fluent.IconData icon;
  final fluent.VoidCallback? onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Container(
        width: 30,
        height: 30,
        decoration: fluent.BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: fluent.BorderRadius.circular(8),
        ),
        child: fluent.Icon(icon, size: 14, color: colors.iconBase),
      ),
    );
  }
}

class _HeaderBadge extends fluent.StatelessWidget {
  const _HeaderBadge({required this.icon, required this.onTap});

  final fluent.IconData icon;
  final fluent.VoidCallback? onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Container(
        width: 30,
        height: 30,
        decoration: fluent.BoxDecoration(
          color: colors.surfaceAccent,
          borderRadius: fluent.BorderRadius.circular(8),
        ),
        child: fluent.Icon(icon, size: 14, color: colors.iconBase),
      ),
    );
  }
}

class _NavigationButton extends fluent.StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final fluent.IconData icon;
  final bool enabled;
  final fluent.VoidCallback? onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: enabled ? onTap : null,
      child: fluent.MouseRegion(
        cursor: enabled
            ? fluent.SystemMouseCursors.click
            : fluent.SystemMouseCursors.basic,
        child: fluent.Icon(
          icon,
          size: 15,
          color: enabled ? colors.iconBase : colors.iconMuted,
        ),
      ),
    );
  }
}
