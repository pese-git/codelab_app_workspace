import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// Text variant types matching design tokens.
enum TextVariant {
  /// 12px caption
  caption,

  /// 13px small
  small,

  /// 14px body (default)
  body,

  /// 14px body medium weight
  bodyMedium,

  /// 15px label
  label,

  /// 16px subtitle
  subtitle,

  /// 18px title
  title,

  /// 24px headline
  headline,

  /// 28px display
  display,

  /// 14px code (monospace)
  code,

  /// 12px code (monospace)
  codeSmall,
}

/// A themed text component with semantic variants.
class AppText extends fluent.StatelessWidget {

  /// Caption text (12px)
  const AppText.caption(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.caption;

  /// Small text (13px)
  const AppText.small(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.small;

  /// Body text (14px)
  const AppText.body(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.body;

  /// Label text (15px medium)
  const AppText.label(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.label;

  /// Subtitle text (16px semibold)
  const AppText.subtitle(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.subtitle;

  /// Title text (18px semibold)
  const AppText.title(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.title;

  /// Headline text (24px bold)
  const AppText.headline(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.headline;

  /// Display text (28px bold)
  const AppText.display(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.display;

  /// Code text (14px monospace)
  const AppText.code(
    this.text, {
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  }) : variant = TextVariant.code;
  const AppText(
    this.text, {
    this.variant = TextVariant.body,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.selectable = false,
    super.key,
  });

  /// Text content
  final String text;

  /// Text variant
  final TextVariant variant;

  /// Text color (overrides theme default)
  final fluent.Color? color;

  /// Maximum lines
  final int? maxLines;

  /// Overflow behavior
  final fluent.TextOverflow? overflow;

  /// Text alignment
  final fluent.TextAlign? textAlign;

  /// Whether text is selectable
  final bool selectable;

  fluent.TextStyle _getStyle(LightColors colors) {
    final effectiveColor = color ?? colors.textBase;

    switch (variant) {
      case TextVariant.caption:
        return AppTypography.caption(color: effectiveColor);
      case TextVariant.small:
        return AppTypography.small(color: effectiveColor);
      case TextVariant.body:
        return AppTypography.body(color: effectiveColor);
      case TextVariant.bodyMedium:
        return AppTypography.bodyMedium(color: effectiveColor);
      case TextVariant.label:
        return AppTypography.label(color: effectiveColor);
      case TextVariant.subtitle:
        return AppTypography.subtitle(color: effectiveColor);
      case TextVariant.title:
        return AppTypography.title(color: effectiveColor);
      case TextVariant.headline:
        return AppTypography.headline(color: effectiveColor);
      case TextVariant.display:
        return AppTypography.display(color: effectiveColor);
      case TextVariant.code:
        return AppTypography.code(color: effectiveColor);
      case TextVariant.codeSmall:
        return AppTypography.codeSmall(color: effectiveColor);
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final style = _getStyle(colors);

    if (selectable) {
      return fluent.SelectableText(
        text,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
      );
    }

    return fluent.Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

// MARK: - Previews

@Preview(name: 'Display')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewTextDisplay() {
  return const AppText.display('Display 28px');
}

@Preview(name: 'Headline')
fluent.Widget previewTextHeadline() {
  return const AppText.headline('Headline 24px');
}

@Preview(name: 'Title')
fluent.Widget previewTextTitle() {
  return const AppText.title('Title 18px');
}

@Preview(name: 'Subtitle')
fluent.Widget previewTextSubtitle() {
  return const AppText.subtitle('Subtitle 16px');
}

@Preview(name: 'Label')
fluent.Widget previewTextLabel() {
  return const AppText.label('Label 15px');
}

@Preview(name: 'Body')
fluent.Widget previewTextBody() {
  return const AppText.body('Body 14px regular');
}

@Preview(name: 'Body Medium')
fluent.Widget previewTextBodyMedium() {
  return const AppText('Body 14px medium', variant: TextVariant.bodyMedium);
}

@Preview(name: 'Small')
fluent.Widget previewTextSmall() {
  return const AppText.small('Small 13px');
}

@Preview(name: 'Caption')
fluent.Widget previewTextCaption() {
  return const AppText.caption('Caption 12px');
}

@Preview(name: 'Code')
fluent.Widget previewTextCode() {
  return const AppText.code('const x = 42;');
}
