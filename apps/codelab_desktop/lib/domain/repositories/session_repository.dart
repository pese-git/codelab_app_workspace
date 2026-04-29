import '../entities/session.dart';

abstract interface class SessionRepository {
  Future<void> save(Session session);
  Future<Session?> load(String sessionId);
  Future<void> delete(String sessionId);
  Future<List<Session>> getAll();
  Future<void> clear();
}
