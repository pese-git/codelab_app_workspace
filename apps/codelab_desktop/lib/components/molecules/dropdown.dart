import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A dropdown menu component.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.isDisabled = false,
    this.isExpanded = true,
    super.key,
  });

  /// Dropdown items
  final List<DropdownItem<T>> items;

  /// Currently selected value
  final T? value;

  /// Selection change callback
  final ValueChanged<T?> onChanged;

  /// Placeholder text when no selection
  final String? placeholder;

  /// Disabled state
  final bool isDisabled;

  /// Whether dropdown expands to fill parent width
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return fluent.ComboBox<T>(
      value: value,
      items: items.map((item) {
        return fluent.ComboBoxItem<T>(
          value: item.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 16, color: colors.iconBase),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(child: Text(item.label)),
            ],
          ),
        );
      }).toList(),
      onChanged: isDisabled ? null : onChanged,
      placeholder: placeholder != null
          ? Text(
              placeholder!,
              style: AppTypography.body(color: colors.textMuted),
            )
          : null,
      isExpanded: isExpanded,
    );
  }
}

/// A dropdown item.
class DropdownItem<T> {
  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.isDisabled = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool isDisabled;
}

/// A dropdown with sections/groups.
class GroupedDropdown<T> extends StatelessWidget {
  const GroupedDropdown({
    required this.groups,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.isDisabled = false,
    super.key,
  });

  /// Grouped items
  final List<DropdownGroup<T>> groups;

  /// Currently selected value
  final T? value;

  /// Selection change callback
  final ValueChanged<T?> onChanged;

  /// Placeholder text
  final String? placeholder;

  /// Disabled state
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    // Flatten groups to items for basic implementation
    final allItems = <DropdownItem<T>>[];
    for (final group in groups) {
      allItems.addAll(group.items);
    }

    return AppDropdown<T>(
      items: allItems,
      value: value,
      onChanged: onChanged,
      placeholder: placeholder,
      isDisabled: isDisabled,
    );
  }
}

/// A group of dropdown items.
class DropdownGroup<T> {
  const DropdownGroup({
    required this.label,
    required this.items,
  });

  final String label;
  final List<DropdownItem<T>> items;
}
