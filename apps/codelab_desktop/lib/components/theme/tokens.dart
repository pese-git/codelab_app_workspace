import 'package:flutter/material.dart';

/// Design tokens for CodeLab Desktop application.
/// Supports light and dark themes with semantic color naming.

// =============================================================================
// COLORS
// =============================================================================

/// Semantic color tokens for the application.
abstract final class AppColors {
  /// Light theme background colors
  static const LightColors light = LightColors();

  /// Dark theme background colors
  static const DarkColors dark = DarkColors();
}

/// Light theme color palette
final class LightColors {
  const LightColors();

  // Backgrounds
  Color get backgroundBase => const Color(0xFFF7F6F3);
  Color get backgroundSubtle => const Color(0xFFF5F4F1);
  Color get backgroundElevated => const Color(0xFFF4F3F0);

  // Surfaces
  Color get surfaceBase => const Color(0xFFFFFFFF);
  Color get surfaceSubtle => const Color(0xFFF5F4F1);
  Color get surfaceAccent => const Color(0xFFF4F3EF);
  Color get surfaceHover => const Color(0xFFF0EFEC);
  Color get surfacePressed => const Color(0xFFEBEAE6);
  Color get surfaceSelected => const Color(0xFFF4F3EF);

  // Borders
  Color get borderBase => const Color(0xFFE2E0DB);
  Color get borderWeak => const Color(0xFFE5E3DD);
  Color get borderStrong => const Color(0xFFD8D6D0);
  Color get borderFocus => const Color(0xFF1F1F1F);

  // Text
  Color get textStrong => const Color(0xFF252522);
  Color get textBase => const Color(0xFF2E2D29);
  Color get textWeak => const Color(0xFF8F8D88);
  Color get textMuted => const Color(0xFF9A9A96);
  Color get textOnAccent => const Color(0xFFFFFFFF);

  // Icons
  Color get iconBase => const Color(0xFF2E2D29);
  Color get iconWeak => const Color(0xFF8F8D88);
  Color get iconMuted => const Color(0xFF9A9A96);
  Color get iconOnAccent => const Color(0xFFFFFFFF);

  // Accent / Primary
  Color get accentPrimary => const Color(0xFF1F1F1F);
  Color get accentHover => const Color(0xFF2D2C28);
  Color get accentPressed => const Color(0xFF3A3935);
  Color get accentSelected => const Color(0xFF30302D);
  Color get accentSubtle => const Color(0xFFE8E7E3);

  // Semantic: Success
  Color get successBase => const Color(0xFF22C55E);
  Color get successSubtle => const Color(0xFFDCFCE7);
  Color get successStrong => const Color(0xFF16A34A);
  Color get successText => const Color(0xFF166534);

  // Semantic: Warning
  Color get warningBase => const Color(0xFFFACC15);
  Color get warningSubtle => const Color(0xFFFEF9C3);
  Color get warningStrong => const Color(0xFFEAB308);
  Color get warningText => const Color(0xFF854D0E);

  // Semantic: Error / Critical
  Color get errorBase => const Color(0xFFEF4444);
  Color get errorSubtle => const Color(0xFFFEE2E2);
  Color get errorStrong => const Color(0xFFDC2626);
  Color get errorText => const Color(0xFF991B1B);

  // Semantic: Info
  Color get infoBase => const Color(0xFF3B82F6);
  Color get infoSubtle => const Color(0xFFDBEAFE);
  Color get infoStrong => const Color(0xFF2563EB);
  Color get infoText => const Color(0xFF1E40AF);

  // Overlay
  Color get overlay => const Color(0x66000000);
  Color get scrim => const Color(0x33000000);
}

/// Dark theme color palette
final class DarkColors extends LightColors {
  const DarkColors();

  // Backgrounds
  @override
  Color get backgroundBase => const Color(0xFF121212);
  @override
  Color get backgroundSubtle => const Color(0xFF1A1A1A);
  @override
  Color get backgroundElevated => const Color(0xFF1E1E1E);

