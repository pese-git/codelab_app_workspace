import '../../domain/services/transport_service.dart';

class SendPromptUseCase {
  SendPromptUseCase({required this.transport});

  final TransportService transport;

  Future<Map<String, dynamic>> execute({
    required String sessionId,
    required String prompt,
  }) async {
    return transport.requestWithCallbacks(
      method: 'session/prompt',
      params: {'sessionId': sessionId, 'prompt': prompt},
    );
  }
}
