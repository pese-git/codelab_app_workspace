import '../../domain/repositories/session_repository.dart';

class InMemorySessionRepository implements SessionRepository {
  final Map<String, Map<String, dynamic>> _sessions = {};

  @override
  Future<void> saveSession(String sessionId, Map<String, dynamic> data) async {
    _sessions[sessionId] = data;
  }

  @override
  Future<Map<String, dynamic>?> loadSession(String sessionId) async {
    return _sessions[sessionId];
  }

  @override
  Future<List<String>> listSessions() async {
    return _sessions.keys.toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    _sessions.remove(sessionId);
  }
}
