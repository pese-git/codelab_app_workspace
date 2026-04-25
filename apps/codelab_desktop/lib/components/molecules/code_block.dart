import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// A code block with syntax highlighting placeholder.
class CodeBlock extends StatelessWidget {
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
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: colors.borderWeak),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                topRight: Radius.circular(AppRadius.sm),
              ),
            ),
            child: Row(
              children: [
                if (language != null)
                  Text(
                    language!,
                    style: AppTypography.caption(color: colors.textMuted),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    onCopy?.call();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, size: 14, color: colors.iconWeak),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: showLineNumbers
                ? _buildWithLineNumbers(colors)
                : SelectableText(
                    code,
                    style: AppTypography.code(color: colors.textBase),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithLineNumbers(LightColors colors) {
    final lines = code.split('\n');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line numbers
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(lines.length, (index) {
            return Text(
              '${index + 1}',
              style: AppTypography.codeSmall(color: colors.textMuted),
            );
          }),
        ),
        const SizedBox(width: AppSpacing.md),
        // Code
        Expanded(
          child: SelectableText(
            code,
            style: AppTypography.code(color: colors.textBase),
          ),
        ),
      ],
    );
  }
}

/// Inline code snippet.
class InlineCode extends StatelessWidget {
  const InlineCode(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceAccent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontFamily: AppTypography.fontFamilyMono,
          fontSize: AppTypography.fontSize13,
          color: colors.infoText,
        ),
      ),
    );
  }
}
