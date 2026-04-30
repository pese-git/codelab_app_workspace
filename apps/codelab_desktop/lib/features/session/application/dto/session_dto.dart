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
