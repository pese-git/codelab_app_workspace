import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/capabilities.dart';
import '../../domain/entities/initialize_result.dart';
import '../../domain/entities/session_list.dart';
import '../../domain/entities/session_setup.dart';

part 'session_dto.g.dart';

@JsonSerializable()
class InitializeResultDto {
  const InitializeResultDto({
    required this.protocolVersion,
    required this.agentCapabilities,
    this.agentInfo,
    this.authMethods = const [],
  });

  final int protocolVersion;
  final AgentCapabilitiesDto agentCapabilities;
  final Map<String, dynamic>? agentInfo;
  final List<AuthMethodDto> authMethods;

  factory InitializeResultDto.fromJson(Map<String, dynamic> json) =>
      _$InitializeResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InitializeResultDtoToJson(this);

  InitializeResult toDomain() => InitializeResult(
        protocolVersion: protocolVersion,
        agentCapabilities: agentCapabilities.toDomain(),
        agentInfo: agentInfo,
        authMethods: authMethods.map((a) => a.toDomain()).toList(),
      );
}

@JsonSerializable()
class AgentCapabilitiesDto {
  const AgentCapabilitiesDto({
    this.loadSession = false,
    this.promptCapabilities = const {},
    this.mcpCapabilities = const {},
    this.sessionCapabilities = const {},
  });

  final bool loadSession;
  final Map<String, dynamic> promptCapabilities;
  final Map<String, dynamic> mcpCapabilities;
  final Map<String, dynamic> sessionCapabilities;

  factory AgentCapabilitiesDto.fromJson(Map<String, dynamic> json) =>
      _$AgentCapabilitiesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AgentCapabilitiesDtoToJson(this);

  AgentCapabilities toDomain() => AgentCapabilities(
        loadSession: loadSession,
        promptCapabilities: promptCapabilities,
        mcpCapabilities: mcpCapabilities,
        sessionCapabilities: sessionCapabilities,
      );
}

@JsonSerializable()
class AuthMethodDto {
  const AuthMethodDto({
    required this.id,
    this.name,
    this.description,
    this.type,
  });

  final String id;
  final String? name;
  final String? description;
  final String? type;

  factory AuthMethodDto.fromJson(Map<String, dynamic> json) =>
      _$AuthMethodDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMethodDtoToJson(this);

  AuthMethod toDomain() => AuthMethod(
        id: id,
        name: name,
        description: description,
        type: type,
      );
}

@JsonSerializable()
class SessionListResultDto {
  const SessionListResultDto({
    required this.sessions,
    this.nextCursor,
  });

  final List<SessionListItemDto> sessions;
  final String? nextCursor;

  factory SessionListResultDto.fromJson(Map<String, dynamic> json) =>
      _$SessionListResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionListResultDtoToJson(this);

  SessionListResult toDomain() => SessionListResult(
        sessions: sessions.map((s) => s.toDomain()).toList(),
        nextCursor: nextCursor,
      );
}

@JsonSerializable()
class SessionListItemDto {
  const SessionListItemDto({
    required this.sessionId,
    required this.cwd,
    this.title,
    this.updatedAt,
  });

  final String sessionId;
  final String cwd;
  final String? title;
  final String? updatedAt;

  factory SessionListItemDto.fromJson(Map<String, dynamic> json) =>
      _$SessionListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionListItemDtoToJson(this);

  SessionListItem toDomain() => SessionListItem(
        sessionId: sessionId,
        cwd: cwd,
        title: title,
        updatedAt: updatedAt,
      );
}

@JsonSerializable()
class SessionSetupResultDto {
  const SessionSetupResultDto({
    this.sessionId,
    this.configOptions = const [],
    this.modes,
  });

  final String? sessionId;
  final List<SessionConfigOptionDto> configOptions;
  final SessionModeStateDto? modes;

  factory SessionSetupResultDto.fromJson(Map<String, dynamic> json) =>
      _$SessionSetupResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionSetupResultDtoToJson(this);

  SessionSetupResult toDomain() => SessionSetupResult(
        sessionId: sessionId,
        configOptions: configOptions.map((c) => c.toDomain()).toList(),
        modes: modes?.toDomain(),
      );
}

@JsonSerializable()
class SessionModeStateDto {
  const SessionModeStateDto({
    required this.availableModes,
    required this.currentModeId,
  });

  final List<SessionModeDto> availableModes;
  final String currentModeId;

  factory SessionModeStateDto.fromJson(Map<String, dynamic> json) =>
      _$SessionModeStateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModeStateDtoToJson(this);

  SessionModeState toDomain() => SessionModeState(
        availableModes: availableModes.map((m) => m.toDomain()).toList(),
        currentModeId: currentModeId,
      );
}

@JsonSerializable()
class SessionModeDto {
  const SessionModeDto({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  factory SessionModeDto.fromJson(Map<String, dynamic> json) =>
      _$SessionModeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModeDtoToJson(this);

  SessionMode toDomain() => SessionMode(
        id: id,
        name: name,
        description: description,
      );
}

@JsonSerializable()
class SessionConfigOptionDto {
  const SessionConfigOptionDto({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.currentValue,
    required this.options,
  });

  final String id;
  final String name;
  final String category;
  final String type;
  final String currentValue;
  final List<SessionConfigValueOptionDto> options;

  factory SessionConfigOptionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigOptionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionConfigOptionDtoToJson(this);

  SessionConfigOption toDomain() => SessionConfigOption(
        id: id,
        name: name,
        category: category,
        type: type,
        currentValue: currentValue,
        options: options.map((o) => o.toDomain()).toList(),
      );
}

@JsonSerializable()
class SessionConfigValueOptionDto {
  const SessionConfigValueOptionDto({
    required this.value,
    required this.name,
    this.description,
  });

  final String value;
  final String name;
  final String? description;

  factory SessionConfigValueOptionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigValueOptionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionConfigValueOptionDtoToJson(this);

  SessionConfigValueOption toDomain() => SessionConfigValueOption(
        value: value,
        name: name,
        description: description,
      );
}
