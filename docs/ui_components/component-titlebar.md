# Title Bar

## 1. Назначение и контекст

Title Bar — верхняя панель окна приложения, содержащая:
- Traffic lights (macOS) / Window controls (Windows/Linux)
- Кнопку переключения sidebar
- Навигацию назад/вперед
- Строку поиска / Command palette trigger
- Кнопки быстрых действий (сервер, терминал, добавить, context panel)

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/shell/desktop_shell.dart`](../../apps/codelab_desktop/lib/app/shell/desktop_shell.dart) — виджет `_TitleBar`

**Референс OpenCode:** [`reference/opencode/packages/app/src/components/titlebar.tsx`](../../reference/opencode/packages/app/src/components/titlebar.tsx)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ [Traffic Lights] [Sidebar] [◀] [▶] │ [Search: ⌘K] │ [Server][Term][+][Panel]│
└─────────────────────────────────────────────────────────────────────────────┘
```

### Flutter реализация (_TitleBar)
- `_TrafficLights` — имитация macOS кнопок (red/yellow/green dots)
- `_TitleIconButton` — кнопка sidebar toggle
- Chevron left/right — навигация (статичная иконка)
- Центральная область — search box с `⌘K`
- `_HeaderBadge` — кнопки справа (server, terminal, add, context panel)

### Референс OpenCode (Titlebar)
- Адаптивный layout под macOS/Windows/Web
- Интеграция с Tauri для drag/maximize
- Полноценная back/forward навигация с историей
- Слоты: `#opencode-titlebar-left`, `#opencode-titlebar-center`, `#opencode-titlebar-right`
- Кнопка создания новой сессии

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Default | ✅ | ✅ | Базовый вид |
| Sidebar opened | ✅ | ✅ | Sidebar развернут — иконка меняется |
| Sidebar closed | ✅ | ✅ | Sidebar свернут |
| Has history back | ❌ | ✅ | Кнопка назад активна |
| Has history forward | ❌ | ✅ | Кнопка вперед активна |
| Creating session | ❌ | ✅ | Активный индикатор создания сессии |
| macOS mode | ✅ (частично) | ✅ | Traffic lights слева |
| Windows mode | ❌ | ✅ | Controls справа, другой layout |
| Web mode | ❌ | ✅ | Без window controls |

---

## 4. Пропсы/параметры

### Flutter (_TitleBar)
| Параметр | Тип | Описание |
|----------|-----|----------|
| — | — | Без пропсов, использует `CodeLabAppScope.of(context)` |

### Зависимости от контроллера (CodeLabAppController)
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `sidebarCollapsed` | bool | Состояние sidebar |
| `toggleSidebarCollapsed()` | void | Переключить sidebar |
| `bottomPanelVisible` | bool | Видимость нижней панели |
| `toggleBottomPanel()` | void | Переключить нижнюю панель |
| `contextPanelVisible` | bool | Видимость правой панели |
| `toggleContextPanel()` | void | Переключить правую панель |
| `openDialog(AppDialog)` | void | Открыть диалог |

### Референс OpenCode (Titlebar)
| Параметр/хук | Тип | Описание |
|--------------|-----|----------|
| `useLayout()` | context | Sidebar, mobile sidebar, projects |
| `usePlatform()` | context | Platform info (desktop/web, os) |
| `useCommand()` | context | Command palette и keybinds |
| `useLanguage()` | context | i18n |
| `useSettings()` | context | Настройки навигации |
| `useNavigate()` | router | Навигация |
| `history` | store | Back/forward stack |

---

## 5. Стили/токены

