import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';
import '../session/file_list.dart';

/// Sidebar component with project info and navigation.
class Sidebar extends fluent.StatelessWidget {
  const Sidebar({
    required this.projectName,
    required this.projectPath,
    this.branchName,
    this.sessions = const [],
    this.selectedSessionId,
    this.workspaceNodes = const [],
    this.expandedNodes = const {},
    this.onSessionSelected,
    this.onNodeToggle,
    this.onNewWorkspace,
    this.onEditProject,
    this.onConnectProvider,
    super.key,
  });

  final String projectName;
  final String projectPath;
  final String? branchName;
  final List<SidebarSession> sessions;
  final String? selectedSessionId;
  final List<FileNode> workspaceNodes;
  final Set<String> expandedNodes;
  final fluent.ValueChanged<String>? onSessionSelected;
  final fluent.ValueChanged<String>? onNodeToggle;
  final fluent.VoidCallback? onNewWorkspace;
  final fluent.VoidCallback? onEditProject;
  final fluent.VoidCallback? onConnectProvider;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      width: AppDimensions.sidebarWidth,
      decoration: fluent.BoxDecoration(
        color: colors.surfaceBase,
        border: fluent.Border(
          right: fluent.BorderSide(color: colors.borderBase),
        ),
      ),
      child: fluent.Column(
        children: [
          // Project header
          fluent.Padding(
            padding: const fluent.EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: fluent.Row(
              children: [
                fluent.Expanded(
                  child: fluent.Column(
                    crossAxisAlignment: fluent.CrossAxisAlignment.start,
                    children: [
                      fluent.Text(
                        projectName,
                        style: AppTypography.title(color: colors.textStrong),
                      ),
                      const fluent.SizedBox(height: 2),
                      fluent.Text(
                        projectPath,
                        style: AppTypography.caption(color: colors.textWeak),
                        overflow: fluent.TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (onEditProject != null)
                  fluent.GestureDetector(
                    onTap: onEditProject,
                    child: fluent.Icon(
                      fluent.FluentIcons.more,
                      size: 16,
                      color: colors.iconWeak,
                    ),
                  ),
              ],
            ),
          ),
          // New workspace button
          if (onNewWorkspace != null)
            fluent.Padding(
              padding: const fluent.EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: fluent.GestureDetector(
                onTap: onNewWorkspace,
                child: fluent.Container(
                  height: 48,
                  padding: const fluent.EdgeInsets.symmetric(horizontal: 18),
                  decoration: fluent.BoxDecoration(
                    color: colors.surfaceBase,
                    borderRadius: fluent.BorderRadius.circular(13),
                    border: fluent.Border.all(color: colors.borderWeak),
                  ),
                  child: fluent.Row(
                    children: [
                      fluent.Icon(
                        fluent.FluentIcons.add,
                        size: 14,
                        color: colors.iconWeak,
                      ),
                      const fluent.SizedBox(width: 12),
                      fluent.Text(
                        'New workspace',
                        style: AppTypography.label(color: colors.textStrong),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Content
          fluent.Expanded(
            child: fluent.ListView(
              padding: const fluent.EdgeInsets.fromLTRB(14, 16, 14, 14),
              children: [
                // Branch info
                if (branchName != null) ...[
                  fluent.Row(
                    children: [
                      fluent.Icon(
                        fluent.FluentIcons.branch_fork2,
                        size: 14,
                        color: colors.iconWeak,
                      ),
                      const fluent.SizedBox(width: 10),
                      fluent.Text(
                        branchName!,
                        style: AppTypography.small(color: colors.textWeak),
                      ),
                    ],
                  ),
                  const fluent.SizedBox(height: 12),
                ],
                // Sessions
                for (final session in sessions)
                  _SessionTile(
                    session: session,
                    isSelected: session.id == selectedSessionId,
                    onTap: () => onSessionSelected?.call(session.id),
                  ),
                // Workspace tree
                if (workspaceNodes.isNotEmpty) ...[
                  const fluent.SizedBox(height: 18),
                  fluent.Text(
                    'workspace',
                    style: AppTypography.style(
                      size: 13,
                      weight: AppTypography.semiBold,
                      color: colors.textMuted,
                    ),
                  ),
                  const fluent.SizedBox(height: 10),
                  fluent.Container(
                    padding: const fluent.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: fluent.BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: fluent.BorderRadius.circular(12),
                      border: fluent.Border.all(color: colors.borderWeak),
                    ),
                    child: FileList(
                      nodes: workspaceNodes,
                      expandedNodes: expandedNodes,
                      onNodeToggle: onNodeToggle,
                    ),
                  ),
                ],
                // Provider card
                if (onConnectProvider != null) ...[
                  const fluent.SizedBox(height: 18),
                  _ProviderCard(onTap: onConnectProvider!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends fluent.StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.isSelected,
    required this.onTap,
  });

  final SidebarSession session;
  final bool isSelected;
  final fluent.VoidCallback onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Padding(
      padding: const fluent.EdgeInsets.only(bottom: 6),
      child: fluent.GestureDetector(
        onTap: onTap,
        child: fluent.Container(
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: fluent.BoxDecoration(
            color: isSelected
                ? colors.surfaceSelected
                : fluent.Colors.transparent,
            borderRadius: fluent.BorderRadius.circular(10),
          ),
          child: fluent.Text(
            session.title,
            maxLines: 1,
            overflow: fluent.TextOverflow.ellipsis,
            style:
                AppTypography.body(
                  color: isSelected ? colors.textStrong : colors.textBase,
                ).copyWith(
                  fontWeight: isSelected
                      ? fluent.FontWeight.w600
                      : fluent.FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

class _ProviderCard extends fluent.StatelessWidget {
  const _ProviderCard({required this.onTap});

  final fluent.VoidCallback onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      padding: const fluent.EdgeInsets.all(18),
      decoration: fluent.BoxDecoration(
        color: colors.surfaceBase,
        borderRadius: fluent.BorderRadius.circular(16),
        border: fluent.Border.all(color: colors.borderWeak),
      ),
      child: fluent.Column(
        crossAxisAlignment: fluent.CrossAxisAlignment.start,
        children: [
          fluent.Text(
            'Get Started',
            style: AppTypography.subtitle(color: colors.textStrong),
          ),
          const fluent.SizedBox(height: 12),
          fluent.Text(
            'Connect a provider to use AI models.',
            style: AppTypography.caption(color: colors.textWeak),
          ),
          const fluent.SizedBox(height: 16),
          fluent.GestureDetector(
            onTap: onTap,
            child: fluent.Container(
              height: 46,
              alignment: fluent.Alignment.centerLeft,
              padding: const fluent.EdgeInsets.symmetric(horizontal: 14),
              decoration: fluent.BoxDecoration(
                borderRadius: fluent.BorderRadius.circular(12),
                border: fluent.Border.all(color: colors.borderWeak),
              ),
              child: fluent.Row(
                children: [
                  fluent.Icon(
                    fluent.FluentIcons.add,
                    size: 14,
                    color: colors.iconWeak,
                  ),
                  const fluent.SizedBox(width: 12),
                  fluent.Text(
                    'Connect provider',
                    style: AppTypography.label(color: colors.textStrong),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Session item for sidebar.
class SidebarSession {
  const SidebarSession({required this.id, required this.title});

  final String id;
  final String title;
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSidebarDefault() {
  return Sidebar(
    projectName: 'My Project',
    projectPath: '/Users/dev/projects/my-project',
    branchName: 'main',
    sessions: const [
      SidebarSession(id: 'session-1', title: 'Initial setup'),
      SidebarSession(id: 'session-2', title: 'Add authentication'),
      SidebarSession(id: 'session-3', title: 'Fix login bug'),
    ],
    selectedSessionId: 'session-2',
    workspaceNodes: const [
      FileNode(
        id: 'lib',
        label: 'lib',
        isFolder: true,
        children: [
          FileNode(id: 'main.dart', label: 'main.dart', isFolder: false),
          FileNode(id: 'app.dart', label: 'app.dart', isFolder: false),
        ],
      ),
      FileNode(id: 'pubspec.yaml', label: 'pubspec.yaml', isFolder: false),
    ],
    expandedNodes: const {'lib'},
    onSessionSelected: (_) {},
    onNodeToggle: (_) {},
    onNewWorkspace: () {},
    onEditProject: () {},
    onConnectProvider: () {},
  );
}

@Preview(name: 'Minimal')
fluent.Widget previewSidebarMinimal() {
  return const Sidebar(
    projectName: 'Simple Project',
    projectPath: '/projects/simple',
    branchName: 'develop',
    sessions: [
      SidebarSession(id: 's1', title: 'First session'),
    ],
    selectedSessionId: 's1',
  );
}

@Preview(name: 'With Provider Card')
fluent.Widget previewSidebarWithProvider() {
  return const Sidebar(
    projectName: 'AI Assistant',
    projectPath: '/projects/ai-assistant',
    onConnectProvider: _onConnectProvider,
  );
}

void _onConnectProvider() {}
