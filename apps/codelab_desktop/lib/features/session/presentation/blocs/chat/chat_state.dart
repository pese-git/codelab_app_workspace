import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/chat_message.dart';
import '../../../../../domain/entities/tool_call_record.dart';
import '../../../../../domain/entities/plan_state.dart';

part 'chat_state.freezed.dart';

@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState({
    required String sessionId,
    @Default([]) List<ChatMessage> messages,
    @Default({}) Map<String, ToolCallRecord> toolCalls,
    @Default(PlanState()) PlanState plan,
    @Default(false) bool isProcessing,
    String? errorMessage,
    String? streamingMessageId,
  }) = _ChatState;

  factory ChatState.initial(String sessionId) =>
      ChatState(sessionId: sessionId);

  const ChatState._();

  bool get hasMessages => messages.isNotEmpty;
  bool get hasToolCalls => toolCalls.isNotEmpty;
  bool get hasPlan => !plan.isEmpty;
}
