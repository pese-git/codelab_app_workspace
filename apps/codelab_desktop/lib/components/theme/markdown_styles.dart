import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'tokens.dart';

/// Markdown style sheet builder using design tokens.
abstract final class AppMarkdownStyles {
  /// Builds a MarkdownStyleSheet for light theme.
  static MarkdownStyleSheet light({Color? textColor}) {
    return _buildStyleSheet(AppColors.light, textColor);
  }

  /// Builds a MarkdownStyleSheet for dark theme.
  static MarkdownStyleSheet dark({Color? textColor}) {
    return _buildStyleSheet(AppColors.dark, textColor);
  }

  /// Builds a MarkdownStyleSheet based on brightness.
  static MarkdownStyleSheet fromBrightness(
    Brightness brightness, {
    Color? textColor,
  }) {
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    return _buildStyleSheet(colors, textColor);
  }

  static MarkdownStyleSheet _buildStyleSheet(LightColors colors, Color? textColor) {
    final baseTextColor = textColor ?? colors.textBase;

    return MarkdownStyleSheet(
      // Paragraphs
      p: AppTypography.body(color: baseTextColor),
      pPadding: const EdgeInsets.only(bottom: AppSpacing.sm),

      // Headers
      h1: AppTypography.style(
        size: AppTypography.fontSize24,
        weight: AppTypography.bold,
        color: baseTextColor,
      ),
      h1Padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      h2: AppTypography.style(
        size: AppTypography.fontSize20,
        weight: AppTypography.bold,
        color: baseTextColor,
      ),
      h2Padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
      h3: AppTypography.style(
        size: AppTypography.fontSize18,
        weight: AppTypography.semiBold,
        color: baseTextColor,
      ),
      h3Padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      h4: AppTypography.style(
        size: AppTypography.fontSize16,
        weight: AppTypography.semiBold,
        color: baseTextColor,
      ),
      h4Padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      h5: AppTypography.style(
        size: AppTypography.fontSize15,
        weight: AppTypography.semiBold,
        color: baseTextColor,
      ),
      h5Padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      h6: AppTypography.style(
        size: AppTypography.fontSize14,
        weight: AppTypography.semiBold,
        color: baseTextColor,
      ),
      h6Padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.xs),

      // Inline code
      code: TextStyle(
        fontFamily: AppTypography.fontFamilyMono,
        fontSize: AppTypography.fontSize13,
        color: colors.infoText,
        backgroundColor: colors.surfaceAccent,
      ),

      // Code blocks
      codeblockDecoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: colors.borderWeak),
      ),
      codeblockPadding: const EdgeInsets.all(AppSpacing.md),

      // Blockquotes
      blockquote: AppTypography.body(color: colors.textWeak),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: colors.borderStrong,
            width: 3,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: AppSpacing.md),

      // Lists
      listBullet: AppTypography.body(color: baseTextColor),
      listIndent: AppSpacing.lg,
      listBulletPadding: const EdgeInsets.only(right: AppSpacing.sm),

      // Strong / emphasis
      strong: TextStyle(
        fontWeight: AppTypography.bold,
        color: baseTextColor,
      ),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color: baseTextColor,
      ),

      // Links
      a: TextStyle(
        color: colors.infoBase,
        decoration: TextDecoration.underline,
      ),

      // Horizontal rules
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.borderWeak,
            width: 1,
          ),
        ),
      ),

      // Tables
      tableHead: AppTypography.bodyMedium(color: baseTextColor),
      tableBody: AppTypography.body(color: baseTextColor),
      tableBorder: TableBorder.all(
        color: colors.borderWeak,
        width: 1,
      ),
      tableColumnWidth: const IntrinsicColumnWidth(),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      tableCellsDecoration: BoxDecoration(
        color: colors.surfaceBase,
      ),
      tableHeadAlign: TextAlign.left,

      // Checkbox
      checkbox: AppTypography.body(color: baseTextColor),
    );
  }
}
