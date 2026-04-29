import '../entities/chat_message.dart';

abstract interface class ChatHistoryRepository {
  Future<void> addMessage(String sessionId, ChatMessage message);
  Future<void> updateMessage(String sessionId, ChatMessage message);
  Future<List<ChatMessage>> getHistory(String sessionId);
  Future<void> clearHistory(String sessionId);
}
