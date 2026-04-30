import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// Toast variant types.
enum ToastVariant { info, success, warning, error }

/// A toast notification component.
class Toast extends fluent.StatelessWidget {
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
  final fluent.VoidCallback? onDismiss;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final shadows = brightness == fluent.Brightness.light
        ? AppShadows.light
        : AppShadows.dark;

    final fluent.Color backgroundColor;
    final fluent.Color iconColor;
    final fluent.IconData icon;

    switch (variant) {
      case ToastVariant.info:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.infoBase;
        icon = fluent.FluentIcons.info;
        break;
      case ToastVariant.success:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.successBase;
        icon = fluent.FluentIcons.check_mark;
        break;
      case ToastVariant.warning:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.warningBase;
        icon = fluent.FluentIcons.warning;
        break;
      case ToastVariant.error:
        backgroundColor = colors.surfaceBase;
        iconColor = colors.errorBase;
        icon = fluent.FluentIcons.error_badge;
        break;
    }

    return fluent.Container(
      constraints: const fluent.BoxConstraints(maxWidth: 400),
      padding: const fluent.EdgeInsets.all(AppSpacing.md),
      decoration: fluent.BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.lgAll,
        border: fluent.Border.all(color: colors.borderWeak),
        boxShadow: shadows.lg,
      ),
      child: fluent.Row(
        mainAxisSize: fluent.MainAxisSize.min,
        crossAxisAlignment: fluent.CrossAxisAlignment.start,
        children: [
          fluent.Icon(icon, size: 20, color: iconColor),
          const fluent.SizedBox(width: AppSpacing.md),
          fluent.Flexible(
            child: fluent.Column(
              crossAxisAlignment: fluent.CrossAxisAlignment.start,
              mainAxisSize: fluent.MainAxisSize.min,
              children: [
                if (title != null) ...[
                  fluent.Text(
                    title!,
                    style: AppTypography.bodyMedium(color: colors.textStrong),
                  ),
                  const fluent.SizedBox(height: AppSpacing.xs),
                ],
                fluent.Text(
                  message,
                  style: AppTypography.body(color: colors.textBase),
                ),
                if (action != null) ...[
                  const fluent.SizedBox(height: AppSpacing.sm),
                  fluent.GestureDetector(
                    onTap: action!.onTap,
                    child: fluent.Text(
                      action!.label,
                      style: AppTypography.bodyMedium(color: colors.infoBase),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const fluent.SizedBox(width: AppSpacing.sm),
            fluent.GestureDetector(
              onTap: onDismiss,
              child: fluent.Icon(
                fluent.FluentIcons.chrome_close,
                size: 18,
                color: colors.iconWeak,
              ),
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
  final fluent.VoidCallback onTap;
}

// MARK: - Previews

@Preview(name: 'Info')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewToastInfo() {
  return const Toast(
    message: 'A new update is available for download.',
  );
}

@Preview(name: 'Success')
fluent.Widget previewToastSuccess() {
  return Toast(
    title: 'Success',
    message: 'Your changes have been saved successfully.',
    variant: ToastVariant.success,
    action: ToastAction(label: 'Undo', onTap: () {}),
    onDismiss: () {},
  );
}

@Preview(name: 'Warning')
fluent.Widget previewToastWarning() {
  return const Toast(
    title: 'Warning',
    message: 'Your session will expire in 5 minutes.',
    variant: ToastVariant.warning,
  );
}

@Preview(name: 'Error')
@Preview(name: 'Error Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewToastError() {
  return Toast(
    title: 'Error',
    message: 'Failed to connect to the server. Please try again.',
    variant: ToastVariant.error,
    action: ToastAction(label: 'Retry', onTap: () {}),
    onDismiss: () {},
  );
}
