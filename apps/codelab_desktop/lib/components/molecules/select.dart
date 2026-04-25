import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'dropdown.dart';

/// A select field with label and validation.
class SelectField<T> extends StatelessWidget {
  const SelectField({
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.isDisabled = false,
    this.isRequired = false,
    super.key,
  });

  /// Select items
  final List<DropdownItem<T>> items;

  /// Currently selected value
  final T? value;

  /// Selection change callback
  final ValueChanged<T?> onChanged;

  /// Field label
  final String? label;

  /// Placeholder text
  final String? placeholder;

  /// Helper text
  final String? helper;

  /// Error message
  final String? error;

  /// Disabled state
  final bool isDisabled;

  /// Required field
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTypography.bodyMedium(color: colors.textBase),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: AppTypography.bodyMedium(color: colors.errorBase),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        AppDropdown<T>(
          items: items,
          value: value,
          onChanged: onChanged,
          placeholder: placeholder,
          isDisabled: isDisabled,
        ),
        if (helper != null && !hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            helper!,
            style: AppTypography.caption(color: colors.textWeak),
          ),
        ],
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            error!,
            style: AppTypography.caption(color: colors.errorText),
          ),
        ],
      ],
    );
  }
}

/// A multi-select component.
class MultiSelect<T> extends StatelessWidget {
  const MultiSelect({
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.label,
    this.placeholder = 'Select items...',
    this.maxDisplayCount = 2,
    super.key,
  });

  /// Available items
  final List<DropdownItem<T>> items;

  /// Currently selected values
  final Set<T> selectedValues;

  /// Selection change callback
  final ValueChanged<Set<T>> onChanged;

  /// Field label
  final String? label;

  /// Placeholder text
  final String placeholder;

  /// Max items to display in the field
  final int maxDisplayCount;

  String get _displayText {
    if (selectedValues.isEmpty) return placeholder;

    final selectedItems = items
        .where((item) => selectedValues.contains(item.value))
        .take(maxDisplayCount)
        .map((item) => item.label)
        .join(', ');

    if (selectedValues.length > maxDisplayCount) {
      return '$selectedItems +${selectedValues.length - maxDisplayCount}';
    }
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodyMedium(color: colors.textBase),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: colors.borderBase),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayText,
                  style: AppTypography.body(
                    color: selectedValues.isEmpty
                        ? colors.textMuted
                        : colors.textBase,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: colors.iconWeak,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
