import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';
import 'dropdown.dart';

/// A select field with label and validation.
class SelectField<T> extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<T?> onChanged;

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
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        if (label != null) ...[
          fluent.Row(
            children: [
              fluent.Text(
                label!,
                style: AppTypography.bodyMedium(color: colors.textBase),
              ),
              if (isRequired)
                fluent.Text(
                  ' *',
                  style: AppTypography.bodyMedium(color: colors.errorBase),
                ),
            ],
          ),
          const fluent.SizedBox(height: AppSpacing.xs),
        ],
        AppDropdown<T>(
          items: items,
          value: value,
          onChanged: onChanged,
          placeholder: placeholder,
          isDisabled: isDisabled,
        ),
        if (helper != null && !hasError) ...[
          const fluent.SizedBox(height: AppSpacing.xs),
          fluent.Text(
            helper!,
            style: AppTypography.caption(color: colors.textWeak),
          ),
        ],
        if (hasError) ...[
          const fluent.SizedBox(height: AppSpacing.xs),
          fluent.Text(
            error!,
            style: AppTypography.caption(color: colors.errorText),
          ),
        ],
      ],
    );
  }
}

/// A multi-select component.
class MultiSelect<T> extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<Set<T>> onChanged;

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
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        if (label != null) ...[
          fluent.Text(
            label!,
            style: AppTypography.bodyMedium(color: colors.textBase),
          ),
          const fluent.SizedBox(height: AppSpacing.xs),
        ],
        fluent.Container(
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: fluent.BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: AppRadius.mdAll,
            border: fluent.Border.all(color: colors.borderBase),
          ),
          child: fluent.Row(
            children: [
              fluent.Expanded(
                child: fluent.Text(
                  _displayText,
                  style: AppTypography.body(
                    color: selectedValues.isEmpty
                        ? colors.textMuted
                        : colors.textBase,
                  ),
                ),
              ),
              fluent.Icon(
                fluent.FluentIcons.chevron_down,
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
