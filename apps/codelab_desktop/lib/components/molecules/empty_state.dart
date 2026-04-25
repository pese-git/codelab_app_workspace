import 'package:flutter/material.dart';

import '../atoms/button.dart';
import '../theme/tokens.dart';

/// An empty state placeholder component.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.compact = false,
    super.key,
  });

  /// Title text
  final String title;

  /// Optional description message
  final String? message;

  /// Optional icon
  final IconData? icon;

  /// Primary action button label
  final String? actionLabel;

  /// Primary action callback
  final VoidCallback? onAction;

  /// Secondary action label
  final String? secondaryActionLabel;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  /// Compact mode (smaller)
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    final iconSize = compact ? 40.0 : 64.0;
    final titleStyle = compact
        ? AppTypography.subtitle(color: colors.textStrong)
        : AppTypography.title(color: colors.textStrong);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: colors.surfaceSubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSize * 0.5,
                  color: colors.iconMuted,
                ),
              ),
              SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            ],
            Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
              Text(
                message!,
                style: AppTypography.body(color: colors.textWeak),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
              AppButton.primary(
                label: actionLabel,
                onPressed: onAction,
                size: compact ? ButtonSize.sm : ButtonSize.md,
              ),
            ],
            if (secondaryActionLabel != null) ...[
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
              AppButton.tertiary(
                label: secondaryActionLabel,
                onPressed: onSecondaryAction,
                size: compact ? ButtonSize.sm : ButtonSize.md,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A "no results" empty state variant.
class NoResultsState extends StatelessWidget {
  const NoResultsState({
    this.searchQuery,
    this.onClearSearch,
    super.key,
  });

  final String? searchQuery;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No results found',
      message: searchQuery != null
          ? 'No results for "$searchQuery"'
          : 'Try adjusting your search or filters',
      actionLabel: onClearSearch != null ? 'Clear search' : null,
      onAction: onClearSearch,
      compact: true,
    );
  }
}

/// An error state variant.
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      message: message,
      actionLabel: onRetry != null ? 'Try again' : null,
      onAction: onRetry,
    );
  }
}
