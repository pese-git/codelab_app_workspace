import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';

import '../models/workspace_models.dart';
import '../shell/desktop_shell.dart';
import '../state/app_scope.dart';
import '../widgets/session_region.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = CodeLabAppScope.of(context);
    if (controller.selectedSessionId != widget.sessionId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        CodeLabAppScope.of(context).selectSession(widget.sessionId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final session = controller.selectedSession;

    return DesktopShell(
      title: session?.title ?? widget.sessionId,
      child: session == null
          ? const Center(child: Text('Session not found'))
          : Column(
              children: [
                _SessionHeader(session: session),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _Timeline(session: session),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SessionRegion(session: session),
                        ),
                      ],
                    ),
                  ),
                ),
                const _ComposerPanel(),
              ],
            ),
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({required this.session});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final theme = FluentTheme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF252A31))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.title, style: theme.typography.subtitle),
                const SizedBox(height: 4),
                Text(
                  '${session.branchName} • ${session.status} • ${session.updatedLabel}',
                  style: theme.typography.caption,
                ),
              ],
            ),
          ),
          Button(
            onPressed: () => controller.openDialog(AppDialog.selectModel),
            child: Text(controller.selectedModel),
          ),
          const SizedBox(width: 8),
          Button(
            onPressed: () => controller.openDialog(AppDialog.selectProvider),
            child: Text(controller.selectedProvider),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => controller.openDialog(AppDialog.forkSession),
            child: const Text('Fork'),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.session});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF252A31)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final message in session.messages)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: message.role == 'user' ? const Color(0xFF171D26) : const Color(0xFF111315),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF252A31)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(message.author, style: theme.typography.bodyStrong),
                        const SizedBox(width: 8),
                        Text(message.timestamp, style: theme.typography.caption),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(message.body, style: theme.typography.body),
                    if (message.tags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in message.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF202632),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(tag, style: theme.typography.caption),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComposerPanel extends StatelessWidget {
  const _ComposerPanel();

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF15181B),
        border: Border(top: BorderSide(color: Color(0xFF252A31))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextBox(
              placeholder: 'Ask Codex to continue the UI implementation...',
              minLines: 3,
              maxLines: 5,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Button(
                onPressed: () => controller.openDialog(AppDialog.selectFile),
                child: const Text('Attach'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => controller.openDialog(AppDialog.commandPalette),
                child: const Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
