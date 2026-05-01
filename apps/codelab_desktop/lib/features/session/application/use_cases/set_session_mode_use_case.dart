import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class SetSessionModeUseCase {
  SetSessionModeUseCase({
    required TransportService transport,
  }) : _transport = transport;

  final TransportService _transport;
  final _log = getLogger('SetSessionModeUseCase');

  Future<Either<Failure, SetSessionModeResponseDto>> execute(
    SetSessionModeRequestDto request,
  ) async {
    _log.info(
      'SetSessionModeUseCase: sessionId=${request.sessionId}, '
      'modeId=${request.modeId}',
    );

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      final modeRequest = AcpMessage.requestWithAutoId(
        'session/set_mode',
        params: {
          'sessionId': request.sessionId,
          'modeId': request.modeId,
        },
      ) as AcpRequest;

      await _transport.send(modeRequest.toJson());

      final responseData = await _transport.receive(
        requestId: modeRequest.id.toString(),
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'session/set_mode failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      _log.info('Session mode set: ${request.modeId}');

      return right(SetSessionModeResponseDto(
        sessionId: request.sessionId,
        modeId: request.modeId,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'SetSessionMode failed: $e'));
    }
  }
}
