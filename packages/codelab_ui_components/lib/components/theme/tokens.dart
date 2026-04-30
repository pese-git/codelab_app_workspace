import 'package:fluent_ui/fluent_ui.dart' as fluent;

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
  fluent.Color get backgroundBase => const fluent.Color(0xFFF7F6F3);
  fluent.Color get backgroundSubtle => const fluent.Color(0xFFF5F4F1);
  fluent.Color get backgroundElevated => const fluent.Color(0xFFF4F3F0);

  // Surfaces
  fluent.Color get surfaceBase => const fluent.Color(0xFFFFFFFF);
  fluent.Color get surfaceSubtle => const fluent.Color(0xFFF5F4F1);
  fluent.Color get surfaceAccent => const fluent.Color(0xFFF4F3EF);
  fluent.Color get surfaceHover => const fluent.Color(0xFFF0EFEC);
  fluent.Color get surfacePressed => const fluent.Color(0xFFEBEAE6);
  fluent.Color get surfaceSelected => const fluent.Color(0xFFF4F3EF);

  // Borders
  fluent.Color get borderBase => const fluent.Color(0xFFE2E0DB);
  fluent.Color get borderWeak => const fluent.Color(0xFFE5E3DD);
  fluent.Color get borderStrong => const fluent.Color(0xFFD8D6D0);
  fluent.Color get borderFocus => const fluent.Color(0xFF1F1F1F);

  // Text
  fluent.Color get textStrong => const fluent.Color(0xFF252522);
  fluent.Color get textBase => const fluent.Color(0xFF2E2D29);
  fluent.Color get textWeak => const fluent.Color(0xFF8F8D88);
  fluent.Color get textMuted => const fluent.Color(0xFF9A9A96);
  fluent.Color get textOnAccent => const fluent.Color(0xFFFFFFFF);

  // Icons
  fluent.Color get iconBase => const fluent.Color(0xFF2E2D29);
  fluent.Color get iconWeak => const fluent.Color(0xFF8F8D88);
  fluent.Color get iconMuted => const fluent.Color(0xFF9A9A96);
  fluent.Color get iconOnAccent => const fluent.Color(0xFFFFFFFF);

  // Accent / Primary
  fluent.Color get accentPrimary => const fluent.Color(0xFF1F1F1F);
  fluent.Color get accentHover => const fluent.Color(0xFF2D2C28);
  fluent.Color get accentPressed => const fluent.Color(0xFF3A3935);
  fluent.Color get accentSelected => const fluent.Color(0xFF30302D);
  fluent.Color get accentSubtle => const fluent.Color(0xFFE8E7E3);

  // Semantic: Success
  fluent.Color get successBase => const fluent.Color(0xFF22C55E);
  fluent.Color get successSubtle => const fluent.Color(0xFFDCFCE7);
  fluent.Color get successStrong => const fluent.Color(0xFF16A34A);
  fluent.Color get successText => const fluent.Color(0xFF166534);

  // Semantic: Warning
  fluent.Color get warningBase => const fluent.Color(0xFFFACC15);
  fluent.Color get warningSubtle => const fluent.Color(0xFFFEF9C3);
  fluent.Color get warningStrong => const fluent.Color(0xFFEAB308);
  fluent.Color get warningText => const fluent.Color(0xFF854D0E);

  // Semantic: Error / Critical
  fluent.Color get errorBase => const fluent.Color(0xFFEF4444);
  fluent.Color get errorSubtle => const fluent.Color(0xFFFEE2E2);
  fluent.Color get errorStrong => const fluent.Color(0xFFDC2626);
  fluent.Color get errorText => const fluent.Color(0xFF991B1B);

  // Semantic: Info
  fluent.Color get infoBase => const fluent.Color(0xFF3B82F6);
  fluent.Color get infoSubtle => const fluent.Color(0xFFDBEAFE);
  fluent.Color get infoStrong => const fluent.Color(0xFF2563EB);
  fluent.Color get infoText => const fluent.Color(0xFF1E40AF);

  // Overlay
  fluent.Color get overlay => const fluent.Color(0x66000000);
  fluent.Color get scrim => const fluent.Color(0x33000000);
}

/// Dark theme color palette
final class DarkColors extends LightColors {
  const DarkColors();

  // Backgrounds
  @override
  fluent.Color get backgroundBase => const fluent.Color(0xFF121212);
  @override
  fluent.Color get backgroundSubtle => const fluent.Color(0xFF1A1A1A);
  @override
  fluent.Color get backgroundElevated => const fluent.Color(0xFF1E1E1E);

  // Surfaces
  @override
  fluent.Color get surfaceBase => const fluent.Color(0xFF1E1E1E);
  @override
  fluent.Color get surfaceSubtle => const fluent.Color(0xFF252525);
  @override
  fluent.Color get surfaceAccent => const fluent.Color(0xFF2A2A2A);
  @override
  fluent.Color get surfaceHover => const fluent.Color(0xFF2F2F2F);
  @override
  fluent.Color get surfacePressed => const fluent.Color(0xFF383838);
  @override
  fluent.Color get surfaceSelected => const fluent.Color(0xFF2A2A2A);

