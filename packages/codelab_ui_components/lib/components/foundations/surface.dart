import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A surface container with configurable appearance.
/// Used as a foundation for cards, panels, and other containers.
class Surface extends StatelessWidget {
  const Surface({
    required this.child,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  /// Child widget
  final Widget child;

  /// Background color (defaults to surfaceBase)
  final Color? color;

  /// Border color (null for no border)
  final Color? borderColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Elevation (0 for no shadow)
  final double elevation;

  /// Internal padding
  final EdgeInsetsGeometry? padding;

  /// External margin
  final EdgeInsetsGeometry? margin;

  /// Fixed width
  final double? width;

  /// Fixed height
  final double? height;

  /// Size constraints
  final BoxConstraints? constraints;

  /// Clip behavior
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final shadows = brightness == Brightness.light
        ? AppShadows.light
        : AppShadows.dark;

    final effectiveColor = color ?? colors.surfaceBase;
    final effectiveBorderRadius = borderRadius ?? AppRadius.lgAll;

    List<BoxShadow> boxShadow;
    switch (elevation) {
      case 0:
        boxShadow = shadows.none;
        break;
      case <= 1:
        boxShadow = shadows.subtle;
        break;
      case <= 2:
        boxShadow = shadows.sm;
        break;
      case <= 4:
        boxShadow = shadows.md;
        break;
      case <= 8:
        boxShadow = shadows.lg;
        break;
      default:
        boxShadow = shadows.xl;
    }

    Widget result = Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        boxShadow: boxShadow,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );

    return result;
  }
}

/// Elevated surface variant with default shadow.
class ElevatedSurface extends StatelessWidget {
  const ElevatedSurface({
    required this.child,
    this.elevation = AppElevation.low,
    this.padding,
    this.borderRadius,
    super.key,
  });

  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Surface(
      elevation: elevation,
      padding: padding,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

/// Outlined surface variant with border.
class OutlinedSurface extends StatelessWidget {
  const OutlinedSurface({
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Surface(
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor ?? colors.borderWeak,
      child: child,
    );
  }
}
