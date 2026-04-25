# Sidebar Panel

## 1. Назначение и контекст

Sidebar Panel — боковая панель справа от Project Rail, содержащая:
- Заголовок проекта с путем
- Поле поиска
- Дерево сессий (Sessions)
- Дерево файлов workspace (Workspace Tree)

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/shell/desktop_shell.dart`](../../apps/codelab_desktop/lib/app/shell/desktop_shell.dart) — виджет `_SidebarPanel`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/layout/sidebar-workspace.tsx`](../../reference/opencode/packages/app/src/pages/layout/sidebar-workspace.tsx)

---

## 2. Состав и layout

```
┌────────────────────────┐
│ project-name           │
│ ~/path/to/project      │
├────────────────────────┤
│ [🔍 Search sessions]   │
├────────────────────────┤
│ SESSIONS               │
│  ├─ Session 1 (active) │
│  ├─ Session 2          │
│  └─ Session 3          │
├────────────────────────┤
│ WORKSPACE              │
│  ├─ 📁 lib             │
│  │   ├─ 📄 main.dart   │
│  │   └─ 📁 app         │
│  └─ 📄 pubspec.yaml    │
└────────────────────────┘
```

### Flutter реализация (_SidebarPanel)
```dart
Container (width: 376)
└── Column
    ├── Padding (header)
    │   └── Row
    │       ├── Column (name, path)
    │       └── GestureDetector (chevron)
    ├── Padding (search)
    │   └── Container (search box)
    ├── _SectionHeader ("Sessions")
    ├── Expanded
    │   └── ListView
    │       ├── _SessionRow for each session
    │       └── WorkspaceTree
    └── Padding (bottom actions)
```

### Референс OpenCode (SidebarContent, LocalWorkspace)
- `SidebarContent` — wrapper с header, search, content
- `LocalWorkspace` — workspace item с sessions
- `SortableWorkspace` — drag-drop версия
- Inline editor для rename
- Branch selector
- Git status integration

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Visible | ✅ | ✅ | Sidebar отображается |
| Hidden (collapsed) | ✅ | ✅ | Скрыт, виден только Rail |
| Session selected | ✅ | ✅ | Выделенная сессия |
| Session hover | ❌ | ✅ | Hover эффект |
| Workspace expanded | ✅ | ✅ | Развернутые папки |
| Workspace collapsed | ✅ | ✅ | Свернутые папки |
| Search active | ❌ | ✅ | Фильтрация по поиску |
| Dragging session | ❌ | ✅ | Drag сессии |
| Dragging workspace | ❌ | ✅ | Drag workspace |
| Editing name | ❌ | ✅ | Inline rename |
| Loading | ❌ | ✅ | Skeleton/spinner |

---

## 4. Пропсы/параметры

### Flutter (_SidebarPanel)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `project` | ProjectModel | Текущий проект |
| `session` | SessionModel? | Выбранная сессия |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `selectedSessionId` | String? | ID выбранной сессии |
| `selectSession(id)` | void | Выбрать сессию |
| `openDialog(AppDialog)` | void | Открыть диалог |

### Референс OpenCode (SidebarContent)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `project` | LocalProject | Проект |
| `workspace` | LocalWorkspace | Workspace |
| `sessions` | Session[] | Список сессий |
| `editor` | InlineEditorController | Inline редактор |

---

## 5. Стили/токены

### Flutter
```dart
// Container
width: 376
background: Colors.white
border: Border(right: BorderSide(color: Color(0xFFE2E0DB)))

// Header
padding: EdgeInsets.fromLTRB(18, 14, 18, 8)

// Project name
fontSize: 19
fontWeight: FontWeight.w600
color: Color(0xFF252522)

// Project path
fontSize: 12
color: Color(0xFF7F7C76)

// Search box
height: 36
background: Color(0xFFF5F4F1)
borderRadius: 10
border: Color(0xFFE1DED8)
icon color: Color(0xFF9B9892)
text: fontSize 13, color Color(0xFFADABA5)

// Section header
height: 42
padding: horizontal 18
text: fontSize 12, fontWeight w600, color Color(0xFF8B8983)

// Session row
padding: EdgeInsets.fromLTRB(18, 10, 18, 10)
borderRadius: 10
selected background: Color(0xFFF4F3EF)
selected border: Color(0xFFE4E2DC)
text: fontSize 14, fontWeight w500, color selected ? Color(0xFF2B2B27) : Color(0xFF5E5C57)
timestamp: fontSize 12, color Color(0xFF9D9A94)

// Workspace tree
See component-workspace-tree.md
```

### Референс OpenCode
```css
/* Sidebar container */
w-[var(--sidebar-width)]
min-w-[240px]
bg-surface-base

/* Project header */
h-11
px-3
border-b border-border-base

/* Search */
h-9
mx-2
rounded-lg
bg-surface-subtle

/* Session item */
h-9
px-2
rounded-md
hover:bg-surface-subtle
selected: bg-surface-accent
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Select session | ✅ tap → navigate | ✅ |
| Create session | ❌ | ✅ Button + |
| Search sessions | ❌ | ✅ Filter |
| Expand/collapse folder | ✅ | ✅ |
| Select file | ❌ | ✅ Open in editor |
| Drag session | ❌ | ✅ Reorder |
| Context menu session | ❌ | ✅ Delete/Fork/Rename |
| Context menu file | ❌ | ✅ Open/Copy path |
| Branch selector | ❌ | ✅ Git integration |
| Inline rename | ❌ | ✅ Double-click |

---

## 7. Маршрутизация

При выборе сессии:
```dart
// Flutter
onTap: () => context.go('/session/${session.id}')
```

---

## 8. Интеграция с диалогами

- `AppDialog.editProject` — редактирование проекта
- `AppDialog.forkSession` — форк сессии

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Базовый layout с header, search box, sessions, workspace
- Project name и path
- Session list с selection
- Workspace tree с expand/collapse
- Navigate to session

### ⚠️ Частично
- Search box (UI есть, логика фильтрации нет)

### ❌ Не реализовано
- Session create button
- Session search/filter
- Session drag-drop reorder
- Session context menu (delete, fork, rename)
- File context menu
- Branch selector
- Git status integration
- Inline rename
- Hover эффекты
- Loading states

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Кнопка создания новой сессии
- [ ] Реализовать поиск/фильтрацию сессий
- [ ] Hover эффекты на session rows

### Medium Priority
- [ ] Context menu для сессий (delete, rename, fork)
- [ ] Context menu для файлов
- [ ] Drag-drop reorder сессий

### Low Priority
- [ ] Branch selector
- [ ] Git status integration
- [ ] Inline rename
- [ ] Loading skeleton

---

## Связанные компоненты

- [WorkspaceTree](./component-workspace-tree.md) — дерево файлов
- [ProjectRail](./component-project-rail.md) — панель проектов
