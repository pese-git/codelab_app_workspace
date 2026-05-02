import 'package:cherrypick/cherrypick.dart';

import '../../features/session/application/use_cases/initialize_use_case.dart';
import '../../features/session/application/use_cases/create_session_use_case.dart';
import '../../features/session/application/use_cases/list_sessions_use_case.dart';
import '../../features/session/application/use_cases/load_session_use_case.dart';
import '../../features/session/application/use_cases/cancel_session_use_case.dart';
import '../../features/session/application/use_cases/set_session_mode_use_case.dart';
import '../../features/session/application/use_cases/set_config_option_use_case.dart';
import '../../features/session/application/use_cases/fork_session_use_case.dart';
import '../../features/session/application/use_cases/resume_session_use_case.dart';
import '../../features/session/presentation/blocs/session/session_bloc.dart';
import '../../features/server/application/server_connection_manager.dart';
import '../../features/project/application/use_cases/open_project_use_case.dart';
import '../../domain/repositories/chat_history_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/repositories/server_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/services/directory_scanner_service.dart';
import '../../domain/services/transport_service.dart';
import '../../infrastructure/repositories/in_memory_chat_history_repository.dart';
import '../../infrastructure/repositories/in_memory_project_repository.dart';
import '../../infrastructure/repositories/in_memory_server_repository.dart';
import '../../infrastructure/repositories/in_memory_session_repository.dart';
import '../../infrastructure/services/acp_transport_service.dart';
import '../../infrastructure/services/native_directory_scanner.dart';
import '../../infrastructure/services/permission_handler.dart';
import '../../infrastructure/transport/websocket_transport.dart';

class AppModule extends Module {
  @override
  void builder(Scope currentScope) {
    bind<SessionRepository>()
        .toProvide(() => InMemorySessionRepository())
        .singleton();

    bind<ChatHistoryRepository>()
        .toProvide(() => InMemoryChatHistoryRepository())
        .singleton();

    bind<ProjectRepository>()
        .toProvide(() => InMemoryProjectRepository())
        .singleton();

    bind<ServerRepository>()
        .toProvide(() => InMemoryServerRepository())
        .singleton();

    bind<DirectoryScannerService>()
        .toProvide(() => NativeDirectoryScanner())
        .singleton();

    bind<PermissionHandler>()
        .toProvide(() => PermissionHandler())
        .singleton();

    bind<AcpServerConfig>()
        .toProvide(
          () => const AcpServerConfig(
            host: 'localhost',
            port: 8080,
          ),
        )
        .singleton();

    bind<TransportService>()
        .toProvide(
          () => AcpTransportService(
            config: currentScope.resolve<AcpServerConfig>(),
            permissionHandler: currentScope.resolve<PermissionHandler>(),
          ),
        )
        .singleton();

    bind<InitializeUseCase>()
        .toProvide(
          () => InitializeUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );

    bind<CreateSessionUseCase>()
        .toProvide(
          () => CreateSessionUseCase(
            transport: currentScope.resolve<TransportService>(),
            sessionRepo: currentScope.resolve<SessionRepository>(),
          ),
        );

    bind<ListSessionsUseCase>()
        .toProvide(
          () => ListSessionsUseCase(
            transport: currentScope.resolve<TransportService>(),
            sessionRepo: currentScope.resolve<SessionRepository>(),
          ),
        );

    bind<LoadSessionUseCase>()
        .toProvide(
          () => LoadSessionUseCase(
            transport: currentScope.resolve<TransportService>(),
            sessionRepo: currentScope.resolve<SessionRepository>(),
          ),
        );

    bind<CancelSessionUseCase>()
        .toProvide(
          () => CancelSessionUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );

    bind<SetSessionModeUseCase>()
        .toProvide(
          () => SetSessionModeUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );

    bind<SetConfigOptionUseCase>()
        .toProvide(
          () => SetConfigOptionUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );

    bind<ForkSessionUseCase>()
        .toProvide(
          () => ForkSessionUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );

    bind<ResumeSessionUseCase>()
        .toProvide(
          () => ResumeSessionUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );

    bind<OpenProjectUseCase>()
        .toProvide(
          () => OpenProjectUseCase(
            directoryScanner: currentScope.resolve<DirectoryScannerService>(),
            projectRepository: currentScope.resolve<ProjectRepository>(),
          ),
        );

    bind<SessionBloc>()
        .toProvide(
          () => SessionBloc(
            initializeUseCase: currentScope.resolve<InitializeUseCase>(),
            createSessionUseCase: currentScope.resolve<CreateSessionUseCase>(),
            loadSessionUseCase: currentScope.resolve<LoadSessionUseCase>(),
            listSessionsUseCase: currentScope.resolve<ListSessionsUseCase>(),
            transport: currentScope.resolve<TransportService>(),
          ),
        )
        .singleton();

    bind<ServerConnectionManager>()
        .toProvide(
          () => ServerConnectionManager(
            serverRepository: currentScope.resolve<ServerRepository>(),
            transport: currentScope.resolve<TransportService>(),
            sessionBloc: currentScope.resolve<SessionBloc>(),
          ),
        )
        .singleton();
  }
}
