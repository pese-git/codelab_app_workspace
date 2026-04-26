import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A group of input fields.
class InputGroup extends StatelessWidget {
  const InputGroup({
    required this.children,
    this.label,
    this.helper,
    this.error,
    this.spacing = AppSpacing.md,
    this.direction = Axis.vertical,
    super.key,
  });

  /// Input widgets
  final List<Widget> children;

  /// Group label
  final String? label;

  /// Helper text
  final String? helper;

  /// Error message
  final String? error;

  /// Spacing between fields
  final double spacing;

  /// Layout direction
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.bodyMedium(color: colors.textBase)),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (direction == Axis.vertical)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(),
          )
        else
          Row(children: _buildChildren()),
        if (helper != null && !hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(helper!, style: AppTypography.caption(color: colors.textWeak)),
        ],
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(error!, style: AppTypography.caption(color: colors.errorText)),
        ],
      ],
    );
  }

  List<Widget> _buildChildren() {
    return children.asMap().entries.map((entry) {
      final isLast = entry.key == children.length - 1;
      final child = direction == Axis.horizontal
          ? Expanded(child: entry.value)
          : entry.value;

      if (isLast) return child;

      return direction == Axis.vertical
          ? Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: child,
            )
          : Padding(
              padding: EdgeInsets.only(right: spacing),
              child: child,
            );
    }).toList();
  }
}

/// A form section with a header.
class FormSection extends StatelessWidget {
  const FormSection({
    required this.title,
    required this.children,
    this.description,
    this.collapsible = false,
    this.initiallyExpanded = true,
    super.key,
  });

  /// Section title
  final String title;

  /// Form fields
  final List<Widget> children;

  /// Optional description
  final String? description;

  /// Whether section is collapsible
  final bool collapsible;

  /// Initial expanded state
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTypography.subtitle(color: colors.textStrong)),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(description!, style: AppTypography.body(color: colors.textWeak)),
        ],
        const SizedBox(height: AppSpacing.lg),
        ...children.map((child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: child,
          );
        }),
      ],
    );
  }
}
