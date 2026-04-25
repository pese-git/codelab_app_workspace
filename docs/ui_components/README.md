# UI Components Documentation

Подробные спецификации UI компонентов для `codelab_desktop` на Flutter SDK + fluent_ui + go_router.

Референс: OpenCode Desktop (`reference/opencode/packages/app/src/`)

---

## Структура документации

Каждый компонент описывается в отдельном файле со следующими секциями:

1. **Назначение и контекст** — зачем нужен компонент, где используется
2. **Состав и layout** — иерархия/секции, внутренние виджеты
3. **Состояния/варианты** — empty, hover, active, expanded, error/loading
4. **Пропсы/параметры** — входные данные, контроллеры, сигналы состояния
5. **Стили/токены** — цвета, типографика, размеры, отступы
6. **Взаимодействия** — клики, навигация, drag/drop, хоткеи
7. **Маршрутизация** — роуты, контейнеры, где используется
8. **Интеграция с диалогами/оверлеями** — если применимо
9. **Паритет с reference/opencode** — соответствие и гапы
10. **TODO/гап-анализ** — что нужно доработать для Flutter реализации

---

## Перечень компонентов

### Shell и каркас
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-titlebar.md](./component-titlebar.md) | Title Bar | `components/titlebar.tsx` |
| [component-project-rail.md](./component-project-rail.md) | Project Rail | `pages/layout.tsx` (SortableProject) |
| [component-sidebar.md](./component-sidebar.md) | Sidebar Panel + Workspace Tree | `pages/layout/sidebar-workspace.tsx` |
| [component-context-panel.md](./component-context-panel.md) | Context Panel (правая) | `pages/session/session-side-panel.tsx` |
| [component-desktop-shell.md](./component-desktop-shell.md) | Desktop Shell (каркас) | `pages/layout.tsx` |

### Home
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-home-screen.md](./component-home-screen.md) | Home Screen | `pages/home.tsx` |

### Session
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-session-header.md](./component-session-header.md) | Session Header | `components/session/session-header.tsx` |
| [component-message-timeline.md](./component-message-timeline.md) | Message Timeline | `pages/session/message-timeline.tsx` |
| [component-prompt-composer.md](./component-prompt-composer.md) | Prompt Composer | `components/prompt-input/*.tsx` |

### Bottom Panels / Regions
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-session-tabs.md](./component-session-tabs.md) | Session Tabs (Files/Review/Terminal) | `pages/session/file-tabs.tsx` |
| [component-terminal-panel.md](./component-terminal-panel.md) | Terminal Panel | `pages/session/terminal-panel.tsx` |
| [component-review-panel.md](./component-review-panel.md) | Review Panel | `pages/session/review-tab.tsx` |
| [component-file-list.md](./component-file-list.md) | File List | `pages/session/file-tabs.tsx` |

### Навигация
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-router.md](./component-router.md) | Router (go_router) | `app.tsx`, роутинг |

### Диалоги/оверлеи
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-dialogs.md](./component-dialogs.md) | Dialogs Host | `components/dialog-*.tsx` |

### Темы/токены
| Файл | Компонент | Референс OpenCode |
|------|-----------|-------------------|
| [component-theme-tokens.md](./component-theme-tokens.md) | Theme Tokens | `index.css`, UI library |

---

## Архитектура компонентов (Atomic Design)

Компоненты организованы по принципу Atomic Design в `lib/components/`:

```
lib/components/
├── theme/                    # Дизайн токены и темы
│   ├── tokens.dart           # AppColors, AppSpacing, AppRadius, AppTypo, AppShadows
│   ├── themes.dart           # AppTheme (Material 3 + Fluent UI)
│   └── markdown_styles.dart  # MarkdownStyleSheet builder
├── foundations/              # Базовые визуальные примитивы
│   ├── surface.dart          # Surface containers
│   ├── focus_ring.dart       # Focus indicators
│   ├── icon.dart             # AppIcon wrapper
│   ├── skeleton.dart         # Loading skeletons
│   └── loaders.dart          # Progress indicators
├── atoms/                    # Атомарные UI элементы
│   ├── button.dart, icon_button.dart
│   ├── text.dart, text_field.dart, text_area.dart, search_field.dart
│   ├── badge.dart, tag.dart, avatar.dart
│   ├── checkbox.dart, toggle.dart, segmented_control.dart
│   ├── divider.dart, tooltip.dart, scrollbar.dart
├── molecules/                # Составные компоненты
│   ├── list_item.dart, menu_item.dart, toolbar.dart
│   ├── tabs.dart, pill_tabs.dart, breadcrumbs.dart
│   ├── toast.dart, snackbar.dart, dropdown.dart, select.dart
│   ├── code_block.dart, markdown_view.dart
│   ├── empty_state.dart, section_header.dart
├── organisms/                # Сложные составные компоненты
│   ├── session/              # Компоненты сессии
│   │   ├── message_bubble.dart, message_timeline.dart
│   │   ├── prompt_composer.dart, session_tabs.dart
│   │   ├── file_list.dart, review_list.dart
│   │   ├── terminal_panel_shell.dart, session_header.dart
│   └── shell/                # Shell/layout компоненты
│       ├── title_bar.dart, project_rail.dart
│       ├── sidebar.dart, context_panel.dart
│       └── desktop_shell.dart
├── layout/                   # Layout утилиты
│   ├── stack.dart, overlay_host.dart
│   ├── split_view.dart, grid.dart
└── icons/
    └── icons.dart            # FluentIcons re-export
```

