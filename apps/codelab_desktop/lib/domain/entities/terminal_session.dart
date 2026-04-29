import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal_session.freezed.dart';

enum TerminalSessionStatus { running, exited, killed }

@freezed
abstract class TerminalSession with _$TerminalSession {
  const factory TerminalSession({
    required String terminalId,
    required String command,
    required TerminalSessionStatus status,
    required DateTime createdAt,
    @Default('') String output,
    int? exitCode,
  }) = _TerminalSession;

  const TerminalSession._();

  factory TerminalSession.create({
    required String terminalId,
    required String command,
  }) {
    return TerminalSession(
      terminalId: terminalId,
      command: command,
      status: TerminalSessionStatus.running,
      createdAt: DateTime.now().toUtc(),
    );
  }

  TerminalSession appendOutput(String newOutput) {
    return copyWith(output: output + newOutput);
  }

  TerminalSession markExited(int exitCode) {
    return copyWith(
      status: TerminalSessionStatus.exited,
      exitCode: exitCode,
    );
  }
}