### Flutter
```dart
// Container
height: 58
padding: EdgeInsets.symmetric(horizontal: 14)
color: Color(0xFFF4F3F0)
border: Border(bottom: BorderSide(color: Color(0xFFE2E0DB)))

// Traffic lights
dot size: 14x14
colors: #FF5F57 (red), #FEBC2E (yellow), #28C840 (green)
spacing: 8

// Title icon button
size: 30x30
background: Color(0xFFE6E4E0)
borderRadius: 8
icon size: 14
icon color: Color(0xFF5F5C56)

// Header badge (right buttons)
size: 30x30
background: Color(0xFFEDEBE7)
borderRadius: 8
icon size: 14
icon color: Color(0xFF64615C)

// Search box
width: 360
height: 32
background: Color(0xFFF8F7F4)
borderRadius: 10
border: Color(0xFFDAD8D2)
text: fontSize 13, color Color(0xFF8F8D88)
shortcut text: fontSize 12, color Color(0xFFB1AFA9)
```

### Референс OpenCode
```css
header.h-10 /* height: 40px */
bg-background-base
grid-cols-[minmax(0,1fr)_auto_minmax(0,1fr)]

/* macOS traffic lights spacer */
width: 72px / zoom

/* Icon buttons */
.titlebar-icon
w-8 h-6 or w-6 h-6
rounded-md

/* Channel badge (beta/dev) */
bg-icon-interactive-base
text-[#FFF]
font-mono uppercase
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Sidebar toggle | ✅ `toggleSidebarCollapsed()` | ✅ `layout.sidebar.toggle()` |
| Back navigation | ❌ Статичная иконка | ✅ `back()` с историей |
| Forward navigation | ❌ Статичная иконка | ✅ `forward()` с историей |
| Search/Command palette | ✅ `openDialog(commandPalette)` | ✅ Command palette |
| Server dialog | ✅ `openDialog(selectServer)` | ✅ Server status dialog |
| Terminal toggle | ✅ `toggleBottomPanel()` | ✅ Terminal panel toggle |
| Add project | ✅ `openDialog(selectDirectory)` | ✅ Directory picker |
| Context panel toggle | ✅ `toggleContextPanel()` | ✅ `layout.fileTree.toggle()` |
| Window drag (macOS) | ❌ | ✅ Tauri `startDragging()` |
| Window maximize (dblclick) | ❌ | ✅ Tauri `toggleMaximize()` |
| New session | ❌ | ✅ Navigate to session create |

### Хоткеи (OpenCode)
| Keybind | Действие |
|---------|----------|
| `mod+[` | Go back |
| `mod+]` | Go forward |
| `mod+K` | Command palette |
| — | Sidebar toggle (custom) |

---

## 7. Маршрутизация

- Компонент используется в: `DesktopShell` (все экраны)
- Навигация: Home `/`, Session `/session/:sessionId`

---

## 8. Интеграция с диалогами

Открываемые диалоги через Title Bar:
- `AppDialog.commandPalette` — Command palette
- `AppDialog.selectServer` — Выбор сервера
- `AppDialog.selectDirectory` — Выбор директории

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Базовый layout с Traffic lights
- Sidebar toggle
- Search box placeholder
- Кнопки действий справа
- Bottom panel toggle
- Context panel toggle

### ⚠️ Частично
- Навигация back/forward (иконки есть, логика нет)

### ❌ Не реализовано
- Back/forward navigation с историей
- Адаптация под Windows/Linux/Web
- Window drag/maximize (Tauri интеграция)
- Кнопка создания новой сессии
- Channel badge (beta/dev)
- Zoom scaling для macOS
- Mobile sidebar toggle
- Полноценные tooltips с keybinds

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Реализовать back/forward навигацию с историей (нужен отдельный контроллер истории)
- [ ] Добавить кнопку "New Session" (условно показывать когда есть активный проект)

### Medium Priority
- [ ] Адаптировать под разные платформы (macOS/Windows/Linux)
- [ ] Добавить window drag region для desktop
- [ ] Tooltips с keybinds на все кнопки

### Low Priority
- [ ] Channel badge для beta/dev builds
- [ ] Mobile sidebar toggle
- [ ] Zoom scaling
