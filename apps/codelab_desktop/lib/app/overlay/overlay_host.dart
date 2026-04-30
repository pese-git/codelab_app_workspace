import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../state/workspace_controller.dart';
import 'overlay_controller.dart';

class OverlayHost extends StatelessWidget {
  const OverlayHost({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final overlayController = context.watch<OverlayController>();
    final overlay = overlayController.current;

    if (overlay == null) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: GestureDetector(
            onTap: overlayController.close,
            child: Container(
              color: const Color(0x40E7E4DE),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: _OverlaySurface(overlay: overlay),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OverlaySurface extends StatelessWidget {
  const _OverlaySurface({required this.overlay});

  final AppOverlay overlay;

  @override
  Widget build(BuildContext context) {
    switch (overlay) {
      case AppOverlay.settings:
        return const _SettingsOverlay();
      case AppOverlay.selectServer:
        return const _ServersOverlay();
      case AppOverlay.selectProvider:
        return const _ChoiceOverlay(
          title: 'Провайдеры',
          searchPlaceholder: 'Поиск провайдеров',
          source: _ChoiceSource.providers,
          primaryAction: 'Подключить провайдера',
        );
      case AppOverlay.selectModel:
        return const _ChoiceOverlay(
          title: 'Модели',
          searchPlaceholder: 'Поиск моделей',
          source: _ChoiceSource.models,
        );
      case AppOverlay.selectMcp:
        return const _ChoiceOverlay(
          title: 'Инструменты',
          searchPlaceholder: 'Поиск инструментов',
          source: _ChoiceSource.mcps,
        );
      case AppOverlay.selectDirectory:
      case AppOverlay.selectFile:
      case AppOverlay.editProject:
      case AppOverlay.forkSession:
      case AppOverlay.help:
      case AppOverlay.releaseNotes:
      case AppOverlay.commandPalette:
        return _GenericOverlay(overlay: overlay);
    }
  }
}

class _SettingsOverlay extends StatelessWidget {
  const _SettingsOverlay();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return _OverlayFrame(
      width: 1280,
      height: 812,
      child: Row(
        children: [
          Container(
            width: 272,
            padding: const EdgeInsets.fromLTRB(18, 26, 18, 18),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: colors.borderBase)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Приложение',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A9892),
                  ),
                ),
                const SizedBox(height: 10),
                const _SettingsNavTile(
                  icon: FluentIcons.settings,
                  label: 'Основные',
                  selected: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Сервер',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A9892),
                  ),
                ),
                const SizedBox(height: 10),
                _SettingsNavTile(
                  icon: FluentIcons.server_processes,
                  label: 'Провайдеры',
                  onTap: () {
                    overlayController.close();
                    overlayController.show(AppOverlay.selectProvider);
                  },
                ),
                _SettingsNavTile(
                  icon: FluentIcons.favorite_list,
                  label: 'Модели',
                  onTap: () {
                    overlayController.close();
                    overlayController.show(AppOverlay.selectModel);
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(54, 34, 54, 28),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Основные',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF23231F),
                          ),
                        ),
                      ),
                      _CloseIconButton(onTap: overlayController.close),
                    ],
                  ),
                  const SizedBox(height: 26),
                  _SettingsSection(
                    children: [
                      _SettingsRow(
                        title: 'Язык',
                        subtitle: 'Изменить язык отображения OpenCode',
                        trailing: _DropdownPill(
                          label: 'Русский',
                          onTap: overlayController.close,
                        ),
                      ),
                      _SettingsRow(
                        title: 'Автоматически принимать разрешения',
                        subtitle:
                            'Запросы на разрешения будут одобряться автоматически',
                        trailing: _SwitchStub(
                          enabled: controller.isSettingEnabled('autoApprove'),
                          onTap: () => controller.toggleSetting('autoApprove'),
                        ),
                      ),
                      _SettingsRow(
                        title: 'Показывать сводки рассуждений',
                        subtitle:
                            'Отображать сводки рассуждений модели в ленте',
                        trailing: _SwitchStub(
                          enabled: controller.isSettingEnabled('showReasoning'),
                          onTap: () => controller.toggleSetting('showReasoning'),
                        ),
                      ),
                      _SettingsRow(
                        title: 'Разворачивать элементы инструмента shell',
                        subtitle:
                            'Показывать элементы инструмента shell в ленте развернутыми по умолчанию',
                        trailing: _SwitchStub(
                          enabled: controller.isSettingEnabled('expandShell'),
                          onTap: () => controller.toggleSetting('expandShell'),
                        ),
                      ),
                      _SettingsRow(
                        title: 'Разворачивать элементы инструмента edit',
                        subtitle:
                            'Показывать элементов инструментов edit, write и patch в ленте развернутыми по умолчанию',
                        trailing: _SwitchStub(
                          enabled: controller.isSettingEnabled('expandEdit'),
                          onTap: () => controller.toggleSetting('expandEdit'),
                        ),
                      ),
                      _SettingsRow(
                        title: 'Показывать индикатор прогресса сессии',
                        subtitle:
                            'Показывать анимированный индикатор прогресса вверху сессии, когда агент работает',
                        trailing: _SwitchStub(
                          enabled: controller.isSettingEnabled('showProgress'),
                          onTap: () => controller.toggleSetting('showProgress'),
                        ),
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  _SettingsSection(
                    title: 'Внешний вид',
                    children: [
                      _SettingsRow(
                        title: 'Цветовая схема',
                        subtitle:
                            'Выберите, следует ли OpenCode системной, светлой или тёмной теме',
                        trailing: _DropdownPill(
                          label: 'Системная',
                          onTap: overlayController.close,
                        ),
                        showDivider: false,
                      ),
                    ],
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

class _ServersOverlay extends StatelessWidget {
  const _ServersOverlay();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();

    return _OverlayFrame(
      width: 870,
      height: 380,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Серверы',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF23231F),
                    ),
                  ),
                ),
                _CloseIconButton(onTap: overlayController.close),
              ],
            ),
            const SizedBox(height: 20),
            const _SearchField(placeholder: 'Поиск серверов'),
            const SizedBox(height: 22),
            ...controller.servers.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChoiceTile(
                  label: item == 'Local Agent' ? 'Локальный сервер' : item,
                  subtitle: item == controller.selectedServer
                      ? 'v1.14.25'
                      : null,
                  selected: item == controller.selectedServer,
                  leading: const _StatusDot(),
                  trailing: item == controller.selectedServer
                      ? const Icon(
                          FluentIcons.check_mark,
                          color: Color(0xFF8E8B86),
                          size: 16,
                        )
                      : null,
                  onTap: () {
                    controller.chooseServer(item);
                    overlayController.close();
                  },
                ),
              ),
            ),
            const Spacer(),
            _SecondaryActionButton(
              label: 'Добавить сервер',
              onTap: overlayController.close,
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChoiceSource { providers, models, mcps }

class _ChoiceOverlay extends StatelessWidget {
  const _ChoiceOverlay({
    required this.title,
    required this.searchPlaceholder,
    required this.source,
    this.primaryAction,
  });

  final String title;
  final String searchPlaceholder;
  final _ChoiceSource source;
  final String? primaryAction;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();
    final entries = switch (source) {
      _ChoiceSource.providers => controller.providers,
      _ChoiceSource.models => controller.models,
      _ChoiceSource.mcps => controller.mcps,
    };

    bool isSelected(String value) => switch (source) {
      _ChoiceSource.providers => value == controller.selectedProvider,
      _ChoiceSource.models => value == controller.selectedModel,
      _ChoiceSource.mcps => value == controller.selectedMcp,
    };

    void select(String value) {
      switch (source) {
        case _ChoiceSource.providers:
          controller.chooseProvider(value);
        case _ChoiceSource.models:
          controller.chooseModel(value);
        case _ChoiceSource.mcps:
          controller.chooseMcp(value);
      }
      overlayController.close();
    }

    return _OverlayFrame(
      width: 870,
      height: 430,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF23231F),
                    ),
                  ),
                ),
                _CloseIconButton(onTap: overlayController.close),
              ],
            ),
            const SizedBox(height: 20),
            _SearchField(placeholder: searchPlaceholder),
            const SizedBox(height: 22),
            ...entries.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ChoiceTile(
                  label: item,
                  selected: isSelected(item),
                  trailing: isSelected(item)
                      ? const Icon(
                          FluentIcons.check_mark,
                          color: Color(0xFF8E8B86),
                          size: 16,
                        )
                      : null,
                  onTap: () => select(item),
                ),
              ),
            ),
            const Spacer(),
            if (primaryAction != null)
              _SecondaryActionButton(
                label: primaryAction!,
                onTap: overlayController.close,
              ),
          ],
        ),
      ),
    );
  }
}

