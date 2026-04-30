import '../entities/chat_message.dart';

/// Интерфейс репозитория для истории сообщений чата
///
/// Хранит сообщения, привязанные к конкретной сессии.
abstract interface class ChatHistoryRepository {
  /// Добавляет сообщение в историю сессии
  Future<void> addMessage(String sessionId, ChatMessage message);

  /// Обновляет существующее сообщение (например, при завершении streaming)
  Future<void> updateMessage(String sessionId, ChatMessage message);

  /// Загружает всю историю сессии
  Future<List<ChatMessage>> getHistory(String sessionId);

  /// Очищает историю сессии
  Future<void> clearHistory(String sessionId);
}
