import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../theme/tokens.dart';

/// A review item model.
class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.severity,
  });

  final String id;
  final String title;
  final String summary;
  final String severity;
}

/// A review list component.
class ReviewList extends fluent.StatelessWidget {
  const ReviewList({required this.items, this.onItemTap, super.key});

  final List<ReviewItem> items;
  final fluent.ValueChanged<ReviewItem>? onItemTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return fluent.ListView.builder(
      padding: const fluent.EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ReviewCard(
          item: items[index],
          onTap: () => onItemTap?.call(items[index]),
        );
      },
    );
  }

  fluent.Widget _buildEmptyState(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Center(
      child: fluent.Column(
        mainAxisSize: fluent.MainAxisSize.min,
        children: [
          fluent.Icon(
            fluent.FluentIcons.check_mark,
            size: 48,
            color: colors.successBase,
          ),
          const fluent.SizedBox(height: AppSpacing.md),
          fluent.Text(
            'No issues found',
            style: AppTypography.subtitle(color: colors.textStrong),
          ),
          const fluent.SizedBox(height: AppSpacing.xs),
          fluent.Text(
            'All code looks good!',
            style: AppTypography.body(color: colors.textWeak),
          ),
        ],
      ),
    );
  }
}

/// A single review card.
class ReviewCard extends fluent.StatelessWidget {
  const ReviewCard({required this.item, this.onTap, super.key});

  final ReviewItem item;
  final fluent.VoidCallback? onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Container(
        margin: const fluent.EdgeInsets.only(top: AppSpacing.md2),
        padding: const fluent.EdgeInsets.all(AppSpacing.lg2),
        decoration: fluent.BoxDecoration(
          color: colors.surfaceBase,
          borderRadius: AppRadius.smAll,
          border: fluent.Border.all(color: colors.borderWeak),
        ),
        child: fluent.Column(
          crossAxisAlignment: fluent.CrossAxisAlignment.start,
          children: [
            fluent.Row(
              children: [
                _buildSeverityBadge(item.severity, colors),
                const fluent.SizedBox(width: AppSpacing.sm),
                fluent.Expanded(
                  child: fluent.Text(
                    item.title,
                    style: AppTypography.bodyMedium(color: colors.textStrong),
                  ),
                ),
              ],
            ),
            const fluent.SizedBox(height: AppSpacing.sm),
            fluent.Text(
              item.summary,
              style: AppTypography.caption(color: colors.textWeak),
            ),
          ],
        ),
      ),
    );
  }

  fluent.Widget _buildSeverityBadge(String severity, LightColors colors) {
    fluent.Color bgColor;
    fluent.Color textColor;

    switch (severity.toLowerCase()) {
      case 'error':
      case 'critical':
        bgColor = colors.errorSubtle;
        textColor = colors.errorText;
        break;
      case 'warning':
        bgColor = colors.warningSubtle;
        textColor = colors.warningText;
        break;
      case 'info':
        bgColor = colors.infoSubtle;
        textColor = colors.infoText;
        break;
      default:
        bgColor = colors.surfaceSubtle;
        textColor = colors.textMuted;
    }

    return fluent.Container(
      padding: const fluent.EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: fluent.BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.fullAll,
      ),
      child: fluent.Text(
        severity,
        style: AppTypography.style(
          size: 11,
          weight: AppTypography.medium,
          color: textColor,
        ),
      ),
    );
  }
}
