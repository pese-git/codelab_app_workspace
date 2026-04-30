import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A checkbox component.
class AppCheckbox extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<bool>? onChanged;

  /// Optional label
  final String? label;

  /// Disabled state
  final bool isDisabled;

  /// Indeterminate state (partially checked)
  final bool isIndeterminate;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    fluent.Widget checkbox = fluent.Checkbox(
      checked: isIndeterminate ? null : value,
      onChanged: isDisabled ? null : (v) => onChanged?.call(v ?? false),
    );

    if (label != null) {
      checkbox = fluent.Row(
        mainAxisSize: fluent.MainAxisSize.min,
        children: [
          checkbox,
          const fluent.SizedBox(width: AppSpacing.sm),
          fluent.Text(
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
class CheckboxGroup extends fluent.StatelessWidget {
  const CheckboxGroup({
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.direction = fluent.Axis.vertical,
    this.spacing = AppSpacing.sm,
    this.isDisabled = false,
    super.key,
  });

  /// List of option labels
  final List<String> options;

  /// Currently selected values (indices)
  final Set<int> selectedValues;

  /// Change callback with updated selection
  final fluent.ValueChanged<Set<int>> onChanged;

  /// Layout direction
  final fluent.Axis direction;

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
  fluent.Widget build(fluent.BuildContext context) {
    final children = List.generate(options.length, (index) {
      return AppCheckbox(
        value: selectedValues.contains(index),
        onChanged: (checked) => _handleChange(index, checked),
        label: options[index],
        isDisabled: isDisabled,
      );
    });

    if (direction == fluent.Axis.horizontal) {
      return fluent.Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: children,
      );
    }

    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      mainAxisSize: fluent.MainAxisSize.min,
      children: children.map((child) {
        return fluent.Padding(
          padding: fluent.EdgeInsets.only(bottom: spacing),
          child: child,
        );
      }).toList(),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Unchecked')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewCheckboxUnchecked() {
  return AppCheckbox(value: false, onChanged: (_) {});
}

@Preview(name: 'Checked')
fluent.Widget previewCheckboxChecked() {
  return AppCheckbox(value: true, onChanged: (_) {});
}

@Preview(name: 'With Label')
fluent.Widget previewCheckboxWithLabel() {
  return AppCheckbox(value: true, onChanged: (_) {}, label: 'Accept terms');
}

@Preview(name: 'Disabled')
fluent.Widget previewCheckboxDisabled() {
  return const AppCheckbox(value: false, onChanged: null, isDisabled: true, label: 'Disabled');
}

@Preview(name: 'Group')
fluent.Widget previewCheckboxGroup() {
  return CheckboxGroup(
    options: const ['Option A', 'Option B', 'Option C'],
    selectedValues: const {0, 2},
    onChanged: (_) {},
  );
}
