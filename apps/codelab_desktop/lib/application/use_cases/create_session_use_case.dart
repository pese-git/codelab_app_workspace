import '../../domain/services/transport_service.dart';
import '../../domain/repositories/session_repository.dart';

class CreateSessionUseCase {
  CreateSessionUseCase({
    required this.transport,
    required this.sessionRepo,
  });

  final TransportService transport;
  final SessionRepository sessionRepo;

  Future<String> execute({required String cwd}) async {
    final response = await transport.sendRequest('session/new', {'cwd': cwd});
    final sessionId = response['sessionId'] as String;
    await sessionRepo.saveSession(sessionId, {'cwd': cwd});
    return sessionId;
  }
}
