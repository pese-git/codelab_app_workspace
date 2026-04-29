import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

enum ChatMessageRole { user, agent, system }

enum ChatMessageStatus { pending, streaming, complete, error }

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required ChatMessageRole role,
    required String text,
    required ChatMessageStatus status,
    required DateTime timestamp,
    String? thoughtText,
  }) = _ChatMessage;

  const ChatMessage._();

  factory ChatMessage.userMessage(String text) {
    return ChatMessage(
      id: _generateId(),
      role: ChatMessageRole.user,
      text: text,
      status: ChatMessageStatus.complete,
      timestamp: DateTime.now().toUtc(),
    );
  }

  factory ChatMessage.agentMessageStreaming() {
    return ChatMessage(
      id: _generateId(),
      role: ChatMessageRole.agent,
      text: '',
      status: ChatMessageStatus.streaming,
      timestamp: DateTime.now().toUtc(),
    );
  }

  ChatMessage appendChunk(String chunk) {
    return copyWith(text: text + chunk);
  }

  ChatMessage complete() {
    return copyWith(status: ChatMessageStatus.complete);
  }

  static String _generateId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}';
  }
}
