import '../../domain/services/transport_service.dart';
import '../../domain/repositories/session_repository.dart';

class ListSessionsUseCase {
  ListSessionsUseCase({
    required this.transport,
    required this.sessionRepo,
  });

  final TransportService transport;
  final SessionRepository sessionRepo;

  Future<List<String>> execute() async {
    return sessionRepo.listSessions();
  }
}