  // Borders
  @override
  fluent.Color get borderBase => const fluent.Color(0xFF333333);
  @override
  fluent.Color get borderWeak => const fluent.Color(0xFF2A2A2A);
  @override
  fluent.Color get borderStrong => const fluent.Color(0xFF404040);
  @override
  fluent.Color get borderFocus => const fluent.Color(0xFFE5E5E5);

  // Text
  @override
  fluent.Color get textStrong => const fluent.Color(0xFFF5F5F5);
  @override
  fluent.Color get textBase => const fluent.Color(0xFFE5E5E5);
  @override
  fluent.Color get textWeak => const fluent.Color(0xFF9A9A9A);
  @override
  fluent.Color get textMuted => const fluent.Color(0xFF737373);
  @override
  fluent.Color get textOnAccent => const fluent.Color(0xFF121212);

  // Icons
  @override
  fluent.Color get iconBase => const fluent.Color(0xFFE5E5E5);
  @override
  fluent.Color get iconWeak => const fluent.Color(0xFF9A9A9A);
  @override
  fluent.Color get iconMuted => const fluent.Color(0xFF737373);
  @override
  fluent.Color get iconOnAccent => const fluent.Color(0xFF121212);

  // Accent / Primary
  @override
  fluent.Color get accentPrimary => const fluent.Color(0xFFE5E5E5);
  @override
  fluent.Color get accentHover => const fluent.Color(0xFFD4D4D4);
  @override
  fluent.Color get accentPressed => const fluent.Color(0xFFC4C4C4);
  @override
  fluent.Color get accentSelected => const fluent.Color(0xFFD8D8D8);
  @override
  fluent.Color get accentSubtle => const fluent.Color(0xFF333333);

  // Semantic: Success
  @override
  fluent.Color get successSubtle => const fluent.Color(0xFF14532D);
  @override
  fluent.Color get successStrong => const fluent.Color(0xFF4ADE80);
  @override
  fluent.Color get successText => const fluent.Color(0xFF86EFAC);

  // Semantic: Warning
  @override
  fluent.Color get warningSubtle => const fluent.Color(0xFF713F12);
  @override
  fluent.Color get warningStrong => const fluent.Color(0xFFFDE047);
  @override
  fluent.Color get warningText => const fluent.Color(0xFFFEF08A);

  // Semantic: Error / Critical
  @override
  fluent.Color get errorSubtle => const fluent.Color(0xFF7F1D1D);
  @override
  fluent.Color get errorStrong => const fluent.Color(0xFFF87171);
  @override
  fluent.Color get errorText => const fluent.Color(0xFFFCA5A5);

  // Semantic: Info
  @override
  fluent.Color get infoSubtle => const fluent.Color(0xFF1E3A8A);
  @override
  fluent.Color get infoStrong => const fluent.Color(0xFF60A5FA);
  @override
  fluent.Color get infoText => const fluent.Color(0xFF93C5FD);

  // Overlay
  @override
  fluent.Color get overlay => const fluent.Color(0x99000000);
  @override
  fluent.Color get scrim => const fluent.Color(0x66000000);
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

  // fluent.BorderRadius helpers
  static fluent.BorderRadius get smAll => fluent.BorderRadius.circular(sm);
  static fluent.BorderRadius get mdAll => fluent.BorderRadius.circular(md);
  static fluent.BorderRadius get lgAll => fluent.BorderRadius.circular(lg);
  static fluent.BorderRadius get xlAll => fluent.BorderRadius.circular(xl);
  static fluent.BorderRadius get xxlAll => fluent.BorderRadius.circular(xxl);
  static fluent.BorderRadius get fullAll => fluent.BorderRadius.circular(full);
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
  static const fluent.FontWeight regular = fluent.FontWeight.w400;
  static const fluent.FontWeight medium = fluent.FontWeight.w500;
  static const fluent.FontWeight semiBold = fluent.FontWeight.w600;
  static const fluent.FontWeight bold = fluent.FontWeight.w700;

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

