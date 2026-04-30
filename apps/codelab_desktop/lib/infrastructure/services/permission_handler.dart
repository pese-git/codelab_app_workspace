import 'package:structured_log/structured_log.dart';

import '../transport/websocket_transport.dart';

class PermissionHandler {
  final _log = getLogger('PermissionHandler');

  Future<bool> requestPermission({
    required String toolName,
    required String description,
  }) async {
    return true;
  }

  Future<void> handleRaw(
    Map<String, dynamic> message,
    WebSocketTransport transport,
  ) async {
    final params = message['params'] as Map<String, dynamic>? ?? {};
    final toolName = params['toolName'] as String? ?? 'unknown';
    final description = params['description'] as String? ?? '';

    _log.debug('Permission requested: $toolName - $description');

    final granted = await requestPermission(
      toolName: toolName,
      description: description,
    );

    final messageId = message['id'];
    if (messageId != null) {
      await transport.sendMessage({
        'jsonrpc': '2.0',
        'id': messageId,
        'result': {'approved': granted},
      });
    }
  }
}
