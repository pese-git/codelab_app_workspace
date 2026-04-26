import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Toast variant types.
enum ToastVariant { info, success, warning, error }

/// A toast notification component.
class Toast extends StatelessWidget {
  const Toast({
    required this.message,
    this.variant = ToastVariant.info,
    this.title,
    this.action,
    this.onDismiss,
    super.key,
  });

  /// Toast message
  final String message;

  /// Toast variant
  final ToastVariant variant;

  /// Optional title
  final String? title;

  /// Optional action button
  final ToastAction? action;

  /// Dismiss callback
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final shadows = brightness == Brightness.light
        ? AppShadows.light
        : AppShadows.dark;

    final Color backgroundColor;
    final Color iconColor;
    final IconData icon;

    switch (variant) {
      case ToastVariant.info:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.infoBase;
        icon = Icons.info_outline;
        break;
      case ToastVariant.success:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.successBase;
        icon = Icons.check_circle_outline;
        break;
      case ToastVariant.warning:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.warningBase;
        icon = Icons.warning_amber_outlined;
        break;
      case ToastVariant.error:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.errorBase;
        icon = Icons.error_outline;
        break;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: colors.borderWeak),
        boxShadow: shadows.lg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTypography.bodyMedium(color: colors.textStrong),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(
                  message,
                  style: AppTypography.body(color: colors.textBase),
                ),
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: action!.onTap,
                    child: Text(
                      action!.label,
                      style: AppTypography.bodyMedium(color: colors.infoBase),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 18, color: colors.iconWeak),
            ),
          ],
        ],
      ),
    );
  }
}

/// Toast action button data.
class ToastAction {
  const ToastAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}
