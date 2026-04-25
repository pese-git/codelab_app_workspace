# Review Panel

## 1. Назначение и контекст

Review Panel — область отображения элементов для ревью в нижней панели сессии:
- Проблемы и suggestions
- Severity levels
- Ссылки на файлы/строки

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — case `review` в `_BottomPanelBody`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/session/review-tab.tsx`](../../reference/opencode/packages/app/src/pages/session/review-tab.tsx)

---

## 2. Состав и layout

### Flutter реализация
```dart
// case SessionRegionTab.review:
ListView
└── For each reviewItem:
    └── Padding
        └── _TerminalCard(
            title: item.title,
            subtitle: item.summary,
            trailing: item.severity,
        )
```

### _TerminalCard
```dart
Container
└── Row
    ├── Expanded
    │   └── Column
    │       ├── Text (title)
    │       └── Text (subtitle)
    └── Text (trailing/severity)
```

### Референс OpenCode (SessionReviewTab)
- Diff view integration
- Line-by-line changes
- Accept/reject changes
- Comment threads
- Syntax highlighting

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Empty | ❌ | ✅ | Нет элементов |
| With items | ✅ | ✅ | Есть элементы |
| Item selected | ❌ | ✅ | Выбран элемент |
| Item expanded | ❌ | ✅ | Развернут diff |
| Severity info | ✅ | ✅ | Информационный |
| Severity warning | ✅ | ✅ | Предупреждение |
| Severity error | ✅ | ✅ | Ошибка |
| Change accepted | ❌ | ✅ | Изменение принято |
| Change rejected | ❌ | ✅ | Изменение отклонено |

---

## 4. Пропсы/параметры

### Flutter (в _BottomPanelBody)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel | Сессия с reviewItems |

### ReviewItem model
```dart
class ReviewItem {
  final String title;
  final String summary;
  final String severity;
}
```

### Референс OpenCode (SessionReviewTab)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `changes` | Change[] | Список изменений |
| `diffStyle` | DiffStyle | Стиль отображения diff |
| `onAccept` | callback | Принять изменение |
| `onReject` | callback | Отклонить изменение |
| `onOpenFile` | callback | Открыть файл |

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

// Title
fontSize: 14
fontWeight: FontWeight.w600
color: Color(0xFF2E2D29)

// Subtitle/summary
fontSize: 12
color: Color(0xFF8E8B86)

// Trailing/severity
fontSize: 12
color: Color(0xFF8E8B86)
```

### Референс OpenCode
```css
/* Review container */
flex-1
overflow-auto
p-3

/* Review item */
rounded-lg
border border-border-base
p-3
mb-2
hover:bg-surface-subtle

/* Diff view */
font-mono
text-13-mono

/* Added line */
bg-surface-success-subtle
text-text-success

/* Removed line */
bg-surface-critical-subtle
text-text-critical

/* Severity badge */
px-2
rounded-full
text-11-medium
/* info */ bg-surface-info text-text-info
/* warning */ bg-surface-warning text-text-warning
/* error */ bg-surface-critical text-text-critical
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| View items | ✅ | ✅ |
| Scroll | ✅ | ✅ |
| Click item | ❌ | ✅ → expand diff |
| Jump to file/line | ❌ | ✅ |
| Accept change | ❌ | ✅ |
| Reject change | ❌ | ✅ |
| Accept all | ❌ | ✅ |
| Reject all | ❌ | ✅ |
| Add comment | ❌ | ✅ |
| Toggle diff style | ❌ | ✅ Side-by-side/inline |

---

## 7. Маршрутизация

Review Panel не влияет на маршрутизацию напрямую, но:
- Click на item может открыть файл в editor

---

## 8. Интеграция с диалогами

Нет прямой интеграции.

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Список review items
- Title/summary отображение
- Severity badge

### ❌ Не реализовано
- Click → expand diff
- Jump to file/line
- Accept/reject changes
- Diff view
- Syntax highlighting
- Comment threads
- Empty state
- Severity colors

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Click item → jump to file/line
- [ ] Severity colors (info/warning/error)
- [ ] Empty state

### Medium Priority
- [ ] Expandable diff view
- [ ] Accept/reject changes
- [ ] Hover states

### Low Priority
- [ ] Syntax highlighted diff
- [ ] Comment threads
- [ ] Side-by-side diff style
- [ ] Accept/reject all

---

## 11. Рекомендуемые улучшения

### Severity colors
```dart
Color _severityColor(String severity) {
  switch (severity.toLowerCase()) {
    case 'error':
      return const Color(0xFFDC2626);
    case 'warning':
      return const Color(0xFFF59E0B);
    case 'info':
    default:
      return const Color(0xFF3B82F6);
  }
}

Color _severityBackground(String severity) {
  switch (severity.toLowerCase()) {
    case 'error':
      return const Color(0xFFFEE2E2);
    case 'warning':
      return const Color(0xFFFEF3C7);
    case 'info':
    default:
      return const Color(0xFFDBEAFE);
  }
}
```

### Expandable diff
```dart
class _ReviewItemCard extends StatefulWidget {
  final ReviewItem item;
  
  @override
  State<_ReviewItemCard> createState() => _ReviewItemCardState();
}

class _ReviewItemCardState extends State<_ReviewItemCard> {
  bool _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: _buildHeader(),
        ),
        if (_expanded)
          _buildDiffView(),
      ],
    );
  }
}
```
