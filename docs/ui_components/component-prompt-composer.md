# Prompt Composer

## 1. Назначение и контекст

Prompt Composer — многофункциональная область ввода для:
- Текст промпта
- Прикрепление файлов
- Выбор модели AI
- Выбор провайдера
- Отправка сообщения

Используется на Home Screen и Session Screen.

**Расположение в Flutter:**
- [`apps/codelab_desktop/lib/app/widgets/prompt_composer.dart`](../../apps/codelab_desktop/lib/app/widgets/prompt_composer.dart) — основная реализация `PromptComposer`
- Home: [`apps/codelab_desktop/lib/app/screens/home_screen.dart`](../../apps/codelab_desktop/lib/app/screens/home_screen.dart) — inline `_PromptComposer`
- Session: [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — `_ComposerPanel`

**Референс OpenCode:** [`reference/opencode/packages/app/src/components/prompt-input/*.tsx`](../../reference/opencode/packages/app/src/components/prompt-input/)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  Спросите что угодно...                            │
│                                                     │
│                                                     │
├─────────────────────────────────────────────────────┤
│ [+]                                          [↑]   │
├─────────────────────────────────────────────────────┤
│ Build ▼    👤 Big Pickle ▼                         │
└─────────────────────────────────────────────────────┘
```

### Flutter реализация (_PromptComposer / _ComposerPanel)
```dart
Container
└── Column
    ├── Expanded
    │   └── Align(topLeft)
    │       └── Text (placeholder)
    ├── Row
    │   ├── GestureDetector [+] (attach file)
    │   ├── Spacer
    │   └── Container [↑] (send button)
    └── Row
        ├── GestureDetector (model selector)
        │   ├── Text ("Build")
        │   └── Icon (chevron down)
        ├── Icon (user)
        └── GestureDetector (provider selector)
            ├── Text ("Big Pickle")
            └── Icon (chevron down)
```

### Референс OpenCode (prompt-input)
Более сложная структура:
- `prompt-input.tsx` — основной контейнер
- `attachments.tsx` — прикрепленные файлы
- `context-chips.tsx` — контекст чипы
- `slash-popover.tsx` — slash commands
- `submit.tsx` — логика отправки
- Drag overlay для файлов
- Markdown превью
- Auto-resize textarea

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Empty | ✅ | ✅ | Placeholder текст |
| With text | ✅ | ✅ | Введенный текст (TextEditingController) |
| With attachments | ❌ | ✅ | Chips файлов |
| With context | ❌ | ✅ | Context chips |
| Focused | ✅ | ✅ | Focus ring (FocusNode) |
| Sending | ✅ | ✅ | Loading state |
| Disabled | ❌ | ✅ | Disabled UI |
| Slash command open | ❌ | ✅ | Popover с командами |
| Drag over | ❌ | ✅ | Drop zone highlight |
| Model dropdown open | ❌ | ✅ | Model selector |
| Provider dropdown open | ❌ | ✅ | Provider selector |

---

## 4. Пропсы/параметры

### Flutter (PromptComposer / _PromptComposer)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `placeholder` | String | Placeholder текст |
| `onSend` | OnSendMessage | Колбэк отправки сообщения |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `selectedModel` | String | Выбранная модель |
| `selectedProvider` | String | Выбранный провайдер |
| `openDialog(AppDialog)` | void | Открыть диалог |

### Референс OpenCode (prompt-input)
| Параметр/хук | Тип | Описание |
|--------------|-----|----------|
| `usePrompt()` | context | Prompt state (text, parts, context) |
| `useSettings()` | context | Model/provider settings |
| `useSDK()` | context | API calls |
| `attachments` | store | Attached files |
| `onSubmit` | callback | Submit handler |

---

## 5. Стили/токены

### Flutter
```dart
// Container
height: 184 (Home) / 182 (Session)
padding: EdgeInsets.fromLTRB(18, 16, 18, 12)
background: Color(0xFFFBFAF7)
borderRadius: 18
border: Color(0xFFD8D6D0) / Color(0xFFD9D6D0)

// Placeholder text
fontSize: 14/15
color: Color(0xFFA0A09A) / Color(0xFFA3A19B)

// Add button [+]
icon size: 17
icon color: Color(0xFF94918B) / Color(0xFF95928C)

// Send button [↑]
size: 44x44
background: Color(0xFFB6B3AE) / Color(0xFFB8B5AF)
borderRadius: 10
icon size: 18
icon color: Colors.white

// Model/Provider text
fontSize: 14
color: Color(0xFF66645F) / Color(0xFF686662)

// Chevron icon
size: 10
color: Color(0xFF8D8A85) / Color(0xFF8F8C87)

// User icon
size: 14
color: Color(0xFF97948F) / Color(0xFF97948E)
```

### Референс OpenCode
```css
/* Container */
min-h-[120px]
rounded-2xl
bg-surface-base
border border-border-base
p-3

/* Textarea */
min-h-[80px]
resize-none
bg-transparent
text-14-regular

/* Attachments area */
flex flex-wrap gap-2
mb-2

/* Bottom bar */
flex items-center justify-between
gap-2
pt-2

/* Send button */
w-8 h-8
rounded-lg
bg-surface-interactive
hover:bg-surface-interactive-hover

/* Model selector */
h-7
px-2
rounded-md
bg-surface-subtle
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Type text | ✅ TextEditingController | ✅ Controlled input |
| Paste text | ❌ | ✅ |
| Paste file | ❌ | ✅ Auto-attach |
| Drop file | ❌ | ✅ Drag-drop |
| Click [+] | ✅ openDialog(selectFile) | ✅ File picker |
| Click send | ✅ openDialog(commandPalette) | ✅ Submit |
| Click model | ✅ openDialog(selectModel) | ✅ Model dropdown |
| Click provider | ✅ openDialog(selectProvider) | ✅ Provider dropdown |
| Slash command | ❌ | ✅ Popover |
| @ mention | ❌ | ✅ File mention |
| Remove attachment | ❌ | ✅ Chip X button |
| Auto-resize | ❌ | ✅ |
| Enter to send | ✅ | ✅ Mod+Enter |

### Хоткеи (Flutter)
| Keybind | Действие |
|---------|----------|
| `Cmd/Ctrl+Enter` | Отправить сообщение |
| `Enter` | Отправить сообщение |
| `Shift+Enter` | Перевод строки |

### Хоткеи (OpenCode)
| Keybind | Действие |
|---------|----------|
| `Mod+Enter` | Send message |
| `Escape` | Clear/cancel |
| `/` | Slash commands |
| `@` | Mention file |

---

## 7. Маршрутизация

Prompt Composer не навигирует напрямую, но:
- На Home: отправка создает сессию → `/session/:id`
- На Session: отправка добавляет сообщение

---

## 8. Интеграция с диалогами

- `AppDialog.selectFile` — выбор файла для attachment
- `AppDialog.selectModel` — выбор AI модели
- `AppDialog.selectProvider` — выбор провайдера
- `AppDialog.commandPalette` — command palette (при клике send)

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Базовый layout с placeholder
- Кнопка attach [+]
- Кнопка send [↑]
- Model selector (открывает диалог)
- Provider selector (открывает диалог)

### ❌ Не реализовано
- Реальный text input
- Attachments chips
- Context chips
- Drag-drop файлов
- Paste файлов
- Slash commands
- @ mentions
- Auto-resize
- Focus states
- Send логика (создание сессии/сообщения)
- Keyboard shortcuts
- Loading state
- Markdown preview

---

## 10. TODO/гап-анализ

### Critical
- [ ] Реализовать TextField с реальным вводом
- [ ] Логика отправки (создание сессии, отправка сообщения)

### High Priority
- [ ] Attachments chips (прикрепленные файлы)
- [ ] Keyboard shortcuts (Mod+Enter)
- [ ] Auto-resize textarea

### Medium Priority
- [ ] Drag-drop файлов
- [ ] Paste файлов
- [ ] Context chips
- [ ] Loading state

### Low Priority
- [ ] Slash commands popover
- [ ] @ mentions
- [ ] Markdown preview
