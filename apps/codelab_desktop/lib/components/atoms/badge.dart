import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Badge variant types.
enum BadgeVariant {
  /// Default neutral badge
  neutral,

  /// Primary accent badge
  primary,

  /// Success badge
  success,

  /// Warning badge
  warning,

  /// Error badge
  error,

  /// Info badge
  info,
}

/// A small status badge component.
class Badge extends StatelessWidget {
  const Badge({
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.size = BadgeSize.md,
    super.key,
  });

  /// Badge text
  final String label;

  /// Badge variant
  final BadgeVariant variant;

  /// Badge size
  final BadgeSize size;

  const Badge.primary(this.label, {this.size = BadgeSize.md, super.key})
      : variant = BadgeVariant.primary;

  const Badge.success(this.label, {this.size = BadgeSize.md, super.key})
      : variant = BadgeVariant.success;

  const Badge.warning(this.label, {this.size = BadgeSize.md, super.key})
      : variant = BadgeVariant.warning;

  const Badge.error(this.label, {this.size = BadgeSize.md, super.key})
      : variant = BadgeVariant.error;

  const Badge.info(this.label, {this.size = BadgeSize.md, super.key})
      : variant = BadgeVariant.info;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    final Color backgroundColor;
    final Color textColor;

    switch (variant) {
      case BadgeVariant.neutral:
        backgroundColor = colors.surfaceSubtle;
        textColor = colors.textBase;
        break;
      case BadgeVariant.primary:
        backgroundColor = colors.accentSubtle;
        textColor = colors.textStrong;
        break;
      case BadgeVariant.success:
        backgroundColor = colors.successSubtle;
        textColor = colors.successText;
        break;
      case BadgeVariant.warning:
        backgroundColor = colors.warningSubtle;
        textColor = colors.warningText;
        break;
      case BadgeVariant.error:
        backgroundColor = colors.errorSubtle;
        textColor = colors.errorText;
        break;
      case BadgeVariant.info:
        backgroundColor = colors.infoSubtle;
        textColor = colors.infoText;
        break;
    }

    final padding = size == BadgeSize.sm
        ? const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 1)
        : const EdgeInsets.symmetric(horizontal: AppSpacing.sm2, vertical: 2);

    final textStyle = size == BadgeSize.sm
        ? AppTypography.style(size: 10, weight: AppTypography.medium, color: textColor)
        : AppTypography.caption(color: textColor);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(label, style: textStyle),
    );
  }
}

/// Badge size variants.
enum BadgeSize {
  /// Small badge
  sm,

  /// Medium badge (default)
  md,
}

/// A numeric count badge (e.g., for notifications).
class CountBadge extends StatelessWidget {
  const CountBadge({
    required this.count,
    this.maxCount = 99,
    this.variant = BadgeVariant.error,
    super.key,
  });

  /// Count to display
  final int count;

  /// Maximum count (shows "99+" style)
  final int maxCount;

  /// Badge variant
  final BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final displayText = count > maxCount ? '$maxCount+' : '$count';

    return Badge(
      label: displayText,
      variant: variant,
      size: BadgeSize.sm,
    );
  }
}

/// A dot indicator badge (no text).
class DotBadge extends StatelessWidget {
  const DotBadge({
    this.size = 8,
    this.color,
    this.variant = BadgeVariant.error,
    super.key,
  });

  /// Dot size
  final double size;

  /// Custom color (overrides variant)
  final Color? color;

  /// Badge variant for color
  final BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    Color dotColor;
    if (color != null) {
      dotColor = color!;
    } else {
      switch (variant) {
        case BadgeVariant.neutral:
          dotColor = colors.textMuted;
          break;
        case BadgeVariant.primary:
          dotColor = colors.accentPrimary;
          break;
        case BadgeVariant.success:
          dotColor = colors.successBase;
          break;
        case BadgeVariant.warning:
          dotColor = colors.warningBase;
          break;
        case BadgeVariant.error:
          dotColor = colors.errorBase;
          break;
        case BadgeVariant.info:
          dotColor = colors.infoBase;
          break;
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
