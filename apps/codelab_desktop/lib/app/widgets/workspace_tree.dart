import 'package:fluent_ui/fluent_ui.dart';

import '../models/workspace_models.dart';
import '../state/app_scope.dart';

class WorkspaceTree extends StatelessWidget {
  const WorkspaceTree({
    required this.nodes,
    this.depth = 0,
    super.key,
  });

  final List<WorkspaceNode> nodes;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final node in nodes)
          _WorkspaceNodeRow(
            node: node,
            depth: depth,
          ),
      ],
    );
  }
}

class _WorkspaceNodeRow extends StatelessWidget {
  const _WorkspaceNodeRow({
    required this.node,
    required this.depth,
  });

  final WorkspaceNode node;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final expanded = controller.isNodeExpanded(node.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: node.isFolder ? () => controller.toggleNode(node.id) : null,
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
                      ? (expanded ? FluentIcons.chevron_down : FluentIcons.chevron_right)
                      : FluentIcons.page,
                  size: 10,
                  color: const Color(0xFF8F8F8B),
                ),
                const SizedBox(width: 8),
                Icon(
                  node.isFolder ? FluentIcons.fabric_folder : FluentIcons.page_add,
                  size: 13,
                  color: const Color(0xFF787874),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    node.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4E4E49),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (node.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E8E4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      node.badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF676762),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (node.isFolder && expanded)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: WorkspaceTree(
              nodes: node.children,
              depth: depth + 1,
            ),
          ),
      ],
    );
  }
}