class _GenericOverlay extends StatelessWidget {
  const _GenericOverlay({required this.overlay});

  final AppOverlay overlay;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkspaceController>();
    final overlayController = context.read<OverlayController>();
    final actions = _actions(context, controller, overlayController);

    return _OverlayFrame(
      width: 700,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _title(overlay),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF23231F),
                    ),
                  ),
                ),
                _CloseIconButton(onTap: overlayController.close),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _description(overlay),
              style: const TextStyle(
                fontSize: 15,
                height: 1.45,
                color: Color(0xFF6B6963),
              ),
            ),
            const SizedBox(height: 18),
            for (final (index, action) in actions.indexed) ...[
              _ChoiceTile(
                label: action.label,
                subtitle: action.subtitle,
                onTap: action.onTap,
              ),
              if (index != actions.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  String _title(AppOverlay overlay) {
    switch (overlay) {
      case AppOverlay.selectDirectory:
        return 'Рабочие пространства';
      case AppOverlay.selectFile:
        return 'Файлы';
      case AppOverlay.editProject:
        return 'Проект';
      case AppOverlay.forkSession:
        return 'Fork session';
      case AppOverlay.help:
        return 'Справка';
      case AppOverlay.releaseNotes:
        return 'Что нового';
      case AppOverlay.commandPalette:
        return 'Команды';
      case AppOverlay.settings:
      case AppOverlay.selectModel:
      case AppOverlay.selectProvider:
      case AppOverlay.selectMcp:
      case AppOverlay.selectServer:
        return '';
    }
  }

  String _description(AppOverlay overlay) {
    switch (overlay) {
      case AppOverlay.selectDirectory:
        return 'Mock directory picker for opening another workspace.';
      case AppOverlay.selectFile:
        return 'Quick file search surface with recent and suggested files.';
      case AppOverlay.editProject:
        return 'Update project labels, path details and pinned status.';
      case AppOverlay.forkSession:
        return 'Create a new session branch from the current state.';
      case AppOverlay.help:
        return 'Keybinds, command routes and desktop navigation hints.';
      case AppOverlay.releaseNotes:
        return 'Recent shipped updates for the desktop prototype.';
      case AppOverlay.commandPalette:
        return 'Search commands, routes, dialogs and recent actions.';
      case AppOverlay.settings:
      case AppOverlay.selectModel:
      case AppOverlay.selectProvider:
      case AppOverlay.selectMcp:
      case AppOverlay.selectServer:
        return '';
    }
  }

  List<_OverlayAction> _actions(
    BuildContext context,
    WorkspaceController controller,
    OverlayController overlayController,
  ) {
    switch (overlay) {
      case AppOverlay.selectDirectory:
        return [
          for (final project in controller.projects)
            _OverlayAction(
              label: project.name,
              subtitle: project.path,
              onTap: () {
                controller.selectProject(project.id);
                overlayController.close();
                context.go('/');
              },
            ),
        ];
      case AppOverlay.selectFile:
        final session = controller.selectedSession;
        final fileItems = session?.fileItems ?? const <FileItem>[];
        return [
          for (final item in fileItems)
            _OverlayAction(
              label: item.path,
              subtitle: item.summary,
              onTap: overlayController.close,
            ),
        ];
      case AppOverlay.editProject:
        return [
          _OverlayAction(
            label: 'Открыть настройки проекта',
            subtitle: 'Изменить название, путь и закрепление проекта',
            onTap: overlayController.close,
          ),
          _OverlayAction(
            label: 'Сменить рабочее пространство',
            subtitle: 'Открыть выбор директории для текущего проекта',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.selectDirectory);
            },
          ),
        ];
      case AppOverlay.forkSession:
        return [
          _OverlayAction(
            label: 'Создать новую ветку сессии',
            subtitle: 'Fork текущего состояния в отдельную сессию',
            onTap: overlayController.close,
          ),
          _OverlayAction(
            label: 'Продолжить в текущей сессии',
            subtitle: 'Закрыть диалог и остаться в этой ветке',
            onTap: overlayController.close,
          ),
        ];
      case AppOverlay.help:
        return [
          _OverlayAction(
            label: 'Открыть настройки',
            subtitle: 'Перейти к основным настройкам приложения',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.settings);
            },
          ),
          _OverlayAction(
            label: 'Открыть команды',
            subtitle: 'Показать command palette',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.commandPalette);
            },
          ),
        ];
      case AppOverlay.releaseNotes:
        return const [
          _OverlayAction(
            label: 'v1.14.25',
            subtitle: 'Improved desktop shell parity and session chrome',
          ),
          _OverlayAction(
            label: 'v1.14.24',
            subtitle:
                'Added server picker, settings surface and sidebar project list',
          ),
        ];
      case AppOverlay.commandPalette:
        return [
          _OverlayAction(
            label: 'Open project',
            subtitle: 'Показать выбор рабочего пространства',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.selectDirectory);
            },
          ),
          _OverlayAction(
            label: 'Open file',
            subtitle: 'Показать быстрый выбор файла',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.selectFile);
            },
          ),
          _OverlayAction(
            label: 'Switch provider',
            subtitle: 'Открыть список провайдеров',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.selectProvider);
            },
          ),
          _OverlayAction(
            label: 'Release notes',
            subtitle: 'Показать последние обновления прототипа',
            onTap: () {
              overlayController.close();
              overlayController.show(AppOverlay.releaseNotes);
            },
          ),
        ];
      case AppOverlay.settings:
      case AppOverlay.selectModel:
      case AppOverlay.selectProvider:
      case AppOverlay.selectMcp:
      case AppOverlay.selectServer:
        return const [];
    }
  }
}

