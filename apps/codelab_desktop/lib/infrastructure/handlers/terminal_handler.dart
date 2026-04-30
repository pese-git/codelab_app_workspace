import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:structured_log/structured_log.dart';
import 'package:uuid/uuid.dart';

import '../../domain/services/terminal_service.dart';
import '../../core/error/failures.dart';

class _TerminalProcess {
  _TerminalProcess({
    required this.process,
    required this.outputBuffer,
    required this.stdoutSub,
    required this.stderrSub,
  });

  final Process process;
  final StringBuffer outputBuffer;
  bool hasExited = false;
  int? exitCode;
  final StreamSubscription<List<int>> stdoutSub;
  final StreamSubscription<List<int>> stderrSub;
}

/// Реализация TerminalService через dart:io Process
///
/// Управляет пулом запущенных процессов.
/// Аналог Python: infrastructure/services/terminal_executor.py
/// Регистрируется в SessionModule как singleton TerminalService.
class TerminalHandler implements TerminalService {
  TerminalHandler();

  final _log = getLogger('TerminalHandler');
  final _uuid = const Uuid();
  final Map<String, _TerminalProcess> _processes = {};

  @override
  Future<String> create({
    required String command,
    List<String>? args,
    Map<String, String>? env,
    String? cwd,
    int? outputByteLimit,
  }) async {
    _log.debug('terminal/create: $command');

    try {
      final process = await Process.start(
        command,
        args ?? [],
        environment: env,
        workingDirectory: cwd,
        runInShell: true,
      );

      final buffer = StringBuffer();
      final int byteLimit = outputByteLimit ?? 1024 * 1024;
      int bytesCollected = 0;

      final stdoutSub = process.stdout.listen((bytes) {
        if (bytesCollected < byteLimit) {
          final text = utf8.decode(bytes, allowMalformed: true);
          buffer.write(text);
          bytesCollected += bytes.length;
        }
      });

      final stderrSub = process.stderr.listen((bytes) {
        if (bytesCollected < byteLimit) {
          final text = utf8.decode(bytes, allowMalformed: true);
          buffer.write(text);
          bytesCollected += bytes.length;
        }
      });

      final terminalId = 'term_${_uuid.v4().substring(0, 8)}';
      final termProcess = _TerminalProcess(
        process: process,
        outputBuffer: buffer,
        stdoutSub: stdoutSub,
        stderrSub: stderrSub,
      );

      unawaited(
        process.exitCode.then((code) {
          termProcess.hasExited = true;
          termProcess.exitCode = code;
          _log.debug('Terminal $terminalId exited with code $code');
        }),
      );

      _processes[terminalId] = termProcess;
      _log.debug('Created terminal $terminalId for command: $command');

      return terminalId;
    } catch (e) {
      throw TerminalFailure(
        message: 'Failed to create terminal: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getOutput(String terminalId) async {
    final proc = _getProcess(terminalId);
    final output = proc.outputBuffer.toString();
    return {
      'output': output,
      'hasMore': !proc.hasExited,
    };
  }

  @override
  Future<Map<String, dynamic>> waitForExit(String terminalId) async {
    final proc = _getProcess(terminalId);

    final exitCode = proc.hasExited
        ? proc.exitCode!
        : await proc.process.exitCode;

    return {
      'exitCode': exitCode,
      'output': proc.outputBuffer.toString(),
    };
  }

  @override
  Future<void> release(String terminalId) async {
    final proc = _processes.remove(terminalId);
    if (proc == null) return;

    await proc.stdoutSub.cancel();
    await proc.stderrSub.cancel();

    if (!proc.hasExited) {
      proc.process.kill();
    }

    _log.debug('Released terminal $terminalId');
  }

  @override
  Future<bool> kill(String terminalId) async {
    final proc = _processes[terminalId];
    if (proc == null) return false;

    if (proc.hasExited) return false;

    final killed = proc.process.kill(ProcessSignal.sigkill);
    _log.debug('Killed terminal $terminalId: $killed');
    return killed;
  }

  _TerminalProcess _getProcess(String terminalId) {
    final proc = _processes[terminalId];
    if (proc == null) {
      throw TerminalFailure(
        message: 'Terminal not found: $terminalId',
        terminalId: terminalId,
      );
    }
    return proc;
  }

  Future<void> dispose() async {
    for (final entry in _processes.entries) {
      await release(entry.key);
    }
  }
}
