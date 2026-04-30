import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal_event.freezed.dart';

@freezed
sealed class TerminalEvent with _$TerminalEvent {
  const factory TerminalEvent.terminalCreated({
    required String terminalId,
    required String command,
  }) = TerminalCreated;

  const factory TerminalEvent.outputUpdated({
    required String terminalId,
    required String output,
  }) = TerminalOutputUpdated;

  const factory TerminalEvent.terminated({
    required String terminalId,
    required int exitCode,
  }) = TerminalTerminated;

  const factory TerminalEvent.released({
    required String terminalId,
  }) = TerminalReleased;
}
