import 'package:codelab_desktop/core/error/failures.dart';
import 'package:codelab_desktop/domain/entities/chat_message.dart';
import 'package:codelab_desktop/features/session/application/dto/session_dto.dart';
import 'package:codelab_desktop/features/session/application/use_cases/cancel_session_use_case.dart';
import 'package:codelab_desktop/features/session/application/use_cases/send_prompt_use_case.dart';
import 'package:codelab_desktop/features/session/presentation/blocs/chat/chat_bloc.dart';
import 'package:codelab_desktop/features/session/presentation/blocs/chat/chat_event.dart';
import 'package:codelab_desktop/features/session/presentation/blocs/chat/chat_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSendPromptUseCase extends Mock implements SendPromptUseCase {}

class MockCancelSessionUseCase extends Mock implements CancelSessionUseCase {}

final _successResponse = right<Failure, SendPromptResponseDto>(
  SendPromptResponseDto(
    sessionId: 'session-1',
    promptResult: {'stopReason': 'end_turn'},
  ),
);

final _cancelResponse = right<Failure, CancelSessionResponseDto>(
  CancelSessionResponseDto(sessionId: 'session-1'),
);

void main() {
  setUpAll(() {
    registerFallbackValue(SendPromptRequestDto(sessionId: '', promptText: ''));
    registerFallbackValue(const PromptCallbacks());
    registerFallbackValue(CancelSessionRequestDto(sessionId: ''));
  });

  group('ChatBloc', () {
    test('initial state has empty messages', () {
      final mockSendPrompt = MockSendPromptUseCase();
      final mockCancel = MockCancelSessionUseCase();

      when(() => mockSendPrompt.execute(any(), callbacks: any(named: 'callbacks'))).thenAnswer((_) async => _successResponse);
      when(() => mockCancel.execute(any())).thenAnswer((_) async => _cancelResponse);

      final bloc = ChatBloc(
        sendPromptUseCase: mockSendPrompt,
        cancelSessionUseCase: mockCancel,
      );
      expect(bloc.state.sessionId, '');
      expect(bloc.state.messages, isEmpty);
      expect(bloc.state.isProcessing, isFalse);
      bloc.close();
    });
  });
}
