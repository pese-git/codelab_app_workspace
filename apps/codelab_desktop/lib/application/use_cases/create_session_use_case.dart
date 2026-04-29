import '../../domain/entities/session.dart';
import '../../domain/services/transport_service.dart';
import '../../domain/repositories/session_repository.dart';

class CreateSessionUseCase {
  CreateSessionUseCase({
    required this.transport,
    required this.sessionRepo,
  });

  final TransportService transport;
  final SessionRepository sessionRepo;

  Future<Session> execute({required String cwd}) async {
    final response = await transport.requestWithCallbacks(
      method: 'session/new',
      params: {'cwd': cwd},
    );
    final sessionId = response['sessionId'] as String;
    final session = Session.create(
      serverHost: 'localhost',
      serverPort: 0,
      clientCapabilities: {},
      serverCapabilities: transport.getServerCapabilities(),
      sessionId: sessionId,
      cwd: cwd,
    );
    await sessionRepo.save(session);
    return session;
  }
}