  // Surfaces
  @override
  Color get surfaceBase => const Color(0xFF1E1E1E);
  @override
  Color get surfaceSubtle => const Color(0xFF252525);
  @override
  Color get surfaceAccent => const Color(0xFF2A2A2A);
  @override
  Color get surfaceHover => const Color(0xFF2F2F2F);
  @override
  Color get surfacePressed => const Color(0xFF383838);
  @override
  Color get surfaceSelected => const Color(0xFF2A2A2A);

  // Borders
  @override
  Color get borderBase => const Color(0xFF333333);
  @override
  Color get borderWeak => const Color(0xFF2A2A2A);
  @override
  Color get borderStrong => const Color(0xFF404040);
  @override
  Color get borderFocus => const Color(0xFFE5E5E5);

  // Text
  @override
  Color get textStrong => const Color(0xFFF5F5F5);
  @override
  Color get textBase => const Color(0xFFE5E5E5);
  @override
  Color get textWeak => const Color(0xFF9A9A9A);
  @override
  Color get textMuted => const Color(0xFF737373);
  @override
  Color get textOnAccent => const Color(0xFF121212);

  // Icons
  @override
  Color get iconBase => const Color(0xFFE5E5E5);
  @override
  Color get iconWeak => const Color(0xFF9A9A9A);
  @override
  Color get iconMuted => const Color(0xFF737373);
  @override
  Color get iconOnAccent => const Color(0xFF121212);

  // Accent / Primary
  @override
  Color get accentPrimary => const Color(0xFFE5E5E5);
  @override
  Color get accentHover => const Color(0xFFD4D4D4);
  @override
  Color get accentPressed => const Color(0xFFC4C4C4);
  @override
  Color get accentSelected => const Color(0xFFD8D8D8);
  @override
  Color get accentSubtle => const Color(0xFF333333);

  // Semantic: Success
  @override
  Color get successSubtle => const Color(0xFF14532D);
  @override
  Color get successStrong => const Color(0xFF4ADE80);
  @override
  Color get successText => const Color(0xFF86EFAC);

  // Semantic: Warning
  @override
  Color get warningSubtle => const Color(0xFF713F12);
  @override
  Color get warningStrong => const Color(0xFFFDE047);
  @override
  Color get warningText => const Color(0xFFFEF08A);

  // Semantic: Error / Critical
  @override
  Color get errorSubtle => const Color(0xFF7F1D1D);
  @override
  Color get errorStrong => const Color(0xFFF87171);
  @override
  Color get errorText => const Color(0xFFFCA5A5);

  // Semantic: Info
  @override
  Color get infoSubtle => const Color(0xFF1E3A8A);
  @override
  Color get infoStrong => const Color(0xFF60A5FA);
  @override
  Color get infoText => const Color(0xFF93C5FD);

  // Overlay
  @override
  Color get overlay => const Color(0x99000000);
  @override
  Color get scrim => const Color(0x66000000);
}

// =============================================================================
// SPACING
// =============================================================================

/// Spacing scale tokens (in logical pixels).
abstract final class AppSpacing {
  /// 2px - Micro gaps
  static const double xs2 = 2;

  /// 4px - Tight spacing
  static const double xs = 4;

  /// 6px - Icon gaps
  static const double sm2 = 6;

  /// 8px - Small padding
  static const double sm = 8;

  /// 10px - Component gaps
  static const double md2 = 10;

  /// 12px - Standard padding
  static const double md = 12;

  /// 14px - Panel padding
  static const double lg2 = 14;

  /// 16px - Section gaps
  static const double lg = 16;

  /// 18px - Large padding
  static const double xl2 = 18;

  /// 20px - Major gaps
  static const double xl = 20;

  /// 24px - Section spacing
  static const double xxl = 24;

  /// 26px - Message spacing
  static const double xxl2 = 26;

  /// 28px - Content padding
  static const double xxxl = 28;

  /// 32px - Large section spacing
  static const double huge = 32;

  /// 40px - Extra large spacing
  static const double massive = 40;

  /// 48px - Maximum spacing
  static const double giant = 48;
}

// =============================================================================
// BORDER RADIUS
// =============================================================================

/// Border radius tokens.
abstract final class AppRadius {
  /// 4px - Extra small
  static const double xs = 4;

  /// 7px - Small chips
  static const double sm = 7;

