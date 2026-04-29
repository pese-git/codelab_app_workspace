abstract class SessionRepository {
  Future<void> saveSession(String sessionId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> loadSession(String sessionId);
  Future<List<String>> listSessions();
  Future<void> deleteSession(String sessionId);
}
