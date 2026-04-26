import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A horizontal or vertical divider component.
class AppDivider extends StatelessWidget {
  const AppDivider({
    this.direction = Axis.horizontal,
    this.thickness = AppDimensions.dividerThickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  });

  /// Divider direction
  final Axis direction;

  /// Line thickness
  final double thickness;

  /// Indent from start
  final double indent;

  /// Indent from end
  final double endIndent;

  /// Custom color
  final Color? color;

  /// Horizontal divider
  const AppDivider.horizontal({
    this.thickness = AppDimensions.dividerThickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  }) : direction = Axis.horizontal;

  /// Vertical divider
  const AppDivider.vertical({
    this.thickness = AppDimensions.dividerThickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  }) : direction = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveColor = color ?? colors.borderWeak;

    if (direction == Axis.horizontal) {
      return Padding(
        padding: EdgeInsets.only(left: indent, right: endIndent),
        child: Container(height: thickness, color: effectiveColor),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: indent, bottom: endIndent),
      child: Container(width: thickness, color: effectiveColor),
    );
  }
}

/// A divider with a label in the middle.
class LabeledDivider extends StatelessWidget {
  const LabeledDivider({required this.label, this.color, super.key});

  /// Label text
  final String label;

  /// Custom color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveColor = color ?? colors.borderWeak;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppDimensions.dividerThickness,
            color: effectiveColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: AppTypography.caption(color: colors.textMuted),
          ),
        ),
        Expanded(
          child: Container(
            height: AppDimensions.dividerThickness,
            color: effectiveColor,
          ),
        ),
      ],
    );
  }
}
