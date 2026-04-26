import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A tag/chip component for labels and filters.
class Tag extends fluent.StatelessWidget {
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
  final fluent.IconData? icon;

  /// Remove callback (shows X button)
  final fluent.VoidCallback? onRemove;

  /// Press callback
  final fluent.VoidCallback? onPressed;

  /// Custom background color
  final fluent.Color? color;

  /// Selected state
  final bool isSelected;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final backgroundColor =
        color ?? (isSelected ? colors.accentSubtle : colors.surfaceSubtle);
    final textColor = isSelected ? colors.textStrong : colors.textBase;
    final borderColor = isSelected ? colors.accentPrimary : colors.borderWeak;

    return fluent.GestureDetector(
      onTap: onPressed,
      child: fluent.MouseRegion(
        cursor: onPressed != null
            ? fluent.SystemMouseCursors.click
            : fluent.SystemMouseCursors.basic,
        child: fluent.Container(
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: fluent.BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadius.smAll,
            border: fluent.Border.all(color: borderColor),
          ),
          child: fluent.Row(
            mainAxisSize: fluent.MainAxisSize.min,
            children: [
              if (icon != null) ...[
                fluent.Icon(icon, size: 12, color: textColor),
                const fluent.SizedBox(width: AppSpacing.xs),
              ],
              fluent.Text(label, style: AppTypography.small(color: textColor)),
              if (onRemove != null) ...[
                const fluent.SizedBox(width: AppSpacing.xs),
                fluent.GestureDetector(
                  onTap: onRemove,
                  child: fluent.Icon(fluent.FluentIcons.chrome_close, size: 12, color: colors.iconWeak),
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
class TagGroup extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<int>? onTagSelected;

  /// Spacing between tags
  final double spacing;

  /// Whether to wrap tags
  final bool wrap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final children = List.generate(tags.length, (index) {
      return Tag(
        label: tags[index],
        isSelected: index == selectedIndex,
        onPressed: onTagSelected != null ? () => onTagSelected!(index) : null,
      );
    });

    if (wrap) {
      return fluent.Wrap(spacing: spacing, runSpacing: spacing, children: children);
    }

    return fluent.Row(
      mainAxisSize: fluent.MainAxisSize.min,
      children: children.map((tag) {
        return fluent.Padding(
          padding: fluent.EdgeInsets.only(right: spacing),
          child: tag,
        );
      }).toList(),
    );
  }
}
