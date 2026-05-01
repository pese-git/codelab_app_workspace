import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class ForkSessionUseCase {
  ForkSessionUseCase({
    required TransportService transport,
  }) : _transport = transport;

  final TransportService _transport;
  final _log = getLogger('ForkSessionUseCase');

  Future<Either<Failure, ForkSessionResponseDto>> execute(
    ForkSessionRequestDto request,
  ) async {
    _log.info(
      'ForkSessionUseCase: sessionId=${request.sessionId}',
    );

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      final forkRequest = AcpMessage.requestWithAutoId(
        'unstable_forkSession',
        params: {
          'sessionId': request.sessionId,
          if (request.title != null) 'title': request.title,
        },
      ) as AcpRequest;

      await _transport.send(forkRequest.toJson());

      final responseData = await _transport.receive(
        requestId: forkRequest.id.toString(),
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'unstable_forkSession failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      final result = (response as AcpResponse).result as Map<String, dynamic>;
      final forkedSessionId = result['sessionId'] as String?;

      if (forkedSessionId == null) {
        return left(const ProtocolFailure(
          message: 'Server response missing sessionId',
        ));
      }

      _log.info(
        'Session forked: ${request.sessionId} -> $forkedSessionId',
      );

      return right(ForkSessionResponseDto(
        sessionId: request.sessionId,
        forkedSessionId: forkedSessionId,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'ForkSession failed: $e'));
    }
  }
}
