import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';

class ListSessionsUseCase {
  ListSessionsUseCase({required this.sessionRepo});

  final SessionRepository sessionRepo;

  Future<List<Session>> execute() async {
    return sessionRepo.getAll();
  }
}
