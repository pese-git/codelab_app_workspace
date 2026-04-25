import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../navigation/router.dart';
import '../state/app_scope.dart';
import '../widgets/workspace_tree.dart';

class DesktopShell extends StatelessWidget {
  const DesktopShell({
    required this.child,
    required this.title,
    this.isHome = false,
    this.bottomPanel,
    super.key,
  });

  final Widget child;
  final String title;
  final bool isHome;
  final Widget? bottomPanel;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final project = controller.selectedProject;
    final session = controller.selectedSession;

    return NavigationView(
      content: ScaffoldPage(
        padding: EdgeInsets.zero,
        content: Container(
          color: const Color(0xFFF6F5F2),
          child: Column(
            children: [
              const _TitleBar(),
              Expanded(
                child: Row(
                  children: [
                    _ProjectRail(projects: controller.projects),
                    if (!controller.sidebarCollapsed)
                      _SidebarPanel(project: project, session: session),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(color: Colors.white, child: child),
                          ),
                          if (bottomPanel != null &&
                              controller.bottomPanelVisible)
                            Container(
                              height: 178,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF7F6F3),
                                border: Border(
                                  top: BorderSide(color: Color(0xFFE2E0DB)),
                                ),
                              ),
                              child: bottomPanel!,
                            ),
                        ],
                      ),
                    ),
                    if (controller.contextPanelVisible)
                      _ContextPanel(session: session, isHome: isHome),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F3F0),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E0DB))),
      ),
      child: Row(
        children: [
          const _TrafficLights(),
          const SizedBox(width: 20),
          _TitleIconButton(
            icon: FluentIcons.side_panel,
            onTap: controller.toggleSidebarCollapsed,
          ),
          const SizedBox(width: 10),
          ListenableBuilder(
            listenable: historyController,
            builder: (context, _) => _NavigationButton(
              icon: FluentIcons.chevron_left_small,
              enabled: historyController.canBack,
              onTap: historyController.back,
            ),
          ),
          const SizedBox(width: 6),
          ListenableBuilder(
            listenable: historyController,
            builder: (context, _) => _NavigationButton(
              icon: FluentIcons.chevron_right_small,
              enabled: historyController.canForward,
              onTap: historyController.forward,
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 360,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7F4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDAD8D2)),
                ),
                child: GestureDetector(
                  onTap: () => controller.openDialog(AppDialog.commandPalette),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Поиск acp-protocol',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8F8D88),
                          ),
                        ),
                      ),
                      Text(
                        '⌘K',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB1AFA9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _HeaderBadge(
            icon: FluentIcons.server_processes,
            onTap: () => controller.openDialog(AppDialog.selectServer),
          ),
          const SizedBox(width: 10),
          _HeaderBadge(
            icon: FluentIcons.command_prompt,
            onTap: controller.toggleBottomPanel,
          ),
          const SizedBox(width: 10),
          _HeaderBadge(
            icon: FluentIcons.add,
            onTap: () => controller.openDialog(AppDialog.selectDirectory),
          ),
          const SizedBox(width: 10),
          _TitleIconButton(
            icon: controller.contextPanelVisible
                ? FluentIcons.open_pane_mirrored
                : FluentIcons.open_pane,
            onTap: controller.toggleContextPanel,
          ),
        ],
      ),
    );
  }
}

class _TrafficLights extends StatelessWidget {
  const _TrafficLights();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color color) {
      return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
    }

    return Row(
      children: [
        dot(const Color(0xFFFF5F57)),
        const SizedBox(width: 8),
        dot(const Color(0xFFFEBB2E)),
        const SizedBox(width: 8),
        dot(const Color(0xFF28C840)),
      ],
    );
  }
}