  /// Creates a fluent.TextStyle with the given parameters.
  static fluent.TextStyle style({
    double size = fontSize14,
    fluent.FontWeight weight = regular,
    double? height,
    double? letterSpacing,
    fluent.Color? color,
    String? fontFamily,
  }) {
    return fluent.TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height ?? lineHeightNormal,
      letterSpacing: letterSpacing ?? letterSpacingNormal,
      color: color,
      fontFamily: fontFamily ?? AppTypography.fontFamily,
    );
  }

  /// Caption text style (12px, regular)
  static fluent.TextStyle caption({fluent.Color? color}) =>
      style(size: fontSize12, color: color);

  /// Small text style (13px, regular)
  static fluent.TextStyle small({fluent.Color? color}) =>
      style(size: fontSize13, color: color);

  /// Body text style (14px, regular)
  static fluent.TextStyle body({fluent.Color? color}) =>
      style(color: color);

  /// Body medium text style (14px, medium)
  static fluent.TextStyle bodyMedium({fluent.Color? color}) =>
      style(weight: medium, color: color);

  /// Label text style (15px, medium)
  static fluent.TextStyle label({fluent.Color? color}) =>
      style(size: fontSize15, weight: medium, color: color);

  /// Subtitle text style (16px, semibold)
  static fluent.TextStyle subtitle({fluent.Color? color}) =>
      style(size: fontSize16, weight: semiBold, color: color);

  /// Title text style (18px, semibold)
  static fluent.TextStyle title({fluent.Color? color}) => style(
    size: fontSize18,
    weight: semiBold,
    height: lineHeightTight,
    color: color,
  );

  /// Headline text style (24px, bold)
  static fluent.TextStyle headline({fluent.Color? color}) => style(
    size: fontSize24,
    weight: bold,
    height: lineHeightTight,
    color: color,
  );

  /// Display text style (28px, bold)
  static fluent.TextStyle display({fluent.Color? color}) => style(
    size: fontSize28,
    weight: bold,
    height: lineHeightTight,
    color: color,
  );

  /// Code text style (14px, regular, monospace)
  static fluent.TextStyle code({fluent.Color? color}) => style(
    fontFamily: fontFamilyMono,
    height: lineHeightRelaxed,
    color: color,
  );

  /// Code small text style (12px, regular, monospace)
  static fluent.TextStyle codeSmall({fluent.Color? color}) => style(
    size: fontSize12,
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
  List<fluent.BoxShadow> get none => const [];

  /// Subtle shadow for hover states
  List<fluent.BoxShadow> get subtle => [
    const fluent.BoxShadow(
      color: fluent.Color(0x0D000000),
      blurRadius: 4,
      offset: fluent.Offset(0, 1),
    ),
  ];

  /// Small shadow for cards
  List<fluent.BoxShadow> get sm => [
    const fluent.BoxShadow(
      color: fluent.Color(0x0F000000),
      blurRadius: 6,
      offset: fluent.Offset(0, 2),
    ),
  ];

  /// Medium shadow for dropdowns
  List<fluent.BoxShadow> get md => [
    const fluent.BoxShadow(
      color: fluent.Color(0x14000000),
      blurRadius: 10,
      offset: fluent.Offset(0, 4),
    ),
  ];

  /// Large shadow for panels
  List<fluent.BoxShadow> get lg => [
    const fluent.BoxShadow(
      color: fluent.Color(0x19000000),
      blurRadius: 15,
      offset: fluent.Offset(0, 6),
    ),
  ];

  /// Extra large shadow for dialogs
  List<fluent.BoxShadow> get xl => [
    const fluent.BoxShadow(
      color: fluent.Color(0x1F000000),
      blurRadius: 18,
      offset: fluent.Offset(0, 6),
    ),
    const fluent.BoxShadow(
      color: fluent.Color(0x0A000000),
      blurRadius: 40,
      offset: fluent.Offset(0, 15),
    ),
  ];
}

/// Dark theme shadow definitions
final class DarkShadows extends LightShadows {
  const DarkShadows();

  /// Subtle shadow for hover states
  @override
  List<fluent.BoxShadow> get subtle => [
    const fluent.BoxShadow(
      color: fluent.Color(0x33000000),
      blurRadius: 4,
      offset: fluent.Offset(0, 1),
    ),
  ];

  /// Small shadow for cards
  @override
  List<fluent.BoxShadow> get sm => [
    const fluent.BoxShadow(
      color: fluent.Color(0x40000000),
      blurRadius: 6,
      offset: fluent.Offset(0, 2),
    ),
  ];

  /// Medium shadow for dropdowns
  @override
  List<fluent.BoxShadow> get md => [
    const fluent.BoxShadow(
      color: fluent.Color(0x4D000000),
      blurRadius: 10,
      offset: fluent.Offset(0, 4),
    ),
  ];

  /// Large shadow for panels
  @override
  List<fluent.BoxShadow> get lg => [
    const fluent.BoxShadow(
      color: fluent.Color(0x59000000),
      blurRadius: 15,
      offset: fluent.Offset(0, 6),
    ),
  ];

  /// Extra large shadow for dialogs
  @override
  List<fluent.BoxShadow> get xl => [
    const fluent.BoxShadow(
      color: fluent.Color(0x66000000),
      blurRadius: 18,
      offset: fluent.Offset(0, 6),
    ),
    const fluent.BoxShadow(
      color: fluent.Color(0x33000000),
      blurRadius: 40,
      offset: fluent.Offset(0, 15),
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
