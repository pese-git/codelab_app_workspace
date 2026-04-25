# Components Refactor Changelog

Документ описывает рефакторинг UI-компонентов в `apps/codelab_desktop` — перенос из `lib/app/` в новую иерархию `lib/components/`.

---

## Обзор изменений

**Дата:** Апрель 2026  
**Статус:** Завершён, `fvm flutter analyze` проходит без ошибок

### Что сделано

1. **Создана иерархия `lib/components/`** по принципу Atomic Design:
   - `theme/` — дизайн-токены, темы, markdown-стили
   - `foundations/` — базовые примитивы (surface, focus ring, icon, skeleton, loaders)
   - `atoms/` — атомарные элементы (button, text, checkbox, toggle и др.)
   - `molecules/` — составные компоненты (tabs, toolbar, dropdown, code_block и др.)
   - `organisms/session/` — компоненты сессии (message_timeline, prompt_composer, terminal_panel и др.)
   - `organisms/shell/` — shell-компоненты (desktop_shell, sidebar, title_bar, project_rail и др.)
   - `layout/` — layout-утилиты (stack, split_view, grid, overlay_host)
   - `icons/` — FluentIcons re-export

2. **Единая точка входа `lib/components.dart`** — barrel-файл, экспортирующий все компоненты

3. **Deprecated proxies в `lib/app/`**:
   - `lib/app/widgets/*.dart` — помечены `@Deprecated`, реэкспортируют из `components/`
   - `lib/app/theme/*.dart` — помечены `@Deprecated`, реэкспортируют из `components/`
   - `lib/app/shell/*.dart` — помечены `@Deprecated`, реэкспортируют из `components/`

---

## Структура каталогов

```
lib/
├── components.dart              # ← Единый импорт (рекомендуется)
├── components/
│   ├── theme/                   # Токены, темы
│   ├── foundations/             # Surface, FocusRing, Icon, Skeleton, Loaders
│   ├── atoms/                   # Button, Text, TextField, Checkbox, Toggle...
│   ├── molecules/               # Tabs, Toolbar, CodeBlock, MarkdownView...
│   ├── organisms/
│   │   ├── session/             # MessageTimeline, PromptComposer, SessionTabs...
│   │   └── shell/               # DesktopShell, Sidebar, TitleBar, ProjectRail...
│   ├── layout/                  # Stack, SplitView, Grid, OverlayHost
│   └── icons/                   # FluentIcons
└── app/
    ├── widgets/                 # @Deprecated → components/organisms/session
    ├── theme/                   # @Deprecated → components/theme
    └── shell/                   # @Deprecated → components/organisms/shell
```

---

## Как использовать

### Рекомендуемый способ

```dart
import 'package:codelab_desktop/components.dart';

// Доступны все компоненты:
// - AppTheme, AppColors, AppSpacing, AppRadius, AppTypo
// - AppButton, AppIconButton, AppText, AppTextField
// - MessageTimeline, PromptComposer, SessionTabs
// - DesktopShell, Sidebar, TitleBar
// и т.д.
```

### Deprecated (избегать)

```dart
// ❌ Старые импорты — работают, но будут удалены
import 'package:codelab_desktop/app/widgets/message_timeline.dart';
import 'package:codelab_desktop/app/theme/app_theme.dart';
import 'package:codelab_desktop/app/shell/desktop_shell.dart';
```

---

## Миграция существующего кода

1. Заменить импорты `app/widgets/`, `app/theme/`, `app/shell/` на единый `components.dart`
2. Проверить, что имена классов совпадают (в большинстве случаев они идентичны)
3. Запустить `fvm flutter analyze` для проверки

---

## TODO

- [ ] Удалить deprecated proxy-файлы после полной миграции
- [ ] Добавить lint-правило для запрета импортов из deprecated путей
