import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A toggle switch component.
class AppToggle extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<bool>? onChanged;

  /// Optional label
  final String? label;

  /// Optional description
  final String? description;

  /// Disabled state
  final bool isDisabled;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final fluent.Widget toggle = fluent.ToggleSwitch(
      checked: value,
      onChanged: isDisabled ? null : onChanged,
    );

    if (label != null || description != null) {
      return fluent.Row(
        mainAxisSize: fluent.MainAxisSize.min,
        crossAxisAlignment: fluent.CrossAxisAlignment.start,
        children: [
          toggle,
          const fluent.SizedBox(width: AppSpacing.md),
          fluent.Flexible(
            child: fluent.Column(
              crossAxisAlignment: fluent.CrossAxisAlignment.start,
              mainAxisSize: fluent.MainAxisSize.min,
              children: [
                if (label != null)
                  fluent.Text(
                    label!,
                    style: AppTypography.body(
                      color: isDisabled ? colors.textMuted : colors.textBase,
                    ),
                  ),
                if (description != null) ...[
                  const fluent.SizedBox(height: AppSpacing.xs2),
                  fluent.Text(
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
class LabeledToggle extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<bool>? onChanged;

  /// Disabled state
  final bool isDisabled;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Row(
      mainAxisAlignment: fluent.MainAxisAlignment.spaceBetween,
      children: [
        fluent.Text(
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

// MARK: - Previews

@Preview(name: 'Off')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewToggleOff() {
  return AppToggle(value: false, onChanged: (_) {});
}

@Preview(name: 'On')
fluent.Widget previewToggleOn() {
  return AppToggle(value: true, onChanged: (_) {});
}

@Preview(name: 'With Label')
fluent.Widget previewToggleWithLabel() {
  return AppToggle(
    value: true,
    onChanged: (_) {},
    label: 'Enable notifications',
    description: 'Receive push notifications for updates',
  );
}

@Preview(name: 'Disabled')
fluent.Widget previewToggleDisabled() {
  return const AppToggle(value: false, onChanged: null, isDisabled: true, label: 'Unavailable');
}

@Preview(name: 'Labeled Toggle')
fluent.Widget previewLabeledToggle() {
  return LabeledToggle(label: 'Dark Mode', value: true, onChanged: (_) {});
}
