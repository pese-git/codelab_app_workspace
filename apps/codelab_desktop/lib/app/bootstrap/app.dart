import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/di/di_scope_widget.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/server_repository.dart';
import '../../features/server/presentation/blocs/server/server_bloc.dart';
import '../../features/server/presentation/blocs/server/server_event.dart';
import '../../features/session/presentation/blocs/session/session_bloc.dart';
import '../keyboard/app_shortcuts.dart';
import '../navigation/navigation_controller.dart';
import '../navigation/app_router.dart';
import '../overlay/overlay_controller.dart';
import '../overlay/overlay_host.dart' as app_overlay;
import '../shell/window_shell.dart';
import '../../features/workspace/application/workspace_controller.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/services/directory_scanner_service.dart';

class CodeLabAppBootstrap extends StatefulWidget {
  const CodeLabAppBootstrap({super.key});

  @override
  State<CodeLabAppBootstrap> createState() => _CodeLabAppBootstrapState();
}

class _CodeLabAppBootstrapState extends State<CodeLabAppBootstrap> {
  late final WorkspaceController _workspaceController;
  late final OverlayController _overlayController;
  late final NavigationController _navigationController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _workspaceController = WorkspaceController(
      projectRepository: rootScope.resolve<ProjectRepository>(),
      directoryScanner: rootScope.resolve<DirectoryScannerService>(),
    );
    _overlayController = OverlayController();

    final tempRouter = GoRouter(
      initialLocation: '/',
      refreshListenable: _workspaceController,
      routes: [],
    );
    _navigationController = NavigationController(tempRouter);

    final routerResult = buildRouter(_navigationController);
    _router = routerResult.router;
  }

  @override
  void dispose() {
    _navigationController.dispose();
    _router.dispose();
    _overlayController.dispose();
    _workspaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DiScope(
      scope: rootScope,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _workspaceController),
          ChangeNotifierProvider.value(value: _overlayController),
          ChangeNotifierProvider.value(value: _navigationController),
          BlocProvider<SessionBloc>(
            create: (_) => rootScope.resolve<SessionBloc>(),
          ),
          BlocProvider<ServerBloc>(
            create: (_) => ServerBloc(
              serverRepository: rootScope.resolve<ServerRepository>(),
            )..add(const ServerEvent.load()),
          ),
        ],
        child: AppShortcuts(
          child: FluentApp.router(
            title: 'CodeLab Desktop',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: _router,
            builder: (context, child) {
              return app_overlay.OverlayHost(
                child: WindowShell(
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
