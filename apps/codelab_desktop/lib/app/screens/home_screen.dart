import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../models/workspace_models.dart';
import '../shell/desktop_shell.dart';
import '../state/app_controller.dart';
import '../state/app_scope.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return DesktopShell(
      title: 'Home',
      isHome: true,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(28),
            children: [
              Text('OpenCode desktop replica', style: theme.typography.titleLarge),
              const SizedBox(height: 10),
              Text(
                'Home view with recent projects, server controls and the same desktop chrome as the session screen.',
                style: theme.typography.body,
              ),
              const SizedBox(height: 22),
              _HomeHero(controller: controller),
              const SizedBox(height: 22),
              Text('Recent projects', style: theme.typography.subtitle),
              const SizedBox(height: 12),
              for (final project in controller.projects)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecentProjectRow(project: project),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.controller});

  final CodeLabAppController controller;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF253142)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Server: ${controller.selectedServer}', style: theme.typography.bodyStrong),
                const SizedBox(height: 8),
                Text(
                  'Prototype focuses on shell parity, reusable components, navigation and modal coverage before backend hookup.',
                  style: theme.typography.body,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton(
            onPressed: () => controller.openDialog(AppDialog.selectServer),
            child: const Text('Switch Server'),
          ),
        ],
      ),
    );
  }
}

class _RecentProjectRow extends StatelessWidget {
  const _RecentProjectRow({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Button(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
        backgroundColor: WidgetStateProperty.all(const Color(0xFF14171A)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF252A31)),
          ),
        ),
      ),
      onPressed: () {
        controller.selectProject(project.id);
        final sessionId = controller.selectedSessionId;
        if (sessionId != null) {
          context.go('/session/$sessionId');
        }
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(project.color),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              project.initials,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: theme.typography.bodyStrong),
                const SizedBox(height: 4),
                Text(project.path, style: theme.typography.caption),
              ],
            ),
          ),
          Text('${project.sessions.length} sessions', style: theme.typography.caption),
        ],
      ),
    );
  }
}
