import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';

class LoadSessionUseCase {
  LoadSessionUseCase({required this.sessionRepo});

  final SessionRepository sessionRepo;

  Future<Session?> execute(String sessionId) async {
    return sessionRepo.load(sessionId);
  }
}
