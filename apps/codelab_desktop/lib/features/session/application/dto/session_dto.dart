import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_dto.freezed.dart';

// ─── Request DTOs ─────────────────────────────────────────────────────────

@freezed
abstract class InitializeRequestDto with _$InitializeRequestDto {
  const factory InitializeRequestDto({
    required String serverHost,
    required int serverPort,
  }) = _InitializeRequestDto;
}

@freezed
abstract class CreateSessionRequestDto with _$CreateSessionRequestDto {
  const factory CreateSessionRequestDto({
    required String serverHost,
    required int serverPort,
    required String cwd,
    Map<String, dynamic>? clientCapabilities,
    String? authMethod,
    Map<String, dynamic>? authCredentials,
  }) = _CreateSessionRequestDto;
}

@freezed
abstract class LoadSessionRequestDto with _$LoadSessionRequestDto {
  const factory LoadSessionRequestDto({
    required String sessionId,
    required String serverHost,
    required int serverPort,
    String? cwd,
    List<Map<String, dynamic>>? mcpServers,
  }) = _LoadSessionRequestDto;
}

@freezed
abstract class SendPromptRequestDto with _$SendPromptRequestDto {
  const factory SendPromptRequestDto({
    required String sessionId,
    required String promptText,
  }) = _SendPromptRequestDto;
}

// ─── Response DTOs ────────────────────────────────────────────────────────

@freezed
abstract class InitializeResponseDto with _$InitializeResponseDto {
  const factory InitializeResponseDto({
    required Map<String, dynamic> serverCapabilities,
    required List<Map<String, dynamic>> availableAuthMethods,
    required String protocolVersion,
  }) = _InitializeResponseDto;
}

@freezed
abstract class CreateSessionResponseDto with _$CreateSessionResponseDto {
  const factory CreateSessionResponseDto({
    required String sessionId,
    required Map<String, dynamic> serverCapabilities,
    required bool isAuthenticated,
  }) = _CreateSessionResponseDto;
}

@freezed
abstract class LoadSessionResponseDto with _$LoadSessionResponseDto {
  const factory LoadSessionResponseDto({
    required String sessionId,
    required Map<String, dynamic> serverCapabilities,
    required bool isAuthenticated,
    @Default([]) List<Map<String, dynamic>> replayUpdates,
  }) = _LoadSessionResponseDto;
}

@freezed
abstract class SessionListItemDto with _$SessionListItemDto {
  const factory SessionListItemDto({
    required String sessionId,
    required String cwd,
    String? title,
    String? updatedAt,
  }) = _SessionListItemDto;
}

@freezed
abstract class ListSessionsResponseDto with _$ListSessionsResponseDto {
  const factory ListSessionsResponseDto({
    required List<SessionListItemDto> sessions,
  }) = _ListSessionsResponseDto;
}

@freezed
abstract class SendPromptResponseDto with _$SendPromptResponseDto {
  const factory SendPromptResponseDto({
    required String sessionId,
    required Map<String, dynamic> promptResult,
    @Default([]) List<Map<String, dynamic>> updates,
  }) = _SendPromptResponseDto;
}

@freezed
abstract class CancelSessionRequestDto with _$CancelSessionRequestDto {
  const factory CancelSessionRequestDto({
    required String sessionId,
  }) = _CancelSessionRequestDto;
}

@freezed
abstract class CancelSessionResponseDto with _$CancelSessionResponseDto {
  const factory CancelSessionResponseDto({
    required String sessionId,
  }) = _CancelSessionResponseDto;
}

@freezed
abstract class SetSessionModeRequestDto with _$SetSessionModeRequestDto {
  const factory SetSessionModeRequestDto({
    required String sessionId,
    required String modeId,
  }) = _SetSessionModeRequestDto;
}

@freezed
abstract class SetSessionModeResponseDto with _$SetSessionModeResponseDto {
  const factory SetSessionModeResponseDto({
    required String sessionId,
    required String modeId,
  }) = _SetSessionModeResponseDto;
}

@freezed
abstract class SetConfigOptionRequestDto with _$SetConfigOptionRequestDto {
  const factory SetConfigOptionRequestDto({
    required String sessionId,
    required String key,
    required String value,
  }) = _SetConfigOptionRequestDto;
}

@freezed
abstract class SetConfigOptionResponseDto with _$SetConfigOptionResponseDto {
  const factory SetConfigOptionResponseDto({
    required String sessionId,
  }) = _SetConfigOptionResponseDto;
}

@freezed
abstract class ForkSessionRequestDto with _$ForkSessionRequestDto {
  const factory ForkSessionRequestDto({
    required String sessionId,
    String? title,
  }) = _ForkSessionRequestDto;
}

@freezed
abstract class ForkSessionResponseDto with _$ForkSessionResponseDto {
  const factory ForkSessionResponseDto({
    required String sessionId,
    required String forkedSessionId,
  }) = _ForkSessionResponseDto;
}

@freezed
abstract class ResumeSessionRequestDto with _$ResumeSessionRequestDto {
  const factory ResumeSessionRequestDto({
    required String sessionId,
  }) = _ResumeSessionRequestDto;
}

@freezed
abstract class ResumeSessionResponseDto with _$ResumeSessionResponseDto {
  const factory ResumeSessionResponseDto({
    required String sessionId,
    @Default([]) List<Map<String, dynamic>> replayUpdates,
  }) = _ResumeSessionResponseDto;
}
