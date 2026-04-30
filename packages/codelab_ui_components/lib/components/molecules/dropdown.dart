import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A dropdown menu component.
class AppDropdown<T> extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<T?> onChanged;

  /// Placeholder text when no selection
  final String? placeholder;

  /// Disabled state
  final bool isDisabled;

  /// Whether dropdown expands to fill parent width
  final bool isExpanded;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.ComboBox<T>(
      value: value,
      items: items.map((item) {
        return fluent.ComboBoxItem<T>(
          value: item.value,
          child: fluent.Row(
            mainAxisSize: fluent.MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                fluent.Icon(item.icon, size: 16, color: colors.iconBase),
                const fluent.SizedBox(width: AppSpacing.sm),
              ],
              fluent.Flexible(child: fluent.Text(item.label)),
            ],
          ),
        );
      }).toList(),
      onChanged: isDisabled ? null : onChanged,
      placeholder: placeholder != null
          ? fluent.Text(
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
  final fluent.IconData? icon;
  final bool isDisabled;
}

/// A dropdown with sections/groups.
class GroupedDropdown<T> extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<T?> onChanged;

  /// Placeholder text
  final String? placeholder;

  /// Disabled state
  final bool isDisabled;

  @override
  fluent.Widget build(fluent.BuildContext context) {
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
  const DropdownGroup({required this.label, required this.items});

  final String label;
  final List<DropdownItem<T>> items;
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewDropdownDefault() {
  return AppDropdown<String>(
    items: const [
      DropdownItem(value: 'option1', label: 'Option 1'),
      DropdownItem(value: 'option2', label: 'Option 2'),
      DropdownItem(value: 'option3', label: 'Option 3'),
    ],
    value: 'option1',
    onChanged: (_) {},
    placeholder: 'Select an option',
  );
}

@Preview(name: 'With Icons')
fluent.Widget previewDropdownWithIcons() {
  return AppDropdown<String>(
    items: const [
      DropdownItem(value: 'asc', label: 'Ascending', icon: fluent.FluentIcons.sort_up),
      DropdownItem(value: 'desc', label: 'Descending', icon: fluent.FluentIcons.sort_down),
    ],
    value: 'asc',
    onChanged: (_) {},
  );
}

@Preview(name: 'Grouped')
fluent.Widget previewGroupedDropdown() {
  return GroupedDropdown<String>(
    groups: const [
      DropdownGroup(
        label: 'Fruits',
        items: [
          DropdownItem(value: 'apple', label: 'Apple'),
          DropdownItem(value: 'banana', label: 'Banana'),
        ],
      ),
      DropdownGroup(
        label: 'Vegetables',
        items: [
          DropdownItem(value: 'carrot', label: 'Carrot'),
          DropdownItem(value: 'broccoli', label: 'Broccoli'),
        ],
      ),
    ],
    value: 'apple',
    onChanged: (_) {},
    placeholder: 'Select food',
  );
}
