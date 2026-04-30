import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_event.freezed.dart';

@freezed
sealed class SessionEvent with _$SessionEvent {
  const factory SessionEvent.initialize({
    required String serverHost,
    required int serverPort,
  }) = SessionInitializeRequested;

  const factory SessionEvent.listSessions() = SessionListRequested;

  const factory SessionEvent.createSession({
    required String cwd,
  }) = SessionCreateRequested;

  const factory SessionEvent.loadSession({
    required String sessionId,
  }) = SessionLoadRequested;

  const factory SessionEvent.disconnect() = SessionDisconnectRequested;
}
