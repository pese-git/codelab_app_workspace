import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../state/app_controller.dart';
import '../state/app_scope.dart';

class DialogHost extends StatelessWidget {
  const DialogHost({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final dialog = controller.activeDialog;

    return Stack(
      children: [
        child,
        if (dialog != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.closeDialog,
              child: Container(
                color: const Color(0x40E7E4DE),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: _DialogSurface(dialog: dialog),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DialogSurface extends StatelessWidget {
  const _DialogSurface({required this.dialog});

  final AppDialog dialog;

  @override
  Widget build(BuildContext context) {
    switch (dialog) {
      case AppDialog.settings:
        return const _SettingsDialog();
      case AppDialog.selectServer:
        return const _ServersDialog();
      case AppDialog.selectProvider:
        return const _ChoiceDialog(
          title: 'Провайдеры',
          searchPlaceholder: 'Поиск провайдеров',
          source: _ChoiceSource.providers,
          primaryAction: 'Подключить провайдера',
        );
      case AppDialog.selectModel:
        return const _ChoiceDialog(
          title: 'Модели',
          searchPlaceholder: 'Поиск моделей',
          source: _ChoiceSource.models,
        );
      case AppDialog.selectMcp:
        return const _ChoiceDialog(
          title: 'Инструменты',
          searchPlaceholder: 'Поиск инструментов',
          source: _ChoiceSource.mcps,
        );
      case AppDialog.selectDirectory:
      case AppDialog.selectFile:
      case AppDialog.editProject:
      case AppDialog.forkSession:
      case AppDialog.help:
      case AppDialog.releaseNotes:
      case AppDialog.commandPalette:
        return _GenericDialog(dialog: dialog);
    }
  }
}

class _SettingsDialog extends StatelessWidget {
  const _SettingsDialog();

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return _DialogFrame(
      width: 1280,
      height: 812,
      child: Row(
        children: [
          Container(
            width: 272,
            padding: const EdgeInsets.fromLTRB(18, 26, 18, 18),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFE3E0DB))),
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
                const _SettingsNavTile(
                  icon: FluentIcons.keyboard_classic,
                  label: 'Горячие клавиши',
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
                    controller.closeDialog();
                    controller.openDialog(AppDialog.selectProvider);
                  },
                ),
                _SettingsNavTile(
                  icon: FluentIcons.favorite_list,
                  label: 'Модели',
                  onTap: () {
                    controller.closeDialog();
                    controller.openDialog(AppDialog.selectModel);
                  },
                ),
                const Spacer(),
                const Text(
                  'OpenCode Desktop',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7F7C76),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'v1.14.25',
                  style: TextStyle(fontSize: 13, color: Color(0xFF9A9791)),
                ),
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
                      _CloseIconButton(onTap: controller.closeDialog),
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
                          onTap: controller.closeDialog,
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
                          onTap: () =>
                              controller.toggleSetting('showReasoning'),
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
                            'Показывать элементы инструментов edit, write и patch в ленте развернутыми по умолчанию',
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
                          onTap: controller.closeDialog,
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

class _ServersDialog extends StatelessWidget {
  const _ServersDialog();

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return _DialogFrame(
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
                _CloseIconButton(onTap: controller.closeDialog),
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
                    controller.closeDialog();
                  },
                ),
              ),
            ),
            const Spacer(),
            _SecondaryActionButton(
              label: 'Добавить сервер',
              onTap: controller.closeDialog,
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChoiceSource { providers, models, mcps }

class _ChoiceDialog extends StatelessWidget {
  const _ChoiceDialog({
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
    final controller = CodeLabAppScope.of(context);
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
          break;
        case _ChoiceSource.models:
          controller.chooseModel(value);
          break;
        case _ChoiceSource.mcps:
          controller.chooseMcp(value);
          break;
      }
      controller.closeDialog();
    }

    return _DialogFrame(
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
                _CloseIconButton(onTap: controller.closeDialog),
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
                onTap: controller.closeDialog,
              ),
          ],
        ),
      ),
    );
  }
}

class _GenericDialog extends StatelessWidget {
  const _GenericDialog({required this.dialog});

  final AppDialog dialog;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final actions = _actions(context, controller);

