import 'package:cherrypick/cherrypick.dart';

import '../../domain/repositories/chat_history_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/services/transport_service.dart';
import '../../infrastructure/repositories/in_memory_chat_history_repository.dart';
import '../../infrastructure/repositories/in_memory_session_repository.dart';
import '../../infrastructure/services/acp_transport_service.dart';
import '../../infrastructure/services/permission_handler.dart';
import '../../infrastructure/transport/websocket_transport.dart';
import '../../application/use_cases/initialize_use_case.dart';
import '../../application/use_cases/create_session_use_case.dart';
import '../../application/use_cases/list_sessions_use_case.dart';
import '../../application/use_cases/load_session_use_case.dart';

class AppModule extends Module {
  @override
  void builder(Scope currentScope) {
    bind<SessionRepository>()
        .toProvide(() => InMemorySessionRepository())
        .singleton();

    bind<ChatHistoryRepository>()
        .toProvide(() => InMemoryChatHistoryRepository())
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
  }
}
