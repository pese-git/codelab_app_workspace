# Home Screen

## 1. Назначение и контекст

Home Screen — главный экран приложения при отсутствии активной сессии:
- Логотип/брендинг
- Путь к текущему проекту
- Информация о ветке и последнем изменении
- Prompt Composer для быстрого старта сессии

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/screens/home_screen.dart`](../../apps/codelab_desktop/lib/app/screens/home_screen.dart)

**Референс OpenCode:** [`reference/opencode/packages/app/src/pages/home.tsx`](../../reference/opencode/packages/app/src/pages/home.tsx)

---

## 2. Состав и layout

```
┌─────────────────────────────────────────────┐
│                                             │
│              ┌────┐                         │
│              │ □□ │  ← Logo                 │
│              └────┘                         │
│                                             │
│        Создавайте что угодно               │
│                                             │
│   /Users/.../project_name                   │
│                                             │
│   🔀 Основная ветка (master)               │
│                                             │
│   Последнее изменение 45 минут назад       │
│                                             │
├─────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────┐ │
│ │ Спросите что угодно...                  │ │
│ │                                         │ │
│ │ [+]                              [↑]    │ │
│ │ Build ▼    👤 Big Pickle ▼             │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

### Flutter реализация (HomeScreen)
```dart
DesktopShell(isHome: true)
└── Column
    ├── Expanded
    │   └── Center
    │       └── Column
    │           ├── Container (logo box)
    │           ├── Text ("Создавайте что угодно")
    │           ├── Text (project path)
    │           ├── Row (branch icon + text)
    │           └── Row (last modified text)
    └── Padding
        └── _PromptComposer
```

### Референс OpenCode (Home)
```tsx
<div class="mx-auto mt-55 w-full md:w-auto px-4">
  <Logo />
  <Button (server status)>
    <ServerDot />
    {server.name}
  </Button>
  <Switch>
    <Match when={projects.length > 0}>
      <RecentProjects />
    </Match>
    <Match when={!sync.ready}>
      <Loading />
    </Match>
    <Match when={true}>
      <EmptyState />
    </Match>
  </Switch>
</div>
```

---

## 3. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| With project | ✅ | ✅ | Показывает путь проекта |
| No projects | ❌ | ✅ | Empty state с кнопкой |
| Recent projects | ❌ | ✅ | Список недавних проектов |
| Loading | ❌ | ✅ | Загрузка данных |
| Server healthy | ❌ | ✅ | Зеленый индикатор |
| Server unhealthy | ❌ | ✅ | Красный индикатор |
| Server unknown | ❌ | ✅ | Серый индикатор |

---

## 4. Пропсы/параметры

### Flutter (HomeScreen)
| Параметр | Тип | Описание |
|----------|-----|----------|
| — | — | Без пропсов |

### Зависимости от контроллера
| Поле/метод | Тип | Описание |
|------------|-----|----------|
| `selectedProject` | ProjectModel | Текущий проект |
| `openDialog(AppDialog)` | void | Открыть диалог |

### Референс OpenCode (Home)
| Хук | Тип | Описание |
|-----|-----|----------|
| `useGlobalSync()` | context | Sync state, projects |
| `useLayout()` | context | Projects management |
| `usePlatform()` | context | Platform features |
| `useDialog()` | context | Dialog controller |
| `useServer()` | context | Server status |
| `useLanguage()` | context | i18n |

---

## 5. Стили/токены

### Flutter
```dart
// Logo box
width: 68
height: 68
border: 8px solid Color(0xFF2A2420)

// Title text
fontSize: 28
fontWeight: FontWeight.w700
color: Color(0xFF252522)

// Path text
fontSize: 16
color: Color(0xFF94928D)

// Branch text
icon size: 14
icon color: Color(0xFFA2A09B)
text: fontSize 14, color Color(0xFF9A9892)

// Last modified
fontSize: 16
color: Color(0xFF9D9B96)
bold part: color Color(0xFF2D2D29), fontWeight w700

// Prompt composer container
height: 184
padding: EdgeInsets.fromLTRB(18, 16, 18, 12)
background: Color(0xFFFBFAF7)
borderRadius: 18
border: Color(0xFFD8D6D0)
```

### Референс OpenCode
```css
/* Container */
mx-auto
mt-55
w-full md:w-auto
px-4

/* Logo */
md:w-xl
opacity-12

/* Server button */
mt-4 mx-auto
text-14-regular
text-text-weak

/* Server dot */
size-2
rounded-full
bg-icon-success-base | bg-icon-critical-base | bg-border-weak-base

/* Recent projects */
mt-20
flex flex-col gap-4

/* Project item */
text-14-mono
justify-between px-3

/* Empty state */
mt-30
flex flex-col items-center gap-3
```

---

## 6. Взаимодействия

| Действие | Flutter | OpenCode |
|----------|---------|----------|
| Open project picker | ❌ | ✅ chooseProject() |
| Open recent project | ❌ | ✅ openProject(dir) |
| Server status click | ❌ | ✅ DialogSelectServer |
| Send prompt | ✅ via Composer | ✅ |
| Select model | ✅ openDialog(selectModel) | ✅ |
| Select provider | ✅ openDialog(selectProvider) | ✅ |
| Attach file | ✅ openDialog(selectFile) | ✅ |

---

## 7. Маршрутизация

- Route: `/`
- После отправки prompt создается сессия → `/session/:sessionId`

---

## 8. Интеграция с диалогами

Через Prompt Composer:
- `AppDialog.selectFile` — прикрепить файл
- `AppDialog.selectModel` — выбор модели
- `AppDialog.selectProvider` — выбор провайдера
- `AppDialog.commandPalette` — command palette

---

## 9. Паритет с reference/opencode

### ✅ Реализовано
- Базовый layout с логотипом и текстами
- Путь к проекту
- Branch информация (статичная)
- Last modified информация (статичная)
- Prompt Composer

### ⚠️ Частично
- Logo (простой квадрат вместо SVG)

### ❌ Не реализовано
- Recent projects list
- Empty state (no projects)
- Open project picker
- Server status indicator
- Loading state
- Dynamic branch/git info
- Dynamic last modified time

---

## 10. TODO/гап-анализ

### High Priority
- [ ] Recent projects список
- [ ] Empty state когда нет проектов
- [ ] Open project picker button

### Medium Priority
- [ ] Server status indicator
- [ ] Dynamic git branch info
- [ ] Dynamic last modified time

### Low Priority
- [ ] SVG logo
- [ ] Loading skeleton
- [ ] i18n текстов

---

## Внутренние компоненты

### _PromptComposer
Компонент ввода промпта. См. [component-prompt-composer.md](./component-prompt-composer.md)
