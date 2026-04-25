import 'package:fluent_ui/fluent_ui.dart';

FluentThemeData buildAppTheme() {
  const accent = Color(0xFF4F8CFF);

  return FluentThemeData(
    brightness: Brightness.dark,
    accentColor: AccentColor.swatch({
      'darkest': const Color(0xFF0E2B55),
      'darker': const Color(0xFF153C79),
      'dark': const Color(0xFF245BB0),
      'normal': accent,
      'light': const Color(0xFF6A9EFF),
      'lighter': const Color(0xFF8CB4FF),
      'lightest': const Color(0xFFC8DAFF),
    }),
    scaffoldBackgroundColor: const Color(0xFF111315),
    micaBackgroundColor: const Color(0xFF111315),
    cardColor: const Color(0xFF171A1D),
    inactiveColor: const Color(0xFF7B818A),
    visualDensity: VisualDensity.standard,
    focusTheme: FocusThemeData(
      glowFactor: 0,
      primaryBorder: BorderSide(color: accent.withAlpha(180), width: 1.2),
    ),
  );
}
