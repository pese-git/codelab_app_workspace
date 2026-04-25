# Theme Tokens

## 1. Назначение и контекст

Theme Tokens — дизайн-токены и тема приложения:
- Цвета (backgrounds, surfaces, text, borders)
- Типографика
- Отступы и размеры
- Акценты и состояния

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/theme/app_theme.dart`](../../apps/codelab_desktop/lib/app/theme/app_theme.dart)

**Референс OpenCode:** 
- [`reference/opencode/packages/app/src/index.css`](../../reference/opencode/packages/app/src/index.css)
- `@opencode-ai/ui` library

---

## 2. Текущая реализация Flutter

### buildAppTheme()
```dart
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
```

---

## 3. Цветовая палитра

### Backgrounds
| Token | Flutter Light | Flutter Dark | Использование |
|-------|---------------|--------------|---------------|
| Background Base | `#F7F6F3` | `#121212` | Основной фон |
| Surface Base | `#FFFFFF` | `#1E1E1E` | Карточки, панели |
| Surface Subtle | `#F5F4F1` | `--surface-subtle` | Search boxes |
| Surface Accent | `#F4F3EF` | `--surface-accent` | Selected items |

### Borders
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Border Base | `#E2E0DB` | `--border-base` | Основные границы |
| Border Weak | `#E5E3DD` | `--border-weak` | Разделители |
| Border Strong | `#D8D6D0` | `--border-strong` | Активные границы |

### Text
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Text Strong | `#252522` | `--text-strong` | Заголовки |
| Text Base | `#2E2D29` | `--text-base` | Основной текст |
| Text Weak (secondary) | `#8F8D88` (light) / `#9A9A9A` (dark) | `--text-weak` | Вторичный текст |
| Text Muted | `#9A9A96` | `--text-muted` | Placeholder |

### Accents
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Accent Primary | `#1F1F1F` | `--accent-primary` | Основной акцент |
| Accent Selected | `#30302D` | `--accent-selected` | Выбранные |
| Accent Hover | `#2D2C28` | `--accent-hover` | Hover states |

### Semantic Colors
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Success | — | `--icon-success-base` | Успех (green) |
| Warning | — | `--icon-warning-base` | Предупреждение |
| Critical | — | `--icon-critical-base` | Ошибка (red) |

---

## 4. Типографика

### Font Sizes
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| 12 | `fontSize: 12` | `text-12-*` | Captions, badges |
| 13 | `fontSize: 13` | `text-13-*` | Small text |
| 14 | `fontSize: 14` | `text-14-*` | Body text |
| 15 | `fontSize: 15` | `text-15-*` | Tab labels |
| 16 | `fontSize: 16` | `text-16-*` | Subheadings |
| 17 | `fontSize: 17` | `text-17-*` | Message text |
| 18 | `fontSize: 18` | `text-18-*` | Headings |
| 19 | `fontSize: 19` | `text-19-*` | Section titles |
| 28 | `fontSize: 28` | `text-28-*` | Large headings |

### Font Weights
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Regular | `FontWeight.w400` | `-regular` | Body |
| Medium | `FontWeight.w500` | `-medium` | Emphasis |
| SemiBold | `FontWeight.w600` | `-semibold` | Headings |
| Bold | `FontWeight.w700` | `-bold` | Strong emphasis |

### Font Families
| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Sans | default | default | UI text |
| Mono | `'monospace'` | `-mono` | Code, terminal |

---

## 5. Spacing

| Token | Value | Использование |
|-------|-------|---------------|
| 2 | 2px | Micro gaps |
| 4 | 4px | Tight spacing |
| 6 | 6px | Icon gaps |
| 8 | 8px | Small padding |
| 10 | 10px | Component gaps |
| 12 | 12px | Standard padding |
| 14 | 14px | Panel padding |
| 16 | 16px | Section gaps |
| 18 | 18px | Large padding |
| 20 | 20px | Major gaps |
| 24 | 24px | Section spacing |
| 26 | 26px | Message spacing |
| 28 | 28px | Content padding |

