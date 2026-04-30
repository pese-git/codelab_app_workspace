import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../atoms/button.dart';
import '../theme/tokens.dart';

/// An empty state placeholder component.
class EmptyState extends fluent.StatelessWidget {
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
  final fluent.IconData? icon;

  /// Primary action button label
  final String? actionLabel;

  /// Primary action callback
  final fluent.VoidCallback? onAction;

  /// Secondary action label
  final String? secondaryActionLabel;

  /// Secondary action callback
  final fluent.VoidCallback? onSecondaryAction;

  /// Compact mode (smaller)
  final bool compact;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final iconSize = compact ? 40.0 : 64.0;
    final titleStyle = compact
        ? AppTypography.subtitle(color: colors.textStrong)
        : AppTypography.title(color: colors.textStrong);

    return fluent.Center(
      child: fluent.Padding(
        padding: fluent.EdgeInsets.all(
          compact ? AppSpacing.lg : AppSpacing.xxl,
        ),
        child: fluent.Column(
          mainAxisSize: fluent.MainAxisSize.min,
          children: [
            if (icon != null) ...[
              fluent.Container(
                width: iconSize,
                height: iconSize,
                decoration: fluent.BoxDecoration(
                  color: colors.surfaceSubtle,
                  shape: fluent.BoxShape.circle,
                ),
                child: fluent.Icon(
                  icon,
                  size: iconSize * 0.5,
                  color: colors.iconMuted,
                ),
              ),
              fluent.SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            ],
            fluent.Text(
              title,
              style: titleStyle,
              textAlign: fluent.TextAlign.center,
            ),
            if (message != null) ...[
              fluent.SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
              fluent.Text(
                message!,
                style: AppTypography.body(color: colors.textWeak),
                textAlign: fluent.TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              fluent.SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
              AppButton.primary(
                label: actionLabel,
                onPressed: onAction,
                size: compact ? ButtonSize.sm : ButtonSize.md,
              ),
            ],
            if (secondaryActionLabel != null) ...[
              fluent.SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
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
class NoResultsState extends fluent.StatelessWidget {
  const NoResultsState({this.searchQuery, this.onClearSearch, super.key});

  final String? searchQuery;
  final fluent.VoidCallback? onClearSearch;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return EmptyState(
      icon: fluent.FluentIcons.search,
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
class ErrorState extends fluent.StatelessWidget {
  const ErrorState({required this.message, this.onRetry, super.key});

  final String message;
  final fluent.VoidCallback? onRetry;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return EmptyState(
      icon: fluent.FluentIcons.error_badge,
      title: 'Something went wrong',
      message: message,
      actionLabel: onRetry != null ? 'Try again' : null,
      onAction: onRetry,
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewEmptyStateDefault() {
  return EmptyState(
    icon: fluent.FluentIcons.folder,
    title: 'No projects yet',
    message: 'Create your first project to get started',
    actionLabel: 'Create Project',
    onAction: () {},
  );
}

@Preview(name: 'Compact')
fluent.Widget previewEmptyStateCompact() {
  return const EmptyState(
    icon: fluent.FluentIcons.search,
    title: 'No results',
    message: 'Try adjusting your filters',
    compact: true,
  );
}

@Preview(name: 'With Secondary Action')
fluent.Widget previewEmptyStateSecondaryAction() {
  return EmptyState(
    icon: fluent.FluentIcons.cloud,
    title: 'Offline',
    message: 'You are currently offline. Some features may be unavailable.',
    actionLabel: 'Retry',
    onAction: () {},
    secondaryActionLabel: 'Learn more',
    onSecondaryAction: () {},
  );
}

@Preview(name: 'No Results')
fluent.Widget previewNoResultsState() {
  return const NoResultsState(searchQuery: 'flutter');
}

@Preview(name: 'Error')
fluent.Widget previewErrorState() {
  return ErrorState(
    message: 'Failed to load data. Please check your connection.',
    onRetry: () {},
  );
}
