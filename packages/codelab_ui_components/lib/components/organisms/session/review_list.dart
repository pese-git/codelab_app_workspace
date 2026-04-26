import 'package:flutter/material.dart';

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
class ReviewList extends StatelessWidget {
  const ReviewList({required this.items, this.onItemTap, super.key});

  final List<ReviewItem> items;
  final ValueChanged<ReviewItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
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

  Widget _buildEmptyState(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 48, color: colors.successBase),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No issues found',
            style: AppTypography.subtitle(color: colors.textStrong),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'All code looks good!',
            style: AppTypography.body(color: colors.textWeak),
          ),
        ],
      ),
    );
  }
}

/// A single review card.
class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.item, this.onTap, super.key});

  final ReviewItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.md2),
        padding: const EdgeInsets.all(AppSpacing.lg2),
        decoration: BoxDecoration(
          color: colors.surfaceBase,
          borderRadius: AppRadius.smAll,
          border: Border.all(color: colors.borderWeak),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSeverityBadge(item.severity, colors),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTypography.bodyMedium(color: colors.textStrong),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.summary,
              style: AppTypography.caption(color: colors.textWeak),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(String severity, LightColors colors) {
    Color bgColor;
    Color textColor;

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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
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
