import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'tokens.dart';

export 'tokens.dart';

/// Builds FluentUI theme data for the application.
fluent.FluentThemeData buildAppTheme({
  fluent.Brightness brightness = fluent.Brightness.light,
}) {
  final isLight = brightness == fluent.Brightness.light;
  final colors = isLight ? AppColors.light : AppColors.dark;

  return fluent.FluentThemeData(
    brightness: brightness,
    accentColor: fluent.AccentColor.swatch({
      'darkest': colors.accentPrimary.withAlpha(200),
      'darker': colors.accentPrimary.withAlpha(220),
      'dark': colors.accentPrimary.withAlpha(240),
      'normal': colors.accentPrimary,
      'light': colors.accentHover,
      'lighter': colors.accentSubtle,
      'lightest': colors.surfaceHover,
    }),
    scaffoldBackgroundColor: colors.backgroundBase,
    micaBackgroundColor: colors.backgroundBase,
    cardColor: colors.surfaceBase,
    inactiveColor: colors.textMuted,
    visualDensity: fluent.VisualDensity.standard,
    focusTheme: fluent.FocusThemeData(
      glowFactor: 0,
      primaryBorder: fluent.BorderSide(color: colors.borderFocus, width: 1.1),
    ),
  );
}

/// Application theme provider for FluentUI.
abstract final class AppTheme {
  /// Light FluentUI theme data
  static fluent.FluentThemeData get light =>
      buildAppTheme(brightness: fluent.Brightness.light);

  /// Dark FluentUI theme data
  static fluent.FluentThemeData get dark =>
      buildAppTheme(brightness: fluent.Brightness.dark);

  /// Get theme based on brightness
  static fluent.FluentThemeData fromBrightness(fluent.Brightness brightness) =>
      buildAppTheme(brightness: brightness);
}

/// Extension for easy token access from BuildContext.
extension AppThemeExtension on fluent.BuildContext {
  /// Access FluentUI theme
  fluent.FluentThemeData get fluentTheme => fluent.FluentTheme.of(this);

  /// Check if current theme is dark
  bool get isDarkMode =>
      fluent.FluentTheme.of(this).brightness == fluent.Brightness.dark;

  /// Get current colors based on theme brightness
  LightColors get appColors => isDarkMode ? AppColors.dark : AppColors.light;

  /// Get current shadows based on theme brightness
  LightShadows get appShadows =>
      isDarkMode ? AppShadows.dark : AppShadows.light;
}

/// Helper class for theme-aware color access.
class ThemeColors {
  const ThemeColors._(this._colors);

  final LightColors _colors;

  /// Create from BuildContext
  factory ThemeColors.of(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    return ThemeColors._(colors);
  }

  /// Create from brightness
  factory ThemeColors.fromBrightness(fluent.Brightness brightness) {
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    return ThemeColors._(colors);
  }

  // Background colors
  fluent.Color get backgroundBase => _colors.backgroundBase;
  fluent.Color get backgroundElevated => _colors.backgroundElevated;

  // Surface colors
  fluent.Color get surfaceBase => _colors.surfaceBase;
  fluent.Color get surfaceSubtle => _colors.surfaceSubtle;
  fluent.Color get surfaceHover => _colors.surfaceHover;
  fluent.Color get surfacePressed => _colors.surfacePressed;
  fluent.Color get surfaceAccent => _colors.surfaceAccent;
  fluent.Color get surfaceSelected => _colors.surfaceSelected;

  // Text colors
  fluent.Color get textStrong => _colors.textStrong;
  fluent.Color get textBase => _colors.textBase;
  fluent.Color get textWeak => _colors.textWeak;
  fluent.Color get textMuted => _colors.textMuted;
  fluent.Color get textOnAccent => _colors.textOnAccent;

  // Icon colors
  fluent.Color get iconBase => _colors.iconBase;
  fluent.Color get iconWeak => _colors.iconWeak;
  fluent.Color get iconMuted => _colors.iconMuted;
  fluent.Color get iconOnAccent => _colors.iconOnAccent;

  // Border colors
  fluent.Color get borderBase => _colors.borderBase;
  fluent.Color get borderWeak => _colors.borderWeak;
  fluent.Color get borderStrong => _colors.borderStrong;
  fluent.Color get borderFocus => _colors.borderFocus;

  // Accent colors
  fluent.Color get accentPrimary => _colors.accentPrimary;
  fluent.Color get accentHover => _colors.accentHover;
  fluent.Color get accentPressed => _colors.accentPressed;
  fluent.Color get accentSubtle => _colors.accentSubtle;
  fluent.Color get accentSelected => _colors.accentSelected;

  // Status colors
  fluent.Color get errorBase => _colors.errorBase;
  fluent.Color get errorSubtle => _colors.errorSubtle;
  fluent.Color get errorText => _colors.errorText;
  fluent.Color get warningBase => _colors.warningBase;
  fluent.Color get warningSubtle => _colors.warningSubtle;
  fluent.Color get warningText => _colors.warningText;
  fluent.Color get successBase => _colors.successBase;
  fluent.Color get successSubtle => _colors.successSubtle;
  fluent.Color get successText => _colors.successText;
  fluent.Color get infoBase => _colors.infoBase;
  fluent.Color get infoSubtle => _colors.infoSubtle;
  fluent.Color get infoText => _colors.infoText;

  // Overlay colors
  fluent.Color get overlay => _colors.overlay;
  fluent.Color get scrim => _colors.scrim;
}
