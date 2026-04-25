import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../session/file_list.dart';

/// Sidebar component with project info and navigation.
class Sidebar extends StatelessWidget {
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
  final ValueChanged<String>? onSessionSelected;
  final ValueChanged<String>? onNodeToggle;
  final VoidCallback? onNewWorkspace;
  final VoidCallback? onEditProject;
  final VoidCallback? onConnectProvider;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      width: AppDimensions.sidebarWidth,
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        border: Border(right: BorderSide(color: colors.borderBase)),
      ),
      child: Column(
        children: [
          // Project header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectName,
                        style: AppTypography.title(color: colors.textStrong),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        projectPath,
                        style: AppTypography.caption(color: colors.textWeak),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (onEditProject != null)
                  GestureDetector(
                    onTap: onEditProject,
                    child: Icon(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: GestureDetector(
                onTap: onNewWorkspace,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: colors.surfaceBase,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: colors.borderWeak),
                  ),
                  child: Row(
                    children: [
                      Icon(fluent.FluentIcons.add, size: 14, color: colors.iconWeak),
                      const SizedBox(width: 12),
                      Text(
                        'New workspace',
                        style: AppTypography.label(color: colors.textStrong),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
              children: [
                // Branch info
                if (branchName != null) ...[
                  Row(
                    children: [
                      Icon(
                        fluent.FluentIcons.branch_fork2,
                        size: 14,
                        color: colors.iconWeak,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        branchName!,
                        style: AppTypography.small(color: colors.textWeak),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 18),
                  Text(
                    'workspace',
                    style: AppTypography.style(
                      size: 13,
                      weight: AppTypography.semiBold,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.borderWeak),
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
                  const SizedBox(height: 18),
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

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.session,
    required this.isSelected,
    required this.onTap,
  });

  final SidebarSession session;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colors.surfaceSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            session.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body(
              color: isSelected ? colors.textStrong : colors.textBase,
            ).copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderWeak),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Started',
            style: AppTypography.subtitle(color: colors.textStrong),
          ),
          const SizedBox(height: 12),
          Text(
            'Connect a provider to use AI models.',
            style: AppTypography.caption(color: colors.textWeak),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 46,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderWeak),
              ),
              child: Row(
                children: [
                  Icon(fluent.FluentIcons.add, size: 14, color: colors.iconWeak),
                  const SizedBox(width: 12),
                  Text(
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
  const SidebarSession({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
