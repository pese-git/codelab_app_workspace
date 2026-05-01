import 'package:flutter/foundation.dart';

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
  final List<TerminalSession> _sessions = <TerminalSession>[];
  String? _activeSessionId;
  int _idCounter = 0;

  List<TerminalSession> get sessions => List.unmodifiable(_sessions);
  String? get activeSessionId => _activeSessionId;

  TerminalSession? get activeSession {
    if (_activeSessionId == null) return null;
    final idx = _sessions.indexWhere((s) => s.id == _activeSessionId);
    return idx != -1 ? _sessions[idx] : null;
  }

  void create(String title) {
    final id = 'term_${++_idCounter}';
    final session = TerminalSession(id: id, title: title);
    _sessions.add(session);
    _activeSessionId = id;
    notifyListeners();
  }

  void close(String id) {
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
    notifyListeners();
  }

  void closeAll() {
    _sessions.clear();
    _activeSessionId = null;
    notifyListeners();
  }
}
