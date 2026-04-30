import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../domain/entities/terminal_session.dart';

part 'terminal_state.freezed.dart';

@freezed
sealed class TerminalState with _$TerminalState {
  const factory TerminalState({
    @Default({}) Map<String, TerminalSession> terminals,
  }) = _TerminalState;

  factory TerminalState.initial() => const TerminalState();

  const TerminalState._();

  List<TerminalSession> get activeSessions =>
      terminals.values
          .where((t) => t.status == TerminalSessionStatus.running)
          .toList();
}
