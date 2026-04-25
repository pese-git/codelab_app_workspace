import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const CodeLabApp());
}

class CodeLabApp extends StatelessWidget {
  const CodeLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'CodeLab',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        accentColor: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const WorkspaceHomePage(),
    );
  }
}

class WorkspaceHomePage extends StatelessWidget {
  const WorkspaceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return NavigationView(
      content: ScaffoldPage.scrollable(
        padding: const EdgeInsets.all(24),
        header: PageHeader(
          title: const Text('CodeLab Workspace'),
          commandBar: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                onPressed: () {},
                child: const Text('Open project'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () {},
                child: const Text('Create idea'),
              ),
            ],
          ),
        ),
        children: [
          _HeroPanel(theme: theme),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _StatCard(
                title: 'Active notes',
                value: '12',
                subtitle: '3 updated today',
              ),
              _StatCard(
                title: 'Open experiments',
                value: '4',
                subtitle: '1 ready for review',
              ),
              _StatCard(
                title: 'Team focus',
                value: 'Design system',
                subtitle: 'Next sync at 16:00',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _TaskPanel(),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.theme});

  final FluentThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.accentColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.accentColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Build ideas faster',
                  style: theme.typography.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'A lightweight desktop screen for tracking concepts, tasks, and momentum in one place.',
                  style: theme.typography.body,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Icon(FluentIcons.lightbulb, size: 40),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return SizedBox(
      width: 240,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.resources.cardBackgroundFillColorDefault,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.resources.controlStrokeColorSecondary,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.typography.caption),
            const SizedBox(height: 10),
            Text(value, style: theme.typography.title),
            const SizedBox(height: 6),
            Text(subtitle, style: theme.typography.body),
          ],
        ),
      ),
    );
  }
}

class _TaskPanel extends StatelessWidget {
  const _TaskPanel();

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.resources.cardBackgroundFillColorSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Next steps'),
          SizedBox(height: 16),
          _TaskRow(
            title: 'Prepare onboarding flow draft',
            meta: 'Owner: product team',
          ),
          SizedBox(height: 12),
          _TaskRow(
            title: 'Review desktop layout spacing',
            meta: 'Owner: design',
          ),
          SizedBox(height: 12),
          _TaskRow(
            title: 'Document package boundaries',
            meta: 'Owner: engineering',
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.title,
    required this.meta,
  });

  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.typography.bodyStrong),
              const SizedBox(height: 2),
              Text(meta, style: theme.typography.caption),
            ],
          ),
        ),
      ],
    );
  }
}
