import 'package:bloc/bloc.dart';
import 'package:structured_log/structured_log.dart';

import '../../../application/use_cases/send_prompt_use_case.dart';
import '../../../application/dto/session_dto.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/tool_call_record.dart';
import '../../../infrastructure/dto/session_update.dart';
import '../../../infrastructure/dto/tool_call.dart';
import '../../../infrastructure/dto/plan.dart';
import '../../../infrastructure/mappers/tool_call_record_mapper.dart';
import '../../../infrastructure/mappers/plan_state_mapper.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required SendPromptUseCase sendPromptUseCase})
      : _sendPromptUseCase = sendPromptUseCase,
        super(ChatState.initial('')) {
    on<ChatSessionOpened>(_onSessionOpened);
    on<ChatPromptSubmitted>(_onPromptSubmitted);
    on<ChatUpdateReceived>(_onUpdateReceived);
    on<ChatPromptCancelled>(_onPromptCancelled);
    on<ChatCleared>(_onCleared);
  }

  final _log = getLogger('ChatBloc');
  final SendPromptUseCase _sendPromptUseCase;
  final _updateParser = SessionUpdateParser();

  void _onSessionOpened(
    ChatSessionOpened event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatState.initial(event.sessionId));
  }

  Future<void> _onPromptSubmitted(
    ChatPromptSubmitted event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isProcessing) return;

    final userMessage = ChatMessage.userMessage(event.text);
    final agentMessage = ChatMessage.agentMessageStreaming();

    emit(state.copyWith(
      messages: [...state.messages, userMessage, agentMessage],
      isProcessing: true,
      streamingMessageId: agentMessage.id,
      errorMessage: null,
    ));

    final result = await _sendPromptUseCase.execute(
      SendPromptRequestDto(
        sessionId: state.sessionId,
        promptText: event.text,
      ),
      callbacks: PromptCallbacks(
        onUpdate: (update) => add(ChatEvent.updateReceived(update: update)),
      ),
    );

    result.fold(
      (failure) {
        _log.error('Prompt failed: ${failure.message}');
        emit(state.copyWith(
          isProcessing: false,
          streamingMessageId: null,
          errorMessage: failure.message,
          messages: _finalizeStreamingMessage(state.messages, agentMessage.id),
        ));
      },
      (response) {
        emit(state.copyWith(
          isProcessing: false,
          streamingMessageId: null,
          messages: _finalizeStreamingMessage(state.messages, agentMessage.id),
        ));
      },
    );
  }

  void _onUpdateReceived(
    ChatUpdateReceived event,
    Emitter<ChatState> emit,
  ) {
    final parsed = _updateParser.parse(
      SessionUpdatePayload.fromJson(event.update),
    );

    switch (parsed) {
      case MessageChunkUpdate():
        _handleMessageChunk(parsed, emit);
      case ThoughtChunkUpdate():
        _handleThoughtChunk(parsed);
      case ToolCallCreatedUpdate():
        _handleToolCallCreated(parsed, emit);
      case ToolCallStateUpdate():
        _handleToolCallUpdate(parsed, emit);
      case PlanUpdate():
        _handlePlanUpdate(parsed, emit);
      default:
        break;
    }
  }

  void _handleMessageChunk(
    MessageChunkUpdate update,
    Emitter<ChatState> emit,
  ) {
    final text = update.text;
    if (text == null || text.isEmpty) return;

    final streamingId = state.streamingMessageId;
    if (streamingId == null) return;

    final updatedMessages = state.messages.map((msg) {
      if (msg.id == streamingId) {
        return msg.appendChunk(text);
      }
      return msg;
    }).toList();

    emit(state.copyWith(messages: updatedMessages));
  }

  void _handleThoughtChunk(ThoughtChunkUpdate update) {
    _log.debug('Thought chunk received');
  }

  void _handleToolCallCreated(
    ToolCallCreatedUpdate update,
    Emitter<ChatState> emit,
  ) {
    final record = ToolCallRecordMapper.fromCreatedUpdate(update);
    final newToolCalls = Map<String, ToolCallRecord>.from(state.toolCalls);
    newToolCalls[update.toolCallId] = record;
    emit(state.copyWith(toolCalls: newToolCalls));
  }

  void _handleToolCallUpdate(
    ToolCallStateUpdate update,
    Emitter<ChatState> emit,
  ) {
    final existing = state.toolCalls[update.toolCallId];
    if (existing == null) return;

    final newToolCalls = Map<String, ToolCallRecord>.from(state.toolCalls);
    newToolCalls[update.toolCallId] = ToolCallRecordMapper.applyUpdate(
      existing,
      update,
    );
    emit(state.copyWith(toolCalls: newToolCalls));
  }

  void _handlePlanUpdate(
    PlanUpdate update,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      plan: PlanStateMapper.fromUpdate(state.plan, update),
    ));
  }

  void _onPromptCancelled(
    ChatPromptCancelled event,
    Emitter<ChatState> emit,
  ) {
    if (!state.isProcessing) return;
    emit(state.copyWith(
      isProcessing: false,
      streamingMessageId: null,
    ));
  }

  void _onCleared(ChatCleared event, Emitter<ChatState> emit) {
    emit(ChatState.initial(state.sessionId));
  }

  List<ChatMessage> _finalizeStreamingMessage(
    List<ChatMessage> messages,
    String messageId,
  ) {
    return messages.map((msg) {
      if (msg.id == messageId) return msg.complete();
      return msg;
    }).toList();
  }
}
