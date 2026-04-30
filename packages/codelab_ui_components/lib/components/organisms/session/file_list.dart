import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';

/// A file tree node.
class FileNode {
  const FileNode({
    required this.id,
    required this.label,
    required this.isFolder,
    this.children = const [],
    this.badge,
  });

  final String id;
  final String label;
  final bool isFolder;
  final List<FileNode> children;
  final String? badge;
}

/// A file list/tree component (workspace tree).
class FileList extends fluent.StatelessWidget {
  const FileList({
    required this.nodes,
    this.expandedNodes = const {},
    this.onNodeTap,
    this.onNodeToggle,
    this.depth = 0,
    super.key,
  });

  final List<FileNode> nodes;
  final Set<String> expandedNodes;
  final fluent.ValueChanged<FileNode>? onNodeTap;
  final fluent.ValueChanged<String>? onNodeToggle;
  final int depth;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      children: [
        for (final node in nodes)
          _FileNodeRow(
            node: node,
            depth: depth,
            isExpanded: expandedNodes.contains(node.id),
            expandedNodes: expandedNodes,
            onTap: () => onNodeTap?.call(node),
            onToggle: onNodeToggle,
          ),
      ],
    );
  }
}

class _FileNodeRow extends fluent.StatelessWidget {
  const _FileNodeRow({
    required this.node,
    required this.depth,
    required this.isExpanded,
    required this.expandedNodes,
    this.onTap,
    this.onToggle,
  });

  final FileNode node;
  final int depth;
  final bool isExpanded;
  final Set<String> expandedNodes;
  final fluent.VoidCallback? onTap;
  final fluent.ValueChanged<String>? onToggle;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      children: [
        fluent.GestureDetector(
          onTap: node.isFolder ? () => onToggle?.call(node.id) : onTap,
          child: fluent.Container(
            margin: const fluent.EdgeInsets.symmetric(vertical: 2),
            padding: fluent.EdgeInsets.fromLTRB(10 + depth * 14, 6, 10, 6),
            decoration: fluent.BoxDecoration(
              color: fluent.Colors.transparent,
              borderRadius: fluent.BorderRadius.circular(7),
            ),
            child: fluent.Row(
              children: [
                fluent.Icon(
                  node.isFolder
                      ? (isExpanded
                            ? fluent.FluentIcons.chevron_down
                            : fluent.FluentIcons.chevron_right)
                      : fluent.FluentIcons.page,
                  size: 10,
                  color: colors.iconWeak,
                ),
                const fluent.SizedBox(width: 8),
                fluent.Icon(
                  node.isFolder
                      ? fluent.FluentIcons.fabric_folder
                      : fluent.FluentIcons.page_add,
                  size: 13,
                  color: colors.iconBase,
                ),
                const fluent.SizedBox(width: 8),
                fluent.Expanded(
                  child: fluent.Text(
                    node.label,
                    style: AppTypography.small(color: colors.textBase),
                    overflow: fluent.TextOverflow.ellipsis,
                  ),
                ),
                if (node.badge != null)
                  fluent.Container(
                    padding: const fluent.EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: fluent.BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: AppRadius.fullAll,
                    ),
                    child: fluent.Text(
                      node.badge!,
                      style: AppTypography.style(
                        size: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (node.isFolder && isExpanded)
          fluent.Padding(
            padding: const fluent.EdgeInsets.only(left: 4),
            child: FileList(
              nodes: node.children,
              depth: depth + 1,
              expandedNodes: expandedNodes,
              onNodeTap: (n) {},
              onNodeToggle: onToggle,
            ),
          ),
      ],
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewFileListDefault() {
  return const FileList(
    nodes: [
      FileNode(
        id: 'src',
        label: 'src',
        isFolder: true,
        children: [
          FileNode(id: 'main.dart', label: 'main.dart', isFolder: false),
          FileNode(id: 'app.dart', label: 'app.dart', isFolder: false),
        ],
      ),
      FileNode(id: 'pubspec.yaml', label: 'pubspec.yaml', isFolder: false),
      FileNode(id: 'README.md', label: 'README.md', isFolder: false, badge: 'new'),
    ],
    expandedNodes: {'src'},
  );
}

@Preview(name: 'Deep Tree')
fluent.Widget previewFileListDeepTree() {
  return const FileList(
    nodes: [
      FileNode(
        id: 'lib',
        label: 'lib',
        isFolder: true,
        children: [
          FileNode(
            id: 'src',
            label: 'src',
            isFolder: true,
            children: [
              FileNode(id: 'main.dart', label: 'main.dart', isFolder: false),
              FileNode(
                id: 'models',
                label: 'models',
                isFolder: true,
                children: [
                  FileNode(id: 'user.dart', label: 'user.dart', isFolder: false, badge: 'modified'),
                  FileNode(id: 'session.dart', label: 'session.dart', isFolder: false),
                ],
              ),
            ],
          ),
        ],
      ),
      FileNode(id: 'test', label: 'test', isFolder: true),
    ],
    expandedNodes: {'lib', 'src'},
  );
}
