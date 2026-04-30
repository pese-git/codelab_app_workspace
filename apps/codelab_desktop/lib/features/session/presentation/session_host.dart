import 'package:cherrypick/cherrypick.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di_scope_widget.dart';
import '../../../core/di/session_module.dart';
import 'blocs/chat/chat_bloc.dart';
import 'blocs/chat/chat_event.dart';
import 'blocs/permission/permission_bloc.dart';
import '../../terminal/presentation/blocs/terminal/terminal_bloc.dart';
import 'screens/session_screen.dart';

class SessionHost extends StatefulWidget {
  const SessionHost({required this.sessionId, super.key});

  final String sessionId;

  @override
  State<SessionHost> createState() => _SessionHostState();
}

class _SessionHostState extends State<SessionHost> {
  late final Scope _scope;

  @override
  void initState() {
    super.initState();

    final root = context.resolve<Scope>();

    _scope = root.openSubScope('session:${widget.sessionId}')
      ..installModules([
        SessionModule(sessionId: widget.sessionId),
      ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DiScope(
      scope: _scope,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              final bloc = ChatBloc(sendPromptUseCase: _scope.resolve());
              bloc.add(ChatEvent.sessionOpened(sessionId: widget.sessionId));
              return bloc;
            },
          ),
          BlocProvider(
            create: (_) => _scope.resolve<PermissionBloc>(),
          ),
          BlocProvider(
            create: (_) => _scope.resolve<TerminalBloc>(),
          ),
        ],
        child: SessionScreen(sessionId: widget.sessionId),
      ),
    );
  }
}
