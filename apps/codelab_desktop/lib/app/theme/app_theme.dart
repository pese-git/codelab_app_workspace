import 'package:fluent_ui/fluent_ui.dart';

FluentThemeData buildAppTheme() {
  const accent = Color(0xFF1F1F1F);

  return FluentThemeData(
    brightness: Brightness.light,
    accentColor: AccentColor.swatch({
      'darkest': const Color(0xFF111111),
      'darker': const Color(0xFF1A1A1A),
      'dark': const Color(0xFF252525),
      'normal': accent,
      'light': const Color(0xFF4F4F4F),
      'lighter': const Color(0xFF8D8D8D),
      'lightest': const Color(0xFFD5D5D5),
    }),
    scaffoldBackgroundColor: const Color(0xFFF7F6F3),
    micaBackgroundColor: const Color(0xFFF7F6F3),
    cardColor: Colors.white,
    inactiveColor: const Color(0xFF9A9A96),
    visualDensity: VisualDensity.standard,
    focusTheme: FocusThemeData(
      glowFactor: 0,
      primaryBorder: BorderSide(color: accent.withAlpha(160), width: 1.1),
    ),
  );
}
