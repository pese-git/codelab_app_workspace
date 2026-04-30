import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';

/// In-memory реализация SessionRepository
///
/// Хранит сессии в памяти. При перезапуске данные теряются.
/// Для персистентности заменить на LocalStorageSessionRepository.
/// Регистрируется в AppModule как singleton SessionRepository.
class InMemorySessionRepository implements SessionRepository {
  final Map<String, Session> _sessions = {};

  @override
  Future<void> save(Session session) async {
    _sessions[session.id] = session;
  }

  @override
  Future<Session?> load(String sessionId) async {
    return _sessions[sessionId];
  }

  @override
  Future<void> delete(String sessionId) async {
    _sessions.remove(sessionId);
  }

  @override
  Future<List<Session>> getAll() async {
    return List.unmodifiable(_sessions.values);
  }

  @override
  Future<void> clear() async {
    _sessions.clear();
  }
}
