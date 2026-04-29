import 'package:fpdart/fpdart.dart';

/// Base class for all application failures.
sealed class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'Failure($code): $message';
}

/// Transport layer errors (WebSocket, network)
class TransportFailure extends Failure {
  const TransportFailure({required super.message, super.code});
}

/// ACP protocol errors (JSON-RPC errors from server)
class ProtocolFailure extends Failure {
  const ProtocolFailure({
    required super.message,
    this.errorCode,
    super.code,
  });

  final int? errorCode;

  @override
  String toString() => 'ProtocolFailure($errorCode): $message';
}

/// Session errors (session not found, not initialized)
class SessionFailure extends Failure {
  const SessionFailure({required super.message, super.code});
}

/// Authentication errors
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// File system errors
class FileSystemFailure extends Failure {
  const FileSystemFailure({required super.message, this.path, super.code});

  final String? path;
}

/// Terminal errors
class TerminalFailure extends Failure {
  const TerminalFailure({
    required super.message,
    this.terminalId,
    super.code,
  });

  final String? terminalId;
}

/// Unexpected errors (wrapper around Exception/Error)
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.code});
}

/// Input data validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Timeout errors
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Operation timed out',
    super.code,
  });
}

/// Type aliases for convenience
typedef EitherFailure<T> = Either<Failure, T>;
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Helper to wrap exceptions into Failure
EitherFailure<T> handleException<T>(Object exception, StackTrace stackTrace) {
  if (exception is Failure) {
    return left(exception);
  }

  return left(UnexpectedFailure(message: exception.toString()));
}

/// Convert JSON-RPC error from server into ProtocolFailure
ProtocolFailure fromJsonRpcError({
  required int code,
  required String message,
}) {
  return ProtocolFailure(
    message: message,
    errorCode: code,
    code: 'JSONRPC_$code',
  );
}
