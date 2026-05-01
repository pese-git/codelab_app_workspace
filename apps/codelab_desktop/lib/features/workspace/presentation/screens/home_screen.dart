import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xterm/xterm.dart';

import '../../../../app/models/workspace_models.dart';
import '../../../../app/overlay/overlay_controller.dart';
import '../../../workspace/application/terminal_controller.dart'
    as app_terminal;
import '../../application/workspace_controller.dart';

class HomeScreen extends fluent.StatelessWidget {
  const HomeScreen({super.key});

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();
    final project = controller.selectedProject;
    final hasProjects = controller.projects.isNotEmpty;
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return DesktopShell(
      titleBar: TitleBar(
        onToggleSidebar: controller.toggleSidebarCollapsed,
        canBack: context.canPop(),
        onBack: context.canPop() ? () => context.pop() : null,
        onSearch: () => overlayController.show(AppOverlay.commandPalette),
        onConnections: () => overlayController.show(AppOverlay.selectServer),
        onToggleTerminal: controller.toggleBottomPanel,
        onNewWorkspace: () => overlayController.show(AppOverlay.openProject),
        onToggleContextPanel: controller.toggleContextPanel,
        isContextPanelVisible: controller.contextPanelVisible,
        searchPlaceholder: 'Поиск в проекте...',
      ),
      projectRail: ProjectRail(
        projects: controller.projects
            .map(
              (p) => ProjectRailItem(
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
      sidebar: hasProjects
          ? Sidebar(
              projectName: project!.name,
              projectPath: project.path,
              branchName: 'master',
              sessions: project.sessions
                  .map((s) => SidebarSession(id: s.id, title: s.title))
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
      contextPanel: ContextPanel(
        activeTab: ContextPanelTab.details,
        onTabChanged: (tab) {},
        title: 'Обзор',
        isEmpty: true,
        emptyMessage: 'Выберите сессию для просмотра изменений',
      ),
      showSidebar: !controller.sidebarCollapsed && hasProjects,
      showContextPanel: controller.contextPanelVisible,
      showBottomPanel: controller.bottomPanelVisible,
      bottomPanel: hasProjects
          ? _HomeBottomPanel(projectPath: project!.path, colors: colors)
          : null,
      content: hasProjects
          ? _HomeContent(project: project!, colors: colors)
          : _EmptyWorkspace(onOpenProject: () => overlayController.show(AppOverlay.openProject)),
    );
  }
}

class _EmptyWorkspace extends fluent.StatelessWidget {
  const _EmptyWorkspace({required this.onOpenProject});

  final fluent.VoidCallback onOpenProject;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Center(
      child: fluent.Column(
        mainAxisAlignment: fluent.MainAxisAlignment.center,
        children: [
          AppIcon.lg(AppIcons.folder, color: colors.iconMuted),
          const fluent.SizedBox(height: AppSpacing.xl),
          AppText.display(
            'Добро пожаловать в CodeLab',
            color: colors.textStrong,
          ),
          const fluent.SizedBox(height: AppSpacing.md),
          AppText.subtitle(
            'Откройте проект, чтобы начать работу',
            color: colors.textMuted,
          ),
          const fluent.SizedBox(height: AppSpacing.xl),
          fluent.GestureDetector(
            onTap: onOpenProject,
            child: fluent.Container(
              height: 48,
              padding: const fluent.EdgeInsets.symmetric(horizontal: 28),
              decoration: fluent.BoxDecoration(
                color: colors.accentPrimary,
                borderRadius: AppRadius.lgAll,
              ),
              child: const fluent.Center(
                child: AppText.body(
                  'Открыть проект',
                  color: fluent.Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends fluent.StatelessWidget {
  const _HomeContent({required this.project, required this.colors});

  final ProjectModel project;
  final LightColors colors;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();

    return fluent.Column(
      children: [
        fluent.Expanded(
          child: fluent.SingleChildScrollView(
            child: fluent.Center(
              child: fluent.Column(
                mainAxisAlignment: fluent.MainAxisAlignment.center,
                children: [
                  Surface(
                    width: 68,
                    height: 68,
                    borderColor: colors.accentPrimary,
                    borderRadius: fluent.BorderRadius.zero,
                    color: fluent.Colors.transparent,
                    child: const fluent.SizedBox.shrink(),
                  ),
                  const fluent.SizedBox(height: AppSpacing.xl),
                  AppText.display(
                    'Создавайте что угодно',
                    color: colors.textStrong,
                  ),
                  const fluent.SizedBox(height: AppSpacing.xl),
                  AppText.subtitle(
                    project.path,
                    color: colors.textMuted,
                  ),
                  const fluent.SizedBox(height: AppSpacing.lg),
                  fluent.Row(
                    mainAxisAlignment: fluent.MainAxisAlignment.center,
                    children: [
                      AppIcon.sm(AppIcons.branch, color: colors.iconMuted),
                      const fluent.SizedBox(width: AppSpacing.sm),
                      AppText.body(
                        'Основная ветка (master)',
                        color: colors.textMuted,
                      ),
                    ],
                  ),
                  const fluent.SizedBox(height: AppSpacing.lg),
                  fluent.Row(
                    mainAxisAlignment: fluent.MainAxisAlignment.center,
                    children: [
                      fluent.Flexible(
                        child: AppText.subtitle(
                          'Последнее изменение ',
                          color: colors.textMuted,
                        ),
                      ),
                      fluent.Flexible(
                        child: AppText(
                          '45 минут назад',
                          variant: TextVariant.subtitle,
                          color: colors.textStrong,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        fluent.Padding(
          padding: const fluent.EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: _HomePromptComposer(
            placeholder:
                'Спросите что угодно... "Рефакторить эту функцию для лучшей читаемости"',
            onSend: (message) {
              if (project.sessions.isNotEmpty) {
                final sessionId = project.sessions.first.id;
                controller.selectSession(sessionId);
              }
            },
            onAddFile: () => overlayController.show(AppOverlay.selectFile),
            onSelectModel: () => overlayController.show(AppOverlay.selectModel),
            onSelectProvider: () =>
                overlayController.show(AppOverlay.selectProvider),
          ),
        ),
      ],
    );
  }
}

class _HomePromptComposer extends fluent.StatelessWidget {
  const _HomePromptComposer({
    required this.placeholder,
    required this.onSend,
    this.onAddFile,
    this.onSelectModel,
    this.onSelectProvider,
  });

  final String placeholder;
  final void Function(String) onSend;
  final fluent.VoidCallback? onAddFile;
  final fluent.VoidCallback? onSelectModel;
  final fluent.VoidCallback? onSelectProvider;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Surface(
      height: 184,
      padding: const fluent.EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      borderRadius: AppRadius.xxlAll,
      borderColor: colors.borderBase,
      color: colors.surfaceBase,
      child: fluent.Column(
        children: [
          fluent.Expanded(
            child: fluent.Align(
              alignment: fluent.Alignment.topLeft,
              child: AppText.body(placeholder, color: colors.textMuted),
            ),
          ),
          fluent.Row(
            children: [
              fluent.GestureDetector(
                onTap: onAddFile,
                child: AppIcon.md(AppIcons.add, color: colors.iconMuted),
              ),
              const fluent.Spacer(),
              fluent.GestureDetector(
                onTap: () => onSend(''),
                child: Surface(
                  width: 44,
                  height: 44,
                  borderRadius: AppRadius.lgAll,
                  color: colors.accentSubtle,
                  child: fluent.Center(
                    child: AppIcon.md(
                      AppIcons.chevronUp,
                      color: colors.iconBase,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const fluent.SizedBox(height: AppSpacing.lg),
          fluent.Row(
            children: [
              fluent.GestureDetector(
                onTap: onSelectModel,
                child: AppText.body('Build', color: colors.textWeak),
              ),
              const fluent.SizedBox(width: AppSpacing.xs),
              AppIcon.sm(AppIcons.chevronDown, color: colors.iconMuted),
              const fluent.SizedBox(width: AppSpacing.lg),
              AppIcon.sm(fluent.FluentIcons.contact, color: colors.iconMuted),
              const fluent.SizedBox(width: AppSpacing.sm),
              fluent.GestureDetector(
                onTap: onSelectProvider,
                child: AppText.body('Big Pickle', color: colors.textWeak),
              ),
              const fluent.SizedBox(width: AppSpacing.xs),
              AppIcon.sm(AppIcons.chevronDown, color: colors.iconMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeBottomPanel extends fluent.StatefulWidget {
  const _HomeBottomPanel({required this.projectPath, required this.colors});

  final String projectPath;
  final LightColors colors;

  @override
  fluent.State<_HomeBottomPanel> createState() => _HomeBottomPanelState();
}

class _HomeBottomPanelState extends fluent.State<_HomeBottomPanel> {
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
  fluent.Widget build(fluent.BuildContext context) {
    final workspaceController = context.watch<WorkspaceController>();
    final terminalController = workspaceController.terminalController;
    final sessions = terminalController.sessions;
    final activeSessionId = terminalController.activeSessionId;

    return fluent.Column(
      children: [
        TerminalSessionTabs(
          sessions: sessions
              .map(
                (s) => TerminalSessionTabData(
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
              ? _HomeTerminalView(
                  terminalController: terminalController,
                  colors: widget.colors,
                )
              : fluent.Center(
                  child: AppText.body(
                    'No terminal sessions',
                    color: widget.colors.textMuted,
                  ),
                ),
        ),
      ],
    );
  }
}

class _HomeTerminalView extends fluent.StatefulWidget {
  const _HomeTerminalView({
    required this.terminalController,
    required this.colors,
  });

  final app_terminal.TerminalController terminalController;
  final LightColors colors;

  @override
  fluent.State<_HomeTerminalView> createState() => _HomeTerminalViewState();
}

class _HomeTerminalViewState extends fluent.State<_HomeTerminalView> {
  Terminal? _terminal;

  @override
  void initState() {
    super.initState();
    _terminal = widget.terminalController.getActiveTerminal();
  }

  @override
  void didUpdateWidget(_HomeTerminalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _terminal = widget.terminalController.getActiveTerminal();
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final terminal = _terminal;
    if (terminal == null) {
      return const TerminalLoading();
    }

    return TerminalPanelShell(
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
          fontFamily: AppTypography.fontFamilyMono,
        ),
        padding: const fluent.EdgeInsets.all(AppSpacing.sm),
        autofocus: true,
      ),
    );
  }
}
