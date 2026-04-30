import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/repositories/session_repository.dart';
import '../../../../domain/services/file_system_service.dart';
import '../../../../domain/services/terminal_service.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class PromptCallbacks {
  const PromptCallbacks({this.onUpdate});

  final void Function(Map<String, dynamic> update)? onUpdate;
}

class SendPromptUseCase {
  SendPromptUseCase({
    required TransportService transport,
    required SessionRepository sessionRepo,
    required FileSystemService fsService,
    required TerminalService terminalService,
  })  : _transport = transport,
        _sessionRepo = sessionRepo,
        _fsService = fsService,
        _terminalService = terminalService;

  final TransportService _transport;
  final SessionRepository _sessionRepo;
  final FileSystemService _fsService;
  final TerminalService _terminalService;
  final _log = getLogger('SendPromptUseCase');

  Future<Either<Failure, SendPromptResponseDto>> execute(
    SendPromptRequestDto request, {
    PromptCallbacks? callbacks,
  }) async {
    _log.info(
      'SendPromptUseCase: sessionId=${request.sessionId}, '
      'prompt length=${request.promptText.length}',
    );

    try {
      final session = await _sessionRepo.load(request.sessionId);
      if (session == null) {
        return left(SessionFailure(
          message: 'Session ${request.sessionId} not found',
        ));
      }

      final collectedUpdates = <Map<String, dynamic>>[];

      final responseData = await _transport.requestWithCallbacks(
        method: 'session/prompt',
        params: {
          'sessionId': request.sessionId,
          'prompt': [
            {'type': 'text', 'text': request.promptText},
          ],
        },
        onUpdate: (update) {
          collectedUpdates.add(update);
          callbacks?.onUpdate?.call(update);
        },
        onFsRead: (path) => _fsService.readTextFile(path),
        onFsWrite: (path, content) => _fsService.writeTextFile(path, content),
        onTerminalCreate: (command) => _terminalService.create(
          command: command,
        ),
        onTerminalOutput: (terminalId) =>
            _terminalService.getOutput(terminalId),
        onTerminalWait: (terminalId) =>
            _terminalService.waitForExit(terminalId),
        onTerminalRelease: (terminalId) =>
            _terminalService.release(terminalId),
        onTerminalKill: (terminalId) => _terminalService.kill(terminalId),
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'session/prompt failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      final promptResult =
          (response as AcpResponse).result as Map<String, dynamic>;
      final stopReason = promptResult['stopReason'] as String? ?? 'end_turn';

      _log.info(
        'Prompt completed: stopReason=$stopReason, '
        'updates=${collectedUpdates.length}',
      );

      return right(SendPromptResponseDto(
        sessionId: request.sessionId,
        promptResult: promptResult,
        updates: collectedUpdates,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'SendPrompt failed: $e'));
    }
  }
}