class _OverlayAction {
  const _OverlayAction({
    required this.label,
    required this.subtitle,
    this.onTap,
  });

  final String label;
  final String subtitle;
  final VoidCallback? onTap;
}

class _OverlayFrame extends StatelessWidget {
  const _OverlayFrame({required this.child, this.width = 720, this.height});

  final Widget child;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(maxWidth: width, maxHeight: height ?? 860),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBF8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8D5CF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  const _SettingsNavTile({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: colors.iconMuted),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textBase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textStrong,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: colors.borderBase))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textStrong,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          trailing,
        ],
      ),
    );
  }
}

class _DropdownPill extends StatelessWidget {
  const _DropdownPill({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, color: colors.textBase),
            ),
            const SizedBox(width: 16),
            Icon(
              FluentIcons.chevron_down,
              size: 10,
              color: colors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchStub extends StatelessWidget {
  const _SwitchStub({required this.enabled, this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: enabled ? colors.textStrong : colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderBase),
        ),
        child: Align(
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 16)],
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.textStrong,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 14),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (selected
                    ? Icon(
                        FluentIcons.check_mark,
                        color: colors.iconMuted,
                        size: 16,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.search, size: 16, color: colors.iconMuted),
          const SizedBox(width: 12),
          Text(
            placeholder,
            style: TextStyle(fontSize: 16, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        color: Color(0xFF1AB31A),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderBase),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.add, size: 14, color: colors.iconMuted),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textBase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseIconButton extends StatelessWidget {
  const _CloseIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Icon(
        FluentIcons.chrome_close,
        size: 16,
        color: colors.iconMuted,
      ),
    );
  }
}
