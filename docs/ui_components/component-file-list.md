# File List

## 1. Назначение и контекст

File List — область отображения файлов, затронутых в сессии (нижняя панель):
- Список файлов с path
- Summary изменений
- Status (tracked, modified, etc.)

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — case `files` в `_BottomPanelBody`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/session/file-tabs.tsx`](../../reference/opencode/packages/app/src/pages/session/file-tabs.tsx)

---

## 2. Состав и layout

### Flutter реализация
```dart
// case SessionRegionTab.files:
ListView
└── For each fileItem:
    └── Padding
        └── _TerminalCard(
            title: item.path,
            subtitle: item.summary,
            trailing: item.status,
        )
```

### _TerminalCard (общий с Review)
```dart
Container
└── Row
    ├── Expanded
    │   └── Column
    │       ├── Text (path)
    │       └── Text (summary)
    └── Text (status)
```

### Референс OpenCode (file-tabs)
- File content viewer
- Line selection
- Line comments
- Syntax highlighting
- Scroll sync
- Multiple file tabs

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Empty | ❌ | ✅ | Нет файлов |
| With files | ✅ | ✅ | Есть файлы |
| File selected | ❌ | ✅ | Файл выбран |
| Status tracked | ✅ | ✅ | Отслеживается |
| Status modified | ✅ | ✅ | Изменен |
| Status created | ✅ | ✅ | Создан |
| Status deleted | ✅ | ✅ | Удален |
| File open in tab | ❌ | ✅ | Открыт во вкладке |

---

## 4. Пропсы/параметры

### Flutter (в _BottomPanelBody)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel | Сессия с fileItems |

### FileItem model
```dart
class FileItem {
  final String path;
  final String summary;
  final String status;
}
```

### Референс OpenCode (FileTabContent)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `tab` | string | ID вкладки |
| `path` | string | Путь к файлу |
| `content` | string | Содержимое |
| `selectedLines` | Range | Выбранные строки |
| `comments` | Comment[] | Комментарии |

---

## 5. Стили/токены

### Flutter
```dart
// ListView
padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14)

// Card container
padding: EdgeInsets.all(12)
background: Color(0xFFFBFAF7)
borderRadius: 12
border: Color(0xFFE0DDD7)
margin bottom: 10

// Path (title)
fontSize: 14
fontWeight: FontWeight.w600
color: Color(0xFF2E2D29)

// Summary (subtitle)
fontSize: 12
color: Color(0xFF8E8B86)

// Status (trailing)
fontSize: 12
color: Color(0xFF8E8B86)
```

### Референс OpenCode
```css
/* File tabs container */
flex-1
overflow-hidden

/* Tab bar */
h-10
flex items-center gap-1
border-b border-border-base

/* File tab */
h-8
px-3
rounded-md
text-13-mono
max-w-[200px]
truncate

/* Tab active */
bg-surface-accent

/* File content */
flex-1
overflow-auto
font-mono

/* Line numbers */
w-12
text-right
pr-3
text-text-weak
select-none

/* Status badge */
px-2
py-0.5
rounded-full
text-11-medium
/* tracked */ bg-surface-subtle text-text-weak
/* modified */ bg-surface-warning text-text-warning
/* created */ bg-surface-success text-text-success
/* deleted */ bg-surface-critical text-text-critical
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| View files | ✅ | ✅ |
| Scroll | ✅ | ✅ |
| Click file | ❌ | ✅ → open in tab |
| Close tab | ❌ | ✅ X button |
| Reorder tabs | ❌ | ✅ Drag |
| Select lines | ❌ | ✅ |
| Add comment | ❌ | ✅ |
| Copy selection | ❌ | ✅ |
| Search in file | ❌ | ✅ Cmd+F |

---

## 7. Маршрутизация

File List не влияет на маршрутизацию напрямую, но:
- Click на файл должен открыть его в editor tabs

---

## 8. Интеграция с диалогами

Нет прямой интеграции.

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Список файлов с карточками
- Path/summary/status отображение

### ❌ Не реализовано
- Click → open in tab
- File content viewer
- Syntax highlighting
- Line selection
- Line comments
- Multiple tabs
- Tab close/reorder
- Status colors
- Empty state
- Search in file

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Click file → open in editor tab
- [ ] Status colors (tracked/modified/created/deleted)
- [ ] Empty state

### Medium Priority
- [ ] File content viewer
- [ ] Multiple file tabs
- [ ] Tab management (close, reorder)

### Low Priority
- [ ] Syntax highlighting
- [ ] Line selection
- [ ] Line comments
- [ ] Search in file

---

## 11. Рекомендуемые улучшения

### Status colors
```dart
Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'modified':
      return const Color(0xFFF59E0B);
    case 'created':
      return const Color(0xFF10B981);
    case 'deleted':
      return const Color(0xFFDC2626);
    case 'tracked':
    default:
      return const Color(0xFF6B7280);
  }
}

Color _statusBackground(String status) {
  switch (status.toLowerCase()) {
    case 'modified':
      return const Color(0xFFFEF3C7);
    case 'created':
      return const Color(0xFFD1FAE5);
    case 'deleted':
      return const Color(0xFFFEE2E2);
    case 'tracked':
    default:
      return const Color(0xFFF3F4F6);
  }
}
```

### File tabs system
```dart
class FileTabsController extends ChangeNotifier {
  final List<String> _tabs = [];
  String? _activeTab;
  
  List<String> get tabs => _tabs;
  String? get activeTab => _activeTab;
  
  void openFile(String path) {
    if (!_tabs.contains(path)) {
      _tabs.add(path);
    }
    _activeTab = path;
    notifyListeners();
  }
  
  void closeFile(String path) {
    _tabs.remove(path);
    if (_activeTab == path) {
      _activeTab = _tabs.isNotEmpty ? _tabs.last : null;
    }
    notifyListeners();
  }
  
  void reorderTabs(int oldIndex, int newIndex) {
    final tab = _tabs.removeAt(oldIndex);
    _tabs.insert(newIndex, tab);
    notifyListeners();
  }
}
```
