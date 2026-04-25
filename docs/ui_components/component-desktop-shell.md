# Desktop Shell

## 1. Назначение и контекст

Desktop Shell — главный каркас приложения, объединяющий все основные области:
- Title Bar (верхняя панель)
- Project Rail (левая узкая полоса с проектами)
- Sidebar Panel (боковая панель с деревом файлов/сессий)
- Main Content (центральная область с контентом экрана)
- Bottom Panel (нижняя панель — файлы/review/терминал)
- Context Panel (правая панель с деталями)

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/shell/desktop_shell.dart`](../../apps/codelab_desktop/lib/app/shell/desktop_shell.dart) — виджет `DesktopShell`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/layout.tsx`](../../reference/opencode/packages/app/src/pages/layout.tsx)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Title Bar                                       │
├────────┬──────────────┬─────────────────────────────────────┬───────────────┤
│        │              │                                     │               │
│ Project│   Sidebar    │          Main Content               │   Context     │
│  Rail  │   Panel      │          (Home/Session)             │   Panel       │
│        │              │                                     │               │
│        │              ├─────────────────────────────────────┤               │
│        │              │         Bottom Panel                │               │
│        │              │     (Files/Review/Terminal)         │               │
├────────┴──────────────┴─────────────────────────────────────┴───────────────┤
```

### Flutter реализация (DesktopShell)
```dart
NavigationView
└── ScaffoldPage
    └── Container (background)
        └── Column
            ├── _TitleBar
            └── Expanded Row
                ├── _ProjectRail
                ├── _SidebarPanel (conditional)
                └── Expanded Column
                    ├── Expanded Container (child content)
                    └── Container (bottomPanel, conditional)
                └── _ContextPanel (conditional)
```

### Референс OpenCode (Layout)
- Более сложная структура с DragDropProvider
- Inline editor controller
- Persist для состояния layout
- Session prefetch/cache
- Deep links handling
- Multiple workspaces sorting

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Sidebar visible | ✅ | ✅ | Sidebar развернут |
| Sidebar collapsed | ✅ | ✅ | Sidebar свернут (только Rail) |
| Sidebar hover (desktop) | ❌ | ✅ | Hover раскрывает sidebar |
| Context panel visible | ✅ | ✅ | Правая панель видна |
| Context panel hidden | ✅ | ✅ | Правая панель скрыта |
| Bottom panel visible | ✅ | ✅ | Нижняя панель видна |
| Bottom panel hidden | ✅ | ✅ | Нижняя панель скрыта |
| isHome | ✅ | ✅ | Home экран (без bottom panel) |
| isSession | ✅ | ✅ | Session экран (с bottom panel) |
| Mobile layout | ❌ | ✅ | Адаптивный mobile layout |
| Resizing | ❌ | ✅ | Resize handles между панелями |

---

## 4. Пропсы/параметры

### Flutter (DesktopShell)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `child` | Widget | Контент центральной области |
| `title` | String | Заголовок (не отображается напрямую) |
| `isHome` | bool | Флаг домашнего экрана |
| `bottomPanel` | Widget? | Виджет нижней панели |

### Зависимости от контроллера (CodeLabAppController)
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `projects` | List<ProjectModel> | Список проектов |
| `selectedProject` | ProjectModel | Выбранный проект |
| `selectedSession` | SessionModel? | Выбранная сессия |
| `sidebarCollapsed` | bool | Sidebar свернут |
| `contextPanelVisible` | bool | Правая панель видна |
| `bottomPanelVisible` | bool | Нижняя панель видна |

### Референс OpenCode (Layout)
| Параметр/хук | Тип | Описание |
|--------------|-----|----------|
| `props.children` | ParentProps | Вложенный контент |
| `persisted store` | Store | layout state (workspaceOrder, expanded, etc.) |
| `useLayout()` | context | Layout context |
| `useGlobalSync()` | context | Data sync |
| `usePlatform()` | context | Platform info |
| `useSettings()` | context | Settings |
| `useProviders()` | hook | Provider list |
| `useCommand()` | context | Command palette |

---

## 5. Стили/токены

### Flutter
```dart
// Main container
color: Color(0xFFF6F5F2)

// Project Rail
width: 86
background: Color(0xFFF5F4F1)
border: Border(right: BorderSide(color: Color(0xFFE2E0DB)))

// Sidebar Panel
width: 376
background: Colors.white
border: Border(right: BorderSide(color: Color(0xFFE2E0DB)))

// Main content area
background: Colors.white

// Bottom Panel
height: 178
background: Color(0xFFF7F6F3)
border: Border(top: BorderSide(color: Color(0xFFE2E0DB)))

// Context Panel
width: 280 (из _ContextPanel)
background: Colors.white
border: Border(left: BorderSide(color: Color(0xFFE2E0DB)))
```

### Референс OpenCode
```css
/* Основные размеры из layout */
--sidebar-width: configurable
--session-width: configurable
--file-tree-width: configurable

/* Resize handles */
ResizeHandle component

/* Background */
bg-background-base
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Sidebar collapse/expand | ✅ via TitleBar | ✅ via TitleBar + keyboard |
| Sidebar hover expand | ❌ | ✅ AIM (predictive reveal) |
| Project selection | ✅ Rail click | ✅ Rail click + drag/drop |
| Session selection | ✅ Sidebar click | ✅ Sidebar click + keyboard |
| Panel resize | ❌ | ✅ ResizeHandle |
| Bottom panel toggle | ✅ | ✅ |
| Context panel toggle | ✅ | ✅ |
| Workspace reorder | ❌ | ✅ Drag/drop |
| Project reorder | ❌ | ✅ Drag/drop |
| Keyboard navigation | ❌ | ✅ Extensive keybinds |

---

## 7. Маршрутизация

Desktop Shell оборачивает все экраны:
- Home: `/` → `HomeScreen` внутри `DesktopShell`
- Session: `/session/:sessionId` → `SessionScreen` внутри `DesktopShell`

---

## 8. Интеграция с диалогами

Desktop Shell содержит `DialogHost` (в Flutter это в `app.dart`), который отображает модальные диалоги поверх всего UI.

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Базовый layout с Rail, Sidebar, Content, Context Panel
- Bottom Panel условное отображение
- Project selection
- Session selection
- Sidebar collapse/expand
- Context panel toggle
- Bottom panel toggle

### ⚠️ Частично
- Sidebar panel (базовая структура, без всех фич)
- Context panel (базовая структура)

### ❌ Не реализовано
- Sidebar hover expand (AIM predictive)
- Panel resize handles
- Workspace/project drag-drop reorder
- Keyboard navigation
- Mobile/responsive layout
- Deep links handling
- Session prefetch/cache
- Inline editor controller
- Persisted layout state (ширины панелей, expanded states)

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Добавить ResizeHandle для панелей (sidebar, bottom, context)
- [ ] Сохранять состояние layout в shared_preferences

### Medium Priority
- [ ] Hover expand для sidebar (при collapsed)
- [ ] Keyboard navigation между панелями
- [ ] Drag-drop для проектов в Rail

### Low Priority
- [ ] Mobile/responsive layout
- [ ] AIM predictive reveal
- [ ] Session prefetch
- [ ] Deep links

---

## Внутренние компоненты

### _ProjectRail
Левая узкая панель с проектами. См. [component-project-rail.md](./component-project-rail.md)

### _SidebarPanel
Боковая панель с деревом. См. [component-sidebar.md](./component-sidebar.md)

### _ContextPanel
Правая информационная панель. См. [component-context-panel.md](./component-context-panel.md)

### _TitleBar
Верхняя панель. См. [component-titlebar.md](./component-titlebar.md)
