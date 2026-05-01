import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

/// Mock ACP сервер для тестирования
///
/// Поднимает настоящий WebSocket сервер на localhost
/// и эмулирует поведение ACP сервера.
class MockAcpServer {
  MockAcpServer({
    this.port = 0,
    this.autoRespondToInitialize = true,
    this.autoRespondToPrompt = true,
  });

  final int port;
  final bool autoRespondToInitialize;
  final bool autoRespondToPrompt;

  HttpServer? _server;
  final List<Map<String, dynamic>> receivedMessages = [];
  final List<WebSocket> _clients = [];

  int get actualPort => _server?.port ?? 0;
  bool get isRunning => _server != null;

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    await for (final HttpRequest request in _server!) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final socket = await WebSocketTransformer.upgrade(request);
        _handleWebSocket(socket);
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.close();
      }
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  void _handleWebSocket(WebSocket socket) {
    _clients.add(socket);
    socket.listen(
      (dynamic raw) {
        final message = jsonDecode(raw as String) as Map<String, dynamic>;
        receivedMessages.add(message);

        final method = message['method'] as String?;
        final id = message['id'];

        if (method == 'initialize' && autoRespondToInitialize && id != null) {
          _sendResponse(socket, id, {
            'protocolVersion': 1,
            'agentCapabilities': {
              'fs': {'readTextFile': true, 'writeTextFile': true},
              'terminal': true,
            },
            'authMethods': [],
          });
        } else if (method == 'session/new' && id != null) {
          _sendResponse(socket, id, {
            'sessionId': 'test_session_123',
          });
        } else if (method == 'session/list' && id != null) {
          _sendResponse(socket, id, {
            'sessions': [
              {
                'sessionId': 'test_session_123',
                'cwd': '/test/path',
                'title': 'Test Session',
                'updatedAt': '2024-01-01T00:00:00Z',
              },
            ],
          });
        } else if (method == 'session/load' && id != null) {
          _sendResponse(socket, id, {});
        } else if (method == 'session/cancel' && id != null) {
          _sendResponse(socket, id, {});
        } else if (method == 'session/prompt' && id != null) {
          if (autoRespondToPrompt) {
            _sendResponse(socket, id, {
              'stopReason': 'end_turn',
            });
          }
        } else if (method == 'session/set_mode' && id != null) {
          _sendResponse(socket, id, {});
        } else if (method == 'session/set_config_option' && id != null) {
          _sendResponse(socket, id, {});
        } else if (method == 'unstable_forkSession' && id != null) {
          _sendResponse(socket, id, {
            'sessionId': 'forked_session_456',
          });
        } else if (method == 'unstable_resumeSession' && id != null) {
          _sendResponse(socket, id, {});
        } else if (id != null) {
          _sendResponse(socket, id, {});
        }
      },
      onError: (error) {},
      onDone: () {
        socket.close();
      },
    );
  }

  void _sendResponse(WebSocket socket, dynamic id, Map<String, dynamic> result) {
    final response = {
      'jsonrpc': '2.0',
      'id': id,
      'result': result,
    };
    socket.add(jsonEncode(response));
  }

  Future<void> sendNotification(Map<String, dynamic> notification) async {
    if (_server == null) return;

    for (final WebSocket socket in _clients) {
      socket.add(jsonEncode(notification));
    }
  }
}
