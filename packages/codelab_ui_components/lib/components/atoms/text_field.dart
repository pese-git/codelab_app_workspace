import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A text input field component.
class AppTextField extends fluent.StatelessWidget {
  const AppTextField({
    this.controller,
    this.focusNode,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.label,
    this.helper,
    this.error,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.maxLength,
    this.keyboardType,
    super.key,
  });

  /// Text controller
  final fluent.TextEditingController? controller;

  /// Focus node
  final fluent.FocusNode? focusNode;

  /// Current value (for controlled usage)
  final String? value;

  /// Value change callback
  final fluent.ValueChanged<String>? onChanged;

  /// Submit callback
  final fluent.ValueChanged<String>? onSubmitted;

  /// Placeholder text
  final String? placeholder;

  /// Label text
  final String? label;

  /// Helper text
  final String? helper;

  /// Error message
  final String? error;

  /// Prefix widget
  final fluent.Widget? prefix;

  /// Suffix widget
  final fluent.Widget? suffix;

  /// Prefix icon
  final fluent.IconData? prefixIcon;

  /// Suffix icon
  final fluent.IconData? suffixIcon;

  /// Disabled state
  final bool isDisabled;

  /// Read-only state
  final bool isReadOnly;

  /// Obscure text (for passwords)
  final bool obscureText;

  /// Autofocus
  final bool autofocus;

  /// Max length
  final int? maxLength;

  /// Keyboard type
  final fluent.TextInputType? keyboardType;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    fluent.Widget? prefixWidget;
    if (prefixIcon != null) {
      prefixWidget = fluent.Padding(
        padding: const fluent.EdgeInsets.only(left: AppSpacing.sm),
        child: fluent.Icon(prefixIcon, size: 16, color: colors.iconWeak),
      );
    } else if (prefix != null) {
      prefixWidget = prefix;
    }

    fluent.Widget? suffixWidget;
    if (suffixIcon != null) {
      suffixWidget = fluent.Padding(
        padding: const fluent.EdgeInsets.only(right: AppSpacing.sm),
        child: fluent.Icon(suffixIcon, size: 16, color: colors.iconWeak),
      );
    } else if (suffix != null) {
      suffixWidget = suffix;
    }

    final fluent.Widget textField = fluent.TextBox(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      enabled: !isDisabled,
      readOnly: isReadOnly,
      obscureText: obscureText,
      autofocus: autofocus,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefix: prefixWidget,
      suffix: suffixWidget,
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
          textField,
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

    return textField;
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewTextFieldDefault() {
  return const AppTextField(placeholder: 'Enter text...');
}

@Preview(name: 'With Label')
fluent.Widget previewTextFieldWithLabel() {
  return const AppTextField(
    label: 'Email',
    placeholder: 'user@example.com',
    prefixIcon: fluent.FluentIcons.mail,
    helper: 'We will never share your email',
  );
}

@Preview(name: 'With Error')
fluent.Widget previewTextFieldWithError() {
  return const AppTextField(
    label: 'Email',
    error: 'Please enter a valid email',
  );
}

@Preview(name: 'Password')
fluent.Widget previewTextFieldPassword() {
  return const AppTextField(
    label: 'Password',
    obscureText: true,
    suffixIcon: fluent.FluentIcons.paste_as_text,
  );
}

@Preview(name: 'Disabled')
fluent.Widget previewTextFieldDisabled() {
  return const AppTextField(value: 'Disabled value', isDisabled: true);
}
