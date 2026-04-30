import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/entities/session.dart';
import '../../../../domain/entities/session_list.dart';
import '../../../../domain/repositories/session_repository.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class ListSessionsUseCase {
  ListSessionsUseCase({
    required TransportService transport,
    required SessionRepository sessionRepo,
  })  : _transport = transport,
        _sessionRepo = sessionRepo;

  final TransportService _transport;
  final SessionRepository _sessionRepo;
  final _log = getLogger('ListSessionsUseCase');

  Future<Either<Failure, ListSessionsResponseDto>> execute() async {
    _log.info('ListSessionsUseCase: requesting session list');

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      final responseData = await _transport.requestWithCallbacks(
        method: 'session/list',
        params: {},
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'session/list failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      final result = SessionListResult.fromJson(
        (response as AcpResponse).result as Map<String, dynamic>,
      );

      for (final item in result.sessions) {
        final cached = await _sessionRepo.load(item.sessionId);
        if (cached == null) {
          final session = Session.create(
            serverHost: 'unknown',
            serverPort: 0,
            clientCapabilities: {},
            serverCapabilities: _transport.getServerCapabilities(),
            sessionId: item.sessionId,
            cwd: item.cwd,
          );
          await _sessionRepo.save(session);
        }
      }

      final sessions = result.sessions
          .map((item) => SessionListItemDto(
                sessionId: item.sessionId,
                cwd: item.cwd,
                title: item.title,
                updatedAt: item.updatedAt,
              ))
          .toList();

      _log.info('Listed ${sessions.length} sessions');

      return right(ListSessionsResponseDto(sessions: sessions));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'ListSessions failed: $e'));
    }
  }
}
