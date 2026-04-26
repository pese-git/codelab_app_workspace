import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

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
class FileList extends StatelessWidget {
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
  final ValueChanged<FileNode>? onNodeTap;
  final ValueChanged<String>? onNodeToggle;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

class _FileNodeRow extends StatelessWidget {
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
  final VoidCallback? onTap;
  final ValueChanged<String>? onToggle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: node.isFolder ? () => onToggle?.call(node.id) : onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: EdgeInsets.fromLTRB(10 + depth * 14, 6, 10, 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                Icon(
                  node.isFolder
                      ? (isExpanded
                            ? fluent.FluentIcons.chevron_down
                            : fluent.FluentIcons.chevron_right)
                      : fluent.FluentIcons.page,
                  size: 10,
                  color: colors.iconWeak,
                ),
                const SizedBox(width: 8),
                Icon(
                  node.isFolder
                      ? fluent.FluentIcons.fabric_folder
                      : fluent.FluentIcons.page_add,
                  size: 13,
                  color: colors.iconBase,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    node.label,
                    style: AppTypography.small(color: colors.textBase),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (node.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: AppRadius.fullAll,
                    ),
                    child: Text(
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
          Padding(
            padding: const EdgeInsets.only(left: 4),
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