---

## 6. Border Radius

| Token | Value | Использование |
|-------|-------|---------------|
| sm | 7px | Small chips |
| md | 10px | Buttons, inputs |
| lg | 12px | Cards |
| xl | 14px | Project buttons |
| 2xl | 18px | Dialogs, composer |
| full | 999px | Pills, badges |

---

## 7. Shadows

| Token | Flutter | OpenCode | Использование |
|-------|---------|----------|---------------|
| Dialog | `blur: 18, offset: (0, 6)` | `shadow-xl` | Dialogs |
| Card | — | `shadow-md` | Cards |
| Dropdown | — | `shadow-lg` | Dropdowns |

---

## 8. Component-Specific Tokens

### Title Bar
```dart
height: 58
background: Color(0xFFF4F3F0)
border: Color(0xFFE2E0DB)
```

### Project Rail
```dart
width: 86
background: Color(0xFFF5F4F1)
```

### Sidebar
```dart
width: 376
background: Colors.white
```

### Context Panel
```dart
width: 280
background: Colors.white
```

### Bottom Panel
```dart
height: 178
background: Color(0xFFF7F6F3)
```

---

## 9. Traffic Lights (macOS)

```dart
red: Color(0xFFFF5F57)
yellow: Color(0xFFFEBC2E)
green: Color(0xFF28C840)
size: 14x14
spacing: 8
```

---

## 10. Паритет с reference/opencode

### ✅ Реализовано
- Основная цветовая палитра (light theme)
- Типографика (базовая)
- Spacing (ad-hoc)
- Border radius (ad-hoc)

### ❌ Не реализовано
- Dark theme
- System theme detection
- Theme switching
- CSS custom properties эквивалент
- Semantic color tokens
- Design tokens as constants file
- Typography scale system
- Spacing scale system

---

## 11. TODO/гап-анализ

### High Priority
- [ ] Создать файл констант для дизайн-токенов
- [ ] Реализовать Dark theme
- [ ] Theme switching (light/dark/system)

### Medium Priority
- [ ] Typography scale system
- [ ] Spacing scale system
- [ ] Semantic color tokens

### Low Priority
- [ ] Multiple theme presets
- [ ] Custom theme editor

---

## 12. Рекомендуемая структура токенов

```dart
// lib/app/theme/tokens.dart

class AppColors {
  // Backgrounds
  static const backgroundBase = Color(0xFFF7F6F3);
  static const surfaceBase = Color(0xFFFFFFFF);
  static const surfaceSubtle = Color(0xFFF5F4F1);
  static const surfaceAccent = Color(0xFFF4F3EF);
  
  // Borders
  static const borderBase = Color(0xFFE2E0DB);
  static const borderWeak = Color(0xFFE5E3DD);
  static const borderStrong = Color(0xFFD8D6D0);
  
  // Text
  static const textStrong = Color(0xFF252522);
  static const textBase = Color(0xFF2E2D29);
  static const textWeak = Color(0xFF8F8D88);
  static const textMuted = Color(0xFF9A9A96);
  
  // Accents
  static const accentPrimary = Color(0xFF1F1F1F);
  static const accentSelected = Color(0xFF30302D);
  static const accentHover = Color(0xFF2D2C28);
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

class AppRadius {
  static const sm = 7.0;
  static const md = 10.0;
  static const lg = 12.0;
  static const xl = 14.0;
  static const xxl = 18.0;
  static const full = 999.0;
}

class AppTypography {
  static const caption = TextStyle(fontSize: 12);
  static const bodySmall = TextStyle(fontSize: 13);
  static const body = TextStyle(fontSize: 14);
  static const bodyLarge = TextStyle(fontSize: 16);
  static const heading = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const title = TextStyle(fontSize: 19, fontWeight: FontWeight.w600);
  static const display = TextStyle(fontSize: 28, fontWeight: FontWeight.w700);
}
```
