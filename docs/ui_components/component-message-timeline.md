# Message Timeline

## 1. Назначение и контекст

Message Timeline — основная область отображения диалога между пользователем и AI:
- Сообщения пользователя (user messages)
- Ответы AI с markdown (рендерится через `flutter_markdown` / `MarkdownBody`)
- Теги и метаданные
- Скролл и навигация по истории

**Расположение в Flutter:**
- [`apps/codelab_desktop/lib/app/widgets/message_timeline.dart`](../../apps/codelab_desktop/lib/app/widgets/message_timeline.dart) — виджет `MessageTimeline`
- [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — использование в `SessionScreen`

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/session/message-timeline.tsx`](../../reference/opencode/packages/app/src/pages/session/message-timeline.tsx)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│                        ┌──────────────────────────┐ │
│                        │ User message             │ │
│                        └──────────────────────────┘ │
│                                                     │
│  Исследовано 1 чтение                              │
│                                                     │
│  AI response text with markdown support...          │
│  - bullet points                                    │
│  - code blocks                                      │
│                                                     │
│  [tag1] [tag2] [tag3]                              │
│                                                     │
├─────────────────────────────────────────────────────┤
│                        ┌──────────────────────────┐ │
│                        │ Another user message     │ │
│                        └──────────────────────────┘ │
│                                                     │
│  AI response...                                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Flutter реализация
```dart
ListView
├── Padding (bottom: 26)
│   └── _MessageBubble(message)
├── Padding (bottom: 26)
│   └── _MessageBubble(message)
└── ...
```

### _MessageBubble
```dart
Column
├── if isUser:
│   └── Align(centerRight)
│       └── Container (user bubble)
│           └── Text
└── else:
    ├── Text ("Исследовано N чтение")
    ├── Text (AI body)
    └── if tags:
        └── Wrap (tag chips)
```

### Референс OpenCode (MessageTimeline)
- `createSessionHistoryWindow` — виртуализация истории
- Lazy loading старых сообщений
- `UserMessage` / `AssistantMessage` компоненты
- Tool results rendering
- Code blocks с syntax highlighting
- Streaming support
- Auto-scroll to bottom

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Empty (new session) | ❌ | ✅ | Пустая сессия |
| With messages | ✅ | ✅ | Сообщения отображаются |
| User message | ✅ | ✅ | Справа с рамкой |
| AI message | ✅ | ✅ | Слева с текстом |
| Streaming | ❌ | ✅ | AI печатает в реальном времени |
| Loading history | ❌ | ✅ | Загрузка старых сообщений |
| At bottom | ✅ | ✅ | Auto-scroll активен |
| User scrolled | ❌ | ✅ | Auto-scroll выключен |
| Jump to bottom | ❌ | ✅ | Кнопка перехода вниз |
| Tool result | ❌ | ✅ | Результат инструмента |
| Code block | ❌ | ✅ | Блок кода с подсветкой |
| Error state | ❌ | ✅ | Ошибка в сообщении |

---

## 4. Пропсы/параметры

### Flutter (_MessageBubble)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `message` | MessageModel | Модель сообщения |

### MessageModel (workspace_models.dart)
```dart
class MessageModel {
  final String role; // 'user' | 'assistant'
  final String body;
  final List<String> tags;
}
```

### Message / MessageRole (message_timeline.dart)
```dart
enum MessageRole { user, assistant }

class Message {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
}
```

### Референс OpenCode (MessageTimeline)
| Параметр/хук | Тип | Описание |
|--------------|-----|----------|
| `input.sessionID` | () => string | ID сессии |
| `input.messagesReady` | () => boolean | Данные готовы |
| `input.visibleUserMessages` | () => UserMessage[] | Сообщения |
| `input.historyMore` | () => boolean | Есть еще история |
| `input.historyLoading` | () => boolean | Загрузка |
| `input.loadMore` | (id) => Promise | Загрузить больше |
| `input.userScrolled` | () => boolean | Пользователь скроллил |
| `input.scroller` | () => HTMLDivElement | Scroll container |

---

## 5. Стили/токены

### Flutter
```dart
// ListView
padding: EdgeInsets.fromLTRB(28, 26, 28, 20)

// User message bubble
padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14)
background: Colors.white
borderRadius: 14
border: Color(0xFFE0DDD7)
text: fontSize 18, color Color(0xFF2E2D29)

// AI message
// "Исследовано" text
fontSize: 12
fontWeight: FontWeight.w600
color: Color(0xFF6F6D67)

// AI body text
fontSize: 17
height: 1.45
color: Color(0xFF2C2C28)

// Tag chips
padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)
background: Color(0xFFF2F1ED)
borderRadius: 999
text: fontSize 12, color Color(0xFF7E7B75)
```

### Референс OpenCode
```css
/* Timeline container */
flex-1
overflow-y-auto
px-4 py-4

/* User message */
max-w-[80%]
ml-auto
rounded-2xl
bg-surface-accent
px-4 py-3

/* Assistant message */
max-w-full
rounded-2xl
px-4 py-3

/* Tool result */
rounded-lg
border border-border-base
bg-surface-subtle

/* Code block */
rounded-md
bg-surface-code
font-mono
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Scroll | ✅ ListView | ✅ Custom scroll |
| Auto-scroll to bottom | ✅ | ✅ createAutoScroll |
| Jump to bottom button | ❌ | ✅ When scrolled up |
| Load more history | ❌ | ✅ Scroll to top |
| Copy message | ❌ | ✅ Context menu |
| Copy code block | ❌ | ✅ Copy button |
| Edit user message | ❌ | ✅ Context menu |
| Fork from message | ❌ | ✅ Context menu |
| Retry AI message | ❌ | ✅ Context menu |
| Tool result expand | ❌ | ✅ Accordion |
| File link click | ❌ | ✅ Open in editor |

---

## 7. Маршрутизация

Message Timeline не навигирует напрямую, но:
- File links могут открывать файлы в editor tabs
- Fork создает новую сессию

---

## 8. Интеграция с диалогами

- Fork session → `AppDialog.forkSession`

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Базовый список сообщений
- User/Assistant различие
- Теги на AI сообщениях
- Скролл

### ⚠️ Частично
- Стилизация сообщений (базовая)

### ❌ Не реализовано
- Streaming (realtime typing)
- Lazy loading истории
- Auto-scroll to bottom
- Jump to bottom button
- Tool results rendering
- Code blocks с подсветкой
- Markdown rendering
- Copy/edit/fork context menu
- Empty session state
- Loading states
- Error states

---

## 10. TODO/гап-анализ

### Critical
- [ ] Markdown rendering для AI сообщений
- [ ] Code blocks с syntax highlighting

### High Priority
- [ ] Auto-scroll to bottom
- [ ] Tool results rendering
- [ ] Streaming support

### Medium Priority
- [ ] Lazy loading истории
- [ ] Jump to bottom button
- [ ] Copy/edit context menu

### Low Priority
- [ ] Fork from message
- [ ] Empty session state
- [ ] Error states
