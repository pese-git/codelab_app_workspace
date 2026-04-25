import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import 'tokens.dart';

export 'tokens.dart';

/// Legacy function for FluentUI theme (kept for compatibility).
fluent.FluentThemeData buildAppTheme({Brightness brightness = Brightness.light}) {
  final isLight = brightness == Brightness.light;
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
    visualDensity: VisualDensity.standard,
    focusTheme: fluent.FocusThemeData(
      glowFactor: 0,
      primaryBorder: BorderSide(color: colors.borderFocus, width: 1.1),
    ),
  );
}

/// Application theme builder providing Material 3 ThemeData for light and dark modes.
abstract final class AppTheme {
  /// Light theme data
  static ThemeData get light => _buildTheme(Brightness.light);

  /// Dark theme data
  static ThemeData get dark => _buildTheme(Brightness.dark);

  /// Light FluentUI theme data
  static fluent.FluentThemeData get fluentLight => buildAppTheme(brightness: Brightness.light);

  /// Dark FluentUI theme data
  static fluent.FluentThemeData get fluentDark => buildAppTheme(brightness: Brightness.dark);

  /// Builds a ThemeData for the given brightness.
  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final colors = isLight ? AppColors.light : AppColors.dark;
    final shadows = isLight ? AppShadows.light : AppShadows.dark;

    final colorScheme = _buildColorScheme(brightness);
    final textTheme = _buildTextTheme(colors);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: AppTypography.fontFamily,

