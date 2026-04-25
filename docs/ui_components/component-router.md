# Router

## 1. Назначение и контекст

Router — маршрутизация приложения на базе go_router:
- Home route `/`
- Session route `/session/:sessionId`
- Reactive refresh при изменении состояния

**Расположение в Flutter:** [`apps/codelab_desktop/lib/app/navigation/router.dart`](../../apps/codelab_desktop/lib/app/navigation/router.dart)

**Референс OpenCode:** [`reference/opencode/packages/app/src/app.tsx`](../../reference/opencode/packages/app/src/app.tsx) + @solidjs/router

---

## 2. Структура маршрутов

### Flutter реализация
```dart
GoRouter buildRouter(CodeLabAppController controller) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: controller,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/session/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'] ?? '';
          return SessionScreen(sessionId: sessionId);
        },
      ),
    ],
  );
}
```

### Референс OpenCode
```tsx
// app.tsx routes structure
<Router>
  <Route path="/" component={Home} />
  <Route path="/:dir" component={DirectoryLayout}>
    <Route path="/" component={ProjectHome} />
    <Route path="/session" component={NewSession} />
    <Route path="/session/:id" component={Session} />
  </Route>
</Router>
```

---

## 3. Сравнение маршрутов

| Route | Flutter | OpenCode | Описание |
|-------|---------|----------|----------|
| Home | `/` | `/` | Главная страница |
| Project Home | — | `/:dir` | Домашняя проекта |
| New Session | — | `/:dir/session` | Создание сессии |
| Session | `/session/:sessionId` | `/:dir/session/:id` | Экран сессии |

### Различия
- **Flutter**: Упрощенная структура без nested routes
- **OpenCode**: Вложенная структура с директорией проекта в URL

---

## 4. Пропсы/параметры

### Flutter (buildRouter)
| Параметр | Тип | Описание |
|----------|-----|----------|
| `controller` | CodeLabAppController | Контроллер для refresh |

### GoRouter configuration
| Параметр | Значение | Описание |
|----------|----------|----------|
| `initialLocation` | `/` | Начальный маршрут |
| `refreshListenable` | controller | ChangeNotifier для rebuild |

### Path Parameters
| Route | Parameter | Описание |
|-------|-----------|----------|
| `/session/:sessionId` | `sessionId` | ID сессии |

---

## 5. Навигация в приложении

### Переходы из разных мест

#### Project Rail (_RailProjectButton)
```dart
onTap: () {
  controller.selectProject(project.id);
  final sessionId = controller.selectedSessionId;
  if (sessionId == null) {
    context.go('/');
  } else {
    context.go('/session/$sessionId');
  }
}
```

#### Sidebar Session List
```dart
onTap: () => context.go('/session/${session.id}')
```

#### Session Creation (после отправки prompt)
```dart
// TODO: При создании сессии
context.go('/session/$newSessionId');
```

---

## 6. Состояния/варианты

| Состояние | Flutter | OpenCode | Описание |
|-----------|---------|----------|----------|
| Initial load | ✅ | ✅ | Загрузка на `/` |
| Navigate to session | ✅ | ✅ | Переход к сессии |
| Navigate back home | ✅ | ✅ | Возврат на home |
| Deep link | ❌ | ✅ | Прямая ссылка на сессию |
| Back/forward history | ✅ | ✅ | История через HistoryController |
| Redirect on error | ❌ | ✅ | Редирект при ошибке |

---

## 7. Интеграция с контроллером

```dart
class CodeLabAppController extends ChangeNotifier {
  // При изменении проекта/сессии вызывается notifyListeners()
  // GoRouter с refreshListenable автоматически перестраивает UI
  
  void selectProject(String projectId) {
    _selectedProjectId = projectId;
    _selectedSessionId = project.sessions.first.id;
    notifyListeners(); // Triggers router refresh
  }
  
  void selectSession(String sessionId) {
    _selectedSessionId = sessionId;
    notifyListeners(); // Triggers router refresh
  }
}
```

---

## 8. Паритет с reference/opencode

### ✅ Реализовано
- Home route
- Session route с параметром
- Reactive refresh
- Базовая навигация
- Back/forward история (HistoryController)

### HistoryController API
```dart
class HistoryController {
  bool get canBack;      // Можно ли вернуться назад
  bool get canForward;   // Можно ли перейти вперёд
  void back();           // Переход назад
  void forward();        // Переход вперёд
  Listenable get refreshListenable; // Для GoRouter refresh
}
```

### ❌ Не реализовано
- Nested routes (project in URL)
- New session route
- Deep linking
- Redirect guards
- Loading states во время навигации
- Error boundaries

---

## 9. TODO/гап-анализ

### High Priority
- [ ] New session route (`/session/new` или модальное создание)
- [x] Back/forward navigation с историей (HistoryController)

### Medium Priority
- [ ] Deep linking support
- [ ] Error boundaries
- [ ] Loading states

### Low Priority
- [ ] Nested routes с проектом в URL
- [ ] Redirect guards

---

## 10. Рекомендуемые улучшения

### Добавить route для новой сессии
```dart
GoRoute(
  path: '/session/new',
  builder: (context, state) => const NewSessionScreen(),
),
```

### Добавить redirect при несуществующей сессии
```dart
GoRoute(
  path: '/session/:sessionId',
  redirect: (context, state) {
    final sessionId = state.pathParameters['sessionId'];
    final controller = CodeLabAppScope.of(context);
    if (!controller.hasSession(sessionId)) {
      return '/';
    }
    return null;
  },
  builder: (context, state) {
    final sessionId = state.pathParameters['sessionId'] ?? '';
    return SessionScreen(sessionId: sessionId);
  },
),
```

### Добавить проект в URL (как в OpenCode)
```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? '';
        return ProjectHomeScreen(projectId: projectId);
      },
      routes: [
        GoRoute(
          path: 'session',
          builder: (context, state) => const NewSessionScreen(),
        ),
        GoRoute(
          path: 'session/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId'] ?? '';
            return SessionScreen(sessionId: sessionId);
          },
        ),
      ],
    ),
  ],
);
```
