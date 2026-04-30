import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as flutter_markdown;

import '../theme/markdown_styles.dart';
import '../theme/tokens.dart';

// Re-exports
export 'package:flutter_markdown/flutter_markdown.dart'
    show MarkdownElementBuilder, MarkdownStyleSheet;

/// A markdown rendering component.
class MarkdownView extends fluent.StatelessWidget {
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
  final fluent.EdgeInsets? padding;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final styleSheet = brightness == fluent.Brightness.light
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
      padding: padding ?? const fluent.EdgeInsets.all(AppSpacing.md),
      onTapLink: onTapLink != null
          ? (text, href, title) => onTapLink!(text, href, title)
          : null,
    );
  }
}

/// A simple markdown body (no scrolling).
class AppMarkdownBody extends fluent.StatelessWidget {
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
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final effectiveStyleSheet =
        styleSheet ??
        (brightness == fluent.Brightness.light
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

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewMarkdownViewDefault() {
  return const MarkdownView(
    data: '''
# Hello World

This is a **markdown** preview with some _formatted text_.

- Item one
- Item two
- Item three
''',
  );
}

@Preview(name: 'With Link')
fluent.Widget previewMarkdownViewWithLink() {
  return MarkdownView(
    data: '''
## Documentation

Visit the [official docs](https://example.com) for more information.

> This is a blockquote with important information.
''',
    onTapLink: (text, href, title) {},
  );
}

@Preview(name: 'Code Block')
fluent.Widget previewMarkdownViewCode() {
  return const MarkdownView(
    data: '''
### Code Example

Use `inline code` for short snippets.

```dart
void main() {
  print('Hello, world!');
}
```
''',
  );
}

@Preview(name: 'Markdown Body')
@Preview(name: 'Markdown Body Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewAppMarkdownBody() {
  return const AppMarkdownBody(
    data: '''
**Bold text** and *italic text* in a compact body.
''',
  );
}
