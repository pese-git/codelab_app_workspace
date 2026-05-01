import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class SetConfigOptionUseCase {
  SetConfigOptionUseCase({
    required TransportService transport,
  }) : _transport = transport;

  final TransportService _transport;
  final _log = getLogger('SetConfigOptionUseCase');

  Future<Either<Failure, SetConfigOptionResponseDto>> execute(
    SetConfigOptionRequestDto request,
  ) async {
    _log.info(
      'SetConfigOptionUseCase: sessionId=${request.sessionId}, '
      'key=${request.key}',
    );

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized.',
        ));
      }

      final configRequest = AcpMessage.requestWithAutoId(
        'session/set_config_option',
        params: {
          'sessionId': request.sessionId,
          'key': request.key,
          'value': request.value,
        },
      ) as AcpRequest;

      await _transport.send(configRequest.toJson());

      final responseData = await _transport.receive(
        requestId: configRequest.id.toString(),
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message:
              'session/set_config_option failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      _log.info('Config option set: ${request.key}=${request.value}');

      return right(SetConfigOptionResponseDto(
        sessionId: request.sessionId,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'SetConfigOption failed: $e'));
    }
  }
}