### Использование

```dart
import 'package:codelab_desktop/components.dart';

// Все компоненты доступны через единый импорт
final theme = AppTheme.dark();
final colors = AppColors.dark;
```

### Миграция с app/widgets, app/theme, app/shell

> ⚠️ **Deprecated Proxies**: Директории `lib/app/widgets/`, `lib/app/theme/`, `lib/app/shell/` помечены как `@Deprecated` и являются proxy-файлами, которые реэкспортируют компоненты из `lib/components/`.

**Рекомендуемый импорт:**
```dart
// ✅ Правильно — единая точка входа
import 'package:codelab_desktop/components.dart';

// ❌ Deprecated — старые пути (работают, но будут удалены)
import 'package:codelab_desktop/app/widgets/message_timeline.dart';
import 'package:codelab_desktop/app/theme/app_theme.dart';
```

Подробнее о рефакторинге: [components_refactor.md](./components_refactor.md)

---

## Источники

### Flutter реализация (новая структура)
- `apps/codelab_desktop/lib/components.dart` — единая точка входа
- `apps/codelab_desktop/lib/components/` — компонентная библиотека

### Flutter реализация (deprecated, app layer)
- `apps/codelab_desktop/lib/app/screens/home_screen.dart`
- `apps/codelab_desktop/lib/app/screens/session_screen.dart`
- `apps/codelab_desktop/lib/app/shell/desktop_shell.dart` *(deprecated)*
- `apps/codelab_desktop/lib/app/widgets/` *(deprecated, proxies to components)*
- `apps/codelab_desktop/lib/app/theme/` *(deprecated, proxies to components)*
- `apps/codelab_desktop/lib/app/navigation/router.dart`
- `apps/codelab_desktop/lib/app/state/app_controller.dart`

### Спецификации
- `docs/ui_specs.md`
- `docs/ui_roadmap.md`
- `apps/codelab_desktop/docs/reference_audit.md`

### Reference OpenCode
- `reference/opencode/packages/app/src/pages/*.tsx`
- `reference/opencode/packages/app/src/components/*.tsx`
- `reference/opencode/packages/app/src/pages/session/*.tsx`

---

## Статус реализации

| Компонент | Flutter | Паритет с OpenCode |
|-----------|---------|-------------------|
| Title Bar | ✅ Базовый | ⚠️ Частичный |
| Project Rail | ✅ Базовый | ⚠️ Частичный |
| Sidebar Panel | ✅ Базовый | ⚠️ Частичный |
| Workspace Tree | ✅ Базовый | ⚠️ Частичный |
| Context Panel | ✅ Базовый | ⚠️ Частичный |
| Desktop Shell | ✅ Базовый | ⚠️ Частичный |
| Home Screen | ✅ Базовый | ⚠️ Частичный |
| Session Header | ✅ Базовый | ⚠️ Частичный |
| Message Timeline | ✅ Базовый | ⚠️ Частичный |
| Prompt Composer | ✅ Базовый | ⚠️ Частичный |
| Session Tabs | ✅ Базовый | ⚠️ Частичный |
| Terminal Panel | ✅ Базовый | ⚠️ Частичный |
| Review Panel | ✅ Базовый | ⚠️ Частичный |
| File List | ✅ Базовый | ⚠️ Частичный |
| Router | ✅ Базовый | ✅ Полный |
| Dialogs | ✅ Базовый | ⚠️ Частичный |
| Theme Tokens | ✅ Базовый | ⚠️ Частичный |

**Легенда:**
- ✅ Полный — полностью реализовано/соответствует
- ⚠️ Частичный — базовая реализация, требуется доработка
- ❌ Отсутствует — не реализовано
