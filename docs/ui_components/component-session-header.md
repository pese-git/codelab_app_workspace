# Session Header

## 1. Назначение и контекст

Session Header — верхняя панель экрана сессии:
- Заголовок сессии
- Селекторы модели и провайдера
- Кнопки действий (sync/fork, more)

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/screens/session_screen.dart`](../../apps/codelab_desktop/lib/app/screens/session_screen.dart) — `_ConversationHeader`

**Референс OpenCode:** [`reference/opencode/packages/app/src/components/session/session-header.tsx`](../../reference/opencode/packages/app/src/components/session/session-header.tsx)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Session Title                    [Model ▼] [Provider ▼]  [🔄] [⋮]      │
└─────────────────────────────────────────────────────────────────────────┘
```

### Flutter реализация (_ConversationHeader)
```dart
Container (height: 64)
└── Row
    ├── Expanded
    │   └── Text (session.title)
    ├── GestureDetector (model badge)
    │   └── Container
    │       └── Text (selectedModel)
    ├── GestureDetector (provider badge)
    │   └── Container
    │       └── Text (selectedProvider)
    ├── GestureDetector (sync icon)
    └── GestureDetector (more icon)
```

### Референс OpenCode (SessionHeader)
- Более детальная структура
- Branch selector
- Cost display
- Token count
- Edit title inline
- Keyboard shortcuts

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Default | ✅ | ✅ | Базовый вид |
| Editing title | ❌ | ✅ | Inline редактирование |
| Model dropdown | ✅ (диалог) | ✅ | Выбор модели |
| Provider dropdown | ✅ (диалог) | ✅ | Выбор провайдера |
| Syncing | ❌ | ✅ | Индикатор синхронизации |
| Has cost | ❌ | ✅ | Отображение стоимости |

---

## 4. Пропсы/параметры

### Flutter (_ConversationHeader)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | SessionModel | Модель сессии |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `selectedModel` | String | Выбранная модель |
| `selectedProvider` | String | Выбранный провайдер |
| `openDialog(AppDialog)` | void | Открыть диалог |

### Референс OpenCode (SessionHeader)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `session` | Session | Сессия |
| `title` | string | Заголовок |
| `model` | Model | Модель |
| `provider` | Provider | Провайдер |
| `cost` | number | Стоимость |
| `tokens` | number | Токены |

---

## 5. Стили/токены

### Flutter
```dart
// Container
height: 64
padding: EdgeInsets.symmetric(horizontal: 22)
background: Colors.white
border: Border(bottom: BorderSide(color: Color(0xFFE5E2DC)))

// Title text
fontSize: 18
fontWeight: FontWeight.w600
color: Color(0xFF252522)

// Model/Provider badge
padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
background: Color(0xFFF4F2EE)
borderRadius: 10
text: fontSize 13, color Color(0xFF5F5C57)

// Sync icon
size: 16
color: Color(0xFFD3D0CA)

// More icon
size: 16
color: Color(0xFF8E8C86)
```

### Референс OpenCode
```css
/* Header container */
h-12
px-4
flex items-center gap-3
border-b border-border-base

/* Title */
text-14-medium
truncate

/* Badges */
h-7
px-2
rounded-md
bg-surface-subtle
text-12-regular

/* Action buttons */
w-7 h-7
rounded-md
hover:bg-surface-subtle
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Edit title | ❌ | ✅ Click to edit |
| Select model | ✅ openDialog(selectModel) | ✅ Dropdown |
| Select provider | ✅ openDialog(selectProvider) | ✅ Dropdown |
| Sync/Fork | ✅ openDialog(forkSession) | ✅ Fork session |
| More actions | ✅ openDialog(commandPalette) | ✅ Dropdown menu |
| Copy session ID | ❌ | ✅ Via more menu |
| Delete session | ❌ | ✅ Via more menu |
| Export session | ❌ | ✅ Via more menu |

---

## 7. Маршрутизация

Session Header не навигирует напрямую.

---

## 8. Интеграция с диалогами

- `AppDialog.selectModel` — выбор модели
- `AppDialog.selectProvider` — выбор провайдера
- `AppDialog.forkSession` — форк сессии
- `AppDialog.commandPalette` — действия (more)

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Session title
- Model badge
- Provider badge
- Sync/fork button
- More button

### ❌ Не реализовано
- Inline title editing
- Cost display
- Token count
- Branch selector
- More dropdown menu
- Delete/export actions

---

## 10. TODO/гап-анализ

### High Priority
- [ ] More dropdown menu (delete, export, copy ID)
- [ ] Hover эффекты на кнопках

### Medium Priority
- [ ] Inline title editing
- [ ] Cost/token display

### Low Priority
- [ ] Branch selector
