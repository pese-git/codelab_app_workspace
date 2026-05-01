import 'package:flutter/foundation.dart';
import 'package:xterm/xterm.dart' show Terminal;

import '../../../domain/services/terminal_manager.dart';

@immutable
class TerminalSession {
  const TerminalSession({required this.id, required this.title});

  final String id;
  final String title;

  TerminalSession copyWith({String? title}) {
    return TerminalSession(id: id, title: title ?? this.title);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerminalSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class TerminalController extends ChangeNotifier {
  TerminalController({TerminalManager? terminalManager})
      : _terminalManager = terminalManager ?? TerminalManager();

  final List<TerminalSession> _sessions = <TerminalSession>[];
  final TerminalManager _terminalManager;
  String? _activeSessionId;

  List<TerminalSession> get sessions => List.unmodifiable(_sessions);
  String? get activeSessionId => _activeSessionId;
  TerminalManager get terminalManager => _terminalManager;

  TerminalSession? get activeSession {
    if (_activeSessionId == null) return null;
    final idx = _sessions.indexWhere((s) => s.id == _activeSessionId);
    return idx != -1 ? _sessions[idx] : null;
  }

  Terminal? getActiveTerminal() {
    if (_activeSessionId == null) return null;
    return _terminalManager.getTerminal(_activeSessionId!);
  }

  void create(String title, {String? workingDirectory}) {
    final terminalId = _terminalManager.createSession(
      title: title,
      workingDirectory: workingDirectory,
    );
    final session = TerminalSession(id: terminalId, title: title);
    _sessions.add(session);
    _activeSessionId = terminalId;
    notifyListeners();
  }

  void close(String id) {
    final idx = _sessions.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    _terminalManager.closeSession(id);
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

  void activate(String id) {
    if (_activeSessionId == id) return;
    if (_sessions.any((s) => s.id == id)) {
      _activeSessionId = id;
      notifyListeners();
    }
  }

  void rename(String id, String title) {
    final idx = _sessions.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    if (_sessions[idx].title == title) return;
    _sessions[idx] = _sessions[idx].copyWith(title: title);
    _terminalManager.renameSession(id, title);
    notifyListeners();
  }

  void closeAll() {
    _terminalManager.closeAll();
    _sessions.clear();
    _activeSessionId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _terminalManager.dispose();
    super.dispose();
  }
}
