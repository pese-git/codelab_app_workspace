import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../../domain/entities/server.dart';
import '../../features/workspace/application/workspace_controller.dart';
import '../../features/project/presentation/dialogs/open_project_dialog.dart';
import '../../features/server/presentation/blocs/server/server_bloc.dart';
import '../../features/server/presentation/blocs/server/server_event.dart';
import '../../features/server/presentation/blocs/server/server_state.dart';
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
      case AppOverlay.addServer:
        return const _ServerFormOverlay();
      case AppOverlay.editServer:
        return const _ServerFormOverlay();
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
      case AppOverlay.openProject:
        return const OpenProjectDialog();
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
    final serverBloc = context.watch<ServerBloc>();
    final overlayController = context.read<OverlayController>();
    final state = serverBloc.state;

    return _OverlayFrame(
      width: 870,
      height: 420,
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
            Expanded(
              child: switch (state) {
                ServerInitial() => const Center(child: _EmptyServerList()),
                ServerLoading() => const Center(child: _ServerListLoading()),
                ServerLoaded() => _ServerListContent(
                    servers: state.servers,
                    selectedServerId: state.selectedServerId,
                    onServerSelect: (id) {
                      serverBloc.add(ServerEvent.select(id));
                    },
                    onServerEdit: (server) {
                      overlayController.show(AppOverlay.editServer);
                    },
                    onServerDelete: (id) {
                      serverBloc.add(ServerEvent.delete(id));
                    },
                  ),
                ServerError() => Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Color(0xFFB31A1A)),
                    ),
                  ),
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _SecondaryActionButton(
                  label: 'Добавить сервер',
                  onTap: () {
                    overlayController.show(AppOverlay.addServer);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyServerList extends StatelessWidget {
  const _EmptyServerList();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(FluentIcons.server_processes, size: 32, color: AppColors.light.iconMuted),
        const SizedBox(height: 12),
        const Text(
          'Нет серверов',
          style: TextStyle(fontSize: 16, color: Color(0xFF6B6963)),
        ),
      ],
    );
  }
}

class _ServerListLoading extends StatelessWidget {
  const _ServerListLoading();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ProgressRing(
            strokeWidth: 2,
            activeColor: AppColors.light.iconMuted,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Загрузка...',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B6963)),
        ),
      ],
    );
  }
}

class _ServerListContent extends StatelessWidget {
  const _ServerListContent({
    required this.servers,
    required this.selectedServerId,
    required this.onServerSelect,
    required this.onServerEdit,
    required this.onServerDelete,
  });

  final List<Server> servers;
  final String? selectedServerId;
  final void Function(String id) onServerSelect;
  final void Function(Server server) onServerEdit;
  final void Function(String id) onServerDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: servers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final server = servers[index];
        final isSelected = server.id == selectedServerId;
        return _ServerTile(
          server: server,
          selected: isSelected,
          onTap: () => onServerSelect(server.id),
          onEdit: () => onServerEdit(server),
          onDelete: () => onServerDelete(server.id),
        );
      },
    );
  }
}

