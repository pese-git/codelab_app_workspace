import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import 'dialogs/dialog_host.dart';
import 'mock/mock_data.dart';
import 'navigation/router.dart';
import 'state/app_controller.dart';
import 'state/app_scope.dart';
import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'theme/app_theme.dart';

class CodeLabAppBootstrap extends StatefulWidget {
  const CodeLabAppBootstrap({super.key});

  @override
  State<CodeLabAppBootstrap> createState() => _CodeLabAppBootstrapState();
}

class _CodeLabAppBootstrapState extends State<CodeLabAppBootstrap> {
  late final CodeLabAppController _controller;
  late final GoRouter _router;
  late final HistoryController _historyController;

  @override
  void initState() {
    super.initState();
    _controller = CodeLabAppController(seedWorkspace: buildMockWorkspace());
    final result = buildRouter(_controller);
    _router = result.router;
    _historyController = result.history;
  }

  @override
  void dispose() {
    _historyController.dispose();
    _router.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodeLabAppScope(
      controller: _controller,
      child: FluentApp.router(
        title: 'CodeLab Desktop',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.fluentLight,
        darkTheme: AppTheme.fluentDark,
        routerConfig: _router,
        builder: (context, child) {
          return DialogHost(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
