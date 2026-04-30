import '../entities/session.dart';

/// Интерфейс репозитория для управления ACP сессиями
///
/// Определяет контракт для хранения и получения сессий.
/// Реализации: [InMemorySessionRepository], (будущее) LocalStorageSessionRepository
abstract interface class SessionRepository {
  /// Сохраняет или обновляет сессию
  Future<void> save(Session session);

  /// Загружает сессию по ID
  /// Возвращает null если сессия не найдена
  Future<Session?> load(String sessionId);

  /// Удаляет сессию по ID
  Future<void> delete(String sessionId);

  /// Возвращает все сохранённые сессии
  Future<List<Session>> getAll();

  /// Очищает все сессии
  Future<void> clear();
}
