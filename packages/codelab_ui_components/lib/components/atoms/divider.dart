import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A horizontal or vertical divider component.
class AppDivider extends fluent.StatelessWidget {

  /// Horizontal divider
  const AppDivider.horizontal({
    this.thickness = AppDimensions.dividerThickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  }) : direction = fluent.Axis.horizontal;

  /// Vertical divider
  const AppDivider.vertical({
    this.thickness = AppDimensions.dividerThickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  }) : direction = fluent.Axis.vertical;
  const AppDivider({
    this.direction = fluent.Axis.horizontal,
    this.thickness = AppDimensions.dividerThickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  });

  /// Divider direction
  final fluent.Axis direction;

  /// Line thickness
  final double thickness;

  /// Indent from start
  final double indent;

  /// Indent from end
  final double endIndent;

  /// Custom color
  final fluent.Color? color;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveColor = color ?? colors.borderWeak;

    if (direction == fluent.Axis.horizontal) {
      return fluent.Padding(
        padding: fluent.EdgeInsets.only(left: indent, right: endIndent),
        child: fluent.Container(height: thickness, color: effectiveColor),
      );
    }

    return fluent.Padding(
      padding: fluent.EdgeInsets.only(top: indent, bottom: endIndent),
      child: fluent.Container(width: thickness, color: effectiveColor),
    );
  }
}

/// A divider with a label in the middle.
class LabeledDivider extends fluent.StatelessWidget {
  const LabeledDivider({required this.label, this.color, super.key});

  /// Label text
  final String label;

  /// Custom color
  final fluent.Color? color;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveColor = color ?? colors.borderWeak;

    return fluent.Row(
      children: [
        fluent.Expanded(
          child: fluent.Container(
            height: AppDimensions.dividerThickness,
            color: effectiveColor,
          ),
        ),
        fluent.Padding(
          padding: const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: fluent.Text(
            label,
            style: AppTypography.caption(color: colors.textMuted),
          ),
        ),
        fluent.Expanded(
          child: fluent.Container(
            height: AppDimensions.dividerThickness,
            color: effectiveColor,
          ),
        ),
      ],
    );
  }
}

// MARK: - Previews

@Preview(name: 'Horizontal')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewDividerHorizontal() {
  return const AppDivider();
}

@Preview(name: 'Vertical')
fluent.Widget previewDividerVertical() {
  return const AppDivider(direction: fluent.Axis.vertical);
}

@Preview(name: 'Labeled')
fluent.Widget previewLabeledDivider() {
  return const LabeledDivider(label: 'Section');
}
