import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../navigation/navigation_controller.dart';
import '../overlay/overlay_controller.dart';
import '../state/workspace_controller.dart';

class AppShortcuts extends StatelessWidget {
  const AppShortcuts({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyK, control: true):
            const _CommandPaletteIntent(),
        SingleActivator(LogicalKeyboardKey.keyP, control: true):
            const _QuickOpenIntent(),
        SingleActivator(LogicalKeyboardKey.keyW, control: true):
            const _CloseSessionIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true):
            const _BackIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight, alt: true):
            const _ForwardIntent(),
        SingleActivator(LogicalKeyboardKey.backquote, control: true):
            const _ToggleTerminalIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _CommandPaletteIntent: CallbackAction<_CommandPaletteIntent>(
            onInvoke: (_) {
              context.read<OverlayController>().show(AppOverlay.commandPalette);
              return null;
            },
          ),
          _QuickOpenIntent: CallbackAction<_QuickOpenIntent>(
            onInvoke: (_) {
              context.read<OverlayController>().show(AppOverlay.selectDirectory);
              return null;
            },
          ),
          _CloseSessionIntent: CallbackAction<_CloseSessionIntent>(
            onInvoke: (_) {
              context.go('/');
              return null;
            },
          ),
          _BackIntent: CallbackAction<_BackIntent>(
            onInvoke: (_) {
              context.read<NavigationController>().back();
              return null;
            },
          ),
          _ForwardIntent: CallbackAction<_ForwardIntent>(
            onInvoke: (_) {
              context.read<NavigationController>().forward();
              return null;
            },
          ),
          _ToggleTerminalIntent: CallbackAction<_ToggleTerminalIntent>(
            onInvoke: (_) {
              context.read<WorkspaceController>().toggleBottomPanel();
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }
}

class _CommandPaletteIntent extends Intent {
  const _CommandPaletteIntent();
}

class _QuickOpenIntent extends Intent {
  const _QuickOpenIntent();
}

class _CloseSessionIntent extends Intent {
  const _CloseSessionIntent();
}

class _BackIntent extends Intent {
  const _BackIntent();
}

class _ForwardIntent extends Intent {
  const _ForwardIntent();
}

class _ToggleTerminalIntent extends Intent {
  const _ToggleTerminalIntent();
}
