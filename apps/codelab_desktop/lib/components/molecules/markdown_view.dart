import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as flutter_markdown;

import '../theme/markdown_styles.dart';
import '../theme/tokens.dart';

// Re-exports
export 'package:flutter_markdown/flutter_markdown.dart'
    show MarkdownElementBuilder, MarkdownStyleSheet;

/// A markdown rendering component.
class MarkdownView extends StatelessWidget {
  const MarkdownView({
    required this.data,
    this.selectable = true,
    this.onTapLink,
    this.shrinkWrap = true,
    this.padding,
    super.key,
  });

  /// Markdown content
  final String data;

  /// Whether text is selectable
  final bool selectable;

  /// Link tap callback
  final void Function(String text, String? href, String title)? onTapLink;

  /// Shrink wrap content
  final bool shrinkWrap;

  /// Content padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final styleSheet = brightness == Brightness.light
        ? AppMarkdownStyles.light()
        : AppMarkdownStyles.dark();

    if (shrinkWrap) {
      return flutter_markdown.MarkdownBody(
        data: data,
        selectable: selectable,
        styleSheet: styleSheet,
        onTapLink: onTapLink != null
            ? (text, href, title) => onTapLink!(text, href, title)
            : null,
      );
    }

    return flutter_markdown.Markdown(
      data: data,
      selectable: selectable,
      styleSheet: styleSheet,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      onTapLink: onTapLink != null
          ? (text, href, title) => onTapLink!(text, href, title)
          : null,
    );
  }
}

/// A simple markdown body (no scrolling).
class AppMarkdownBody extends StatelessWidget {
  const AppMarkdownBody({
    required this.data,
    this.selectable = true,
    this.styleSheet,
    this.onTapLink,
    this.builders,
    super.key,
  });

  final String data;
  final bool selectable;
  final flutter_markdown.MarkdownStyleSheet? styleSheet;
  final void Function(String text, String? href, String title)? onTapLink;
  final Map<String, flutter_markdown.MarkdownElementBuilder>? builders;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final effectiveStyleSheet = styleSheet ??
        (brightness == Brightness.light
            ? AppMarkdownStyles.light()
            : AppMarkdownStyles.dark());

    return flutter_markdown.MarkdownBody(
      data: data,
      selectable: selectable,
      styleSheet: effectiveStyleSheet,
      onTapLink: onTapLink,
      builders: builders ?? {},
    );
  }
}
