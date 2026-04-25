import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A text input field component.
class AppTextField extends StatelessWidget {
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
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Current value (for controlled usage)
  final String? value;

  /// Value change callback
  final ValueChanged<String>? onChanged;

  /// Submit callback
  final ValueChanged<String>? onSubmitted;

  /// Placeholder text
  final String? placeholder;

  /// Label text
  final String? label;

  /// Helper text
  final String? helper;

  /// Error message
  final String? error;

  /// Prefix widget
  final Widget? prefix;

  /// Suffix widget
  final Widget? suffix;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

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
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final hasError = error != null && error!.isNotEmpty;

    Widget? prefixWidget;
    if (prefixIcon != null) {
      prefixWidget = Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: Icon(prefixIcon, size: 16, color: colors.iconWeak),
      );
    } else if (prefix != null) {
      prefixWidget = prefix;
    }

    Widget? suffixWidget;
    if (suffixIcon != null) {
      suffixWidget = Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: Icon(suffixIcon, size: 16, color: colors.iconWeak),
      );
    } else if (suffix != null) {
      suffixWidget = suffix;
    }

    Widget textField = fluent.TextBox(
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
      decoration: WidgetStateProperty.resolveWith((states) {
        Color borderColor = colors.borderBase;
        if (hasError) {
          borderColor = colors.errorBase;
        } else if (states.contains(WidgetState.focused)) {
          borderColor = colors.borderFocus;
        }
        return BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: borderColor),
        );
      }),
    );

    if (label != null || helper != null || error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: AppTypography.bodyMedium(color: colors.textBase),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          textField,
          if (helper != null && !hasError) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              helper!,
              style: AppTypography.caption(color: colors.textWeak),
            ),
          ],
          if (hasError) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
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
