import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_history_repository.dart';

/// In-memory реализация ChatHistoryRepository
///
/// Хранит историю сообщений в памяти, привязанную к sessionId.
/// При перезапуске данные теряются.
/// Регистрируется в AppModule как singleton ChatHistoryRepository.
class InMemoryChatHistoryRepository implements ChatHistoryRepository {
  final Map<String, List<ChatMessage>> _histories = {};

  @override
  Future<void> addMessage(String sessionId, ChatMessage message) async {
    _histories.putIfAbsent(sessionId, () => []).add(message);
  }

  @override
  Future<void> updateMessage(String sessionId, ChatMessage message) async {
    final history = _histories[sessionId];
    if (history == null) return;
    final index = history.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      history[index] = message;
    }
  }

  @override
  Future<List<ChatMessage>> getHistory(String sessionId) async {
    return List.unmodifiable(_histories[sessionId] ?? []);
  }

  @override
  Future<void> clearHistory(String sessionId) async {
    _histories.remove(sessionId);
  }
}
