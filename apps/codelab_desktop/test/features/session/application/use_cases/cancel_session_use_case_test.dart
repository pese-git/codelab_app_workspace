import 'package:codelab_desktop/core/error/failures.dart';
import 'package:codelab_desktop/domain/services/transport_service.dart';
import 'package:codelab_desktop/features/session/application/dto/session_dto.dart';
import 'package:codelab_desktop/features/session/application/use_cases/cancel_session_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockTransportService extends Mock implements TransportService {}

void main() {
  late MockTransportService mockTransport;
  late CancelSessionUseCase useCase;

  setUp(() {
    mockTransport = MockTransportService();
    useCase = CancelSessionUseCase(transport: mockTransport);

    when(() => mockTransport.isInitialized()).thenReturn(true);
    when(() => mockTransport.send(any())).thenAnswer((_) async {});
    when(() => mockTransport.receive(requestId: any(named: 'requestId')))
        .thenAnswer((_) async {
      return {
        'jsonrpc': '2.0',
        'id': 'test-id',
        'result': {},
      };
    });
  });

  group('CancelSessionUseCase', () {
    test('sends cancel request and returns success', () async {
      final result = await useCase.execute(
        const CancelSessionRequestDto(sessionId: 'session-123'),
      );

      result.fold(
        (failure) => fail('Expected success, got $failure'),
        (response) {
          expect(response.sessionId, 'session-123');
        },
      );

      verify(
        () => mockTransport.send(any(that: containsPair('method', 'session/cancel'))),
      ).called(1);
    });

    test('returns failure when not initialized', () async {
      when(() => mockTransport.isInitialized()).thenReturn(false);

      final result = await useCase.execute(
        const CancelSessionRequestDto(sessionId: 'session-123'),
      );

      result.fold(
        (failure) => expect(failure, isA<SessionFailure>()),
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
        const CancelSessionRequestDto(sessionId: 'session-123'),
      );

      result.fold(
        (failure) {
          expect(failure, isA<ProtocolFailure>());
          expect((failure as ProtocolFailure).errorCode, -32600);
        },
        (_) => fail('Expected failure'),
      );
    });
  });
}
