/// @deprecated Use `package:codelab_desktop/components.dart` instead.
/// This file is kept for backwards compatibility and will be removed in a future version.
///
/// The original terminal implementation remains here as it includes
/// platform-specific PTY code that depends on external packages.
///
/// Migrate shell wrapper to:
/// ```dart
/// import 'package:codelab_desktop/components.dart';
/// ```
library;

import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

import 'package:codelab_ui_components/codelab_ui_components.dart';

/// A terminal panel widget supporting interactive PTY sessions.
class TerminalPanel extends StatefulWidget {
  const TerminalPanel({this.workingDirectory, this.onExit, super.key});

  /// Working directory for the terminal session.
  final String? workingDirectory;

  /// Callback when the terminal session exits.
  final VoidCallback? onExit;

  @override
  State<TerminalPanel> createState() => _TerminalPanelState();
}

class _TerminalPanelState extends State<TerminalPanel> {
  late Terminal _terminal;
  Pty? _pty;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initTerminal();
  }

  void _initTerminal() {
    _terminal = Terminal(maxLines: 10000);

    try {
      _startPty();
      _isInitialized = true;
    } catch (e) {
      _error = 'Failed to start terminal: $e';
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _startPty() {
    final shell = _getShell();
    final workingDir = widget.workingDirectory ?? Directory.current.path;

    _pty = Pty.start(
      shell,
      columns: _terminal.viewWidth,
      rows: _terminal.viewHeight,
      workingDirectory: workingDir,
      environment: Platform.environment,
    );

    _pty!.output.listen((data) {
      _terminal.write(String.fromCharCodes(data));
    });

    _pty!.exitCode.then((exitCode) {
      _terminal.write('\r\n[Process exited with code $exitCode]\r\n');
      widget.onExit?.call();
    });

    _terminal.onOutput = (data) {
      _pty?.write(utf8.encode(data));
    };

    _terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      _pty?.resize(height, width);
    };
  }

  String _getShell() {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['SHELL'] ?? '/bin/bash';
    } else if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return '/bin/sh';
  }

  @override
  void dispose() {
    _pty?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    if (_error != null) {
      return Container(
        color: colors.backgroundBase,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.error_badge, size: 32, color: colors.errorBase),
              const SizedBox(height: AppSpacing.md),
              Text(
                _error!,
                style: AppTypography.body(color: colors.errorText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Button(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                  _initTerminal();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: colors.backgroundBase,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProgressRing(),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Starting terminal...',
                style: AppTypography.body(color: colors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: colors.backgroundBase,
      child: TerminalView(
        _terminal,
        theme: TerminalTheme(
          cursor: colors.accentPrimary,
          selection: colors.accentSubtle.withValues(alpha: 0.3),
          foreground: colors.textBase,
          background: colors.backgroundBase,
          black: const Color(0xFF000000),
          white: const Color(0xFFFFFFFF),
          red: colors.errorBase,
          green: colors.successBase,
          yellow: colors.warningBase,
          blue: colors.infoBase,
          magenta: const Color(0xFFD33682),
          cyan: const Color(0xFF2AA198),
          brightBlack: const Color(0xFF586E75),
          brightWhite: const Color(0xFFFDF6E3),
          brightRed: colors.errorStrong,
          brightGreen: colors.successStrong,
          brightYellow: colors.warningStrong,
          brightBlue: colors.infoStrong,
          brightMagenta: const Color(0xFF6C71C4),
          brightCyan: const Color(0xFF93A1A1),
          searchHitBackground: colors.warningSubtle,
          searchHitBackgroundCurrent: colors.warningBase,
          searchHitForeground: colors.backgroundBase,
        ),
        textStyle: TerminalStyle(
          fontFamily: AppTypography.fontFamilyMono,
          fontSize: AppTypography.fontSize13,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        autofocus: true,
      ),
    );
  }
}

/// Controller for managing multiple terminal sessions.
class TerminalSessionManager extends ChangeNotifier {
  final List<TerminalSessionData> _sessions = [];
  String? _activeSessionId;
  int _idCounter = 0;

  List<TerminalSessionData> get sessions => List.unmodifiable(_sessions);
  String? get activeSessionId => _activeSessionId;

  TerminalSessionData? get activeSession {
    if (_activeSessionId == null) return null;
    final idx = _sessions.indexWhere((s) => s.id == _activeSessionId);
    return idx != -1 ? _sessions[idx] : null;
  }

  String createSession({String? title, String? workingDirectory}) {
    final id = 'terminal_${++_idCounter}';
    final session = TerminalSessionData(
      id: id,
      title: title ?? 'Terminal $_idCounter',
      workingDirectory: workingDirectory,
    );
    _sessions.add(session);
    _activeSessionId = id;
    notifyListeners();
    return id;
  }

  void closeSession(String id) {
    final idx = _sessions.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    _sessions.removeAt(idx);
    if (_activeSessionId == id) {
      if (_sessions.isNotEmpty) {
        _activeSessionId = _sessions[idx.clamp(0, _sessions.length - 1)].id;
      } else {
        _activeSessionId = null;
      }
    }
    notifyListeners();
  }

  void activateSession(String id) {
    if (_activeSessionId == id) return;
    if (_sessions.any((s) => s.id == id)) {
      _activeSessionId = id;
      notifyListeners();
    }
  }
}

class TerminalSessionData {
  const TerminalSessionData({
    required this.id,
    required this.title,
    this.workingDirectory,
  });

  final String id;
  final String title;
  final String? workingDirectory;
}
