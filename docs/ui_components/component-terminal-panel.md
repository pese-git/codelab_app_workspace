# Terminal Panel

## 1. Назначение и контекст

Terminal Panel — область отображения терминального вывода в нижней панели сессии:
- Текстовый вывод команд
- История выполнения
- (TODO) Интерактивный терминал

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — case `terminal` в `_BottomPanelBody`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/session/terminal-panel.tsx`](../../reference/opencode/packages/app/src/pages/session/terminal-panel.tsx)

---

## 2. Состав и layout

### Flutter реализация
```dart
// case SessionRegionTab.terminal:
Padding
└── Align(topLeft)
    └── Text (monospace terminal output)
```

### Референс OpenCode (TerminalPanel)
- xterm.js integration
- Multiple terminal tabs
- Terminal instance management
- Input handling
- ANSI color support
- Resize handling
- Copy/paste

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Empty | ❌ | ✅ | Нет вывода |
| With output | ✅ | ✅ | Есть текст |
| Running | ❌ | ✅ | Команда выполняется |
| Completed | ❌ | ✅ | Команда завершена |
| Error | ❌ | ✅ | Ошибка выполнения |
| Multiple tabs | ❌ | ✅ | Несколько терминалов |
| Focused | ❌ | ✅ | Терминал в фокусе |
| Scrolled | ❌ | ✅ | Прокручен вверх |

---

## 4. Пропсы/параметры

### Flutter (в _BottomPanelBody)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel | Сессия с terminalEntries |

### TerminalEntry model
```dart
class TerminalEntry {
  final String label;
  final String command;
  final String state;
}
```

### Референс OpenCode (TerminalPanel)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `terminals` | Terminal[] | Список терминалов |
| `activeId` | string | Активный терминал |
| `onActivate` | callback | Переключить терминал |
| `onCreate` | callback | Создать терминал |
| `onClose` | callback | Закрыть терминал |

---

## 5. Стили/токены

### Flutter
```dart
// Container
padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16)

// Text
fontFamily: 'monospace'
fontSize: 17
color: Color(0xFF20201D)
```

### Референс OpenCode
```css
/* Terminal container */
flex-1
overflow-hidden
bg-surface-code

/* xterm.js */
.xterm {
  font-family: 'JetBrains Mono', monospace;
  font-size: 13px;
}

/* Tab bar */
h-9
flex items-center gap-1
border-b border-border-base

/* Terminal tab */
h-7
px-2
rounded-md
text-12-mono
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| View output | ✅ | ✅ |
| Scroll | ✅ (через parent) | ✅ |
| Type input | ❌ | ✅ xterm.js |
| Copy text | ❌ | ✅ |
| Paste | ❌ | ✅ |
| Clear | ❌ | ✅ |
| Create terminal | ❌ | ✅ + button |
| Close terminal | ❌ | ✅ X button |
| Switch terminal | ❌ | ✅ Tabs |
| Resize | ❌ | ✅ Panel resize |
| Search in output | ❌ | ✅ Cmd+F |

---

## 7. Маршрутизация

Terminal Panel не влияет на маршрутизацию.

---

## 8. Интеграция с диалогами

Нет прямой интеграции.

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Отображение текстового вывода
- Monospace шрифт

### ❌ Не реализовано
- Интерактивный терминал (xterm.js эквивалент)
- Input handling
- ANSI colors
- Multiple terminals
- Terminal tabs
- Copy/paste
- Clear
- Search
- Resize

---

## 10. TODO/гап-анализ

### Critical
- [ ] Интегрировать полноценный терминал (flutter_pty + xterm.dart)

### High Priority
- [ ] Multiple terminal tabs
- [ ] Create/close terminal
- [ ] Input handling

### Medium Priority
- [ ] ANSI color support
- [ ] Copy/paste
- [ ] Clear command

### Low Priority
- [ ] Search in output
- [ ] Resize handling

---

## 11. Рекомендации по реализации

### Использование flutter_pty + xterm.dart
```dart
// pubspec.yaml
dependencies:
  flutter_pty: ^0.4.0
  xterm: ^4.0.0

// terminal_widget.dart
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class TerminalWidget extends StatefulWidget {
  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  late final Terminal terminal;
  late final Pty pty;

  @override
  void initState() {
    super.initState();
    terminal = Terminal(maxLines: 10000);
    
    pty = Pty.start(
      '/bin/zsh',
      columns: 80,
      rows: 25,
    );
    
    pty.output.listen((data) {
      terminal.write(String.fromCharCodes(data));
    });
    
    terminal.onOutput = (data) {
      pty.write(const Utf8Encoder().convert(data));
    };
  }

  @override
  Widget build(BuildContext context) {
    return TerminalView(terminal: terminal);
  }

  @override
  void dispose() {
    pty.kill();
    super.dispose();
  }
}
```

### Multiple terminals management
```dart
class TerminalController extends ChangeNotifier {
  final List<TerminalInstance> _terminals = [];
  int _activeIndex = 0;

  void createTerminal() {
    final instance = TerminalInstance(
      id: uuid(),
      label: 'Terminal ${_terminals.length + 1}',
    );
    _terminals.add(instance);
    _activeIndex = _terminals.length - 1;
    notifyListeners();
  }

  void closeTerminal(String id) {
    _terminals.removeWhere((t) => t.id == id);
    if (_activeIndex >= _terminals.length) {
      _activeIndex = _terminals.length - 1;
    }
    notifyListeners();
  }
}
```
