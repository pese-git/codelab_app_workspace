import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A menu item component.
class MenuItem extends StatefulWidget {
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
  final IconData? icon;

  /// Optional keyboard shortcut text
  final String? shortcut;

  /// Tap callback
  final VoidCallback? onTap;

  /// Disabled state
  final bool isDisabled;

  /// Destructive action (shows in red)
  final bool isDestructive;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
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

    return GestureDetector(
      onTap: isEnabled ? widget.onTap : null,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _isHovered && isEnabled ? colors.surfaceHover : Colors.transparent,
            borderRadius: AppRadius.smAll,
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: iconColor),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTypography.body(color: textColor),
                ),
              ),
              if (widget.shortcut != null)
                Text(
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
class MenuDivider extends StatelessWidget {
  const MenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Container(
        height: 1,
        color: colors.borderWeak,
      ),
    );
  }
}

/// A menu section header.
class MenuSectionHeader extends StatelessWidget {
  const MenuSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
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
