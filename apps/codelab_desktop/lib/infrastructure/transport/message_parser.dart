import '../../domain/entities/acp_message.dart';
import '../../core/error/failures.dart';
import '../../application/dto/session_dto.dart';

class AcpMessageParser {
  InitializeResultDto parseInitializeResult(AcpMessage message) {
    final result = _extractResultMap(message, 'initialize');
    return InitializeResultDto.fromJson(result);
  }

  SessionListResultDto parseSessionListResult(AcpMessage message) {
    final result = _extractResultMap(message, 'session/list');
    return SessionListResultDto.fromJson(result);
  }

  SessionSetupResultDto parseSessionSetupResult(
    AcpMessage message, {
    required String methodName,
  }) {
    final result = _extractResultMap(message, methodName);
    return SessionSetupResultDto.fromJson(result);
  }

  Map<String, dynamic> _extractResultMap(AcpMessage message, String method) {
    return switch (message) {
      AcpResponse(error: final JsonRpcError err) =>
        throw ProtocolFailure(
          message: '$method failed: ${err.message}',
          errorCode: err.code,
        ),
      AcpResponse(result: final Map<String, dynamic> map) => map,
      AcpResponse() =>
        throw ProtocolFailure(
          message: '$method response must contain object result',
        ),
      _ =>
        throw ProtocolFailure(
          message: '$method must be a response message',
        ),
    };
  }
}
