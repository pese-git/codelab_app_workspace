import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A list item component with optional leading/trailing widgets.
class ListItem extends fluent.StatelessWidget {
  const ListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
    this.padding,
    super.key,
  });

  /// Title text
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Leading widget (icon, avatar, etc.)
  final fluent.Widget? leading;

  /// Trailing widget
  final fluent.Widget? trailing;

  /// Tap callback
  final fluent.VoidCallback? onTap;

  /// Selected state
  final bool isSelected;

  /// Disabled state
  final bool isDisabled;

  /// Custom padding
  final fluent.EdgeInsetsGeometry? padding;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isEnabled = !isDisabled && onTap != null;

    return fluent.GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: fluent.MouseRegion(
        cursor: isEnabled
            ? fluent.SystemMouseCursors.click
            : fluent.SystemMouseCursors.basic,
        child: fluent.AnimatedContainer(
          duration: AppDurations.fast,
          padding: padding ?? const fluent.EdgeInsets.all(AppSpacing.md),
          decoration: fluent.BoxDecoration(
            color: isSelected
                ? colors.surfaceSelected
                : fluent.Colors.transparent,
            borderRadius: AppRadius.smAll,
          ),
          child: fluent.Row(
            children: [
              if (leading != null) ...[
                leading!,
                const fluent.SizedBox(width: AppSpacing.md),
              ],
              fluent.Expanded(
                child: fluent.Column(
                  crossAxisAlignment: fluent.CrossAxisAlignment.start,
                  mainAxisSize: fluent.MainAxisSize.min,
                  children: [
                    fluent.Text(
                      title,
                      style: AppTypography.body(
                        color: isDisabled ? colors.textMuted : colors.textBase,
                      ),
                      maxLines: 1,
                      overflow: fluent.TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      fluent.Text(
                        subtitle!,
                        style: AppTypography.caption(color: colors.textWeak),
                        maxLines: 1,
                        overflow: fluent.TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const fluent.SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A selectable list item with checkbox.
class CheckableListItem extends fluent.StatelessWidget {
  const CheckableListItem({
    required this.title,
    required this.isChecked,
    required this.onChanged,
    this.subtitle,
    this.isDisabled = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool isChecked;
  final fluent.ValueChanged<bool> onChanged;
  final bool isDisabled;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return ListItem(
      title: title,
      subtitle: subtitle,
      isDisabled: isDisabled,
      onTap: () => onChanged(!isChecked),
      leading: fluent.Container(
        width: 18,
        height: 18,
        decoration: fluent.BoxDecoration(
          color: isChecked ? colors.accentPrimary : fluent.Colors.transparent,
          borderRadius: fluent.BorderRadius.circular(4),
          border: fluent.Border.all(
            color: isChecked ? colors.accentPrimary : colors.borderStrong,
          ),
        ),
        child: isChecked
            ? fluent.Icon(
                fluent.FluentIcons.check_mark,
                size: 14,
                color: colors.iconOnAccent,
              )
            : null,
      ),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewListItemDefault() {
  return const ListItem(
    title: 'Project Alpha',
    subtitle: 'Last edited 2 hours ago',
    leading: fluent.Icon(fluent.FluentIcons.folder_horizontal, size: 20),
    trailing: fluent.Icon(fluent.FluentIcons.chevron_right, size: 16),
  );
}

@Preview(name: 'Selected')
fluent.Widget previewListItemSelected() {
  return const ListItem(
    title: 'Selected Item',
    subtitle: 'This item is currently selected',
    isSelected: true,
    leading: fluent.Icon(fluent.FluentIcons.check_mark, size: 20),
  );
}

@Preview(name: 'Disabled')
fluent.Widget previewListItemDisabled() {
  return const ListItem(
    title: 'Disabled Item',
    subtitle: 'This item cannot be selected',
    isDisabled: true,
    leading: fluent.Icon(fluent.FluentIcons.lock, size: 20),
  );
}

@Preview(name: 'Checkable Unchecked')
@Preview(name: 'Checkable Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewCheckableListItemUnchecked() {
  return CheckableListItem(
    title: 'Enable notifications',
    subtitle: 'Receive push notifications',
    isChecked: false,
    onChanged: (_) {},
  );
}

@Preview(name: 'Checkable Checked')
fluent.Widget previewCheckableListItemChecked() {
  return CheckableListItem(
    title: 'Enable notifications',
    subtitle: 'Receive push notifications',
    isChecked: true,
    onChanged: (_) {},
  );
}

@Preview(name: 'Checkable Disabled')
fluent.Widget previewCheckableListItemDisabled() {
  return CheckableListItem(
    title: 'Legacy feature',
    subtitle: 'No longer available',
    isChecked: false,
    isDisabled: true,
    onChanged: (_) {},
  );
}
