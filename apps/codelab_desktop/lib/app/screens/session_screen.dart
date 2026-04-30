import 'package:codelab_ui_components/codelab_ui_components.dart' as ui;
import 'package:codelab_ui_components/codelab_ui_components.dart'
    show SessionRegionTab;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../state/app_scope.dart';
import '../../core/di/di_scope_widget.dart';
import '../../core/di/injection.dart';
import '../../core/di/session_module.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../../presentation/blocs/chat/chat_event.dart';
import '../../presentation/blocs/permission/permission_bloc.dart';

/// Session screen widget using UI components from codelab_ui_components.
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
    final controller = CodeLabAppScope.of(context);
    if (controller.selectedSessionId != widget.sessionId) {
      fluent.WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        CodeLabAppScope.of(context).selectSession(widget.sessionId);
      });
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final session = controller.selectedSession;
    final project = controller.selectedProject;
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? ui.AppColors.light
        : ui.AppColors.dark;

    return DiScope(
      scope: rootScope.openSubScope('session:${widget.sessionId}')..installModules([SessionModule(sessionId: widget.sessionId)]),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) {
              final bloc = ChatBloc(sendPromptUseCase: ctx.resolve());
              bloc.add(ChatEvent.sessionOpened(sessionId: widget.sessionId));
              return bloc;
            },
          ),
          BlocProvider(
            create: (_) => PermissionBloc(),
          ),
        ],
        child: ui.DesktopShell(
      titleBar: ui.TitleBar(
        onToggleSidebar: controller.toggleSidebarCollapsed,
        canBack: context.canPop(),
        onBack: context.canPop() ? () => context.pop() : null,
        canForward: false,
        onSearch: () => controller.openDialog(AppDialog.commandPalette),
        onToggleTerminal: controller.toggleBottomPanel,
        onNewWorkspace: () => controller.openDialog(AppDialog.settings),
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
        selectedProjectId: project.id,
        onProjectSelected: (id) {
          controller.selectProject(id);
          context.go('/');
        },
        onAddProject: () => controller.openDialog(AppDialog.settings),
        onSettings: () => controller.openDialog(AppDialog.settings),
        onHelp: () => controller.openDialog(AppDialog.help),
      ),
      sidebar: ui.Sidebar(
        projectName: project.name,
        projectPath: project.path,
        branchName: session?.branchName ?? 'master',
        sessions: project.sessions
            .map((s) => ui.SidebarSession(id: s.id, title: s.title))
            .toList(),
        selectedSessionId: controller.selectedSession?.id,
        onSessionSelected: (id) {
          controller.selectSession(id);
          context.go('/session/$id');
        },
        onNewWorkspace: () => controller.openDialog(AppDialog.settings),
        onEditProject: () => controller.openDialog(AppDialog.editProject),
        onConnectProvider: () =>
            controller.openDialog(AppDialog.selectProvider),
      ),
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
        ),
      ),
    );
  }
}

class _SessionContent extends fluent.StatelessWidget {
  const _SessionContent({required this.session, required this.colors});

  final SessionModel session;
  final ui.LightColors colors;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    // Convert SessionModel messages to UI Message format
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
        // Session header
        ui.SessionHeader(
          title: session.title,
          subtitle: session.updatedLabel,
          branchName: session.branchName,
          onFork: () => controller.openDialog(AppDialog.forkSession),
          onMore: () => controller.openDialog(AppDialog.commandPalette),
        ),
        // Messages
        fluent.Expanded(
          child: ui.MessageTimeline(
            messages: messages,
            onCopyCode: (code) {
              // Copy code to clipboard
            },
          ),
        ),
        // Composer
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
              // Handle send message
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
    final controller = CodeLabAppScope.of(context);
    final currentTab = controller.sessionTab;

    return fluent.Column(
      children: [
        // Tab bar
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
        // Content
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
            color: isSelected
                ? colors.accentPrimary
                : fluent.Colors.transparent,
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
          expandedNodes: const {},
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
                  severity: r.severity, //_parseSeverity(r.severity),
                ),
              )
              .toList(),
          onItemTap: (item) {},
        );
      case SessionRegionTab.terminal:
        return ui.TerminalPanelShell(
          title: 'Terminal 1',
          onClose: () => CodeLabAppScope.of(context).toggleBottomPanel(),
          child: fluent.Padding(
            padding: const fluent.EdgeInsets.all(ui.AppSpacing.md),
            child: fluent.Align(
              alignment: fluent.Alignment.topLeft,
              child: ui.AppText(
                'penkovsky_sa@MacBook-Pro % flutter analyze\n${session.terminalEntries.map((e) => e.command).join('\n')}',
                variant: ui.TextVariant.code,
                color: colors.textBase,
              ),
            ),
          ),
        );
    }
  }

  /*
  ui.ReviewSeverity _parseSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return ui.ReviewSeverity.critical;
      case 'high':
        return ui.ReviewSeverity.high;
      case 'medium':
        return ui.ReviewSeverity.medium;
      case 'low':
        return ui.ReviewSeverity.low;
      default:
        return ui.ReviewSeverity.info;
    }
  }
  */
}
