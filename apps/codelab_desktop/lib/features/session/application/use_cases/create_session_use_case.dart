import 'package:fpdart/fpdart.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/acp_message.dart';
import '../../../../domain/entities/session.dart';
import '../../../../domain/repositories/session_repository.dart';
import '../../../../domain/services/transport_service.dart';
import '../dto/session_dto.dart';

class CreateSessionUseCase {
  CreateSessionUseCase({
    required TransportService transport,
    required SessionRepository sessionRepo,
  })  : _transport = transport,
        _sessionRepo = sessionRepo;

  final TransportService _transport;
  final SessionRepository _sessionRepo;
  final _log = getLogger('CreateSessionUseCase');

  Future<Either<Failure, CreateSessionResponseDto>> execute(
    CreateSessionRequestDto request,
  ) async {
    _log.info('CreateSessionUseCase: cwd=${request.cwd}');

    try {
      if (!_transport.isInitialized()) {
        return left(const SessionFailure(
          message: 'Transport not initialized. Call InitializeUseCase first.',
        ));
      }

      if (request.authMethod != null && request.authCredentials != null) {
        final authResult = await _authenticate(
          request.authMethod!,
          request.authCredentials!,
        );
        if (authResult != null) return left(authResult);
      }

      final sessionRequest = AcpMessage.requestWithAutoId(
        'session/new',
        params: {
          'cwd': request.cwd,
          'clientCapabilities': request.clientCapabilities ?? {},
        },
      ) as AcpRequest;

      await _transport.send(sessionRequest.toJson());

      final responseData = await _transport.receive(
        requestId: sessionRequest.id.toString(),
      );

      final response = AcpMessage.fromJson(responseData);

      if (response is AcpResponse && response.error != null) {
        return left(ProtocolFailure(
          message: 'session/new failed: ${response.error!.message}',
          errorCode: response.error!.code,
        ));
      }

      final result = (response as AcpResponse).result as Map<String, dynamic>;
      final sessionId = result['sessionId'] as String?;

      if (sessionId == null) {
        return left(const ProtocolFailure(
          message: 'Server response missing sessionId',
        ));
      }

      final session = Session.create(
        serverHost: request.serverHost,
        serverPort: request.serverPort,
        clientCapabilities: request.clientCapabilities ?? {},
        serverCapabilities: _transport.getServerCapabilities(),
        sessionId: sessionId,
        cwd: request.cwd,
      );

      await _sessionRepo.save(session);

      _log.info('Session created: $sessionId');

      return right(CreateSessionResponseDto(
        sessionId: sessionId,
        serverCapabilities: session.serverCapabilities,
        isAuthenticated: request.authMethod != null,
      ));
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(UnexpectedFailure(message: 'CreateSession failed: $e'));
    }
  }

  Future<Failure?> _authenticate(
    String authMethod,
    Map<String, dynamic> credentials,
  ) async {
    final authRequest = AcpMessage.requestWithAutoId(
      'authenticate',
      params: {'authMethod': authMethod, ...credentials},
    ) as AcpRequest;

    await _transport.send(authRequest.toJson());
    final responseData = await _transport.receive(
      requestId: authRequest.id.toString(),
    );
    final response = AcpMessage.fromJson(responseData);

    if (response is AcpResponse && response.error != null) {
      return AuthFailure(
        message: 'Authentication failed: ${response.error!.message}',
      );
    }
    return null;
  }
}
