import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.sessionOpened({required String sessionId}) =
      ChatSessionOpened;

  const factory ChatEvent.promptSubmitted({required String text}) =
      ChatPromptSubmitted;

  const factory ChatEvent.promptCancelled() = ChatPromptCancelled;

  const factory ChatEvent.updateReceived({
    required Map<String, dynamic> update,
  }) = ChatUpdateReceived;

  const factory ChatEvent.cleared() = ChatCleared;
}