      // Scaffold
      scaffoldBackgroundColor: colors.backgroundBase,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.backgroundElevated,
        foregroundColor: colors.textBase,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.title(color: colors.textStrong),
        iconTheme: IconThemeData(color: colors.iconBase, size: AppDimensions.iconSizeMd),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surfaceBase,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: colors.borderWeak),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        elevation: AppElevation.high,
        backgroundColor: colors.surfaceBase,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xxlAll),
        titleTextStyle: AppTypography.title(color: colors.textStrong),
        contentTextStyle: AppTypography.body(color: colors.textBase),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.borderWeak,
        thickness: AppDimensions.dividerThickness,
        space: 0,
      ),
      dividerColor: colors.borderWeak,

      // Icons
      iconTheme: IconThemeData(
        color: colors.iconBase,
        size: AppDimensions.iconSizeMd,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceSubtle,
        hoverColor: colors.surfaceHover,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: colors.borderBase),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: colors.borderBase),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: colors.borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: colors.errorBase),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: colors.errorBase, width: 1.5),
        ),
        hintStyle: AppTypography.body(color: colors.textMuted),
        labelStyle: AppTypography.body(color: colors.textWeak),
        errorStyle: AppTypography.caption(color: colors.errorText),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buildPrimaryButtonStyle(colors),
      ),

      // Filled buttons (primary)
      filledButtonTheme: FilledButtonThemeData(
        style: _buildPrimaryButtonStyle(colors),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buildOutlinedButtonStyle(colors),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: _buildTextButtonStyle(colors),
      ),

      // Icon buttons
      iconButtonTheme: IconButtonThemeData(
        style: _buildIconButtonStyle(colors),
      ),

      // Checkboxes
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.surfaceSubtle;
          }
          if (states.contains(WidgetState.selected)) {
            return colors.accentPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(colors.iconOnAccent),
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(color: colors.borderFocus, width: 1.5);
          }
          if (states.contains(WidgetState.selected)) {
            return BorderSide.none;
          }
          return BorderSide(color: colors.borderStrong);
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),

      // Radio buttons
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.textMuted;
          }
          if (states.contains(WidgetState.selected)) {
            return colors.accentPrimary;
          }
          return colors.borderStrong;
        }),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),

      // Switches
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.textMuted;
          }
          if (states.contains(WidgetState.selected)) {
            return colors.surfaceBase;
          }
          return colors.textWeak;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.surfaceSubtle;
          }
          if (states.contains(WidgetState.selected)) {
            return colors.accentPrimary;
          }
          return colors.borderBase;
        }),
        trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),

      // Progress indicators
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accentPrimary,
        linearTrackColor: colors.surfaceSubtle,
        circularTrackColor: colors.surfaceSubtle,
      ),

      // Tooltips
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isLight ? colors.accentPrimary : colors.surfaceBase,
          borderRadius: AppRadius.smAll,
          boxShadow: shadows.md,
        ),
        textStyle: AppTypography.caption(
          color: isLight ? colors.textOnAccent : colors.textBase,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        waitDuration: AppDurations.medium,
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.accentPrimary,
        contentTextStyle: AppTypography.body(color: colors.textOnAccent),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        behavior: SnackBarBehavior.floating,
        elevation: AppElevation.medium,
      ),

      // Scrollbars
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colors.textMuted;
          }
          return colors.borderStrong;
        }),
        trackColor: WidgetStatePropertyAll(Colors.transparent),
        radius: const Radius.circular(AppRadius.full),
        thickness: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return 8.0;
          }
          return 6.0;
        }),
        thumbVisibility: WidgetStatePropertyAll(true),
      ),

      // Lists
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        tileColor: Colors.transparent,
        selectedTileColor: colors.surfaceSelected,
        selectedColor: colors.textStrong,
        iconColor: colors.iconBase,
        textColor: colors.textBase,
      ),

      // Popup menus
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceBase,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.medium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: colors.borderWeak),
        ),
        textStyle: AppTypography.body(color: colors.textBase),
      ),

      // Dropdown menus
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colors.surfaceSubtle,
          border: OutlineInputBorder(
            borderRadius: AppRadius.mdAll,
            borderSide: BorderSide(color: colors.borderBase),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(colors.surfaceBase),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          elevation: WidgetStatePropertyAll(AppElevation.medium),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: AppRadius.mdAll,
              side: BorderSide(color: colors.borderWeak),
            ),
          ),
        ),
      ),

      // Focus
      focusColor: colors.surfaceHover,
      hoverColor: colors.surfaceHover,
      highlightColor: colors.surfacePressed,
      splashColor: Colors.transparent,

      // Misc
      canvasColor: colors.surfaceBase,
      shadowColor: isLight ? const Color(0x1F000000) : const Color(0x66000000),
      visualDensity: VisualDensity.standard,
    );
  }

  /// Builds primary button style (filled/elevated).
  static ButtonStyle _buildPrimaryButtonStyle(LightColors colors) {
    return ButtonStyle(
      elevation: WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.surfaceSubtle;
        }
        if (states.contains(WidgetState.pressed)) {
          return colors.accentPressed;
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.accentHover;
        }
        return colors.accentPrimary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textMuted;
        }
        return colors.textOnAccent;
      }),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStatePropertyAll(
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(
        const Size(0, AppDimensions.buttonHeightMd),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      textStyle: WidgetStatePropertyAll(
        AppTypography.label(color: colors.textOnAccent),
      ),
    );
  }

  /// Builds outlined button style.
  static ButtonStyle _buildOutlinedButtonStyle(LightColors colors) {
    return ButtonStyle(
      elevation: WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.pressed)) {
          return colors.surfacePressed;
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.surfaceHover;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textMuted;
        }
        return colors.textBase;
      }),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colors.borderFocus, width: 1.5);
        }
        return BorderSide(color: colors.borderBase);
      }),
      padding: WidgetStatePropertyAll(
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(
        const Size(0, AppDimensions.buttonHeightMd),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      textStyle: WidgetStatePropertyAll(
        AppTypography.label(color: colors.textBase),
      ),
    );
  }

  /// Builds text button style.
  static ButtonStyle _buildTextButtonStyle(LightColors colors) {
    return ButtonStyle(
      elevation: WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colors.surfacePressed;
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.surfaceHover;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textMuted;
        }
        return colors.textBase;
      }),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStatePropertyAll(
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm2,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(const Size(0, 0)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      ),
      textStyle: WidgetStatePropertyAll(
        AppTypography.label(color: colors.textBase),
      ),
    );
  }

  /// Builds icon button style.
  static ButtonStyle _buildIconButtonStyle(LightColors colors) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colors.surfacePressed;
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.surfaceHover;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.iconMuted;
        }
        return colors.iconBase;
      }),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      ),
    );
  }

  /// Builds the ColorScheme for Material 3.
  static ColorScheme _buildColorScheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final c = isLight ? AppColors.light : AppColors.dark;

    return ColorScheme(
      brightness: brightness,

      // Primary
      primary: c.accentPrimary,
      onPrimary: c.textOnAccent,
      primaryContainer: c.accentSubtle,
      onPrimaryContainer: c.textStrong,

      // Secondary
      secondary: c.accentSelected,
      onSecondary: c.textOnAccent,
      secondaryContainer: c.surfaceAccent,
      onSecondaryContainer: c.textBase,

      // Tertiary
      tertiary: c.infoBase,
      onTertiary: isLight ? Colors.white : Colors.black,
      tertiaryContainer: c.infoSubtle,
      onTertiaryContainer: c.infoText,

      // Error
      error: c.errorBase,
      onError: isLight ? Colors.white : Colors.black,
      errorContainer: c.errorSubtle,
      onErrorContainer: c.errorText,

      // Surface
      surface: c.surfaceBase,
      onSurface: c.textBase,
      surfaceContainerLowest: isLight ? Colors.white : const Color(0xFF121212),
      surfaceContainerLow: c.surfaceSubtle,
      surfaceContainer: c.surfaceAccent,
      surfaceContainerHigh: c.surfaceHover,
      surfaceContainerHighest: c.surfacePressed,

      // Outline
      outline: c.borderBase,
      outlineVariant: c.borderWeak,

      // Inverse
      inverseSurface: isLight ? const Color(0xFF2E2D29) : const Color(0xFFE5E5E5),
      onInverseSurface: isLight ? const Color(0xFFE5E5E5) : const Color(0xFF2E2D29),
      inversePrimary: isLight ? const Color(0xFFD5D5D5) : const Color(0xFF252525),

      // Shadow
      shadow: const Color(0xFF000000),
      scrim: c.scrim,
    );
  }

  /// Builds the TextTheme based on design tokens.
  static TextTheme _buildTextTheme(LightColors colors) {
    return TextTheme(
      // Display
      displayLarge: AppTypography.display(color: colors.textStrong),
      displayMedium: AppTypography.headline(color: colors.textStrong),
      displaySmall: AppTypography.title(color: colors.textStrong),

      // Headlines
      headlineLarge: AppTypography.headline(color: colors.textStrong),
      headlineMedium: AppTypography.title(color: colors.textStrong),
      headlineSmall: AppTypography.subtitle(color: colors.textStrong),

      // Titles
      titleLarge: AppTypography.title(color: colors.textStrong),
      titleMedium: AppTypography.subtitle(color: colors.textStrong),
      titleSmall: AppTypography.label(color: colors.textStrong),

      // Body
      bodyLarge: AppTypography.body(color: colors.textBase),
      bodyMedium: AppTypography.body(color: colors.textBase),
      bodySmall: AppTypography.small(color: colors.textWeak),

      // Labels
      labelLarge: AppTypography.label(color: colors.textBase),
      labelMedium: AppTypography.bodyMedium(color: colors.textBase),
      labelSmall: AppTypography.caption(color: colors.textWeak),
    );
  }
}

/// Extension for easy token access from BuildContext.
extension AppThemeExtension on BuildContext {
  /// Access the current theme's color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Access the current theme's text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get current colors based on theme brightness
  LightColors get appColors => isDarkMode ? AppColors.dark : AppColors.light;

  /// Get current shadows based on theme brightness
  LightShadows get appShadows => isDarkMode ? AppShadows.dark : AppShadows.light;
}
