# Flutter ACP Client — План реализации

## Обзор

Реализация Flutter-клиента для протокола **Agent Client Protocol (ACP)** на основе JSON-RPC 2.0.
Клиент обеспечивает двустороннюю коммуникацию с AI-агентом через WebSocket: управление сессиями, потоковую передачу сообщений, обработку разрешений и исполнение инструментов (файловая система, терминал).

## Целевой модуль

**Вся реализация ведётся внутри существующего модуля `apps/codelab_desktop`.**
Никакой новый Flutter-проект НЕ создаётся. Все файлы, зависимости и изменения применяются к `apps/codelab_desktop`.

| Параметр | Значение |
|---|---|
| Базовый модуль | `apps/codelab_desktop` |
| Рабочая директория | `apps/codelab_desktop/lib/` |
| Pubspec | `apps/codelab_desktop/pubspec.yaml` |
| Entry point | `apps/codelab_desktop/lib/main.dart` |
| Роутер | `apps/codelab_desktop/lib/app/navigation/router.dart` |
| Bootstrap | `apps/codelab_desktop/lib/app/app.dart` (`CodeLabAppBootstrap`) |

## Существующие ресурсы проекта

| Пакет | Путь | Содержимое |
|---|---|---|
| `codelab_ui_components` | `packages/codelab_ui_components` | Библиотека UI-компонентов на `fluent_ui`: атомы, молекулы, организмы (`MessageBubble`, `PromptComposer`, `DesktopShell`, `AppButton` и др.) |
| `codelab_desktop` | `apps/codelab_desktop` | Готовое Flutter-приложение с `HomeScreen`, `SessionScreen`, `DialogHost`, роутером и app-state |

**Правило:** при реализации Фазы 7 — использовать компоненты из `codelab_ui_components`, а не создавать аналогичные кастомные виджеты. Создавать новый виджет только если нужного компонента в библиотеке нет.

---

## Архитектурные решения

| Аспект | Решение | Обоснование |
|---|---|---|
| Архитектура | Clean Architecture | Изоляция слоёв, тестируемость |
| State Management | flutter_bloc | Предсказуемость, реактивность |
| DI | cherrypick | Иерархические скоупы, Disposable, аннотации |
| UI Framework | fluent_ui + codelab_ui_components | Существующая дизайн-система проекта |
| WebSocket | web_socket_channel | Официальный Flutter пакет |
| Serializable models | freezed + json_serializable | Иммутабельность, type-safety |
| Async messaging | Dart Streams + Completer | Эквивалент asyncio.Queue + asyncio.Future |
| Обработка ошибок | fpdart (`Either`) | Явный, type-safe путь ошибок без try/catch |
| Тестирование | mocktail | Современная альтернатива mockito |

## Структура слоёв

```
lib/
├── core/                    # Общие утилиты, error handling, DI
├── domain/                  # Entities, Repository interfaces, Service interfaces
│   ├── entities/
│   ├── repositories/
│   └── services/
├── application/             # Use Cases, DTOs
│   ├── dto/
│   └── use_cases/
├── infrastructure/          # Реализации: Transport, Repositories, Handlers
│   ├── transport/
│   ├── repositories/
│   ├── handlers/
│   └── services/
└── presentation/            # BLoCs, UI Screens, Widgets
    ├── blocs/
    ├── screens/
    └── widgets/
```

## Соответствие Python → Flutter

| Python | Flutter |
|---|---|
| `asyncio.Queue` | `StreamController` |
| `asyncio.Future` | `Completer` |
| `asyncio.Task` | `Future` / isolate |
| `BaseModel` (pydantic) | `@freezed` class |
| `ViewModel` (MVVM) | `Bloc` (flutter_bloc) |
| `Observable<T>` | `Stream<T>` / `BehaviorSubject` |
| `DIContainer` (Singleton/Scoped) | `CherryPick` scope + `Module` |
| `structlog` | `structured_log` (pub.dev/packages/structured_log) |
| исключения (`raise`) | `Either<Failure, T>` (fpdart) |

---

## Фазы реализации

