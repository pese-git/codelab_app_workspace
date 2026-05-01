import 'dart:convert';
import 'dart:io';

import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class TerminalSessionHandle {
  TerminalSessionHandle({
    required this.id,
    required this.pty,
    required this.terminal,
    required this.title,
    this.workingDirectory,
  });

  final String id;
  final Pty pty;
  final Terminal terminal;
  final String title;
  final String? workingDirectory;

  TerminalSessionHandle copyWith({String? title}) {
    return TerminalSessionHandle(
      id: id,
      pty: pty,
      terminal: terminal,
      title: title ?? this.title,
      workingDirectory: workingDirectory,
    );
  }
}

class TerminalManager {
  final Map<String, TerminalSessionHandle> _sessions = {};
  int _idCounter = 0;

  Map<String, TerminalSessionHandle> get sessions => Map.unmodifiable(_sessions);

  TerminalSessionHandle? getHandle(String id) => _sessions[id];

  Terminal? getTerminal(String id) => _sessions[id]?.terminal;

  String createSession({
    String? title,
    String? workingDirectory,
  }) {
    final id = 'term_${++_idCounter}';
    final terminal = Terminal(
      maxLines: 10000,
      onOutput: (data) {
        _sessions[id]?.pty.write(utf8.encode(data));
      },
      onResize: (width, height, pixelWidth, pixelHeight) {
        _sessions[id]?.pty.resize(height, width);
      },
    );

    final shell = _getShell();
    var workDir = workingDirectory ?? Directory.current.path;

    if (!Directory(workDir).existsSync()) {
      workDir = Directory.current.path;
    }

    final pty = Pty.start(
      shell,
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
      workingDirectory: workDir,
      environment: Platform.environment,
    );

    pty.output.listen((data) {
      terminal.write(String.fromCharCodes(data));
    });

    pty.exitCode.then((exitCode) {
      if (exitCode != 0) {
        terminal.write(
          '\r\n[Process exited with code $exitCode]\r\n',
        );
      }
    });

    final handle = TerminalSessionHandle(
      id: id,
      pty: pty,
      terminal: terminal,
      title: title ?? 'Terminal $_idCounter',
      workingDirectory: workDir,
    );

    _sessions[id] = handle;
    return id;
  }

  void closeSession(String id) {
    final handle = _sessions.remove(id);
    if (handle != null) {
      handle.pty.kill();
    }
  }

  void renameSession(String id, String title) {
    final handle = _sessions[id];
    if (handle != null) {
      _sessions[id] = handle.copyWith(title: title);
    }
  }

  void resizeSession(String id, int rows, int cols) {
    _sessions[id]?.pty.resize(rows, cols);
  }

  void write(String id, String data) {
    _sessions[id]?.pty.write(utf8.encode(data));
  }

  void closeAll() {
    for (final handle in _sessions.values) {
      handle.pty.kill();
    }
    _sessions.clear();
  }

  void dispose() {
    closeAll();
  }

  String _getShell() {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['SHELL'] ?? '/bin/bash';
    } else if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return '/bin/sh';
  }
}
