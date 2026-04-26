import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Shows a snackbar message.
void showAppSnackbar(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  final brightness = Theme.of(context).brightness;
  final colors = brightness == Brightness.light
      ? AppColors.light
      : AppColors.dark;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTypography.body(color: colors.textOnAccent),
      ),
      backgroundColor: colors.accentPrimary,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      margin: const EdgeInsets.all(AppSpacing.lg),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: colors.textOnAccent,
              onPressed: onAction ?? () {},
            )
          : null,
    ),
  );
}

/// A standalone snackbar widget.
class AppSnackbar extends StatelessWidget {
  const AppSnackbar({
    required this.message,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    super.key,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.accentPrimary,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              message,
              style: AppTypography.body(color: colors.textOnAccent),
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: AppSpacing.lg),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTypography.bodyMedium(
                  color: colors.textOnAccent,
                ).copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 18, color: colors.iconOnAccent),
            ),
          ],
        ],
      ),
    );
  }
}