### Фаза 1 — Фундамент проекта
Настройка структуры проекта, зависимостей, DI-контейнера и инфраструктуры обработки ошибок.

| # | Задача | Файл |
|---|---|---|
| 1.1 | Структура проекта и зависимости | [phase-1/1.1-project-setup.md](phase-1/1.1-project-setup.md) |
| 1.2 | Dependency Injection (cherrypick) | [phase-1/1.2-dependency-injection.md](phase-1/1.2-dependency-injection.md) |
| 1.3 | Error Handling (Either / Result) | [phase-1/1.3-error-handling.md](phase-1/1.3-error-handling.md) |

---

### Фаза 2 — ACP Protocol Layer
Реализация JSON-RPC 2.0 моделей сообщений и всех типизированных payload ACP протокола.

| # | Задача | Файл |
|---|---|---|
| 2.1 | ACP Message Models (JSON-RPC 2.0) | [phase-2/2.1-acp-message-models.md](phase-2/2.1-acp-message-models.md) |
| 2.2 | Session Update типы и Content блоки | [phase-2/2.2-session-update-models.md](phase-2/2.2-session-update-models.md) |
| 2.3 | Tool Call и Permission модели | [phase-2/2.3-tool-call-permission-models.md](phase-2/2.3-tool-call-permission-models.md) |

---

### Фаза 3 — Domain Layer
Доменные сущности, интерфейсы репозиториев и сервисов (чистая бизнес-логика без зависимостей).

| # | Задача | Файл |
|---|---|---|
| 3.1 | Domain Entities | [phase-3/3.1-domain-entities.md](phase-3/3.1-domain-entities.md) |
| 3.2 | Repository Interfaces | [phase-3/3.2-repository-interfaces.md](phase-3/3.2-repository-interfaces.md) |
| 3.3 | Service Interfaces | [phase-3/3.3-service-interfaces.md](phase-3/3.3-service-interfaces.md) |

---

### Фаза 4 — Infrastructure Layer
Конкретные реализации: WebSocket транспорт, маршрутизация сообщений, репозитории, обработчики FS и терминала.

| # | Задача | Файл |
|---|---|---|
| 4.1 | WebSocket Transport | [phase-4/4.1-websocket-transport.md](phase-4/4.1-websocket-transport.md) |
| 4.2 | Message Router & Routing Queues | [phase-4/4.2-message-router.md](phase-4/4.2-message-router.md) |
| 4.3 | Background Receive Loop | [phase-4/4.3-background-receive-loop.md](phase-4/4.3-background-receive-loop.md) |
| 4.4 | ACP Transport Service | [phase-4/4.4-acp-transport-service.md](phase-4/4.4-acp-transport-service.md) |
| 4.5 | Session Repository (in-memory) | [phase-4/4.5-session-repository.md](phase-4/4.5-session-repository.md) |
| 4.6 | File System Handler | [phase-4/4.6-file-system-handler.md](phase-4/4.6-file-system-handler.md) |
| 4.7 | Terminal Handler | [phase-4/4.7-terminal-handler.md](phase-4/4.7-terminal-handler.md) |

---

### Фаза 5 — Application Layer (Use Cases)
DTOs и Use Cases — оркестрация бизнес-логики между Domain и Infrastructure.

| # | Задача | Файл |
|---|---|---|
| 5.1 | DTOs | [phase-5/5.1-dtos.md](phase-5/5.1-dtos.md) |
| 5.2 | InitializeUseCase & CreateSessionUseCase | [phase-5/5.2-initialize-create-session.md](phase-5/5.2-initialize-create-session.md) |
| 5.3 | LoadSessionUseCase & ListSessionsUseCase | [phase-5/5.3-load-list-sessions.md](phase-5/5.3-load-list-sessions.md) |
| 5.4 | SendPromptUseCase | [phase-5/5.4-send-prompt.md](phase-5/5.4-send-prompt.md) |
| 5.5 | Permission Handler | [phase-5/5.5-permission-handler.md](phase-5/5.5-permission-handler.md) |

---

### Фаза 6 — BLoC Layer
Presentation-логика через flutter_bloc: управление состоянием экранов.

