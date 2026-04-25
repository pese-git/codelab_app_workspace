# Dialogs

## 1. Назначение и контекст

Dialogs — модальные окна для различных действий:
- Select File — выбор файла для attachment
- Select Directory — выбор директории/проекта
- Select Model — выбор AI модели
- Select Provider — выбор провайдера
- Select MCP — выбор MCP
- Select Server — выбор сервера
- Settings — настройки приложения
- Help — справка
- Edit Project — редактирование проекта
- Fork Session — форк сессии
- Command Palette — палитра команд

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/dialogs/dialog_host.dart`](../../apps/codelab_desktop/lib/app/dialogs/dialog_host.dart)

**Референс OpenCode:** [`reference/opencode/packages/app/src/components/dialog-*.tsx`](../../reference/opencode/packages/app/src/components/)

---

## 2. Состав и layout

### DialogHost (Flutter)
```dart
Stack
├── child (main content)
└── if (activeDialog != null):
    └── GestureDetector (backdrop)
        └── _DialogOverlay(activeDialog)
```

### _DialogOverlay (Flutter)
```dart
Center
└── Container (dialog box)
    └── Column
        ├── Text (title)
        ├── Search box (if applicable)
        └── ListView (options)
```

### Референс OpenCode
Отдельные компоненты для каждого типа диалога:
- `dialog-select-directory.tsx`
- `dialog-select-server.tsx`
- И др.

---

## 3. Типы диалогов

| Диалог | Flutter enum | Описание |
|--------|--------------|----------|
| Select File | `AppDialog.selectFile` | Выбор файла |
| Select Directory | `AppDialog.selectDirectory` | Выбор директории |
| Select Model | `AppDialog.selectModel` | Выбор AI модели |
| Select Provider | `AppDialog.selectProvider` | Выбор провайдера |
| Select MCP | `AppDialog.selectMcp` | Выбор MCP |
| Select Server | `AppDialog.selectServer` | Выбор сервера |
| Settings | `AppDialog.settings` | Настройки |
| Help | `AppDialog.help` | Справка |
| Edit Project | `AppDialog.editProject` | Редактирование проекта |
| Fork Session | `AppDialog.forkSession` | Форк сессии |
| Command Palette | `AppDialog.commandPalette` | Палитра команд |

---

## 4. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| No dialog | ✅ | ✅ | Нет активного диалога |
| Dialog open | ✅ | ✅ | Диалог отображается |
| Search active | ✅ | ✅ | Фильтрация по поиску |
| Item selected | ✅ | ✅ | Выбран элемент |
| Loading | ❌ | ✅ | Загрузка данных |
| Error | ❌ | ✅ | Ошибка |

---

## 5. Пропсы/параметры

### Flutter (DialogHost)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `child` | Widget | Контент под диалогом |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `activeDialog` | AppDialog? | Активный диалог |
| `closeDialog()` | void | Закрыть диалог |
| `models` | List<String> | Список моделей |
| `providers` | List<String> | Список провайдеров |
| `mcps` | List<String> | Список MCP |
| `servers` | List<String> | Список серверов |
| `chooseModel(value)` | void | Выбрать модель |
| `chooseProvider(value)` | void | Выбрать провайдера |
| `chooseMcp(value)` | void | Выбрать MCP |
| `chooseServer(value)` | void | Выбрать сервер |

### AppDialog enum
```dart
enum AppDialog {
  settings,
  selectDirectory,
  selectFile,
  selectModel,
  selectProvider,
  selectMcp,
  selectServer,
  editProject,
  forkSession,
  help,
  commandPalette,
}
```

---

## 6. Стили/токены

### Flutter
```dart
// Backdrop
color: Colors.black.withAlpha(100)

// Dialog container
width: 400
height: 460 (или auto)
padding: EdgeInsets.all(18)
background: Colors.white
borderRadius: 18
boxShadow: blur 18, offset (0, 6), color black.withAlpha(40)

// Title
fontSize: 16
fontWeight: FontWeight.w600
color: Color(0xFF2E2D29)

// Search box
height: 38
margin: EdgeInsets.symmetric(vertical: 12)
padding: EdgeInsets.symmetric(horizontal: 12)
background: Color(0xFFF5F4F1)
borderRadius: 10
border: Color(0xFFE1DED8)

// Option row
padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)
borderRadius: 10
hover: background Color(0xFFF7F6F3)
selected: background Color(0xFFF0EFEB)
text: fontSize 14, color Color(0xFF3D3D39)

// Selected indicator (checkmark)
size: 18
color: Color(0xFF2D2C28)
```

### Референс OpenCode
```css
/* Dialog overlay */
fixed inset-0
bg-black/50
flex items-center justify-center

/* Dialog container */
w-[480px]
max-h-[80vh]
rounded-2xl
bg-surface-base
shadow-xl
p-4

/* Search input */
h-10
rounded-lg
bg-surface-subtle

/* Option item */
h-9
px-3
rounded-md
hover:bg-surface-subtle
```

---

## 7. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Open dialog | ✅ openDialog(type) | ✅ dialog.show() |
| Close dialog (backdrop) | ✅ closeDialog() | ✅ onDismiss |
| Close dialog (escape) | ❌ | ✅ Keyboard |
| Search/filter | ✅ (базовый) | ✅ |
| Select option | ✅ | ✅ |
| Keyboard navigation | ❌ | ✅ Arrow keys |
| Confirm (Enter) | ❌ | ✅ |

### Хоткеи (OpenCode)
| Keybind | Действие |
|---------|----------|
| `Escape` | Close dialog |
| `Enter` | Select current |
| `↑/↓` | Navigate options |
| `Mod+K` | Open command palette |

---

## 8. Маршрутизация

Dialogs не влияют на роутинг напрямую, но:
- Select Directory может добавить проект и перейти к нему
- Fork Session создает новую сессию

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- DialogHost с backdrop
- Все типы диалогов (enum)
- Select Model/Provider/MCP/Server
- Search в диалогах
- Option selection

### ⚠️ Частично
- Settings (базовый UI)
- Command Palette (базовый UI)

### ❌ Не реализовано
- Keyboard navigation (arrows)
- Escape to close
- Enter to confirm
- Loading states
- Error states
- File picker integration
- Directory picker integration
- Полноценные Settings
- Полноценный Command Palette

---

## 10. TODO/гап-анализ

### Critical
- [ ] Keyboard navigation (arrows, escape, enter)
- [ ] File picker integration (native или custom)
- [ ] Directory picker integration

### High Priority
- [ ] Полноценный Settings dialog
- [ ] Полноценный Command Palette
- [ ] Loading states

### Medium Priority
- [ ] Error states
- [ ] Animations (fade in/out)

### Low Priority
- [ ] Help dialog content
- [ ] Release notes dialog

---

## Примеры реализации диалогов

### Select Model Dialog
```dart
_DialogOverlay(
  title: 'Select Model',
  searchPlaceholder: 'Search models...',
  options: controller.models,
  selected: controller.selectedModel,
  onSelect: (value) {
    controller.chooseModel(value);
    controller.closeDialog();
  },
)
```

### Command Palette (TODO)
Должен содержать:
- Поиск по командам
- Категории команд
- Keybind hints
- Recent commands
