import 'package:codelab_ui_components/codelab_ui_components.dart' as ui;
import 'package:codelab_ui_components/codelab_ui_components.dart'
    show SessionRegionTab;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xterm/xterm.dart';

import '../../../../app/models/workspace_models.dart';
import '../../../../app/overlay/overlay_controller.dart';
import '../../../workspace/application/terminal_controller.dart'
    as app_terminal;
import '../../../workspace/application/workspace_controller.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_event.dart';

class SessionScreen extends fluent.StatefulWidget {
  const SessionScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  fluent.State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends fluent.State<SessionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<WorkspaceController>();
    if (controller.selectedSessionId != widget.sessionId) {
      fluent.WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<WorkspaceController>().selectSession(widget.sessionId);
      });
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();
    final session = controller.selectedSession;
    final project = controller.selectedProject;
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? ui.AppColors.light
        : ui.AppColors.dark;

    return ui.DesktopShell(
      titleBar: ui.TitleBar(
        onToggleSidebar: controller.toggleSidebarCollapsed,
        canBack: context.canPop(),
        onBack: context.canPop() ? () => context.pop() : null,
        onSearch: () => overlayController.show(AppOverlay.commandPalette),
        onToggleTerminal: controller.toggleBottomPanel,
        onNewWorkspace: () => overlayController.show(AppOverlay.settings),
        onToggleContextPanel: controller.toggleContextPanel,
        isContextPanelVisible: controller.contextPanelVisible,
        searchPlaceholder: 'Поиск...',
      ),
      projectRail: ui.ProjectRail(
        projects: controller.projects
            .map(
              (p) => ui.ProjectRailItem(
                id: p.id,
                name: p.name,
                color: fluent.Color(p.color),
                initials: p.initials,
              ),
            )
            .toList(),
        selectedProjectId: project?.id ?? '',
        onProjectSelected: (id) {
          controller.selectProject(id);
          context.go('/');
        },
        onAddProject: () => overlayController.show(AppOverlay.openProject),
        onSettings: () => overlayController.show(AppOverlay.settings),
        onHelp: () => overlayController.show(AppOverlay.help),
      ),
      sidebar: project != null
          ? ui.Sidebar(
              projectName: project.name,
              projectPath: project.path,
              branchName: session?.branchName ?? 'master',
              sessions: project.sessions
                  .map((s) => ui.SidebarSession(id: s.id, title: s.title))
                  .toList(),
              selectedSessionId: controller.selectedSession?.id,
              onSessionSelected: (id) {
                controller.selectSession(id);
              },
              onNewWorkspace: () => overlayController.show(AppOverlay.openProject),
              onEditProject: () => overlayController.show(AppOverlay.editProject),
              onConnectProvider: () =>
                  overlayController.show(AppOverlay.selectProvider),
            )
          : null,
      contextPanel: ui.ContextPanel(
        activeTab: ui.ContextPanelTab.details,
        onTabChanged: (tab) {},
        title: 'Изменения',
        items:
            session?.fileItems
                .map(
                  (f) => ui.ContextPanelItem(
                    title: f.path.split('/').last,
                    subtitle: f.summary,
                    trailing: f.status,
                  ),
                )
                .toList() ??
            [],
        isEmpty: session?.fileItems.isEmpty ?? true,
        emptyMessage: 'Нет изменений',
      ),
      showSidebar: !controller.sidebarCollapsed,
      showContextPanel: controller.contextPanelVisible,
      showBottomPanel: controller.bottomPanelVisible && session != null,
      bottomPanel: session == null
          ? null
          : _BottomTerminalPanel(session: session, colors: colors),
      content: session == null
          ? fluent.Center(
              child: ui.AppText.body(
                'Сессия не найдена',
                color: colors.textMuted,
              ),
            )
          : _SessionContent(session: session, colors: colors),
    );
  }
}

class _SessionContent extends fluent.StatelessWidget {
  const _SessionContent({required this.session, required this.colors});

  final SessionModel session;
  final ui.LightColors colors;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final overlayController = context.read<OverlayController>();

    final messages = session.messages.map((m) {
      ui.MessageRole role;
      switch (m.role) {
        case 'user':
          role = ui.MessageRole.user;
        case 'system':
          role = ui.MessageRole.system;
        default:
          role = ui.MessageRole.assistant;
      }
      return ui.Message(id: m.id, role: role, content: m.body);
    }).toList();