    return _DialogFrame(
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
                    _title(dialog),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF23231F),
                    ),
                  ),
                ),
                _CloseIconButton(onTap: controller.closeDialog),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _description(dialog),
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

  String _title(AppDialog dialog) {
    switch (dialog) {
      case AppDialog.selectDirectory:
        return 'Рабочие пространства';
      case AppDialog.selectFile:
        return 'Файлы';
      case AppDialog.editProject:
        return 'Проект';
      case AppDialog.forkSession:
        return 'Fork session';
      case AppDialog.help:
        return 'Справка';
      case AppDialog.releaseNotes:
        return 'Что нового';
      case AppDialog.commandPalette:
        return 'Команды';
      case AppDialog.settings:
      case AppDialog.selectModel:
      case AppDialog.selectProvider:
      case AppDialog.selectMcp:
      case AppDialog.selectServer:
        return '';
    }
  }

  String _description(AppDialog dialog) {
    switch (dialog) {
      case AppDialog.selectDirectory:
        return 'Mock directory picker for opening another workspace.';
      case AppDialog.selectFile:
        return 'Quick file search surface with recent and suggested files.';
      case AppDialog.editProject:
        return 'Update project labels, path details and pinned status.';
      case AppDialog.forkSession:
        return 'Create a new session branch from the current state.';
      case AppDialog.help:
        return 'Keybinds, command routes and desktop navigation hints.';
      case AppDialog.releaseNotes:
        return 'Recent shipped updates for the desktop prototype.';
      case AppDialog.commandPalette:
        return 'Search commands, routes, dialogs and recent actions.';
      case AppDialog.settings:
      case AppDialog.selectModel:
      case AppDialog.selectProvider:
      case AppDialog.selectMcp:
      case AppDialog.selectServer:
        return '';
    }
  }

  List<_DialogAction> _actions(
    BuildContext context,
    CodeLabAppController controller,
  ) {
    switch (dialog) {
      case AppDialog.selectDirectory:
        return [
          for (final project in controller.projects)
            _DialogAction(
              label: project.name,
              subtitle: project.path,
              onTap: () {
                controller.selectProject(project.id);
                final sessionId = controller.selectedSessionId;
                controller.closeDialog();
                if (sessionId == null) {
                  context.go('/');
                } else {
                  context.go('/session/$sessionId');
                }
              },
            ),
        ];
      case AppDialog.selectFile:
        final session = controller.selectedSession;
        final fileItems = session?.fileItems ?? const <FileItem>[];
        return [
          for (final item in fileItems)
            _DialogAction(
              label: item.path,
              subtitle: item.summary,
              onTap: controller.closeDialog,
            ),
        ];
      case AppDialog.editProject:
        return [
          _DialogAction(
            label: 'Открыть настройки проекта',
            subtitle: 'Изменить название, путь и закрепление проекта',
            onTap: controller.closeDialog,
          ),
          _DialogAction(
            label: 'Сменить рабочее пространство',
            subtitle: 'Открыть выбор директории для текущего проекта',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.selectDirectory);
            },
          ),
        ];
      case AppDialog.forkSession:
        return [
          _DialogAction(
            label: 'Создать новую ветку сессии',
            subtitle: 'Fork текущего состояния в отдельную сессию',
            onTap: controller.closeDialog,
          ),
          _DialogAction(
            label: 'Продолжить в текущей сессии',
            subtitle: 'Закрыть диалог и остаться в этой ветке',
            onTap: controller.closeDialog,
          ),
        ];
      case AppDialog.help:
        return [
          _DialogAction(
            label: 'Открыть настройки',
            subtitle: 'Перейти к основным настройкам приложения',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.settings);
            },
          ),
          _DialogAction(
            label: 'Открыть команды',
            subtitle: 'Показать command palette',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.commandPalette);
            },
          ),
        ];
      case AppDialog.releaseNotes:
        return const [
          _DialogAction(
            label: 'v1.14.25',
            subtitle: 'Improved desktop shell parity and session chrome',
          ),
          _DialogAction(
            label: 'v1.14.24',
            subtitle:
                'Added server picker, settings surface and sidebar project list',
          ),
        ];
      case AppDialog.commandPalette:
        return [
          _DialogAction(
            label: 'Open project',
            subtitle: 'Показать выбор рабочего пространства',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.selectDirectory);
            },
          ),
          _DialogAction(
            label: 'Open file',
            subtitle: 'Показать быстрый выбор файла',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.selectFile);
            },
          ),
          _DialogAction(
            label: 'Switch provider',
            subtitle: 'Открыть список провайдеров',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.selectProvider);
            },
          ),
          _DialogAction(
            label: 'Release notes',
            subtitle: 'Показать последние обновления прототипа',
            onTap: () {
              controller.closeDialog();
              controller.openDialog(AppDialog.releaseNotes);
            },
          ),
        ];
      case AppDialog.settings:
      case AppDialog.selectModel:
      case AppDialog.selectProvider:
      case AppDialog.selectMcp:
      case AppDialog.selectServer:
        return const [];
    }
  }
}

class _DialogAction {
  const _DialogAction({
    required this.label,
    required this.subtitle,
    this.onTap,
  });

  final String label;
  final String subtitle;
  final VoidCallback? onTap;
}

class _DialogFrame extends StatelessWidget {
  const _DialogFrame({required this.child, this.width = 720, this.height});

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3E1DE) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF8C8984)),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4D4C48),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF23231F),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F2EF),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFFD9D6D0)))
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A2A27),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9B9893),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7F4),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Color(0xFF30302D)),
            ),
            const SizedBox(width: 16),
            const Icon(
              FluentIcons.chevron_down,
              size: 10,
              color: Color(0xFFB1AEA8),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF23201D) : const Color(0xFFF0EEEA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD2CEC8)),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F1EE),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D29),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 14),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9F9C96),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (selected
                    ? const Icon(
                        FluentIcons.check_mark,
                        color: Color(0xFF8E8B86),
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
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(FluentIcons.search, size: 16, color: Color(0xFF9B9892)),
          const SizedBox(width: 12),
          Text(
            placeholder,
            style: const TextStyle(fontSize: 16, color: Color(0xFF9B9892)),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD8D5CF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.add, size: 14, color: Color(0xFF8E8B86)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F2F2B),
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
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        FluentIcons.chrome_close,
        size: 16,
        color: Color(0xFFA29F99),
      ),
    );
  }
}
