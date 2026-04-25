import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A section header component.
class SectionHeader extends StatelessWidget {
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
  final Widget? trailing;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle(color: colors.textStrong),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs2),
                  Text(
                    subtitle!,
                    style: AppTypography.caption(color: colors.textWeak),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A collapsible section header.
class CollapsibleSectionHeader extends StatelessWidget {
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
  final VoidCallback onToggle;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: onToggle,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              AnimatedRotation(
                turns: isExpanded ? 0.25 : 0,
                duration: AppDurations.fast,
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: colors.iconWeak,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium(color: colors.textStrong),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.caption(color: colors.textWeak),
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// A small section label (like category headers in lists).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
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