    return fluent.Column(
      children: [
        ui.SessionHeader(
          title: session.title,
          subtitle: session.updatedLabel,
          branchName: session.branchName,
          onFork: () => overlayController.show(AppOverlay.forkSession),
          onMore: () => overlayController.show(AppOverlay.commandPalette),
        ),
        fluent.Expanded(
          child: ui.MessageTimeline(
            messages: messages,
            onCopyCode: (code) {},
          ),
        ),
        fluent.Padding(
          padding: const fluent.EdgeInsets.fromLTRB(
            ui.AppSpacing.md,
            0,
            ui.AppSpacing.md,
            ui.AppSpacing.md,
          ),
          child: ui.PromptComposer(
            placeholder: 'Спросите что угодно...',
            onSend: (message) {
              context.read<ChatBloc>().add(
                    const ChatEvent.cleared(),
                  );
            },
          ),
        ),
      ],
    );
  }
}

class _BottomTerminalPanel extends fluent.StatelessWidget {
  const _BottomTerminalPanel({required this.session, required this.colors});

  final SessionModel session;
  final ui.LightColors colors;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final currentTab = controller.sessionTab;

    return fluent.Column(
      children: [
        fluent.Container(
          height: 42,
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: ui.AppSpacing.md,
          ),
          decoration: fluent.BoxDecoration(
            border: fluent.Border(
              bottom: fluent.BorderSide(color: colors.borderWeak),
            ),
          ),
          child: fluent.Row(
            children: [
              _TabButton(
                label: 'Файлы',
                isSelected: currentTab == SessionRegionTab.files,
                onTap: () => controller.setSessionTab(SessionRegionTab.files),
                colors: colors,
              ),
              const fluent.SizedBox(width: ui.AppSpacing.lg),
              _TabButton(
                label: 'Ревью',
                isSelected: currentTab == SessionRegionTab.review,
                onTap: () => controller.setSessionTab(SessionRegionTab.review),
                colors: colors,
              ),
              const fluent.SizedBox(width: ui.AppSpacing.lg),
              _TabButton(
                label: 'Терминал',
                isSelected: currentTab == SessionRegionTab.terminal,
                onTap: () =>
                    controller.setSessionTab(SessionRegionTab.terminal),
                colors: colors,
              ),
              const fluent.Spacer(),
              fluent.GestureDetector(
                onTap: controller.toggleBottomPanel,
                child: ui.AppIcon.sm(
                  ui.AppIcons.close,
                  color: colors.iconMuted,
                ),
              ),
              const fluent.SizedBox(width: ui.AppSpacing.md),
              fluent.GestureDetector(
                onTap: () =>
                    controller.setSessionTab(SessionRegionTab.terminal),
                child: ui.AppIcon.sm(ui.AppIcons.add, color: colors.iconMuted),
              ),
            ],
          ),
        ),
        fluent.Expanded(
          child: _BottomPanelContent(
            session: session,
            tab: currentTab,
            colors: colors,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends fluent.StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final bool isSelected;
  final fluent.VoidCallback onTap;
  final ui.LightColors colors;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Column(
        mainAxisAlignment: fluent.MainAxisAlignment.end,
        children: [
          ui.AppText(
            label,
            variant: ui.TextVariant.label,
            color: isSelected ? colors.textStrong : colors.textMuted,
          ),
          const fluent.SizedBox(height: ui.AppSpacing.sm),
          fluent.Container(
            height: 2,
            width: 72,
            color: isSelected ? colors.accentPrimary : fluent.Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _BottomPanelContent extends fluent.StatelessWidget {
  const _BottomPanelContent({
    required this.session,
    required this.tab,
    required this.colors,
  });

  final SessionModel session;
  final SessionRegionTab tab;
  final ui.LightColors colors;

  String _getProjectPath(fluent.BuildContext context) {
    final controller = context.read<WorkspaceController>();
    return controller.selectedProject?.path ?? '';
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    switch (tab) {
      case SessionRegionTab.files:
        return ui.FileList(
          nodes: session.fileItems
              .map(
                (f) => ui.FileNode(
                  id: f.path,
                  label: f.path.split('/').last,
                  badge: f.path,
                  isFolder: false,
                ),
              )
              .toList(),
          onNodeToggle: (id) {},
        );
      case SessionRegionTab.review:
        return ui.ReviewList(
          items: session.reviewItems
              .map(
                (r) => ui.ReviewItem(
                  id: r.title,
                  title: r.title,
                  summary: r.summary,
                  severity: r.severity,
                ),
              )
              .toList(),
          onItemTap: (item) {},
        );
      case SessionRegionTab.terminal:
        return _TerminalContent(
          projectPath: _getProjectPath(context),
          colors: colors,
        );
    }
  }
}

class _TerminalContent extends fluent.StatefulWidget {
  const _TerminalContent({required this.projectPath, required this.colors});

  final String projectPath;
  final ui.LightColors colors;

  @override
  fluent.State<_TerminalContent> createState() => _TerminalContentState();
}

class _TerminalContentState extends fluent.State<_TerminalContent> {
  @override
  void initState() {
    super.initState();
    final controller = context.read<WorkspaceController>();
    if (controller.terminalController.sessions.isEmpty) {
      controller.terminalController.create(
        'Terminal 1',
        workingDirectory: widget.projectPath,
      );
    }
  }

  @override
  void didUpdateWidget(_TerminalContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectPath != widget.projectPath) {
      final controller = context.read<WorkspaceController>();
      if (controller.terminalController.sessions.isEmpty) {
        controller.terminalController.create(
          'Terminal 1',
          workingDirectory: widget.projectPath,
        );
      }
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final workspaceController = context.watch<WorkspaceController>();
    final terminalController = workspaceController.terminalController;
    final sessions = terminalController.sessions;
    final activeSessionId = terminalController.activeSessionId;

    return fluent.Column(
      children: [
        ui.TerminalSessionTabs(
          sessions: sessions
              .map(
                (s) => ui.TerminalSessionTabData(
                  id: s.id,
                  title: s.title,
                  isActive: s.id == activeSessionId,
                ),
              )
              .toList(),
          activeSessionId: activeSessionId,
          onTabSelected: terminalController.activate,
          onTabClosed: terminalController.close,
          onAddTab: () {
            terminalController.create(
              'Terminal ${sessions.length + 1}',
              workingDirectory: widget.projectPath,
            );
          },
        ),
        fluent.Expanded(
          child: activeSessionId != null
              ? _ActiveTerminalView(
                  sessionId: activeSessionId,
                  terminalController: terminalController,
                  colors: widget.colors,
                )
              : fluent.Center(
                  child: ui.AppText.body(
                    'No terminal sessions',
                    color: widget.colors.textMuted,
                  ),
                ),
        ),
      ],
    );
  }
}

class _ActiveTerminalView extends fluent.StatefulWidget {
  const _ActiveTerminalView({
    required this.sessionId,
    required this.terminalController,
    required this.colors,
  });

  final String sessionId;
  final app_terminal.TerminalController terminalController;
  final ui.LightColors colors;

  @override
  fluent.State<_ActiveTerminalView> createState() =>
      _ActiveTerminalViewState();
}

class _ActiveTerminalViewState extends fluent.State<_ActiveTerminalView> {
  Terminal? _terminal;

  @override
  void initState() {
    super.initState();
    _terminal = widget.terminalController.getActiveTerminal();
  }

  @override
  void didUpdateWidget(_ActiveTerminalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionId != widget.sessionId) {
      _terminal = widget.terminalController.getActiveTerminal();
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final terminal = _terminal;
    if (terminal == null) {
      return const ui.TerminalLoading();
    }

    return ui.TerminalPanelShell(
      title: widget.terminalController.activeSession?.title ?? 'Terminal',
      child: TerminalView(
        terminal,
        theme: TerminalTheme(
          cursor: widget.colors.accentPrimary,
          selection: widget.colors.accentSubtle.withValues(alpha: 0.3),
          foreground: widget.colors.textBase,
          background: widget.colors.backgroundBase,
          black: const fluent.Color(0xFF000000),
          white: const fluent.Color(0xFFFFFFFF),
          red: widget.colors.errorBase,
          green: widget.colors.successBase,
          yellow: widget.colors.warningBase,
          blue: widget.colors.infoBase,
          magenta: const fluent.Color(0xFFD33682),
          cyan: const fluent.Color(0xFF2AA198),
          brightBlack: const fluent.Color(0xFF586E75),
          brightWhite: const fluent.Color(0xFFFDF6E3),
          brightRed: widget.colors.errorStrong,
          brightGreen: widget.colors.successStrong,
          brightYellow: widget.colors.warningStrong,
          brightBlue: widget.colors.infoStrong,
          brightMagenta: const fluent.Color(0xFF6C71C4),
          brightCyan: const fluent.Color(0xFF93A1A1),
          searchHitBackground: widget.colors.warningSubtle,
          searchHitBackgroundCurrent: widget.colors.warningBase,
          searchHitForeground: widget.colors.backgroundBase,
        ),
        textStyle: const TerminalStyle(
          fontFamily: ui.AppTypography.fontFamilyMono,
        ),
        padding: const fluent.EdgeInsets.all(ui.AppSpacing.sm),
        autofocus: true,
      ),
    );
  }
}
