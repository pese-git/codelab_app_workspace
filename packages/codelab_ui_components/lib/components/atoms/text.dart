import 'package:fluent_ui/fluent_ui.dart' as fluent;

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
