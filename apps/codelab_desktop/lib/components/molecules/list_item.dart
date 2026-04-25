import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A list item component with optional leading/trailing widgets.
class ListItem extends StatelessWidget {
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
  final Widget? leading;

  /// Trailing widget
  final Widget? trailing;

  /// Tap callback
  final VoidCallback? onTap;

  /// Selected state
  final bool isSelected;

  /// Disabled state
  final bool isDisabled;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final isEnabled = !isDisabled && onTap != null;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? colors.surfaceSelected : Colors.transparent,
            borderRadius: AppRadius.smAll,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body(
                        color: isDisabled ? colors.textMuted : colors.textBase,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.caption(color: colors.textWeak),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
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
class CheckableListItem extends StatelessWidget {
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
  final ValueChanged<bool> onChanged;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return ListItem(
      title: title,
      subtitle: subtitle,
      isDisabled: isDisabled,
      onTap: () => onChanged(!isChecked),
      leading: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isChecked ? colors.accentPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isChecked ? colors.accentPrimary : colors.borderStrong,
          ),
        ),
        child: isChecked
            ? Icon(Icons.check, size: 14, color: colors.iconOnAccent)
            : null,
      ),
    );
  }
}
