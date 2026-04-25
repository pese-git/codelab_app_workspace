# Project Rail

## 1. Назначение и контекст

Project Rail — узкая вертикальная панель слева, отображающая:
- Аватары/инициалы открытых проектов
- Кнопку добавления нового проекта
- Кнопки Settings и Help внизу

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/shell/desktop_shell.dart`](../../apps/codelab_desktop/lib/app/shell/desktop_shell.dart) — виджет `_ProjectRail`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/layout.tsx`](../../reference/opencode/packages/app/src/pages/layout.tsx) — секция с `SortableProject`

---

## 2. Состав и layout

```
┌────────┐
│  [P1]  │  ← Project button (selected)
│  [P2]  │  ← Project button
│  [P3]  │  ← Project button
│  [+]   │  ← Add project button
│        │
│  ...   │
│        │
│  [⚙]   │  ← Settings
│  [?]   │  ← Help
└────────┘
```

### Flutter реализация (_ProjectRail)
```dart
Container (width: 86)
└── Column
    ├── SizedBox(height: 16)
    ├── For each project:
    │   └── Padding
    │       └── Tooltip
    │           └── _RailProjectButton
    ├── GestureDetector (+)
    ├── Spacer
    ├── IconButton (Settings)
    └── IconButton (Help)
```

### Референс OpenCode
- `SortableProject` с drag-drop
- Workspace grouping
- Inline editor для rename
- Context menu
- Badge для состояния (busy, notifications)

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Selected project | ✅ | ✅ | Выделенная рамка |
| Unselected project | ✅ | ✅ | Обычная рамка |
| Hover | ❌ | ✅ | Hover эффект |
| Dragging | ❌ | ✅ | Drag overlay |
| Drop target | ❌ | ✅ | Drop zone indicator |
| Busy (loading) | ❌ | ✅ | Spinner/indicator |
| Has notifications | ❌ | ✅ | Badge |
| Editing name | ❌ | ✅ | Inline input |

---

## 4. Пропсы/параметры

### Flutter (_ProjectRail)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `projects` | List<ProjectModel> | Список проектов |

### Flutter (_RailProjectButton)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `project` | ProjectModel | Модель проекта |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `selectedProjectId` | String | ID выбранного проекта |
| `selectProject(id)` | void | Выбрать проект |
| `selectedSessionId` | String? | ID выбранной сессии |
| `openDialog(AppDialog)` | void | Открыть диалог |

### Референс OpenCode (SortableProject)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `project` | LocalProject | Проект |
| `workspace` | LocalWorkspace | Workspace |
| `draggable` | () => void | Drag handlers |
| `context: ProjectSidebarContext` | object | Контекст для действий |

---

## 5. Стили/токены

### Flutter
```dart
// Container
width: 86
background: Color(0xFFF5F4F1)
border: Border(right: BorderSide(color: Color(0xFFE2E0DB)))

// Project button container
width: 54
height: 54
padding: EdgeInsets.all(4)
borderRadius: 14
border: selected ? Color(0xFF30302D), width 2 : Color(0xFFBEBBB4), width 1

// Project button inner
borderRadius: 10
background: Color(0xFFFDE4F4) // Pink example

// Project initial text
fontSize: 18
fontWeight: FontWeight.w600
color: Color(0xFFE24BA8) // Pink example

// Add button
size: 32x32
icon size: 17
icon color: Color(0xFF8B8983)

// Footer buttons (Settings, Help)
icon color: Color(0xFFA29F99)
```

### Референс OpenCode
```css
/* Project avatar */
w-9.5 h-9.5
rounded-lg
ring-2 ring-border-base (selected: ring-border-strong)

/* Add button */
w-6.5 h-6.5
rounded-full
bg-surface-subtle

/* Drag overlay */
shadow-xl
scale transition
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Select project | ✅ tap → selectProject() + navigate | ✅ |
| Add project | ✅ openDialog(selectDirectory) | ✅ directory picker |
| Open settings | ✅ openDialog(settings) | ✅ command palette |
| Open help | ✅ openDialog(help) | ✅ |
| Drag project | ❌ | ✅ SortableProvider |
| Drop project | ❌ | ✅ Reorder |
| Context menu | ❌ | ✅ Right-click menu |
| Rename project | ❌ | ✅ Inline editor |
| Remove project | ❌ | ✅ Via context menu |
| Hover tooltip | ✅ Tooltip(project.name) | ✅ |

---

## 7. Маршрутизация

При выборе проекта:
```dart
// Flutter
controller.selectProject(project.id);
if (sessionId != null) {
  context.go('/session/$sessionId');
} else {
  context.go('/');
}
```

---

## 8. Интеграция с диалогами

- `AppDialog.selectDirectory` — открыть директорию (добавить проект)
- `AppDialog.settings` — настройки
- `AppDialog.help` — справка

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Список проектов с аватарами
- Выделение выбранного проекта
- Кнопка добавления проекта
- Кнопки Settings/Help
- Tooltip с именем проекта
- Навигация при выборе

### ❌ Не реализовано
- Drag-drop reorder проектов
- Context menu (правый клик)
- Inline rename
- Busy/loading состояние
- Notification badge
- Workspace grouping
- Hover эффекты

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Hover эффекты на кнопках проектов
- [ ] Context menu с Remove/Rename

### Medium Priority
- [ ] Drag-drop для reorder
- [ ] Busy/loading состояние

### Low Priority
- [ ] Notification badges
- [ ] Inline rename editor
- [ ] Workspace grouping

---

## Модель данных

### ProjectModel
```dart
class ProjectModel {
  final String id;
  final String name;
  final String initials;
  final String path;
  final List<SessionModel> sessions;
  final List<WorkspaceNode> workspaceRoots;
}
```
