import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A section header component.
class SectionHeader extends fluent.StatelessWidget {
  const SectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    super.key,
  });

  /// Section title
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Trailing widget (action button, etc.)
  final fluent.Widget? trailing;

  /// Custom padding
  final fluent.EdgeInsetsGeometry? padding;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Padding(
      padding:
          padding ?? const fluent.EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: fluent.Row(
        children: [
          fluent.Expanded(
            child: fluent.Column(
              crossAxisAlignment: fluent.CrossAxisAlignment.start,
              children: [
                fluent.Text(
                  title,
                  style: AppTypography.subtitle(color: colors.textStrong),
                ),
                if (subtitle != null) ...[
                  const fluent.SizedBox(height: AppSpacing.xs2),
                  fluent.Text(
                    subtitle!,
                    style: AppTypography.caption(color: colors.textWeak),
                  ),
                ],
              ],
            ),
          ),
          // ignore: use_null_aware_elements
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// A collapsible section header.
class CollapsibleSectionHeader extends fluent.StatelessWidget {
  const CollapsibleSectionHeader({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final bool isExpanded;
  final fluent.VoidCallback onToggle;
  final String? subtitle;
  final fluent.Widget? trailing;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onToggle,
      child: fluent.MouseRegion(
        cursor: fluent.SystemMouseCursors.click,
        child: fluent.Padding(
          padding: const fluent.EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: fluent.Row(
            children: [
              fluent.AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: AppDurations.fast,
                child: fluent.Icon(
                  fluent.FluentIcons.chevron_right,
                  size: 18,
                  color: colors.iconWeak,
                ),
              ),
              const fluent.SizedBox(width: AppSpacing.sm),
              fluent.Expanded(
                child: fluent.Column(
                  crossAxisAlignment: fluent.CrossAxisAlignment.start,
                  children: [
                    fluent.Text(
                      title,
                      style: AppTypography.bodyMedium(color: colors.textStrong),
                    ),
                    if (subtitle != null)
                      fluent.Text(
                        subtitle!,
                        style: AppTypography.caption(color: colors.textWeak),
                      ),
                  ],
                ),
              ),
              // ignore: use_null_aware_elements
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// A small section label (like category headers in lists).
class SectionLabel extends fluent.StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Padding(
      padding: const fluent.EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: fluent.Text(
        label.toUpperCase(),
        style: AppTypography.style(
          size: 11,
          weight: AppTypography.semiBold,
          color: colors.textMuted,
        ),
      ),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSectionHeaderDefault() {
  return const SectionHeader(
    title: 'Settings',
    subtitle: 'Manage your preferences',
  );
}

@Preview(name: 'With Trailing')
fluent.Widget previewSectionHeaderTrailing() {
  return SectionHeader(
    title: 'Team Members',
    subtitle: '5 members',
    trailing: fluent.Text('View all', style: AppTypography.bodyMedium(color: AppColors.light.infoBase)),
  );
}

@Preview(name: 'Collapsible Expanded')
@Preview(name: 'Collapsible Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewCollapsibleSectionExpanded() {
  return CollapsibleSectionHeader(
    title: 'Advanced Options',
    subtitle: 'Click to expand',
    isExpanded: true,
    onToggle: () {},
  );
}

@Preview(name: 'Collapsible Collapsed')
fluent.Widget previewCollapsibleSectionCollapsed() {
  return CollapsibleSectionHeader(
    title: 'Advanced Options',
    subtitle: 'Click to expand',
    isExpanded: false,
    onToggle: () {},
  );
}

@Preview(name: 'Section Label')
fluent.Widget previewSectionLabel() {
  return const SectionLabel('Favorites');
}