| # | Задача | Файл |
|---|---|---|
| 6.1 | SessionBloc | [phase-6/6.1-session-bloc.md](phase-6/6.1-session-bloc.md) |
| 6.2 | ChatBloc | [phase-6/6.2-chat-bloc.md](phase-6/6.2-chat-bloc.md) |
| 6.3 | PermissionBloc | [phase-6/6.3-permission-bloc.md](phase-6/6.3-permission-bloc.md) |
| 6.4 | TerminalBloc | [phase-6/6.4-terminal-bloc.md](phase-6/6.4-terminal-bloc.md) |

---

### Фаза 7 — Presentation Layer (Flutter UI)
Экраны и виджеты Flutter-приложения. Используют `codelab_ui_components` (fluent_ui-based). Кастомные виджеты создаются только для компонентов, которых нет в библиотеке (`ToolCallCard`, `PlanPanel`, `PermissionDialog`).

| # | Задача | Файл |
|---|---|---|
| 7.1 | App Setup & Navigation (go_router) | [phase-7/7.1-app-navigation.md](phase-7/7.1-app-navigation.md) |
| 7.2 | Session List Screen | [phase-7/7.2-session-list-screen.md](phase-7/7.2-session-list-screen.md) |
| 7.3 | Chat Screen (Streaming) | [phase-7/7.3-chat-screen.md](phase-7/7.3-chat-screen.md) |
| 7.4 | Permission Dialog | [phase-7/7.4-permission-dialog.md](phase-7/7.4-permission-dialog.md) |
| 7.5 | Tool Call Widget | [phase-7/7.5-tool-call-widget.md](phase-7/7.5-tool-call-widget.md) |
| 7.6 | Agent Plan Widget | [phase-7/7.6-agent-plan-widget.md](phase-7/7.6-agent-plan-widget.md) |

---

### Фаза 8 — Тестирование
Unit-тесты для всех слоёв и widget-тесты для UI-компонентов.

| # | Задача | Файл |
|---|---|---|
| 8.1 | Unit Tests — Domain & Protocol | [phase-8/8.1-domain-tests.md](phase-8/8.1-domain-tests.md) |
| 8.2 | Unit Tests — Use Cases | [phase-8/8.2-use-case-tests.md](phase-8/8.2-use-case-tests.md) |
| 8.3 | Unit Tests — BLoCs | [phase-8/8.3-bloc-tests.md](phase-8/8.3-bloc-tests.md) |
| 8.4 | Widget Tests | [phase-8/8.4-widget-tests.md](phase-8/8.4-widget-tests.md) |

---

## Диаграмма зависимостей слоёв

```
Presentation (BLoC)
      ↓
Application (Use Cases)
      ↓
Domain (Entities + Interfaces)
      ↑
Infrastructure (Implementations)
```

**Правило:** каждый слой зависит только от слоёв ниже. Infrastructure реализует интерфейсы Domain, но не зависит от Application или Presentation.

## Ключевые протокольные потоки

### Инициализация и создание сессии
```
Client → Agent: initialize
Agent → Client: initialize response (capabilities)
Client → Agent: session/new (cwd)
Agent → Client: session/new response (sessionId)
```

### Промпт-тёрн (основной цикл)
```
Client → Agent: session/prompt
Agent → Client: session/update (plan)
Agent → Client: session/update (agent_message_chunk) ...
Agent → Client: session/request_permission  ← опционально
Client → Agent: permission response
Agent → Client: session/update (tool_call)
Agent → Client: session/update (tool_call_update)
Agent → Client: session/prompt response (stopReason)
```

### Инструменты файловой системы (server → client RPC)
```
Agent → Client: fs/read_text_file {path}
Client → Agent: response {content}

Agent → Client: fs/write_text_file {path, content}
Client → Agent: response {}
```

### Терминал (server → client RPC)
```
Agent → Client: terminal/create {command}
Client → Agent: response {terminalId}
Agent → Client: terminal/output {terminalId}
Client → Agent: response {output, hasMore}
Agent → Client: terminal/wait_for_exit {terminalId}
Client → Agent: response {exitCode}
Agent → Client: terminal/release {terminalId}
Client → Agent: response {}
```