class _ServerTile extends StatelessWidget {
  const _ServerTile({
    required this.server,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Server server;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: BorderRadius.circular(13),
          border: selected ? Border.all(color: const Color(0xFF1AB31A), width: 1.5) : null,
        ),
        child: Row(
          children: [
            _ServerStatusDot(status: server.status),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF23231F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    server.displayUrl,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8E8B86),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  FluentIcons.check_mark,
                  color: Color(0xFF1AB31A),
                  size: 16,
                ),
              ),
            _ServerTileActions(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerStatusDot extends StatelessWidget {
  const _ServerStatusDot({required this.status});

  final ServerStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ServerStatus.disconnected => const Color(0xFF8E8B86),
      ServerStatus.connecting => const Color(0xFFB38F1A),
      ServerStatus.connected => const Color(0xFF1AB31A),
      ServerStatus.error => const Color(0xFFB31A1A),
    };

    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ServerTileActions extends StatelessWidget {
  const _ServerTileActions({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onEdit,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              FluentIcons.edit,
              size: 14,
              color: Color(0xFF8E8B86),
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onDelete,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              FluentIcons.delete,
              size: 14,
              color: Color(0xFFB31A1A),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServerFormOverlay extends StatefulWidget {
  const _ServerFormOverlay();

  @override
  State<_ServerFormOverlay> createState() => _ServerFormOverlayState();
}

class _ServerFormOverlayState extends State<_ServerFormOverlay> {
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _pathController = TextEditingController();
  ServerType _type = ServerType.websocket;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayController = context.read<OverlayController>();
      if (overlayController.current == AppOverlay.editServer) {
        final serverBloc = context.read<ServerBloc>();
        if (serverBloc.state is ServerLoaded) {
          final state = serverBloc.state as ServerLoaded;
          final selectedId = state.selectedServerId;
          final selected = selectedId != null
              ? state.servers.firstWhere(
                  (s) => s.id == selectedId,
                  orElse: () => state.servers.first,
                )
              : state.servers.first;
          _nameController.text = selected.name;
          _hostController.text = selected.host;
          _portController.text = selected.port.toString();
          _pathController.text = selected.path ?? '/ws';
          _type = selected.type;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final host = _hostController.text.trim();
    final portStr = _portController.text.trim();

    if (name.isEmpty || host.isEmpty || portStr.isEmpty) return;

    final port = int.tryParse(portStr);
    if (port == null) return;

    final serverBloc = context.read<ServerBloc>();
    final overlayController = context.read<OverlayController>();

    if (overlayController.current == AppOverlay.editServer) {
      final state = serverBloc.state;
      if (state is ServerLoaded) {
        final selectedId = state.selectedServerId;
        final selected = selectedId != null
            ? state.servers.firstWhere(
                (s) => s.id == selectedId,
                orElse: () => state.servers.first,
              )
            : state.servers.first;
        serverBloc.add(ServerEvent.update(
          id: selected.id,
          name: name,
          host: host,
          port: port,
          type: _type,
          path: _pathController.text.trim().isEmpty ? '/ws' : _pathController.text.trim(),
        ));
      }
    } else {
      serverBloc.add(ServerEvent.add(
        name: name,
        host: host,
        port: port,
        type: _type,
        path: _pathController.text.trim().isEmpty ? '/ws' : _pathController.text.trim(),
      ));
    }

    overlayController.close();
  }

  @override
  Widget build(BuildContext context) {
    final overlayController = context.read<OverlayController>();
    final isEdit = overlayController.current == AppOverlay.editServer;
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return _OverlayFrame(
      width: 520,
      height: 480,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isEdit ? 'Редактировать сервер' : 'Добавить сервер',
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
            const SizedBox(height: 24),
            _FormTextField(
              controller: _nameController,
              label: 'Название',
              placeholder: 'Local Agent',
            ),
            const SizedBox(height: 16),
            _FormTextField(
              controller: _hostController,
              label: 'Хост',
              placeholder: 'localhost',
            ),
            const SizedBox(height: 16),
            _FormTextField(
              controller: _portController,
              label: 'Порт',
              placeholder: '8080',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Тип подключения',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF23231F),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _TypePill(
                        label: 'WebSocket',
                        selected: _type == ServerType.websocket,
                        onTap: () => setState(() => _type = ServerType.websocket),
                      ),
                      const SizedBox(width: 8),
                      _TypePill(
                        label: 'SSE',
                        selected: _type == ServerType.sse,
                        onTap: () => setState(() => _type = ServerType.sse),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FormTextField(
              controller: _pathController,
              label: 'Путь',
              placeholder: '/ws',
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _SecondaryActionButton(
                    label: 'Отмена',
                    onTap: overlayController.close,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PrimaryActionButton(
                    label: isEdit ? 'Сохранить' : 'Добавить',
                    onTap: _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF23231F) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF6B6963),
          ),
        ),
      ),
    );
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    required this.label,
    required this.placeholder,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String placeholder;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final brightness = FluentTheme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF23231F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colors.surfaceSubtle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextBox(
                  controller: controller,
                  placeholder: placeholder,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF23231F)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onTap});

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
          color: const Color(0xFF23231F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
      case AppOverlay.openProject:
        return '';
      case AppOverlay.settings:
      case AppOverlay.selectModel:
      case AppOverlay.selectProvider:
      case AppOverlay.selectMcp:
      case AppOverlay.selectServer:
      case AppOverlay.addServer:
      case AppOverlay.editServer:
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
      case AppOverlay.openProject:
        return '';
      case AppOverlay.settings:
      case AppOverlay.selectModel:
      case AppOverlay.selectProvider:
      case AppOverlay.selectMcp:
      case AppOverlay.selectServer:
      case AppOverlay.addServer:
      case AppOverlay.editServer:
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
      case AppOverlay.addServer:
      case AppOverlay.editServer:
      case AppOverlay.openProject:
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
