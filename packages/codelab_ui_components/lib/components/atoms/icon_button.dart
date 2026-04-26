import 'package:fluent_ui/fluent_ui.dart' as fluent;

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
class AppIconButton extends fluent.StatelessWidget {
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
  final fluent.IconData icon;

  /// Press callback
  final fluent.VoidCallback? onPressed;

  /// Button size
  final IconButtonSize size;

  /// Icon color
  final fluent.Color? color;

  /// Background color
  final fluent.Color? backgroundColor;

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
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isEnabled = !isDisabled && onPressed != null;

    final effectiveColor =
        color ?? (isEnabled ? colors.iconBase : colors.iconMuted);
    final effectiveBgColor = backgroundColor ?? fluent.Colors.transparent;

    fluent.Widget button = fluent.IconButton(
      icon: fluent.Icon(icon, size: _iconSize, color: effectiveColor),
      onPressed: isEnabled ? onPressed : null,
      style: fluent.ButtonStyle(
        backgroundColor: fluent.WidgetStateProperty.resolveWith((states) {
          if (states.contains(fluent.WidgetState.pressed)) {
            return colors.surfacePressed;
          }
          if (states.contains(fluent.WidgetState.hovered)) {
            return colors.surfaceHover;
          }
          return effectiveBgColor;
        }),
        shape: fluent.WidgetStatePropertyAll(
          fluent.RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        ),
      ),
    );

    button = fluent.SizedBox(width: _size, height: _size, child: button);

    if (tooltip != null) {
      button = fluent.Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// A toggle-able icon button (e.g., for like, favorite, etc.)
class AppToggleIconButton extends fluent.StatelessWidget {
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
  final fluent.IconData icon;

  /// Icon when selected
  final fluent.IconData selectedIcon;

  /// Whether currently selected
  final bool isSelected;

  /// Toggle callback
  final fluent.ValueChanged<bool>? onChanged;

  /// Button size
  final IconButtonSize size;

  /// Unselected icon color
  final fluent.Color? color;

  /// Selected icon color
  final fluent.Color? selectedColor;

  /// Optional tooltip
  final String? tooltip;

  /// Disabled state
  final bool isDisabled;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

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
