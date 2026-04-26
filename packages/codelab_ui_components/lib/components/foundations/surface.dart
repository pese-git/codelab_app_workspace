import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A surface container with configurable appearance.
/// Used as a foundation for cards, panels, and other containers.
class Surface extends fluent.StatelessWidget {
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
    this.clipBehavior = fluent.Clip.antiAlias,
    super.key,
  });

  /// Child widget
  final fluent.Widget child;

  /// Background color (defaults to surfaceBase)
  final fluent.Color? color;

  /// Border color (null for no border)
  final fluent.Color? borderColor;

  /// Border radius
  final fluent.BorderRadius? borderRadius;

  /// Elevation (0 for no shadow)
  final double elevation;

  /// Internal padding
  final fluent.EdgeInsetsGeometry? padding;

  /// External margin
  final fluent.EdgeInsetsGeometry? margin;

  /// Fixed width
  final double? width;

  /// Fixed height
  final double? height;

  /// Size constraints
  final fluent.BoxConstraints? constraints;

  /// Clip behavior
  final fluent.Clip clipBehavior;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final shadows = brightness == fluent.Brightness.light
        ? AppShadows.light
        : AppShadows.dark;

    final effectiveColor = color ?? colors.surfaceBase;
    final effectiveBorderRadius = borderRadius ?? AppRadius.lgAll;

    List<fluent.BoxShadow> boxShadow;
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

    fluent.Widget result = fluent.Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      decoration: fluent.BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        border: borderColor != null
            ? fluent.Border.all(color: borderColor!)
            : null,
        boxShadow: boxShadow,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );

    return result;
  }
}

/// Elevated surface variant with default shadow.
class ElevatedSurface extends fluent.StatelessWidget {
  const ElevatedSurface({
    required this.child,
    this.elevation = AppElevation.low,
    this.padding,
    this.borderRadius,
    super.key,
  });

  final fluent.Widget child;
  final double elevation;
  final fluent.EdgeInsetsGeometry? padding;
  final fluent.BorderRadius? borderRadius;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return Surface(
      elevation: elevation,
      padding: padding,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

/// Outlined surface variant with border.
class OutlinedSurface extends fluent.StatelessWidget {
  const OutlinedSurface({
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    super.key,
  });

  final fluent.Widget child;
  final fluent.EdgeInsetsGeometry? padding;
  final fluent.BorderRadius? borderRadius;
  final fluent.Color? borderColor;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
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