class _TitleIconButton extends StatelessWidget {
  const _TitleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E4E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: const Color(0xFF5F5C56)),
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEBE7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: const Color(0xFF64615C)),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Icon(
          icon,
          size: 15,
          color: enabled ? const Color(0xFF5F5C56) : const Color(0xFFCAC8C3),
        ),
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
      width: 86,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F4F1),
        border: Border(right: BorderSide(color: Color(0xFFE2E0DB))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          for (final project in projects)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Tooltip(
                message: project.name,
                child: _RailProjectButton(project: project),
              ),
            ),
          GestureDetector(
            onTap: () => controller.openDialog(AppDialog.selectDirectory),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: const Icon(
                FluentIcons.add,
                size: 17,
                color: Color(0xFF8B8983),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(FluentIcons.settings, color: Color(0xFFA29F99)),
            onPressed: () => controller.openDialog(AppDialog.settings),
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(FluentIcons.help, color: Color(0xFFA29F99)),
            onPressed: () => controller.openDialog(AppDialog.help),
          ),
          const SizedBox(height: 12),
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
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF30302D) : const Color(0xFFBEBBB4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFDE4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            project.initials.substring(0, 1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE24BA8),
            ),
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

    return Container(
      width: 376,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE2E0DB))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name.toLowerCase().replaceAll(' desktop', ''),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF252522),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        project.path.replaceFirst(
                          '~',
                          '~/Projects/OpenIdeaLab',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7F7C76),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.openDialog(AppDialog.editProject),
                  child: const Icon(
                    FluentIcons.more,
                    size: 16,
                    color: Color(0xFF8E8B85),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: GestureDetector(
              onTap: () => controller.openDialog(AppDialog.selectDirectory),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: const Color(0xFFDDDAD4)),
                ),
                child: const Row(
                  children: [
                    Icon(FluentIcons.add, size: 14, color: Color(0xFF8F8C86)),
                    SizedBox(width: 12),
                    Text(
                      'Новое рабочее пространство',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF353531),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
              children: [
                Row(
                  children: [
                    const Icon(
                      FluentIcons.branch_fork2,
                      size: 14,
                      color: Color(0xFF9A9791),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'локальное : ${session == null ? 'master' : session!.branchName.split('/').last}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF76736D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final item in project.sessions)
                  _SessionListTile(
                    session: item,
                    selected: item.id == controller.selectedSessionId,
                  ),
                const SizedBox(height: 18),
                const Text(
                  'workspace',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A8781),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7F4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEBE8E2)),
                  ),
                  child: WorkspaceTree(nodes: project.workspaceRoots),
                ),
                const SizedBox(height: 18),
                _ProviderCard(
                  onTap: () => controller.openDialog(AppDialog.selectProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionListTile extends StatelessWidget {
  const _SessionListTile({required this.session, required this.selected});

  final SessionModel session;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          controller.selectSession(session.id);
          context.go('/session/${session.id}');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE8E7E4) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            session.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF30302D),
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDDAD4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Начало работы',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF252522),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'OpenCode включает бесплатные модели, чтобы вы могли начать сразу.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFF74716C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Подключите любого провайдера для использования моделей, включая Claude, GPT, Gemini и др.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFF74716C),
            ),
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
                border: Border.all(color: const Color(0xFFD8D5CF)),
              ),
              child: const Row(
                children: [
                  Icon(FluentIcons.add, size: 14, color: Color(0xFF8C8983)),
                  SizedBox(width: 12),
                  Text(
                    'Подключить провайдера',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF30302D),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Пока нет',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF30302D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextPanel extends StatelessWidget {
  const _ContextPanel({required this.session, required this.isHome});

  final SessionModel? session;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      width: 334,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE2E0DB))),
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE6E3DD))),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      controller.setContextPanelTab(ContextPanelTab.details),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          controller.contextPanelTab == ContextPanelTab.details
                          ? const Color(0xFFE7E5E1)
                          : const Color(0xFFF4F2EE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Обзор',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF30302D),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () => controller.openDialog(AppDialog.releaseNotes),
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 20, color: Color(0xFF8A8781)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                Text(
                  isHome ? 'Изменения последнего хода' : 'Git changes',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF242420),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  FluentIcons.chevron_down,
                  size: 10,
                  color: Color(0xFF9E9B95),
                ),
              ],
            ),
          ),
          Expanded(
            child: isHome
                ? const Center(
                    child: Text(
                      'Нет изменений',
                      style: TextStyle(fontSize: 17, color: Color(0xFFABAAA5)),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    children: [
                      _SegmentedHeader(
                        activeTab: controller.contextPanelTab,
                        onTabSelected: controller.setContextPanelTab,
                      ),
                      const SizedBox(height: 18),
                      if (session == null)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 140),
                            child: Text(
                              'No uncommitted changes yet',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFFABAAA5),
                              ),
                            ),
                          ),
                        )
                      else if (controller.contextPanelTab ==
                          ContextPanelTab.details)
                        ...session!.fileItems.map(
                          (item) => _FileListRow(
                            title: item.path.split('/').last,
                            subtitle: item.path.contains('/')
                                ? item.path.substring(
                                    0,
                                    item.path.lastIndexOf('/'),
                                  )
                                : '',
                            trailing: item.status,
                            onTap: () =>
                                controller.openDialog(AppDialog.selectFile),
                          ),
                        )
                      else if (controller.contextPanelTab ==
                          ContextPanelTab.activity)
                        ...session!.metrics.map(
                          (item) => _FileListRow(
                            title: item.label,
                            subtitle: 'Session metric',
                            trailing: item.value,
                            onTap: () =>
                                controller.openDialog(AppDialog.releaseNotes),
                          ),
                        )
                      else
                        ...session!.reviewItems.map(
                          (item) => _FileListRow(
                            title: item.title,
                            subtitle: item.summary,
                            trailing: item.severity,
                            onTap: () =>
                                controller.openDialog(AppDialog.forkSession),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedHeader extends StatelessWidget {
  const _SegmentedHeader({
    required this.activeTab,
    required this.onTabSelected,
  });

  final ContextPanelTab activeTab;
  final ValueChanged<ContextPanelTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onTabSelected(ContextPanelTab.activity),
          child: Text(
            '0 Изменения',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: activeTab == ContextPanelTab.activity
                  ? const Color(0xFF5A5752)
                  : const Color(0xFF9A9892),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => onTabSelected(ContextPanelTab.details),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: activeTab == ContextPanelTab.details
                  ? const Color(0xFFE7E5E1)
                  : const Color(0xFFF4F2EE),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text(
              'Все файлы',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2B),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onTabSelected(ContextPanelTab.agent),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: activeTab == ContextPanelTab.agent
                  ? const Color(0xFFE7E5E1)
                  : const Color(0xFFF4F2EE),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text(
              'Агент',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2B),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FileListRow extends StatelessWidget {
  const _FileListRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(FluentIcons.page, size: 13, color: Color(0xFF9A9791)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4C4B47),
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0AEA8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
              trailing,
              style: const TextStyle(fontSize: 12, color: Color(0xFF9B9892)),
            ),
          ],
        ),
      ),
    );
  }
}
