import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class ResumeSessionUseCase {
  ResumeSessionUseCase({
    required TransportService transport,
  }) : _transport = transport;

  final TransportService _transport;
  final _log = getLogger('ResumeSessionUseCase');

  Future<Either<Failure, ResumeSessionResponseDto>> execute(
    ResumeSessionRequestDto request,
  ) async {
    _log.info(
      'ResumeSessionUseCase: sessionId=${request.sessionId}',
    );

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      final replayUpdates = <Map<String, dynamic>>[];

      final responseData = await _transport.requestWithCallbacks(
        method: 'unstable_resumeSession',
        params: {'sessionId': request.sessionId},
        onUpdate: (update) {
          replayUpdates.add(update);
        },
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message:
              'unstable_resumeSession failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      _log.info(
        'Session resumed: ${request.sessionId}, '
        'replay updates: ${replayUpdates.length}',
      );

      return right(ResumeSessionResponseDto(
        sessionId: request.sessionId,
        replayUpdates: replayUpdates,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'ResumeSession failed: $e'));
    }
  }
}
