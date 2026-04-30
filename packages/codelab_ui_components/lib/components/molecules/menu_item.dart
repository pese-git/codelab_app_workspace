import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A menu item component.
class MenuItem extends fluent.StatefulWidget {
  const MenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.onTap,
    this.isDisabled = false,
    this.isDestructive = false,
    super.key,
  });

  /// Menu item label
  final String label;

  /// Optional leading icon
  final fluent.IconData? icon;

  /// Optional keyboard shortcut text
  final String? shortcut;

  /// Tap callback
  final fluent.VoidCallback? onTap;

  /// Disabled state
  final bool isDisabled;

  /// Destructive action (shows in red)
  final bool isDestructive;

  @override
  fluent.State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends fluent.State<MenuItem> {
  bool _isHovered = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isEnabled = !widget.isDisabled && widget.onTap != null;

    final textColor = widget.isDisabled
        ? colors.textMuted
        : widget.isDestructive
        ? colors.errorBase
        : colors.textBase;

    final iconColor = widget.isDisabled
        ? colors.iconMuted
        : widget.isDestructive
        ? colors.errorBase
        : colors.iconBase;

    return fluent.GestureDetector(
      onTap: isEnabled ? widget.onTap : null,
      child: fluent.MouseRegion(
        cursor: isEnabled
            ? fluent.SystemMouseCursors.click
            : fluent.SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: fluent.AnimatedContainer(
          duration: AppDurations.fast,
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: fluent.BoxDecoration(
            color: _isHovered && isEnabled
                ? colors.surfaceHover
                : fluent.Colors.transparent,
            borderRadius: AppRadius.smAll,
          ),
          child: fluent.Row(
            children: [
              if (widget.icon != null) ...[
                fluent.Icon(widget.icon, size: 16, color: iconColor),
                const fluent.SizedBox(width: AppSpacing.md),
              ],
              fluent.Expanded(
                child: fluent.Text(
                  widget.label,
                  style: AppTypography.body(color: textColor),
                ),
              ),
              if (widget.shortcut != null)
                fluent.Text(
                  widget.shortcut!,
                  style: AppTypography.caption(color: colors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A menu divider.
class MenuDivider extends fluent.StatelessWidget {
  const MenuDivider({super.key});

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Padding(
      padding: const fluent.EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: fluent.Container(height: 1, color: colors.borderWeak),
    );
  }
}

/// A menu section header.
class MenuSectionHeader extends fluent.StatelessWidget {
  const MenuSectionHeader({required this.title, super.key});

  final String title;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Padding(
      padding: const fluent.EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: fluent.Text(
        title.toUpperCase(),
        style: AppTypography.style(
          size: 11,
          weight: AppTypography.semiBold,
          color: colors.textMuted,
        ),
      ),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewMenuItemDefault() {
  return MenuItem(
    label: 'Copy',
    icon: fluent.FluentIcons.copy,
    shortcut: 'Ctrl+C',
    onTap: () {},
  );
}

@Preview(name: 'Disabled')
fluent.Widget previewMenuItemDisabled() {
  return const MenuItem(
    label: 'Paste',
    icon: fluent.FluentIcons.paste,
    shortcut: 'Ctrl+V',
    isDisabled: true,
  );
}

@Preview(name: 'Destructive')
fluent.Widget previewMenuItemDestructive() {
  return MenuItem(
    label: 'Delete',
    icon: fluent.FluentIcons.delete,
    isDestructive: true,
    onTap: () {},
  );
}

@Preview(name: 'Without Icon')
fluent.Widget previewMenuItemNoIcon() {
  return MenuItem(
    label: 'Settings',
    shortcut: 'Ctrl+,',
    onTap: () {},
  );
}

@Preview(name: 'Menu Section')
@Preview(name: 'Menu Section Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewMenuSection() {
  return const fluent.Column(
    mainAxisSize: fluent.MainAxisSize.min,
    crossAxisAlignment: fluent.CrossAxisAlignment.start,
    children: [
      MenuSectionHeader(title: 'Edit'),
      MenuItem(label: 'Undo', shortcut: 'Ctrl+Z'),
      MenuItem(label: 'Redo', shortcut: 'Ctrl+Y'),
      MenuDivider(),
      MenuItem(label: 'Cut', shortcut: 'Ctrl+X'),
      MenuItem(label: 'Copy', shortcut: 'Ctrl+C'),
    ],
  );
}
