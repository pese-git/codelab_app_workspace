import 'package:codelab_desktop/core/error/failures.dart';
import 'package:codelab_desktop/domain/services/transport_service.dart';
import 'package:codelab_desktop/features/session/application/dto/session_dto.dart';
import 'package:codelab_desktop/features/session/application/use_cases/initialize_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockTransportService extends Mock implements TransportService {}

void main() {
  late MockTransportService mockTransport;
  late InitializeUseCase useCase;

  setUp(() {
    mockTransport = MockTransportService();
    useCase = InitializeUseCase(transport: mockTransport);

    when(() => mockTransport.connect()).thenAnswer((_) async {});
    when(() => mockTransport.disconnect()).thenAnswer((_) async {});
    when(() => mockTransport.send(any())).thenAnswer((_) async {});
    when(() => mockTransport.receive(requestId: any(named: 'requestId')))
        .thenAnswer((_) async {
      return {
        'jsonrpc': '2.0',
        'id': 'test-id',
        'result': {
          'protocolVersion': 1,
          'agentCapabilities': {
            'fs': {'readTextFile': true, 'writeTextFile': true},
            'terminal': true,
          },
          'authMethods': [],
        },
      };
    });
  });

  group('InitializeUseCase', () {
    test('connects and sends initialize request', () async {
      final result = await useCase.execute(
        const InitializeRequestDto(serverHost: 'localhost', serverPort: 8080),
      );

      result.fold(
        (failure) => fail('Expected success, got $failure'),
        (response) {
          expect(response.protocolVersion, '1');
          expect(response.serverCapabilities, isNotEmpty);
        },
      );

      verify(() => mockTransport.connect()).called(1);
      verify(
        () => mockTransport.send(
          any(that: containsPair('method', 'initialize')),
        ),
      ).called(1);
    });

    test('stores server capabilities', () async {
      final result = await useCase.execute(
        const InitializeRequestDto(serverHost: 'localhost', serverPort: 8080),
      );

      result.fold(
        (_) {},
        (response) {
          verify(
            () => mockTransport.setServerCapabilities(
              any(that: containsPair('terminal', true)),
            ),
          ).called(1);
        },
      );
    });

    test('returns TransportFailure on connection error', () async {
      when(() => mockTransport.connect())
          .thenThrow(Exception('Connection refused'));

      final result = await useCase.execute(
        const InitializeRequestDto(serverHost: 'localhost', serverPort: 8080),
      );

      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns ProtocolFailure on server error', () async {
      when(() => mockTransport.receive(requestId: any(named: 'requestId')))
          .thenAnswer((_) async {
        return {
          'jsonrpc': '2.0',
          'id': 'test-id',
          'error': {'code': -32600, 'message': 'Invalid request'},
        };
      });

      final result = await useCase.execute(
        const InitializeRequestDto(serverHost: 'localhost', serverPort: 8080),
      );

      result.fold(
        (failure) {
          expect(failure, isA<ProtocolFailure>());
          verify(() => mockTransport.disconnect()).called(1);
        },
        (_) => fail('Expected failure'),
      );
    });
  });
}
