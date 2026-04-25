import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A tag/chip component for labels and filters.
class Tag extends StatelessWidget {
  const Tag({
    required this.label,
    this.icon,
    this.onRemove,
    this.onPressed,
    this.color,
    this.isSelected = false,
    super.key,
  });

  /// Tag label
  final String label;

  /// Optional leading icon
  final IconData? icon;

  /// Remove callback (shows X button)
  final VoidCallback? onRemove;

  /// Press callback
  final VoidCallback? onPressed;

  /// Custom background color
  final Color? color;

  /// Selected state
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    final backgroundColor = color ?? (isSelected ? colors.accentSubtle : colors.surfaceSubtle);
    final textColor = isSelected ? colors.textStrong : colors.textBase;
    final borderColor = isSelected ? colors.accentPrimary : colors.borderWeak;

    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadius.smAll,
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: textColor),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: AppTypography.small(color: textColor),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: colors.iconWeak,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A group of tags with optional selection behavior.
class TagGroup extends StatelessWidget {
  const TagGroup({
    required this.tags,
    this.selectedIndex,
    this.onTagSelected,
    this.spacing = AppSpacing.sm,
    this.wrap = true,
    super.key,
  });

  /// List of tag labels
  final List<String> tags;

  /// Currently selected tag index
  final int? selectedIndex;

  /// Callback when tag is selected
  final ValueChanged<int>? onTagSelected;

  /// Spacing between tags
  final double spacing;

  /// Whether to wrap tags
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final children = List.generate(tags.length, (index) {
      return Tag(
        label: tags[index],
        isSelected: index == selectedIndex,
        onPressed: onTagSelected != null ? () => onTagSelected!(index) : null,
      );
    });

    if (wrap) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: children,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children.map((tag) {
        return Padding(
          padding: EdgeInsets.only(right: spacing),
          child: tag,
        );
      }).toList(),
    );
  }
}
