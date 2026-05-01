import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class CancelSessionUseCase {
  CancelSessionUseCase({
    required TransportService transport,
  }) : _transport = transport;

  final TransportService _transport;
  final _log = getLogger('CancelSessionUseCase');

  Future<Either<Failure, CancelSessionResponseDto>> execute(
    CancelSessionRequestDto request,
  ) async {
    _log.info('CancelSessionUseCase: sessionId=${request.sessionId}');

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      final cancelRequest = AcpMessage.requestWithAutoId(
        'session/cancel',
        params: {'sessionId': request.sessionId},
      ) as AcpRequest;

      await _transport.send(cancelRequest.toJson());

      final responseData = await _transport.receive(
        requestId: cancelRequest.id.toString(),
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'session/cancel failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      _log.info('Session cancelled: ${request.sessionId}');

      return right(CancelSessionResponseDto(
        sessionId: request.sessionId,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'CancelSession failed: $e'));
    }
  }
}
