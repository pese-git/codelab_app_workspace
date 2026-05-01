import 'dart:async';

import 'package:codelab_desktop/core/error/failures.dart';
import 'package:codelab_desktop/domain/entities/connection_state.dart';
import 'package:codelab_desktop/domain/services/transport_service.dart';
import 'package:codelab_desktop/infrastructure/services/acp_transport_service.dart';
import 'package:codelab_desktop/infrastructure/services/permission_handler.dart';
import 'package:codelab_desktop/infrastructure/transport/websocket_transport.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWebSocketTransport extends Mock implements WebSocketTransport {}

class MockPermissionHandler extends Mock implements PermissionHandler {}

void main() {
  late MockWebSocketTransport mockWsTransport;
  late MockPermissionHandler mockPermissionHandler;
  late AcpTransportService transportService;

  setUp(() {
    mockWsTransport = MockWebSocketTransport();
    mockPermissionHandler = MockPermissionHandler();

    when(() => mockWsTransport.isConnected).thenReturn(false);
    when(() => mockWsTransport.connectionState)
        .thenReturn(ConnectionState.disconnected);
    when(() => mockWsTransport.connectionStateStream)
        .thenAnswer((_) => const Stream<ConnectionState>.empty());

    transportService = AcpTransportService(
      config: const AcpServerConfig(host: 'localhost', port: 8080),
      permissionHandler: mockPermissionHandler,
    );
  });

  group('AcpTransportService', () {
    test('isConnected returns false when not connected', () {
      expect(transportService.isConnected(), isFalse);
    });

    test('isInitialized returns false when not initialized', () {
      expect(transportService.isInitialized(), isFalse);
    });

    test('setServerCapabilities stores capabilities', () {
      final capabilities = {'fs': true, 'terminal': true};
      transportService.setServerCapabilities(capabilities);

      expect(transportService.isInitialized(), isTrue);
      expect(transportService.getServerCapabilities(), capabilities);
    });

    test('getServerCapabilities throws when not initialized', () {
      expect(
        () => transportService.getServerCapabilities(),
        throwsA(isA<SessionFailure>()),
      );
    });
  });
}
