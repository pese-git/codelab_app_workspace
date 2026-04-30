import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../application/dto/session_dto.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.initial() = SessionInitial;
  const factory SessionState.loading() = SessionLoading;

  const factory SessionState.initialized({
    required InitializeResponseDto initResponse,
  }) = SessionInitialized;

  const factory SessionState.sessionListLoaded({
    required InitializeResponseDto initResponse,
    required ListSessionsResponseDto listResponse,
  }) = SessionListLoaded;

  const factory SessionState.active({
    required String sessionId,
    required String serverHost,
    required int serverPort,
  }) = SessionActive;

  const factory SessionState.error({
    required String message,
    SessionState? previousState,
  }) = SessionError;
}
