import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/acp_message.dart';
import '../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class InitializeUseCase {
  InitializeUseCase({required TransportService transport})
      : _transport = transport;

  final TransportService _transport;
  final _log = getLogger('InitializeUseCase');

  Future<Either<Failure, InitializeResponseDto>> execute(
    InitializeRequestDto request,
  ) async {
    _log.info(
      'InitializeUseCase: connecting to ${request.serverHost}:${request.serverPort}',
    );

    try {
      await _transport.connect();
      _log.debug('Connected to server');

      final initRequest = AcpMessage.requestWithAutoId(
        'initialize',
        params: {
          'protocolVersion': 1,
          'clientCapabilities': {
            'fs': {
              'readTextFile': true,
              'writeTextFile': true,
            },
            'terminal': true,
          },
          'clientInfo': {
            'name': 'acp-flutter-client',
            'version': '1.0.0',
          },
        },
      ) as AcpRequest;
      final requestId = initRequest.id.toString();

      await _transport.send(initRequest.toJson());
      _log.debug('Sent initialize request id=$requestId');

      final responseData = await _transport.receive(
        requestId: requestId,
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        await _transport.disconnect();
        return left(ProtocolFailure(
          message: 'Initialize failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      final result = (response as AcpResponse).result as Map<String, dynamic>;
      final capabilities =
          result['agentCapabilities'] as Map<String, dynamic>? ?? {};
      final authMethods = (result['authMethods'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [];
      final protocolVersion = result['protocolVersion']?.toString() ?? '1';

      _transport.setServerCapabilities(capabilities);

      _log.info(
        'InitializeUseCase: success, protocolVersion=$protocolVersion',
      );

      return right(InitializeResponseDto(
        serverCapabilities: capabilities,
        availableAuthMethods: authMethods,
        protocolVersion: protocolVersion,
      ));
    } on TransportFailure catch (f) {
      return left(f);
    } on ProtocolFailure catch (f) {
      return left(f);
    } catch (e) {
      await _transport.disconnect();
      return left(UnexpectedFailure(message: 'Initialize failed: $e'));
    }
  }
}
