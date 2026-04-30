import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../overlay/overlay_controller.dart';
import '../state/workspace_controller.dart';

class HomeScreen extends fluent.StatelessWidget {
  const HomeScreen({super.key});

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();
    final project = controller.selectedProject;
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return DesktopShell(
      titleBar: TitleBar(
        onToggleSidebar: controller.toggleSidebarCollapsed,
        canBack: context.canPop(),
        onBack: context.canPop() ? () => context.pop() : null,
        canForward: false,
        onSearch: () => overlayController.show(AppOverlay.commandPalette),
        onToggleTerminal: controller.toggleBottomPanel,
        onNewWorkspace: () => overlayController.show(AppOverlay.settings),
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
        selectedProjectId: project.id,
        onProjectSelected: (id) {
          controller.selectProject(id);
          context.go('/');
        },
        onAddProject: () => overlayController.show(AppOverlay.settings),
        onSettings: () => overlayController.show(AppOverlay.settings),
        onHelp: () => overlayController.show(AppOverlay.help),
      ),
      sidebar: Sidebar(
        projectName: project.name,
        projectPath:
            '/Users/.../CodeLab/${project.name.toLowerCase().replaceAll(' ', '_')}',
        branchName: 'master',
        sessions: project.sessions
            .map((s) => SidebarSession(id: s.id, title: s.title))
            .toList(),
        selectedSessionId: controller.selectedSession?.id,
        onSessionSelected: (id) {
          controller.selectSession(id);
          context.go('/session/$id');
        },
        onNewWorkspace: () => overlayController.show(AppOverlay.settings),
        onEditProject: () => overlayController.show(AppOverlay.editProject),
        onConnectProvider: () =>
            overlayController.show(AppOverlay.selectProvider),
      ),
      contextPanel: ContextPanel(
        activeTab: ContextPanelTab.details,
        onTabChanged: (tab) {},
        title: 'Обзор',
        isEmpty: true,
        emptyMessage: 'Выберите сессию для просмотра изменений',
      ),
      showSidebar: !controller.sidebarCollapsed,
      showContextPanel: controller.contextPanelVisible,
      content: _HomeContent(project: project, colors: colors),
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
                    '/Users/CodeLab/${project.name.toLowerCase().replaceAll(' ', '_')}',
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
                context.go('/session/$sessionId');
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
