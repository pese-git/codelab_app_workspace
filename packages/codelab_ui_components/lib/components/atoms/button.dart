import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../foundations/loaders.dart';
import '../theme/tokens.dart';

/// Button variant types.
enum ButtonVariant {
  /// Primary filled button
  primary,

  /// Secondary outlined button
  secondary,

  /// Tertiary text button
  tertiary,

  /// Destructive (danger) button
  destructive,
}

/// Button size variants.
enum ButtonSize {
  /// Small (28px height)
  sm,

  /// Medium (36px height) - default
  md,

  /// Large (44px height)
  lg,
}

/// A styled button component with multiple variants.
class AppButton extends fluent.StatelessWidget {
  const AppButton({
    required this.onPressed,
    this.label,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    super.key,
  }) : assert(
         label != null || icon != null,
         'Either label or icon must be provided',
       );

  /// Button press callback (null for disabled state)
  final fluent.VoidCallback? onPressed;

  /// Button label text
  final String? label;

  /// Optional leading icon
  final fluent.IconData? icon;

  /// Button variant
  final ButtonVariant variant;

  /// Button size
  final ButtonSize size;

  /// Show loading state
  final bool isLoading;

  /// Disabled state (also disabled when isLoading)
  final bool isDisabled;

  /// Expand to full width
  final bool fullWidth;

  /// Primary button factory
  const AppButton.primary({
    required this.onPressed,
    this.label,
    this.icon,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    super.key,
  }) : variant = ButtonVariant.primary;

  /// Secondary button factory
  const AppButton.secondary({
    required this.onPressed,
    this.label,
    this.icon,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    super.key,
  }) : variant = ButtonVariant.secondary;

  /// Tertiary button factory
  const AppButton.tertiary({
    required this.onPressed,
    this.label,
    this.icon,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    super.key,
  }) : variant = ButtonVariant.tertiary;

  /// Destructive button factory
  const AppButton.destructive({
    required this.onPressed,
    this.label,
    this.icon,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    super.key,
  }) : variant = ButtonVariant.destructive;

  double get _height {
    switch (size) {
      case ButtonSize.sm:
        return AppDimensions.buttonHeightSm;
      case ButtonSize.md:
        return AppDimensions.buttonHeightMd;
      case ButtonSize.lg:
        return AppDimensions.buttonHeightLg;
    }
  }

  fluent.EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.sm:
        return const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.md);
      case ButtonSize.md:
        return const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case ButtonSize.lg:
        return const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.xl);
    }
  }

  double get _iconSize {
    switch (size) {
      case ButtonSize.sm:
        return 14;
      case ButtonSize.md:
        return 16;
      case ButtonSize.lg:
        return 18;
    }
  }

  fluent.TextStyle _textStyle(LightColors colors) {
    switch (size) {
      case ButtonSize.sm:
        return AppTypography.small(color: colors.textBase);
      case ButtonSize.md:
        return AppTypography.label(color: colors.textBase);
      case ButtonSize.lg:
        return AppTypography.subtitle(color: colors.textBase);
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    final fluent.Color backgroundColor;
    final fluent.Color foregroundColor;
    final fluent.Color? borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = isEnabled
            ? colors.accentPrimary
            : colors.surfaceSubtle;
        foregroundColor = isEnabled ? colors.textOnAccent : colors.textMuted;
        borderColor = null;
        break;
      case ButtonVariant.secondary:
        backgroundColor = fluent.Colors.transparent;
        foregroundColor = isEnabled ? colors.textBase : colors.textMuted;
        borderColor = colors.borderBase;
        break;
      case ButtonVariant.tertiary:
        backgroundColor = fluent.Colors.transparent;
        foregroundColor = isEnabled ? colors.textBase : colors.textMuted;
        borderColor = null;
        break;
      case ButtonVariant.destructive:
        backgroundColor = isEnabled ? colors.errorBase : colors.surfaceSubtle;
        foregroundColor = isEnabled ? fluent.Colors.white : colors.textMuted;
        borderColor = null;
        break;
    }

    fluent.Widget content;
    if (isLoading) {
      content = ButtonLoader(size: _iconSize, color: foregroundColor);
    } else {
      final children = <fluent.Widget>[];
      if (icon != null) {
        children.add(
          fluent.Icon(icon, size: _iconSize, color: foregroundColor),
        );
        if (label != null) {
          children.add(const fluent.SizedBox(width: AppSpacing.sm));
        }
      }
      if (label != null) {
        children.add(
          fluent.Text(
            label!,
            style: _textStyle(colors).copyWith(color: foregroundColor),
          ),
        );
      }
      content = fluent.Row(
        mainAxisSize: fluent.MainAxisSize.min,
        mainAxisAlignment: fluent.MainAxisAlignment.center,
        children: children,
      );
    }

    return fluent.SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: fluent.Button(
        onPressed: isEnabled ? onPressed : null,
        style: fluent.ButtonStyle(
          backgroundColor: fluent.WidgetStatePropertyAll(backgroundColor),
          foregroundColor: fluent.WidgetStatePropertyAll(foregroundColor),
          padding: fluent.WidgetStatePropertyAll(_padding),
          shape: fluent.WidgetStatePropertyAll(
            fluent.RoundedRectangleBorder(
              borderRadius: AppRadius.mdAll,
              side: borderColor != null
                  ? fluent.BorderSide(color: borderColor)
                  : fluent.BorderSide.none,
            ),
          ),
        ),
        child: content,
      ),
    );
  }
}
