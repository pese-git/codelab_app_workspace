import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// A code block with syntax highlighting placeholder.
class CodeBlock extends fluent.StatelessWidget {
  const CodeBlock({
    required this.code,
    this.language,
    this.showLineNumbers = false,
    this.onCopy,
    super.key,
  });

  /// Code content
  final String code;

  /// Programming language
  final String? language;

  /// Show line numbers
  final bool showLineNumbers;

  /// Copy callback
  final fluent.VoidCallback? onCopy;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      width: double.infinity,
      decoration: fluent.BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: AppRadius.smAll,
        border: fluent.Border.all(color: colors.borderWeak),
      ),
      child: fluent.Column(
        crossAxisAlignment: fluent.CrossAxisAlignment.stretch,
        children: [
          // Header
          fluent.Container(
            padding: const fluent.EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: fluent.BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: const fluent.BorderRadius.only(
                topLeft: fluent.Radius.circular(AppRadius.sm),
                topRight: fluent.Radius.circular(AppRadius.sm),
              ),
            ),
            child: fluent.Row(
              children: [
                if (language != null)
                  fluent.Text(
                    language!,
                    style: AppTypography.caption(color: colors.textMuted),
                  ),
                const fluent.Spacer(),
                fluent.GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    onCopy?.call();
                  },
                  child: fluent.Row(
                    mainAxisSize: fluent.MainAxisSize.min,
                    children: [
                      fluent.Icon(fluent.FluentIcons.copy, size: 14, color: colors.iconWeak),
                      const fluent.SizedBox(width: AppSpacing.xs),
                      fluent.Text(
                        'Copy',
                        style: AppTypography.caption(color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Code content
          fluent.Padding(
            padding: const fluent.EdgeInsets.all(AppSpacing.md),
            child: showLineNumbers
                ? _buildWithLineNumbers(colors)
                : fluent.SelectableText(
                    code,
                    style: AppTypography.code(color: colors.textBase),
                  ),
          ),
        ],
      ),
    );
  }

  fluent.Widget _buildWithLineNumbers(LightColors colors) {
    final lines = code.split('\n');

    return fluent.Row(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      children: [
        // Line numbers
        fluent.Column(
          crossAxisAlignment: fluent.CrossAxisAlignment.end,
          children: List.generate(lines.length, (index) {
            return fluent.Text(
              '${index + 1}',
              style: AppTypography.codeSmall(color: colors.textMuted),
            );
          }),
        ),
        const fluent.SizedBox(width: AppSpacing.md),
        // Code
        fluent.Expanded(
          child: fluent.SelectableText(
            code,
            style: AppTypography.code(color: colors.textBase),
          ),
        ),
      ],
    );
  }
}

/// Inline code snippet.
class InlineCode extends fluent.StatelessWidget {
  const InlineCode(this.code, {super.key});

  final String code;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      padding: const fluent.EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 1,
      ),
      decoration: fluent.BoxDecoration(
        color: colors.surfaceAccent,
        borderRadius: fluent.BorderRadius.circular(4),
      ),
      child: fluent.Text(
        code,
        style: fluent.TextStyle(
          fontFamily: AppTypography.fontFamilyMono,
          fontSize: AppTypography.fontSize13,
          color: colors.infoText,
        ),
      ),
    );
  }
}