  /// 10px - Buttons, inputs
  static const double md = 10;

  /// 12px - Cards
  static const double lg = 12;

  /// 14px - Project buttons
  static const double xl = 14;

  /// 18px - Dialogs, composer
  static const double xxl = 18;

  /// 999px - Pills, badges (fully rounded)
  static const double full = 999;

  // BorderRadius helpers
  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get xxlAll => BorderRadius.circular(xxl);
  static BorderRadius get fullAll => BorderRadius.circular(full);
}

// =============================================================================
// TYPOGRAPHY
// =============================================================================

/// Typography tokens defining text styles.
abstract final class AppTypography {
  /// Default font family for UI text
  static const String fontFamily = 'Inter';

  /// Monospace font family for code
  static const String fontFamilyMono = 'JetBrains Mono';

  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Font sizes
  static const double fontSize12 = 12;
  static const double fontSize13 = 13;
  static const double fontSize14 = 14;
  static const double fontSize15 = 15;
  static const double fontSize16 = 16;
  static const double fontSize17 = 17;
  static const double fontSize18 = 18;
  static const double fontSize19 = 19;
  static const double fontSize20 = 20;
  static const double fontSize24 = 24;
  static const double fontSize28 = 28;
  static const double fontSize32 = 32;

  // Line heights (as multipliers)
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightLoose = 1.6;

  // Letter spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.5;

  /// Creates a TextStyle with the given parameters.
  static TextStyle style({
    double size = fontSize14,
    FontWeight weight = regular,
    double? height,
    double? letterSpacing,
    Color? color,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height ?? lineHeightNormal,
      letterSpacing: letterSpacing ?? letterSpacingNormal,
      color: color,
      fontFamily: fontFamily ?? AppTypography.fontFamily,
    );
  }

  /// Caption text style (12px, regular)
  static TextStyle caption({Color? color}) => style(
        size: fontSize12,
        weight: regular,
        color: color,
      );

  /// Small text style (13px, regular)
  static TextStyle small({Color? color}) => style(
        size: fontSize13,
        weight: regular,
        color: color,
      );

  /// Body text style (14px, regular)
  static TextStyle body({Color? color}) => style(
        size: fontSize14,
        weight: regular,
        color: color,
      );

  /// Body medium text style (14px, medium)
  static TextStyle bodyMedium({Color? color}) => style(
        size: fontSize14,
        weight: medium,
        color: color,
      );

  /// Label text style (15px, medium)
  static TextStyle label({Color? color}) => style(
        size: fontSize15,
        weight: medium,
        color: color,
      );

  /// Subtitle text style (16px, semibold)
  static TextStyle subtitle({Color? color}) => style(
        size: fontSize16,
        weight: semiBold,
        color: color,
      );

  /// Title text style (18px, semibold)
  static TextStyle title({Color? color}) => style(
        size: fontSize18,
        weight: semiBold,
        height: lineHeightTight,
        color: color,
      );

  /// Headline text style (24px, bold)
  static TextStyle headline({Color? color}) => style(
        size: fontSize24,
        weight: bold,
        height: lineHeightTight,
        color: color,
      );

  /// Display text style (28px, bold)
  static TextStyle display({Color? color}) => style(
        size: fontSize28,
        weight: bold,
        height: lineHeightTight,
        color: color,
      );

  /// Code text style (14px, regular, monospace)
  static TextStyle code({Color? color}) => style(
        size: fontSize14,
        weight: regular,
        fontFamily: fontFamilyMono,
        height: lineHeightRelaxed,
        color: color,
      );

  /// Code small text style (12px, regular, monospace)
  static TextStyle codeSmall({Color? color}) => style(
        size: fontSize12,
        weight: regular,
        fontFamily: fontFamilyMono,
        height: lineHeightRelaxed,
        color: color,
      );
}

// =============================================================================
// ELEVATIONS & SHADOWS
// =============================================================================

/// Elevation and shadow tokens.
abstract final class AppElevation {
  /// No elevation
  static const double none = 0;

  /// Low elevation (cards)
  static const double low = 1;

  /// Medium elevation (dropdowns)
  static const double medium = 3;

  /// High elevation (dialogs)
  static const double high = 6;

