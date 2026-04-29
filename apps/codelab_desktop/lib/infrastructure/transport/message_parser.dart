import '../dto/acp_message.dart';
import '../dto/initialize_result.dart';
import '../dto/session_list.dart';
import '../dto/session_setup.dart';
import '../../core/error/failures.dart';

class AcpMessageParser {
  InitializeResult parseInitializeResult(AcpMessage message) {
    final result = _extractResultMap(message, 'initialize');
    return InitializeResult.fromJson(result);
  }

  SessionListResult parseSessionListResult(AcpMessage message) {
    final result = _extractResultMap(message, 'session/list');
    return SessionListResult.fromJson(result);
  }

  SessionSetupResult parseSessionSetupResult(
    AcpMessage message, {
    required String methodName,
  }) {
    final result = _extractResultMap(message, methodName);
    return SessionSetupResult.fromJson(result);
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
