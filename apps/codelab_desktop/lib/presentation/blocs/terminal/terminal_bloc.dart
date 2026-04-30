import 'package:bloc/bloc.dart';

import '../../../domain/entities/terminal_session.dart';
import 'terminal_event.dart';
import 'terminal_state.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  TerminalBloc() : super(TerminalState.initial()) {
    on<TerminalCreated>(_onCreated);
    on<TerminalOutputUpdated>(_onOutputUpdated);
    on<TerminalTerminated>(_onTerminated);
    on<TerminalReleased>(_onReleased);
  }

  void _onCreated(TerminalCreated event, Emitter<TerminalState> emit) {
    final session = TerminalSession.create(
      terminalId: event.terminalId,
      command: event.command,
    );
    emit(state.copyWith(
      terminals: {...state.terminals, event.terminalId: session},
    ));
  }

  void _onOutputUpdated(
    TerminalOutputUpdated event,
    Emitter<TerminalState> emit,
  ) {
    final session = state.terminals[event.terminalId];
    if (session == null) return;
    emit(state.copyWith(
      terminals: {
        ...state.terminals,
        event.terminalId: session.appendOutput(event.output),
      },
    ));
  }

  void _onTerminated(TerminalTerminated event, Emitter<TerminalState> emit) {
    final session = state.terminals[event.terminalId];
    if (session == null) return;
    emit(state.copyWith(
      terminals: {
        ...state.terminals,
        event.terminalId: session.markExited(event.exitCode),
      },
    ));
  }

  void _onReleased(TerminalReleased event, Emitter<TerminalState> emit) {
    final newTerminals = Map<String, TerminalSession>.from(state.terminals)
      ..remove(event.terminalId);
    emit(state.copyWith(terminals: newTerminals));
  }
}
