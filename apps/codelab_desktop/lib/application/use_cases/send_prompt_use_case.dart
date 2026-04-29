import '../../domain/services/transport_service.dart';
import '../../domain/repositories/session_repository.dart';
import '../../infrastructure/handlers/file_system_handler.dart';
import '../../infrastructure/handlers/terminal_handler.dart';

class SendPromptUseCase {
  SendPromptUseCase({
    required this.transport,
    required this.sessionRepo,
    required this.fsService,
    required this.terminalService,
  });

  final TransportService transport;
  final SessionRepository sessionRepo;
  final FileSystemHandler fsService;
  final TerminalHandler terminalService;

  Future<void> execute({
    required String sessionId,
    required String prompt,
  }) async {
    await transport.sendRequest('session/prompt', {
      'sessionId': sessionId,
      'prompt': prompt,
    });
  }
}