  /// Extra high elevation (modals)
  static const double extraHigh = 12;
}

/// Box shadow tokens.
abstract final class AppShadows {
  /// Light theme shadows
  static const LightShadows light = LightShadows();

  /// Dark theme shadows
  static const DarkShadows dark = DarkShadows();
}

/// Light theme shadow definitions
final class LightShadows {
  const LightShadows();

  /// No shadow
  List<BoxShadow> get none => const [];

  /// Subtle shadow for hover states
  List<BoxShadow> get subtle => [
        BoxShadow(
          color: const Color(0x0D000000),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Small shadow for cards
  List<BoxShadow> get sm => [
        BoxShadow(
          color: const Color(0x0F000000),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium shadow for dropdowns
  List<BoxShadow> get md => [
        BoxShadow(
          color: const Color(0x14000000),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  /// Large shadow for panels
  List<BoxShadow> get lg => [
        BoxShadow(
          color: const Color(0x19000000),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ];

  /// Extra large shadow for dialogs
  List<BoxShadow> get xl => [
        BoxShadow(
          color: const Color(0x1F000000),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: const Color(0x0A000000),
          blurRadius: 40,
          offset: const Offset(0, 15),
        ),
      ];
}

/// Dark theme shadow definitions
final class DarkShadows extends LightShadows {
  const DarkShadows();

  /// Subtle shadow for hover states
  @override
  List<BoxShadow> get subtle => [
        BoxShadow(
          color: const Color(0x33000000),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Small shadow for cards
  @override
  List<BoxShadow> get sm => [
        BoxShadow(
          color: const Color(0x40000000),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium shadow for dropdowns
  @override
  List<BoxShadow> get md => [
        BoxShadow(
          color: const Color(0x4D000000),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  /// Large shadow for panels
  @override
  List<BoxShadow> get lg => [
        BoxShadow(
          color: const Color(0x59000000),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ];

  /// Extra large shadow for dialogs
  @override
  List<BoxShadow> get xl => [
        BoxShadow(
          color: const Color(0x66000000),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: const Color(0x33000000),
          blurRadius: 40,
          offset: const Offset(0, 15),
        ),
      ];
}

// =============================================================================
// DURATIONS
// =============================================================================

/// Animation duration tokens.
abstract final class AppDurations {
  /// Instant (0ms) - no animation
  static const Duration instant = Duration.zero;

  /// Fast (100ms) - micro interactions
  static const Duration fast = Duration(milliseconds: 100);

  /// Normal (200ms) - standard animations
  static const Duration normal = Duration(milliseconds: 200);

  /// Medium (300ms) - moderate animations
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow (400ms) - entrance/exit animations
  static const Duration slow = Duration(milliseconds: 400);

  /// Slower (500ms) - large element animations
  static const Duration slower = Duration(milliseconds: 500);
}

// =============================================================================
// COMPONENT DIMENSIONS
// =============================================================================

/// Fixed dimensions for specific UI components.
abstract final class AppDimensions {
  // Title bar
  static const double titleBarHeight = 58;

  // Project rail (sidebar)
  static const double projectRailWidth = 86;

  // Sidebar
  static const double sidebarWidth = 376;
  static const double sidebarMinWidth = 280;
  static const double sidebarMaxWidth = 500;

  // Context panel
  static const double contextPanelWidth = 280;

  // Bottom panel (terminal)
  static const double bottomPanelHeight = 178;
  static const double bottomPanelMinHeight = 100;
  static const double bottomPanelMaxHeight = 400;

  // Buttons
  static const double buttonHeightSm = 28;
  static const double buttonHeightMd = 36;
  static const double buttonHeightLg = 44;

  // Inputs
  static const double inputHeightSm = 32;
  static const double inputHeightMd = 40;
  static const double inputHeightLg = 48;

  // Icons
  static const double iconSizeSm = 16;
  static const double iconSizeMd = 20;
  static const double iconSizeLg = 24;
  static const double iconSizeXl = 28;

  // Avatars
  static const double avatarSizeSm = 24;
  static const double avatarSizeMd = 32;
  static const double avatarSizeLg = 40;

  // Dividers
  static const double dividerThickness = 1;
}
