import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// Shows an info bar message (fluent_ui equivalent of snackbar).
void showAppSnackbar(
  fluent.BuildContext context, {
  required String message,
  String? actionLabel,
  fluent.VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  fluent.displayInfoBar(
    context,
    builder: (context, close) {
      return fluent.InfoBar(
        title: fluent.Text(message),
        action: actionLabel != null
            ? fluent.Button(
                child: fluent.Text(actionLabel),
                onPressed: () {
                  close();
                  onAction?.call();
                },
              )
            : null,
        onClose: close,
      );
    },
    duration: duration,
  );
}

/// A standalone snackbar widget.
class AppSnackbar extends fluent.StatelessWidget {
  const AppSnackbar({
    required this.message,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    super.key,
  });

  final String message;
  final String? actionLabel;
  final fluent.VoidCallback? onAction;
  final fluent.VoidCallback? onDismiss;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      padding: const fluent.EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: fluent.BoxDecoration(
        color: colors.accentPrimary,
        borderRadius: AppRadius.mdAll,
      ),
      child: fluent.Row(
        mainAxisSize: fluent.MainAxisSize.min,
        children: [
          fluent.Flexible(
            child: fluent.Text(
              message,
              style: AppTypography.body(color: colors.textOnAccent),
            ),
          ),
          if (actionLabel != null) ...[
            const fluent.SizedBox(width: AppSpacing.lg),
            fluent.GestureDetector(
              onTap: onAction,
              child: fluent.Text(
                actionLabel!,
                style: AppTypography.bodyMedium(
                  color: colors.textOnAccent,
                ).copyWith(decoration: fluent.TextDecoration.underline),
              ),
            ),
          ],
          if (onDismiss != null) ...[
            const fluent.SizedBox(width: AppSpacing.md),
            fluent.GestureDetector(
              onTap: onDismiss,
              child: fluent.Icon(
                fluent.FluentIcons.chrome_close,
                size: 18,
                color: colors.iconOnAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSnackbarDefault() {
  return const AppSnackbar(
    message: 'Changes saved successfully',
  );
}

@Preview(name: 'With Action')
fluent.Widget previewSnackbarWithAction() {
  return AppSnackbar(
    message: 'File uploaded',
    actionLabel: 'View',
    onAction: () {},
    onDismiss: () {},
  );
}

@Preview(name: 'With Dismiss Only')
fluent.Widget previewSnackbarWithDismiss() {
  return AppSnackbar(
    message: 'New version available',
    onDismiss: () {},
  );
}
