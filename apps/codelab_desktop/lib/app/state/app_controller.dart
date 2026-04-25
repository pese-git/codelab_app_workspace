import 'package:flutter/foundation.dart';

import '../models/workspace_models.dart';

class CodeLabAppController extends ChangeNotifier {
  CodeLabAppController({required WorkspaceData seedWorkspace})
    : _workspace = seedWorkspace {
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
}
