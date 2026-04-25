import 'package:fluent_ui/fluent_ui.dart';

import '../models/workspace_models.dart';
import '../state/app_scope.dart';

class SessionRegion extends StatelessWidget {
  const SessionRegion({required this.session, super.key});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF252A31)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                for (final tab in SessionRegionTab.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Button(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          controller.sessionTab == tab
                              ? const Color(0xFF202632)
                              : const Color(0xFF111315),
                        ),
                      ),
                      onPressed: () => controller.setSessionTab(tab),
                      child: Text(_label(tab)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: _buildContent(theme, controller.sessionTab),
            ),
          ),
        ],
      ),
    );
  }

  String _label(SessionRegionTab tab) {
    switch (tab) {
      case SessionRegionTab.files:
        return 'Files';
      case SessionRegionTab.review:
        return 'Review';
      case SessionRegionTab.terminal:
        return 'Terminal';
    }
  }

  List<Widget> _buildContent(FluentThemeData theme, SessionRegionTab tab) {
    switch (tab) {
      case SessionRegionTab.files:
        return session.fileItems
            .map(
              (item) => _RegionCard(
                title: item.path,
                summary: item.summary,
                trailing: item.status,
              ),
            )
            .toList();
      case SessionRegionTab.review:
        return session.reviewItems
            .map(
              (item) => _RegionCard(
                title: item.title,
                summary: item.summary,
                trailing: item.severity,
              ),
            )
            .toList();
      case SessionRegionTab.terminal:
        return session.terminalEntries
            .map(
              (item) => _RegionCard(
                title: item.label,
                summary: item.command,
                trailing: item.state,
              ),
            )
            .toList();
    }
  }
}

class _RegionCard extends StatelessWidget {
  const _RegionCard({
    required this.title,
    required this.summary,
    required this.trailing,
  });

  final String title;
  final String summary;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111315),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF252A31)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: theme.typography.bodyStrong)),
              Text(trailing, style: theme.typography.caption),
            ],
          ),
          const SizedBox(height: 8),
          Text(summary, style: theme.typography.caption),
        ],
      ),
    );
  }
}
