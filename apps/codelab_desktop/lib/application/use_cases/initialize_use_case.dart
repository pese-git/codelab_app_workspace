import '../../domain/services/transport_service.dart';

class InitializeUseCase {
  InitializeUseCase({required this.transport});

  final TransportService transport;

  Future<void> execute({
    required String serverHost,
    required int serverPort,
  }) async {
    await transport.connect();
  }
}
