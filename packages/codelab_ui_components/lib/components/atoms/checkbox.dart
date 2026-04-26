import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A checkbox component.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    required this.value,
    required this.onChanged,
    this.label,
    this.isDisabled = false,
    this.isIndeterminate = false,
    super.key,
  });

  /// Current checked state
  final bool value;

  /// Change callback
  final ValueChanged<bool>? onChanged;

  /// Optional label
  final String? label;

  /// Disabled state
  final bool isDisabled;

  /// Indeterminate state (partially checked)
  final bool isIndeterminate;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    Widget checkbox = fluent.Checkbox(
      checked: isIndeterminate ? null : value,
      onChanged: isDisabled ? null : (v) => onChanged?.call(v ?? false),
    );

    if (label != null) {
      checkbox = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          const SizedBox(width: AppSpacing.sm),
          Text(
            label!,
            style: AppTypography.body(
              color: isDisabled ? colors.textMuted : colors.textBase,
            ),
          ),
        ],
      );
    }

    return checkbox;
  }
}

/// A group of checkboxes.
class CheckboxGroup extends StatelessWidget {
  const CheckboxGroup({
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.direction = Axis.vertical,
    this.spacing = AppSpacing.sm,
    this.isDisabled = false,
    super.key,
  });

  /// List of option labels
  final List<String> options;

  /// Currently selected values (indices)
  final Set<int> selectedValues;

  /// Change callback with updated selection
  final ValueChanged<Set<int>> onChanged;

  /// Layout direction
  final Axis direction;

  /// Spacing between checkboxes
  final double spacing;

  /// Disabled state
  final bool isDisabled;

  void _handleChange(int index, bool checked) {
    final newSelection = Set<int>.from(selectedValues);
    if (checked) {
      newSelection.add(index);
    } else {
      newSelection.remove(index);
    }
    onChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final children = List.generate(options.length, (index) {
      return AppCheckbox(
        value: selectedValues.contains(index),
        onChanged: (checked) => _handleChange(index, checked),
        label: options[index],
        isDisabled: isDisabled,
      );
    });

    if (direction == Axis.horizontal) {
      return Wrap(spacing: spacing, runSpacing: spacing, children: children);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.map((child) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: child,
        );
      }).toList(),
    );
  }
}
