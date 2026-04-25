import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Icon button size variants.
enum IconButtonSize {
  /// Small (24px)
  sm,

  /// Medium (32px) - default
  md,

  /// Large (40px)
  lg,
}

/// A themed icon button component.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.size = IconButtonSize.md,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.isDisabled = false,
    super.key,
  });

  /// Icon to display
  final IconData icon;

  /// Press callback
  final VoidCallback? onPressed;

  /// Button size
  final IconButtonSize size;

  /// Icon color
  final Color? color;

  /// Background color
  final Color? backgroundColor;

  /// Optional tooltip
  final String? tooltip;

  /// Disabled state
  final bool isDisabled;

  double get _size {
    switch (size) {
      case IconButtonSize.sm:
        return 24;
      case IconButtonSize.md:
        return 32;
      case IconButtonSize.lg:
        return 40;
    }
  }

  double get _iconSize {
    switch (size) {
      case IconButtonSize.sm:
        return 14;
      case IconButtonSize.md:
        return 16;
      case IconButtonSize.lg:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final isEnabled = !isDisabled && onPressed != null;

    final effectiveColor = color ?? (isEnabled ? colors.iconBase : colors.iconMuted);
    final effectiveBgColor = backgroundColor ?? Colors.transparent;

    Widget button = fluent.IconButton(
      icon: Icon(
        icon,
        size: _iconSize,
        color: effectiveColor,
      ),
      onPressed: isEnabled ? onPressed : null,
      style: fluent.ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colors.surfacePressed;
          }
          if (states.contains(WidgetState.hovered)) {
            return colors.surfaceHover;
          }
          return effectiveBgColor;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        ),
      ),
    );

    button = SizedBox(
      width: _size,
      height: _size,
      child: button,
    );

    if (tooltip != null) {
      button = fluent.Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// A toggle-able icon button (e.g., for like, favorite, etc.)
class AppToggleIconButton extends StatelessWidget {
  const AppToggleIconButton({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onChanged,
    this.size = IconButtonSize.md,
    this.color,
    this.selectedColor,
    this.tooltip,
    this.isDisabled = false,
    super.key,
  });

  /// Icon when not selected
  final IconData icon;

  /// Icon when selected
  final IconData selectedIcon;

  /// Whether currently selected
  final bool isSelected;

  /// Toggle callback
  final ValueChanged<bool>? onChanged;

  /// Button size
  final IconButtonSize size;

  /// Unselected icon color
  final Color? color;

  /// Selected icon color
  final Color? selectedColor;

  /// Optional tooltip
  final String? tooltip;

  /// Disabled state
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return AppIconButton(
      icon: isSelected ? selectedIcon : icon,
      color: isSelected ? (selectedColor ?? colors.accentPrimary) : color,
      size: size,
      tooltip: tooltip,
      isDisabled: isDisabled,
      onPressed: onChanged != null ? () => onChanged!(!isSelected) : null,
    );
  }
}
