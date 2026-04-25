import 'package:flutter/foundation.dart';

import '../models/workspace_models.dart';

// ---------------------------------------------------------------------------
// Session Tab Model & Controller
// ---------------------------------------------------------------------------

/// Represents a single open file tab in the session.
@immutable
class SessionTab {
  const SessionTab({
    required this.id,
    required this.label,
    required this.path,
    this.isDirty = false,
  });

  final String id;
  final String label;
  final String path;
  final bool isDirty;

  SessionTab copyWith({String? label, String? path, bool? isDirty}) {
    return SessionTab(
      id: id,
      label: label ?? this.label,
      path: path ?? this.path,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTab &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Controller managing open file tabs within a session.
class SessionTabsController extends ChangeNotifier {
  final List<SessionTab> _tabs = <SessionTab>[];
  String? _activeTabId;
  int _idCounter = 0;

  List<SessionTab> get tabs => List.unmodifiable(_tabs);
  String? get activeTabId => _activeTabId;

  SessionTab? get activeTab {
    if (_activeTabId == null) return null;
    final idx = _tabs.indexWhere((t) => t.id == _activeTabId);
    return idx != -1 ? _tabs[idx] : null;
  }

  /// Opens a tab for the given [path]. If a tab with the same path exists,
  /// it activates that tab instead (reopen semantics).
  void open(String path, String label) {
    final existing = _tabs.indexWhere((t) => t.path == path);
    if (existing != -1) {
      activate(_tabs[existing].id);
      return;
    }
    final id = 'tab_${++_idCounter}';
    final tab = SessionTab(id: id, label: label, path: path);
    _tabs.add(tab);
    _activeTabId = id;
    notifyListeners();
  }

  /// Reopens a tab by [path]. No-op if already open; activates if exists.
  void reopen(String path, String label) => open(path, label);

  /// Closes a tab by [id].
  void close(String id) {
    final idx = _tabs.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tabs.removeAt(idx);
    if (_activeTabId == id) {
      if (_tabs.isNotEmpty) {
        _activeTabId = _tabs[idx.clamp(0, _tabs.length - 1)].id;
      } else {
        _activeTabId = null;
      }
    }
    notifyListeners();
  }

  /// Closes all tabs except the one with [id].
  void closeOthers(String id) {
    _tabs.removeWhere((t) => t.id != id);
    if (_tabs.isNotEmpty) {
      _activeTabId = _tabs.first.id;
    } else {
      _activeTabId = null;
    }
    notifyListeners();
  }

  /// Closes all open tabs.
  void closeAll() {
    _tabs.clear();
    _activeTabId = null;
    notifyListeners();
  }

  /// Activates the tab with the given [id].
  void activate(String id) {
    if (_activeTabId == id) return;
    if (_tabs.any((t) => t.id == id)) {
      _activeTabId = id;
      notifyListeners();
    }
  }

  /// Reorders a tab from [fromIndex] to [toIndex].
  void reorder(int fromIndex, int toIndex) {
    if (fromIndex < 0 ||
        fromIndex >= _tabs.length ||
        toIndex < 0 ||
        toIndex >= _tabs.length ||
        fromIndex == toIndex) {
      return;
    }
    final tab = _tabs.removeAt(fromIndex);
    _tabs.insert(toIndex, tab);
    notifyListeners();
  }

  /// Marks a tab as dirty or clean.
  void setDirty(String id, {required bool dirty}) {
    final idx = _tabs.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    if (_tabs[idx].isDirty == dirty) return;
    _tabs[idx] = _tabs[idx].copyWith(isDirty: dirty);
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Terminal Session Model & Controller
// ---------------------------------------------------------------------------

/// Represents a single terminal session.
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

/// Controller managing terminal sessions.
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

  /// Creates a new terminal session with the given [title].
  void create(String title) {
    final id = 'term_${++_idCounter}';
    final session = TerminalSession(id: id, title: title);
    _sessions.add(session);
    _activeSessionId = id;
    notifyListeners();
  }

  /// Closes the terminal session with the given [id].
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

  /// Activates the terminal session with the given [id].
  void activate(String id) {
    if (_activeSessionId == id) return;
    if (_sessions.any((s) => s.id == id)) {
      _activeSessionId = id;
      notifyListeners();
    }
  }

  /// Renames the terminal session with the given [id].
  void rename(String id, String title) {
    final idx = _sessions.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    if (_sessions[idx].title == title) return;
    _sessions[idx] = _sessions[idx].copyWith(title: title);
    notifyListeners();
  }

  /// Closes all terminal sessions.
  void closeAll() {
    _sessions.clear();
    _activeSessionId = null;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// App Controller
// ---------------------------------------------------------------------------

class CodeLabAppController extends ChangeNotifier {
  CodeLabAppController({
    required WorkspaceData seedWorkspace,
    SessionTabsController? sessionTabsController,
    TerminalController? terminalController,
  })  : _workspace = seedWorkspace,
        _sessionTabsController = sessionTabsController ?? SessionTabsController(),
        _terminalController = terminalController ?? TerminalController() {
    _selectedProjectId = seedWorkspace.projects.first.id;
    _selectedSessionId = seedWorkspace.projects.first.sessions.first.id;
    _selectedModel = seedWorkspace.models.first;
    _selectedProvider = seedWorkspace.providers.first;
    _selectedMcp = seedWorkspace.mcps.first;
    _selectedServer = seedWorkspace.servers.first;
    for (final project in seedWorkspace.projects) {
      for (final node in project.workspaceRoots) {
        _primeExpanded(node);
      }
    }
  }

  final WorkspaceData _workspace;
  final SessionTabsController _sessionTabsController;
  final TerminalController _terminalController;
  final Set<String> _expandedNodes = <String>{};
  final Set<String> _enabledSettings = <String>{'showProgress'};
  String _selectedProjectId = '';
  String? _selectedSessionId;
  SessionRegionTab _sessionTab = SessionRegionTab.files;
  ContextPanelTab _contextPanelTab = ContextPanelTab.details;
  bool _sidebarCollapsed = false;
  bool _contextPanelVisible = true;
  bool _bottomPanelVisible = true;
  AppDialog? _activeDialog;
  String _selectedModel = '';
  String _selectedProvider = '';
  String _selectedMcp = '';
  String _selectedServer = '';

  /// Controller for managing open file tabs in the session.
  SessionTabsController get sessionTabsController => _sessionTabsController;

  /// Controller for managing terminal sessions.
  TerminalController get terminalController => _terminalController;

  WorkspaceData get workspace => _workspace;
  List<ProjectModel> get projects => _workspace.projects;
  List<String> get models => _workspace.models;
  List<String> get providers => _workspace.providers;
  List<String> get mcps => _workspace.mcps;
  List<String> get servers => _workspace.servers;
  String get selectedProjectId => _selectedProjectId;
  String? get selectedSessionId => _selectedSessionId;
  SessionRegionTab get sessionTab => _sessionTab;
  ContextPanelTab get contextPanelTab => _contextPanelTab;
  bool get sidebarCollapsed => _sidebarCollapsed;
  bool get contextPanelVisible => _contextPanelVisible;
  bool get bottomPanelVisible => _bottomPanelVisible;
  AppDialog? get activeDialog => _activeDialog;
  String get selectedModel => _selectedModel;
  String get selectedProvider => _selectedProvider;
  String get selectedMcp => _selectedMcp;
  String get selectedServer => _selectedServer;
  bool isSettingEnabled(String key) => _enabledSettings.contains(key);

  ProjectModel get selectedProject =>
      projects.firstWhere((project) => project.id == _selectedProjectId);

  SessionModel? get selectedSession {
    final id = _selectedSessionId;
    if (id == null) return null;
    for (final project in projects) {
      for (final session in project.sessions) {
        if (session.id == id) {
          return session;
        }
      }
    }
    return null;
  }

  void _primeExpanded(WorkspaceNode node) {
    if (node.children.isNotEmpty) {
      _expandedNodes.add(node.id);
      for (final child in node.children) {
        _primeExpanded(child);
      }
    }
  }

  bool isNodeExpanded(String nodeId) => _expandedNodes.contains(nodeId);

  void toggleNode(String nodeId) {
    if (_expandedNodes.contains(nodeId)) {
      _expandedNodes.remove(nodeId);
    } else {
      _expandedNodes.add(nodeId);
    }
    notifyListeners();
  }

  void selectProject(String projectId) {
    if (_selectedProjectId == projectId) return;
    _selectedProjectId = projectId;
    final project = selectedProject;
    _selectedSessionId = project.sessions.isNotEmpty
        ? project.sessions.first.id
        : null;
    notifyListeners();
  }

  void selectSession(String sessionId) {
    if (_selectedSessionId == sessionId) return;
    _selectedSessionId = sessionId;
    final project = projects.firstWhere(
      (candidate) =>
          candidate.sessions.any((session) => session.id == sessionId),
      orElse: () => selectedProject,
    );
    _selectedProjectId = project.id;
    notifyListeners();
  }

  void setSessionTab(SessionRegionTab tab) {
    if (_sessionTab == tab) return;
    _sessionTab = tab;
    notifyListeners();
  }

  void setContextPanelTab(ContextPanelTab tab) {
    if (_contextPanelTab == tab) return;
    _contextPanelTab = tab;
    notifyListeners();
  }

  void toggleSidebarCollapsed() {
    _sidebarCollapsed = !_sidebarCollapsed;
    notifyListeners();
  }

  void toggleContextPanel() {
    _contextPanelVisible = !_contextPanelVisible;
    notifyListeners();
  }

  void toggleBottomPanel() {
    _bottomPanelVisible = !_bottomPanelVisible;
    notifyListeners();
  }

  void openDialog(AppDialog dialog) {
    _activeDialog = dialog;
    notifyListeners();
  }

  void closeDialog() {
    if (_activeDialog == null) return;
    _activeDialog = null;
    notifyListeners();
  }

  void chooseModel(String value) {
    _selectedModel = value;
    notifyListeners();
  }

  void chooseProvider(String value) {
    _selectedProvider = value;
    notifyListeners();
  }

  void chooseMcp(String value) {
    _selectedMcp = value;
    notifyListeners();
  }

  void chooseServer(String value) {
    _selectedServer = value;
    notifyListeners();
  }

  void toggleSetting(String key) {
    if (_enabledSettings.contains(key)) {
      _enabledSettings.remove(key);
    } else {
      _enabledSettings.add(key);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionTabsController.dispose();
    _terminalController.dispose();
    super.dispose();
  }
}
