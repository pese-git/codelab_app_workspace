import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A toggle switch component.
class AppToggle extends StatelessWidget {
  const AppToggle({
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.isDisabled = false,
    super.key,
  });

  /// Current toggle state
  final bool value;

  /// Change callback
  final ValueChanged<bool>? onChanged;

  /// Optional label
  final String? label;

  /// Optional description
  final String? description;

  /// Disabled state
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    Widget toggle = fluent.ToggleSwitch(
      checked: value,
      onChanged: isDisabled ? null : onChanged,
    );

    if (label != null || description != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          toggle,
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTypography.body(
                      color: isDisabled ? colors.textMuted : colors.textBase,
                    ),
                  ),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.xs2),
                  Text(
                    description!,
                    style: AppTypography.caption(color: colors.textWeak),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return toggle;
  }
}

/// A labeled toggle with label on the left.
class LabeledToggle extends StatelessWidget {
  const LabeledToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
    super.key,
  });

  /// Label text
  final String label;

  /// Current value
  final bool value;

  /// Change callback
  final ValueChanged<bool>? onChanged;

  /// Disabled state
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.body(
            color: isDisabled ? colors.textMuted : colors.textBase,
          ),
        ),
        fluent.ToggleSwitch(
          checked: value,
          onChanged: isDisabled ? null : onChanged,
        ),
      ],
    );
  }
}
