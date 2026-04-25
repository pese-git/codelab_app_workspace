# Session Tabs (Bottom Panel)

## 1. Назначение и контекст

Session Tabs — нижняя панель экрана сессии с тремя вкладками:
- **Files** — файлы, затронутые в сессии
- **Review** — элементы для ревью (проблемы, suggestions)
- **Terminal** — терминальный вывод

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — `_BottomTerminal` + `_BottomPanelBody`

**Референс OpenCode:**
- Files: [`pages/session/file-tabs.tsx`](../../reference/opencode/packages/app/src/pages/session/file-tabs.tsx)
- Review: [`pages/session/review-tab.tsx`](../../reference/opencode/packages/app/src/pages/session/review-tab.tsx)
- Terminal: [`pages/session/terminal-panel.tsx`](../../reference/opencode/packages/app/src/pages/session/terminal-panel.tsx)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Файлы        Ревью        Терминал 1                    [+]  [×]       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  [Content based on active tab]                                         │
│                                                                         │
│  Files tab: List of file cards                                         │
│  Review tab: List of review items                                      │
│  Terminal tab: Terminal output text                                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Flutter реализация (_BottomTerminal)
```dart
Column
├── Container (height: 42, tab bar)
│   └── Row
│       ├── For each tab:
│       │   └── GestureDetector
│       │       └── Column
│       │           ├── Text (tab label)
│       │           └── Container (underline indicator)
│       ├── Spacer
│       ├── GestureDetector (close)
│       └── GestureDetector (add terminal)
├── Container (divider, height: 1)
└── Expanded
    └── _BottomPanelBody
```

### _BottomPanelBody
```dart
switch (sessionTab):
  case files: ListView with _TerminalCard for each file
  case review: ListView with _TerminalCard for each review item
  case terminal: Text with terminal output
```

### Референс OpenCode
- `file-tabs.tsx` — более сложная реализация с:
  - File editor integration
  - Line comments
  - Selection handling
  - Scroll sync
  - Syntax highlighting
- `review-tab.tsx` — review items с diff view
- `terminal-panel.tsx` — полноценный терминал с xterm.js

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Files tab active | ✅ | ✅ | Список файлов |
| Review tab active | ✅ | ✅ | Список review items |
| Terminal tab active | ✅ | ✅ | Terminal output |
| No files | ❌ | ✅ | Empty state |
| No review items | ❌ | ✅ | Empty state |
| Terminal running | ❌ | ✅ | Активный терминал |
| Multiple terminals | ❌ | ✅ | Несколько вкладок |
| Panel collapsed | ✅ | ✅ | Панель скрыта |

---

## 4. Пропсы/параметры

### Flutter (_BottomTerminal)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel | Модель сессии |

### Flutter (_BottomPanelBody)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel | Модель сессии |

### SessionModel data
```dart
class SessionModel {
  final List<FileItem> fileItems;
  final List<ReviewItem> reviewItems;
  final List<TerminalEntry> terminalEntries;
}

class FileItem {
  final String path;
  final String summary;
  final String status;
}

class ReviewItem {
  final String title;
  final String summary;
  final String severity;
}

class TerminalEntry {
  final String label;
  final String command;
  final String state;
}
```

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `sessionTab` | SessionRegionTab | Активная вкладка |
| `setSessionTab(tab)` | void | Переключить вкладку |
| `toggleBottomPanel()` | void | Скрыть/показать панель |

---

## 5. Стили/токены

### Flutter
```dart
// Tab bar container
height: 42
padding: EdgeInsets.symmetric(horizontal: 16)

// Tab text
fontSize: 15
fontWeight: FontWeight.w600
color: active ? Color(0xFF2E2E2A) : Color(0xFF9A9792)

// Tab underline
height: 2
width: 72
color: active ? Color(0xFF2E2E2A) : Colors.transparent

// Divider
height: 1
color: Color(0xFFE1DED8)

// Card (_TerminalCard)
padding: EdgeInsets.all(12)
background: Color(0xFFFBFAF7)
borderRadius: 12
border: Color(0xFFE0DDD7)

// Card title
fontSize: 14
fontWeight: FontWeight.w600
color: Color(0xFF2E2D29)

// Card subtitle
fontSize: 12
color: Color(0xFF8E8B86)

// Card trailing
fontSize: 12
color: Color(0xFF8E8B86)

// Terminal text
fontFamily: 'monospace'
fontSize: 17
color: Color(0xFF20201D)

// Close/add icons
size: 11/16
color: Color(0xFF8E8B86)
```

### Референс OpenCode
```css
/* Tab bar */
h-10
flex items-center gap-1
border-b border-border-base

/* Tab button */
h-8
px-3
rounded-md
text-13-medium
hover:bg-surface-subtle

/* Tab active */
bg-surface-accent
text-text-strong

/* Content area */
flex-1
overflow-auto

/* File/Review card */
rounded-lg
border border-border-base
p-3

/* Terminal */
font-mono
text-13-mono
bg-surface-code
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Switch tab | ✅ setSessionTab() | ✅ |
| Close panel | ✅ toggleBottomPanel() | ✅ |
| Add terminal | ❌ (opens terminal tab) | ✅ Create new terminal |
| Click file card | ❌ | ✅ Open in editor |
| Click review card | ❌ | ✅ Jump to file/line |
| Terminal input | ❌ | ✅ Full xterm.js |
| Copy from terminal | ❌ | ✅ |
| Resize panel | ❌ | ✅ Drag handle |

---

## 7. Маршрутизация

Session Tabs не навигируют, но:
- File click может открыть файл в editor (если реализовано)

---

## 8. Интеграция с диалогами

Нет прямой интеграции.

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Три вкладки (Files, Review, Terminal)
- Переключение вкладок
- Список файлов с карточками
- Список review items с карточками
- Terminal output (статичный текст)
- Close panel button

### ⚠️ Частично
- Terminal (статичный текст, не интерактивный)
- File cards (без действий)
- Review cards (без действий)

### ❌ Не реализовано
- File click → open in editor
- Review click → jump to file/line
- Full terminal (xterm.js)
- Multiple terminals
- Terminal input
- Panel resize
- Empty states
- Loading states

---

## 10. TODO/гап-анализ

### High Priority
- [ ] File card click → open file
- [ ] Review card click → jump to location
- [ ] Panel resize handle

### Medium Priority
- [ ] Интерактивный терминал (xterm.js via flutter_pty)
- [ ] Empty states
- [ ] Multiple terminals

### Low Priority
- [ ] Copy from terminal
- [ ] Terminal input
