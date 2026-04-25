import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../state/app_scope.dart';
import '../widgets/workspace_tree.dart';

class DesktopShell extends StatelessWidget {
  const DesktopShell({
    required this.child,
    required this.title,
    this.isHome = false,
    super.key,
  });

  final Widget child;
  final String title;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final project = controller.selectedProject;
    final session = controller.selectedSession;
    final theme = FluentTheme.of(context);

    return NavigationView(
      content: ScaffoldPage(
        padding: EdgeInsets.zero,
        content: Container(
          color: const Color(0xFF111315),
          child: Column(
            children: [
              _TitleBar(title: title, isHome: isHome),
              Expanded(
                child: Row(
                  children: [
                    _ProjectRail(projects: controller.projects),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: controller.sidebarCollapsed ? 0 : 288,
                      curve: Curves.easeOut,
                      decoration: const BoxDecoration(
                        color: Color(0xFF15181B),
                        border: Border(
                          right: BorderSide(color: Color(0xFF252A31)),
                        ),
                      ),
                      child: controller.sidebarCollapsed
                          ? const SizedBox.shrink()
                          : _SidebarPanel(project: project, session: session),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color(0xFF111315),
                        child: child,
                      ),
                    ),
                    if (controller.contextPanelVisible)
                      Container(
                        width: 320,
                        decoration: const BoxDecoration(
                          color: Color(0xFF15181B),
                          border: Border(
                            left: BorderSide(color: Color(0xFF252A31)),
                          ),
                        ),
                        child: _ContextPanel(session: session),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.title, required this.isHome});

  final String title;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF15181B),
        border: Border(bottom: BorderSide(color: Color(0xFF252A31))),
      ),
      child: Row(
        children: [
          const Icon(FluentIcons.code, size: 16),
          const SizedBox(width: 10),
          Text('CodeLab', style: theme.typography.bodyStrong),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.typography.body,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Button(
            onPressed: controller.toggleSidebarCollapsed,
            child: Text(controller.sidebarCollapsed ? 'Show Sidebar' : 'Hide Sidebar'),
          ),
          const SizedBox(width: 8),
          Button(
            onPressed: controller.toggleContextPanel,
            child: Text(controller.contextPanelVisible ? 'Hide Panel' : 'Show Panel'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => controller.openDialog(
              isHome ? AppDialog.selectDirectory : AppDialog.commandPalette,
            ),
            child: Text(isHome ? 'Open Project' : 'Commands'),
          ),
        ],
      ),
    );
  }
}

class _ProjectRail extends StatelessWidget {
  const _ProjectRail({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      width: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0F11),
        border: Border(right: BorderSide(color: Color(0xFF252A31))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          for (final project in projects)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Tooltip(
                message: project.name,
                child: _RailProjectButton(project: project),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: const Icon(FluentIcons.add),
              onPressed: () => controller.openDialog(AppDialog.selectDirectory),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: const Icon(FluentIcons.settings),
              onPressed: () => controller.openDialog(AppDialog.settings),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              icon: const Icon(FluentIcons.help),
              onPressed: () => controller.openDialog(AppDialog.help),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailProjectButton extends StatelessWidget {
  const _RailProjectButton({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final selected = controller.selectedProjectId == project.id;

    return GestureDetector(
      onTap: () {
        controller.selectProject(project.id);
        final sessionId = controller.selectedSessionId;
        if (sessionId == null) {
          context.go('/');
          return;
        }
        context.go('/session/$sessionId');
      },
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(project.color).withAlpha(selected ? 255 : 184),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.white : const Color(0x00000000),
          ),
        ),
        child: Text(
          project.initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SidebarPanel extends StatelessWidget {
  const _SidebarPanel({required this.project, required this.session});

  final ProjectModel project;
  final SessionModel? session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.name, style: theme.typography.subtitle),
              const SizedBox(height: 4),
              Text(project.path, style: theme.typography.caption),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Button(
            onPressed: () => controller.openDialog(AppDialog.editProject),
            child: const Text('Edit Project'),
          ),
        ),
        const SizedBox(height: 12),
        const _SidebarSectionLabel('Workspace'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: WorkspaceTree(nodes: project.workspaceRoots),
          ),
        ),
        const _SidebarSectionLabel('Sessions'),
        SizedBox(
          height: 220,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
            children: [
              for (final item in project.sessions)
                _SessionListRow(
                  session: item,
                  selected: session?.id == item.id,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  const _SidebarSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
      child: Text(
        label,
        style: theme.typography.caption?.copyWith(color: const Color(0xFF8A929C)),
      ),
    );
  }
}

class _SessionListRow extends StatelessWidget {
  const _SessionListRow({
    required this.session,
    required this.selected,
  });

  final SessionModel session;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Button(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
          backgroundColor: WidgetStateProperty.all(
            selected ? const Color(0xFF202632) : const Color(0xFF14171A),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selected ? const Color(0xFF4F8CFF) : const Color(0xFF252A31),
              ),
            ),
          ),
        ),
        onPressed: () {
          controller.selectSession(session.id);
          context.go('/session/${session.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.title, style: theme.typography.bodyStrong),
            const SizedBox(height: 4),
            Text(
              '${session.branchName} • ${session.updatedLabel}',
              style: theme.typography.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContextPanel extends StatelessWidget {
  const _ContextPanel({required this.session});

  final SessionModel? session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);
    final metrics = session?.metrics ?? const <MetricItem>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text('Context Panel', style: theme.typography.subtitle),
              ),
              IconButton(
                icon: const Icon(FluentIcons.branch_merge),
                onPressed: () => controller.openDialog(AppDialog.forkSession),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final tab in ContextPanelTab.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Button(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          controller.contextPanelTab == tab
                              ? const Color(0xFF202632)
                              : const Color(0xFF14171A),
                        ),
                      ),
                      onPressed: () => controller.setContextPanelTab(tab),
                      child: Text(_contextLabel(tab)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: [
              if (session != null) ...[
                _InfoCard(
                  title: 'Session',
                  lines: [
                    session!.title,
                    session!.status,
                    controller.selectedModel,
                    controller.selectedProvider,
                  ],
                ),
                const SizedBox(height: 12),
              ],
              _InfoCard(
                title: 'Metrics',
                lines: metrics.map((item) => '${item.label}: ${item.value}').toList(),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                title: 'Controls',
                lines: [
                  'Server: ${controller.selectedServer}',
                  'MCP: ${controller.selectedMcp}',
                  'Dialogs: ${controller.activeDialog?.name ?? 'closed'}',
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _contextLabel(ContextPanelTab tab) {
    switch (tab) {
      case ContextPanelTab.details:
        return 'Details';
      case ContextPanelTab.activity:
        return 'Activity';
      case ContextPanelTab.agent:
        return 'Agent';
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF252A31)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.typography.bodyStrong),
          const SizedBox(height: 10),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(line, style: theme.typography.caption),
            ),
        ],
      ),
    );
  }
}
