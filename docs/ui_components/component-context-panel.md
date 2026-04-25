# Context Panel

## 1. Назначение и контекст

Context Panel — правая боковая панель с контекстной информацией:
- Details tab — информация о сессии
- Files tab — файлы проекта
- Настройки сессии

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/shell/desktop_shell.dart`](../../apps/codelab_desktop/lib/app/shell/desktop_shell.dart) — `_ContextPanel`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/session/session-side-panel.tsx`](../../reference/opencode/packages/app/src/pages/session/session-side-panel.tsx)

---

## 2. Состав и layout

```
┌────────────────────────┐
│ Details    Files       │  ← Tabs
├────────────────────────┤
│                        │
│  [Content based on     │
│   active tab]          │
│                        │
│  Details: Session info │
│  Files: File tree      │
│                        │
└────────────────────────┘
```

### Flutter реализация (_ContextPanel)
```dart
Container (width: 280)
└── Column
    ├── Container (tab bar)
    │   └── Row
    │       ├── GestureDetector (Details tab)
    │       └── GestureDetector (Files tab)
    └── Expanded
        └── switch (contextPanelTab):
            case details: _DetailsContent
            case files: _FilesContent
```

### _DetailsContent
```dart
ListView
├── _DetailRow (Model)
├── _DetailRow (Provider)
├── _DetailRow (MCP)
├── Divider
├── _ToggleRow (Show progress)
├── Divider
└── _DetailRow (Server)
```

### _FilesContent
```dart
Column
├── Search box
└── Expanded
    └── ListView
        └── WorkspaceTree
```

### Референс OpenCode (SessionSidePanel)
- Более детальная структура
- Cost/token display
- Branch/git info
- Context items (attached files)
- Settings toggles
- Keyboard shortcuts reference

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Visible | ✅ | ✅ | Панель отображается |
| Hidden | ✅ | ✅ | Панель скрыта |
| Details tab | ✅ | ✅ | Tab с деталями |
| Files tab | ✅ | ✅ | Tab с файлами |
| isHome | ✅ | ✅ | Home экран (другой контент) |
| isSession | ✅ | ✅ | Session экран |

---

## 4. Пропсы/параметры

### Flutter (_ContextPanel)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel? | Текущая сессия |
| `isHome` | bool | Флаг Home экрана |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `contextPanelTab` | ContextPanelTab | Активная вкладка |
| `setContextPanelTab(tab)` | void | Переключить вкладку |
| `selectedModel` | String | Выбранная модель |
| `selectedProvider` | String | Выбранный провайдер |
| `selectedMcp` | String | Выбранный MCP |
| `selectedServer` | String | Выбранный сервер |
| `isSettingEnabled(key)` | bool | Настройка включена |
| `toggleSetting(key)` | void | Переключить настройку |
| `openDialog(AppDialog)` | void | Открыть диалог |

---

## 5. Стили/токены

### Flutter
```dart
// Container
width: 280
background: Colors.white
border: Border(left: BorderSide(color: Color(0xFFE2E0DB)))

// Tab bar
height: 52
padding: EdgeInsets.symmetric(horizontal: 14)
border: Border(bottom: BorderSide(color: Color(0xFFE1DED8)))

// Tab text
fontSize: 14
fontWeight: FontWeight.w600
color: active ? Color(0xFF2D2C28) : Color(0xFF9C9A95)

// Tab underline
height: 2
color: active ? Color(0xFF2D2C28) : Colors.transparent

// Detail row
height: 42
padding: EdgeInsets.symmetric(horizontal: 14)

// Detail label
fontSize: 13
color: Color(0xFF8D8A85)

// Detail value
fontSize: 13
fontWeight: FontWeight.w500
color: Color(0xFF45443F)

// Chevron icon
size: 10
color: Color(0xFF9A9793)

// Toggle row
height: 42
padding: EdgeInsets.symmetric(horizontal: 14)

// Toggle switch
width: 36
height: 20
active: Color(0xFF2D2C28)
inactive: Color(0xFFCFCCC6)

// Divider
height: 1
color: Color(0xFFE5E3DD)
margin: EdgeInsets.symmetric(horizontal: 14)

// Search box
height: 36
margin: EdgeInsets.fromLTRB(14, 14, 14, 10)
background: Color(0xFFF5F4F1)
borderRadius: 10
border: Color(0xFFE1DED8)
```

### Референс OpenCode
```css
/* Panel container */
w-[280px]
border-l border-border-base
bg-surface-base

/* Tab bar */
h-11
flex items-center
gap-1
px-3
border-b border-border-base

/* Tab button */
h-7
px-2
rounded-md
text-13-medium

/* Content area */
flex-1
overflow-auto
p-3

/* Detail row */
flex items-center justify-between
h-9
px-2
rounded-md
hover:bg-surface-subtle
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Switch tab | ✅ setContextPanelTab() | ✅ |
| Click model row | ✅ openDialog(selectModel) | ✅ |
| Click provider row | ✅ openDialog(selectProvider) | ✅ |
| Click MCP row | ✅ openDialog(selectMcp) | ✅ |
| Click server row | ✅ openDialog(selectServer) | ✅ |
| Toggle setting | ✅ toggleSetting() | ✅ |
| Search files | ❌ | ✅ Filter tree |
| Click file | ❌ | ✅ Open in editor |
| Expand/collapse folder | ✅ | ✅ |

---

## 7. Маршрутизация

Context Panel не навигирует напрямую.

---

## 8. Интеграция с диалогами

- `AppDialog.selectModel` — выбор модели
- `AppDialog.selectProvider` — выбор провайдера
- `AppDialog.selectMcp` — выбор MCP
- `AppDialog.selectServer` — выбор сервера

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Две вкладки (Details, Files)
- Model/Provider/MCP/Server rows
- Setting toggles
- File tree в Files tab
- Search box (UI)

### ⚠️ Частично
- Search (UI есть, логика фильтрации нет)

### ❌ Не реализовано
- Cost/token display
- Branch/git info
- Context items (attached files in session)
- Keyboard shortcuts reference
- File click → open in editor

---

## 10. TODO/гап-анализ

### High Priority
- [ ] File search/filter логика
- [ ] File click → open in editor

### Medium Priority
- [ ] Cost/token display (когда появится API)
- [ ] Context items (attached files)

### Low Priority
- [ ] Keyboard shortcuts reference
- [ ] Branch/git info
