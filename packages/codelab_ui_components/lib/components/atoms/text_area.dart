import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A multi-line text area component.
class AppTextArea extends fluent.StatelessWidget {
  const AppTextArea({
    this.controller,
    this.focusNode,
    this.value,
    this.onChanged,
    this.placeholder,
    this.label,
    this.helper,
    this.error,
    this.minLines = 3,
    this.maxLines = 10,
    this.maxLength,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.autofocus = false,
    super.key,
  });

  /// Text controller
  final fluent.TextEditingController? controller;

  /// Focus node
  final fluent.FocusNode? focusNode;

  /// Current value
  final String? value;

  /// Value change callback
  final fluent.ValueChanged<String>? onChanged;

  /// Placeholder text
  final String? placeholder;

  /// Label text
  final String? label;

  /// Helper text
  final String? helper;

  /// Error message
  final String? error;

  /// Minimum lines
  final int minLines;

  /// Maximum lines
  final int maxLines;

  /// Max length
  final int? maxLength;

  /// Disabled state
  final bool isDisabled;

  /// Read-only state
  final bool isReadOnly;

  /// Autofocus
  final bool autofocus;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    fluent.Widget textArea = fluent.TextBox(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      enabled: !isDisabled,
      readOnly: isReadOnly,
      autofocus: autofocus,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      style: AppTypography.body(color: colors.textBase),
      placeholderStyle: AppTypography.body(color: colors.textMuted),
      decoration: fluent.WidgetStateProperty.resolveWith((states) {
        fluent.Color borderColor = colors.borderBase;
        if (hasError) {
          borderColor = colors.errorBase;
        } else if (states.contains(fluent.WidgetState.focused)) {
          borderColor = colors.borderFocus;
        }
        return fluent.BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: AppRadius.mdAll,
          border: fluent.Border.all(color: borderColor),
        );
      }),
    );

    if (label != null || helper != null || error != null) {
      return fluent.Column(
        crossAxisAlignment: fluent.CrossAxisAlignment.start,
        mainAxisSize: fluent.MainAxisSize.min,
        children: [
          if (label != null) ...[
            fluent.Text(
              label!,
              style: AppTypography.bodyMedium(color: colors.textBase),
            ),
            const fluent.SizedBox(height: AppSpacing.xs),
          ],
          textArea,
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

    return textArea;
  }
}
