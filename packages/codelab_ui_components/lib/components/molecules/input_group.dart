import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A group of input fields.
class InputGroup extends fluent.StatelessWidget {
  const InputGroup({
    required this.children,
    this.label,
    this.helper,
    this.error,
    this.spacing = AppSpacing.md,
    this.direction = fluent.Axis.vertical,
    super.key,
  });

  /// Input widgets
  final List<fluent.Widget> children;

  /// Group label
  final String? label;

  /// Helper text
  final String? helper;

  /// Error message
  final String? error;

  /// Spacing between fields
  final double spacing;

  /// Layout direction
  final fluent.Axis direction;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        if (label != null) ...[
          fluent.Text(
            label!,
            style: AppTypography.bodyMedium(color: colors.textBase),
          ),
          const fluent.SizedBox(height: AppSpacing.sm),
        ],
        if (direction == fluent.Axis.vertical)
          fluent.Column(
            crossAxisAlignment: fluent.CrossAxisAlignment.stretch,
            children: _buildChildren(),
          )
        else
          fluent.Row(children: _buildChildren()),
        if (helper != null && !hasError) ...[
          const fluent.SizedBox(height: AppSpacing.xs),
          fluent.Text(
            helper!,
            style: AppTypography.caption(color: colors.textWeak),
          ),
        ],
        if (hasError) ...[
          const fluent.SizedBox(height: AppSpacing.xs),
          fluent.Text(
            error!,
            style: AppTypography.caption(color: colors.errorText),
          ),
        ],
      ],
    );
  }

  List<fluent.Widget> _buildChildren() {
    return children.asMap().entries.map((entry) {
      final isLast = entry.key == children.length - 1;
      final child = direction == fluent.Axis.horizontal
          ? fluent.Expanded(child: entry.value)
          : entry.value;

      if (isLast) return child;

      return direction == fluent.Axis.vertical
          ? fluent.Padding(
              padding: fluent.EdgeInsets.only(bottom: spacing),
              child: child,
            )
          : fluent.Padding(
              padding: fluent.EdgeInsets.only(right: spacing),
              child: child,
            );
    }).toList();
  }
}

/// A form section with a header.
class FormSection extends fluent.StatelessWidget {
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
  final List<fluent.Widget> children;

  /// Optional description
  final String? description;

  /// Whether section is collapsible
  final bool collapsible;

  /// Initial expanded state
  final bool initiallyExpanded;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        fluent.Text(
          title,
          style: AppTypography.subtitle(color: colors.textStrong),
        ),
        if (description != null) ...[
          const fluent.SizedBox(height: AppSpacing.xs),
          fluent.Text(
            description!,
            style: AppTypography.body(color: colors.textWeak),
          ),
        ],
        const fluent.SizedBox(height: AppSpacing.lg),
        ...children.map((child) {
          return fluent.Padding(
            padding: const fluent.EdgeInsets.only(bottom: AppSpacing.md),
            child: child,
          );
        }),
      ],
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewInputGroupDefault() {
  return const InputGroup(
    label: 'Personal Information',
    helper: 'Please fill in all required fields',
    children: [
      fluent.Text('Input 1'),
      fluent.Text('Input 2'),
    ],
  );
}

@Preview(name: 'With Error')
fluent.Widget previewInputGroupError() {
  return const InputGroup(
    label: 'Email Address',
    error: 'Please enter a valid email address',
    children: [
      fluent.Text('user@example'),
    ],
  );
}

@Preview(name: 'Horizontal')
fluent.Widget inputGroupHorizontal() {
  return const InputGroup(
    label: 'Date Range',
    direction: fluent.Axis.horizontal,
    children: [
      fluent.Text('From'),
      fluent.Text('To'),
    ],
  );
}

@Preview(name: 'Form Section')
@Preview(name: 'Form Section Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewFormSection() {
  return const FormSection(
    title: 'Account Settings',
    description: 'Manage your account preferences',
    children: [
      fluent.Text('Username field'),
      fluent.Text('Email field'),
    ],
  );
}
