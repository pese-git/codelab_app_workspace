import 'dart:async';
import 'dart:convert';

import 'package:codelab_desktop/infrastructure/transport/websocket_transport.dart';
import 'package:codelab_desktop/domain/entities/connection_state.dart';
import 'package:test/test.dart';

import '../../helpers/mock_acp_server.dart';

void main() {
  late MockAcpServer mockServer;
  late WebSocketTransport transport;

  setUp(() async {
    mockServer = MockAcpServer(port: 0);
    unawaited(mockServer.start());
    await Future.delayed(const Duration(milliseconds: 100));

    transport = WebSocketTransport(
      config: AcpServerConfig(
        host: '127.0.0.1',
        port: mockServer.actualPort,
        autoReconnect: false,
      ),
    );
  });

  tearDown(() async {
    await transport.dispose();
    await mockServer.stop();
  });

  group('WebSocketTransport', () {
    test('connects to server', () async {
      await transport.connect();
      expect(transport.isConnected, isTrue);
      expect(transport.connectionState, ConnectionState.connected);
    });

    test('sends and receives messages', () async {
      await transport.connect();

      final received = <Map<String, dynamic>>[];
      final sub = transport.incomingMessages.listen(received.add);

      await transport.sendMessage({'method': 'test', 'id': '1'});

      await Future.delayed(const Duration(milliseconds: 100));
      expect(received, isNotEmpty);

      await sub.cancel();
    });

    test('disconnects cleanly', () async {
      await transport.connect();
      expect(transport.isConnected, isTrue);

      await transport.disconnect();
      expect(transport.isConnected, isFalse);
      expect(transport.connectionState, ConnectionState.disconnected);
    });

    test('throws when sending while disconnected', () async {
      expect(
        () => transport.sendMessage({'method': 'test'}),
        throwsA(isA<StateError>()),
      );
    });

    test('parses incoming JSON messages', () async {
      await transport.connect();

      final completer = Completer<Map<String, dynamic>>();
      final sub = transport.incomingMessages.listen(
        (msg) {
          if (!completer.isCompleted) completer.complete(msg);
        },
      );

      await transport.sendMessage({'method': 'test', 'id': '1'});

      final msg = await completer.future.timeout(
        const Duration(seconds: 5),
      );

      expect(msg, isA<Map<String, dynamic>>());
      expect(msg['jsonrpc'], '2.0');
      expect(msg['id'], '1');

      await sub.cancel();
    });
  });
}
