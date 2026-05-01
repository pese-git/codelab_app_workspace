import 'package:codelab_ui_components/codelab_ui_components.dart'
    show SessionRegionTab;
import 'package:codelab_ui_components/src.dart' show ContextPanelTab;
import 'package:flutter/foundation.dart';

import '../../../app/models/workspace_models.dart';
import '../../../domain/entities/project_entity.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/services/directory_scanner_service.dart';
import 'terminal_controller.dart';

class WorkspaceController extends ChangeNotifier {
  WorkspaceController({
    required ProjectRepository projectRepository,
    required DirectoryScannerService directoryScanner,
    TerminalController? terminalController,
  }) : _projectRepository = projectRepository,
       _directoryScanner = directoryScanner,
       _workspace = WorkspaceData(
         projects: [],
         models: [],
         providers: [],
         mcps: [],
       ),
       _terminalController = terminalController ?? TerminalController() {
    _selectedModel = '';
    _selectedProvider = '';
    _selectedMcp = '';
  }

  final ProjectRepository _projectRepository;
  final DirectoryScannerService _directoryScanner;
  WorkspaceData _workspace;
  final TerminalController _terminalController;
  final Set<String> _expandedNodes = <String>{};
  final Set<String> _enabledSettings = <String>{'showProgress'};
  String? _selectedProjectId;
  String? _selectedSessionId;
  SessionRegionTab _sessionTab = SessionRegionTab.files;
  ContextPanelTab _contextPanelTab = ContextPanelTab.details;
  bool _sidebarCollapsed = false;
  bool _contextPanelVisible = true;
  bool _bottomPanelVisible = true;
  String _selectedModel = '';
  String _selectedProvider = '';
  String _selectedMcp = '';

  WorkspaceData get workspace => _workspace;
  TerminalController get terminalController => _terminalController;
  List<ProjectModel> get projects => _workspace.projects;
  List<String> get models => _workspace.models;
  List<String> get providers => _workspace.providers;
  List<String> get mcps => _workspace.mcps;
  String? get selectedProjectId => _selectedProjectId;
  String? get selectedSessionId => _selectedSessionId;
  SessionRegionTab get sessionTab => _sessionTab;
  ContextPanelTab get contextPanelTab => _contextPanelTab;
  bool get sidebarCollapsed => _sidebarCollapsed;
  bool get contextPanelVisible => _contextPanelVisible;
  bool get bottomPanelVisible => _bottomPanelVisible;
  String get selectedModel => _selectedModel;
  String get selectedProvider => _selectedProvider;
  String get selectedMcp => _selectedMcp;
  bool isSettingEnabled(String key) => _enabledSettings.contains(key);

  ProjectModel? get selectedProject {
    final id = _selectedProjectId;
    if (id == null || projects.isEmpty) return null;
    return projects.firstWhere(
      (project) => project.id == id,
      orElse: () => projects.first,
    );
  }

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

  Future<void> openProject(String directoryPath) async {
    final workspaceRoots = await _directoryScanner.scanDirectory(
      directoryPath,
      maxDepth: 3,
    );

    final entity = ProjectEntity.fromPath(directoryPath);
    await _projectRepository.addProject(entity);

    final projectModel = entity.toProjectModel(
      workspaceRoots: workspaceRoots,
    );

    final updatedProjects = [..._workspace.projects, projectModel];

    _workspace = WorkspaceData(
      projects: updatedProjects,
      models: _workspace.models,
      providers: _workspace.providers,
      mcps: _workspace.mcps,
    );

    _selectedProjectId = projectModel.id;
    _selectedSessionId = null;

    for (final node in workspaceRoots) {
      _primeExpanded(node);
    }

    notifyListeners();
  }

  void selectProject(String projectId) {
    if (_selectedProjectId == projectId) return;
    _selectedProjectId = projectId;
    final project = selectedProject;
    _selectedSessionId = project?.sessions.isNotEmpty == true
        ? project!.sessions.first.id
        : null;
    notifyListeners();
  }

  void selectSession(String sessionId) {
    if (_selectedSessionId == sessionId) return;
    _selectedSessionId = sessionId;
    final project = projects.firstWhere(
      (candidate) =>
          candidate.sessions.any((session) => session.id == sessionId),
      orElse: () => selectedProject ?? projects.first,
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
    _terminalController.dispose();
    super.dispose();
  }
}
