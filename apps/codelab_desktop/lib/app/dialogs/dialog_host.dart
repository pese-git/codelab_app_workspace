import 'package:fluent_ui/fluent_ui.dart';

import '../models/workspace_models.dart';
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
            child: Container(
              color: const Color(0xCC090A0C),
              alignment: Alignment.center,
              child: _DialogSurface(dialog: dialog),
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
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Container(
      width: 560,
      constraints: const BoxConstraints(maxWidth: 560),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171A1D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2A2F36)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x7A000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _title(dialog),
                  style: theme.typography.subtitle,
                ),
              ),
              Button(
                onPressed: controller.closeDialog,
                child: const Text('Close'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _description(dialog),
            style: theme.typography.body,
          ),
          const SizedBox(height: 18),
          ..._content(context, dialog),
        ],
      ),
    );
  }

  String _title(AppDialog dialog) {
    switch (dialog) {
      case AppDialog.settings:
        return 'Settings';
      case AppDialog.selectDirectory:
        return 'Select Directory';
      case AppDialog.selectFile:
        return 'Select File';
      case AppDialog.selectModel:
        return 'Select Model';
      case AppDialog.selectProvider:
        return 'Select Provider';
      case AppDialog.selectMcp:
        return 'Select MCP';
      case AppDialog.selectServer:
        return 'Select Server';
      case AppDialog.editProject:
        return 'Edit Project';
      case AppDialog.forkSession:
        return 'Fork Session';
      case AppDialog.help:
        return 'Help';
      case AppDialog.releaseNotes:
        return 'Release Notes';
      case AppDialog.commandPalette:
        return 'Command Palette';
    }
  }

  String _description(AppDialog dialog) {
    switch (dialog) {
      case AppDialog.settings:
        return 'General settings, providers, keybinds and model preferences.';
      case AppDialog.selectDirectory:
        return 'Mock directory picker for opening another workspace.';
      case AppDialog.selectFile:
        return 'Quick file search surface with recent and suggested files.';
      case AppDialog.selectModel:
        return 'Switch the active model for the current session.';
      case AppDialog.selectProvider:
        return 'Connect and choose a provider for model execution.';
      case AppDialog.selectMcp:
        return 'Attach a tool server or MCP integration to this workspace.';
      case AppDialog.selectServer:
        return 'Choose where the desktop app sends its requests.';
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
    }
  }

  List<Widget> _content(BuildContext context, AppDialog dialog) {
    final controller = CodeLabAppScope.of(context);

    switch (dialog) {
      case AppDialog.selectModel:
        return controller.models
            .map(
              (item) => _SelectionRow(
                label: item,
                selected: item == controller.selectedModel,
                onPressed: () {
                  controller.chooseModel(item);
                  controller.closeDialog();
                },
              ),
            )
            .toList();
      case AppDialog.selectProvider:
        return controller.providers
            .map(
              (item) => _SelectionRow(
                label: item,
                selected: item == controller.selectedProvider,
                onPressed: () {
                  controller.chooseProvider(item);
                  controller.closeDialog();
                },
              ),
            )
            .toList();
      case AppDialog.selectMcp:
        return controller.mcps
            .map(
              (item) => _SelectionRow(
                label: item,
                selected: item == controller.selectedMcp,
                onPressed: () {
                  controller.chooseMcp(item);
                  controller.closeDialog();
                },
              ),
            )
            .toList();
      case AppDialog.selectServer:
        return controller.servers
            .map(
              (item) => _SelectionRow(
                label: item,
                selected: item == controller.selectedServer,
                onPressed: () {
                  controller.chooseServer(item);
                  controller.closeDialog();
                },
              ),
            )
            .toList();
      case AppDialog.commandPalette:
        return const [
          _SelectionRow(label: 'Open project', subtitle: 'Show directory picker'),
          _SelectionRow(label: 'Go to session', subtitle: 'Focus latest session'),
          _SelectionRow(label: 'Toggle side panel', subtitle: 'Show or hide details'),
          _SelectionRow(label: 'Release notes', subtitle: 'Open current changelog'),
        ];
      default:
        return const [
          _SelectionRow(label: 'Prototype surface', subtitle: 'Included as part of the Flutter mock UI scope'),
          _SelectionRow(label: 'Shared modal chrome', subtitle: 'Uses one overlay presenter for all dialog kinds'),
        ];
    }
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.label,
    this.subtitle,
    this.selected = false,
    this.onPressed,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Button(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (selected) return const Color(0xFF212731);
            if (states.contains(WidgetState.hovered)) return const Color(0xFF1C2025);
            return const Color(0xFF14171A);
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selected ? const Color(0xFF4F8CFF) : const Color(0xFF2A2F36),
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.typography.bodyStrong),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: theme.typography.caption),
                  ],
                ],
              ),
            ),
            if (selected) const Icon(FluentIcons.check_mark),
          ],
        ),
      ),
    );
  }
}
