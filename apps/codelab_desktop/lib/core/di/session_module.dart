import 'package:cherrypick/cherrypick.dart';

import '../../application/use_cases/send_prompt_use_case.dart';
import '../../infrastructure/services/permission_handler.dart';
import '../../domain/services/transport_service.dart';
import '../../infrastructure/handlers/file_system_handler.dart';
import '../../infrastructure/handlers/terminal_handler.dart';

class SessionModule extends Module {
  SessionModule({required this.sessionId});

  final String sessionId;

  @override
  void builder(Scope currentScope) {
    bind<FileSystemHandler>()
        .toProvide(() => FileSystemHandler())
        .singleton();

    bind<TerminalHandler>()
        .toProvide(() => TerminalHandler())
        .singleton();

    bind<PermissionHandler>()
        .toProvide(() => PermissionHandler())
        .singleton();

    bind<SendPromptUseCase>()
        .toProvide(
          () => SendPromptUseCase(
            transport: currentScope.resolve<TransportService>(),
          ),
        );
  }
}
