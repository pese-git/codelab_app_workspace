import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/acp_message.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class LoadSessionUseCase {
  LoadSessionUseCase({
    required TransportService transport,
    required SessionRepository sessionRepo,
  })  : _transport = transport,
        _sessionRepo = sessionRepo;

  final TransportService _transport;
  final SessionRepository _sessionRepo;
  final _log = getLogger('LoadSessionUseCase');

  Future<Either<Failure, LoadSessionResponseDto>> execute(
    LoadSessionRequestDto request,
  ) async {
    _log.info('LoadSessionUseCase: sessionId=${request.sessionId}');

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      var session = await _sessionRepo.load(request.sessionId);
      if (session == null) {
        _log.debug('Session not in repo, creating shadow copy');
        session = Session.create(
          serverHost: request.serverHost,
          serverPort: request.serverPort,
          clientCapabilities: {},
          serverCapabilities: _transport.getServerCapabilities(),
          sessionId: request.sessionId,
        );
        await _sessionRepo.save(session);
      }

      final replayUpdates = <Map<String, dynamic>>[];

      final responseData = await _transport.requestWithCallbacks(
        method: 'session/load',
        params: {
          'sessionId': request.sessionId,
          'cwd': request.cwd ?? '',
          'mcpServers': request.mcpServers ?? [],
        },
        onUpdate: (update) {
          final params = update['params'] as Map<String, dynamic>?;
          if (params?['sessionId'] == request.sessionId) {
            replayUpdates.add(update);
          }
        },
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'session/load failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      _log.info(
        'Session loaded: ${request.sessionId}, '
        'replay updates: ${replayUpdates.length}',
      );

      return right(LoadSessionResponseDto(
        sessionId: session.id,
        serverCapabilities: session.serverCapabilities,
        isAuthenticated: session.isAuthenticated,
        replayUpdates: replayUpdates,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'LoadSession failed: $e'));
    }
  }
}
