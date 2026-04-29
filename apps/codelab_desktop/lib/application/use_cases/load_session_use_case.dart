import '../../domain/services/transport_service.dart';
import '../../domain/repositories/session_repository.dart';

class LoadSessionUseCase {
  LoadSessionUseCase({
    required this.transport,
    required this.sessionRepo,
  });

  final TransportService transport;
  final SessionRepository sessionRepo;

  Future<Map<String, dynamic>?> execute(String sessionId) async {
    return sessionRepo.loadSession(sessionId);
  }
}
