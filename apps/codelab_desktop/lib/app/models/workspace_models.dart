//enum SessionRegionTab { files, review, terminal }

//enum ContextPanelTab { details, activity, agent }

enum AppDialog {
  settings,
  selectDirectory,
  selectFile,
  selectModel,
  selectProvider,
  selectMcp,
  selectServer,
  editProject,
  forkSession,
  help,
  releaseNotes,
  commandPalette,
}

class WorkspaceData {
  WorkspaceData({
    required this.projects,
    required this.models,
    required this.providers,
    required this.mcps,
  });

  final List<ProjectModel> projects;
  final List<String> models;
  final List<String> providers;
  final List<String> mcps;
}

class ProjectModel {
  ProjectModel({
    required this.id,
    required this.name,
    required this.path,
    required this.initials,
    required this.color,
    required this.sessions,
    required this.workspaceRoots,
  });

  final String id;
  final String name;
  final String path;
  final String initials;
  final int color;
  final List<SessionModel> sessions;
  final List<WorkspaceNode> workspaceRoots;
}

class SessionModel {
  SessionModel({
    required this.id,
    required this.title,
    required this.branchName,
    required this.updatedLabel,
    required this.status,
    required this.messages,
    required this.fileItems,
    required this.reviewItems,
    required this.terminalEntries,
    required this.metrics,
  });

  final String id;
  final String title;
  final String branchName;
  final String updatedLabel;
  final String status;
  final List<MessageModel> messages;
  final List<FileItem> fileItems;
  final List<ReviewItem> reviewItems;
  final List<TerminalEntry> terminalEntries;
  final List<MetricItem> metrics;
}

class WorkspaceNode {
  WorkspaceNode({
    required this.id,
    required this.label,
    required this.kind,
    this.children = const [],
    this.badge,
  });

  final String id;
  final String label;
  final String kind;
  final List<WorkspaceNode> children;
  final String? badge;

  bool get isFolder => children.isNotEmpty;
}

class MessageModel {
  MessageModel({
    required this.id,
    required this.author,
    required this.role,
    required this.timestamp,
    required this.body,
    this.tags = const [],
  });

  final String id;
  final String author;
  final String role;
  final String timestamp;
  final String body;
  final List<String> tags;
}

class FileItem {
  FileItem({required this.path, required this.summary, required this.status});

  final String path;
  final String summary;
  final String status;
}

class ReviewItem {
  ReviewItem({
    required this.title,
    required this.summary,
    required this.severity,
  });

  final String title;
  final String summary;
  final String severity;
}

class TerminalEntry {
  TerminalEntry({
    required this.label,
    required this.command,
    required this.state,
  });

  final String label;
  final String command;
  final String state;
}

class MetricItem {
  MetricItem({required this.label, required this.value});

  final String label;
  final String value;
}
