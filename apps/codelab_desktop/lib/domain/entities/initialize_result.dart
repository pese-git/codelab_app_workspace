import 'package:freezed_annotation/freezed_annotation.dart';

import 'capabilities.dart';

part 'initialize_result.freezed.dart';

@freezed
abstract class AuthMethod with _$AuthMethod {
  const factory AuthMethod({
    required String id,
    String? name,
    String? description,
    String? type,
  }) = _AuthMethod;
}

@freezed
abstract class InitializeResult with _$InitializeResult {
  const factory InitializeResult({
    required int protocolVersion,
    required AgentCapabilities agentCapabilities,
    Map<String, dynamic>? agentInfo,
    @Default([]) List<AuthMethod> authMethods,
  }) = _InitializeResult;
}
