import 'package:fluent_ui/fluent_ui.dart';

import '../models/workspace_models.dart';
import '../shell/desktop_shell.dart';
import '../state/app_scope.dart';

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
      bottomPanel: session == null ? null : _BottomTerminal(session: session),
      child: session == null
          ? const Center(child: Text('Session not found'))
          : Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _ConversationHeader(session: session),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  28,
                                  26,
                                  28,
                                  20,
                                ),
                                children: [
                                  for (final message in session.messages)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 26,
                                      ),
                                      child: _MessageBubble(message: message),
                                    ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: _ComposerPanel(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _ConversationHeader extends StatelessWidget {
  const _ConversationHeader({required this.session});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E2DC))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              session.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF252522),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.openDialog(AppDialog.selectModel),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2EE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.selectedModel,
                style: const TextStyle(fontSize: 13, color: Color(0xFF5F5C57)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => controller.openDialog(AppDialog.selectProvider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2EE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.selectedProvider,
                style: const TextStyle(fontSize: 13, color: Color(0xFF5F5C57)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () => controller.openDialog(AppDialog.forkSession),
            child: const Icon(
              FluentIcons.sync,
              size: 16,
              color: Color(0xFFD3D0CA),
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () => controller.openDialog(AppDialog.commandPalette),
            child: const Icon(
              FluentIcons.more,
              size: 16,
              color: Color(0xFF8E8C86),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUser)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0DDD7)),
              ),
              child: Text(
                message.body.split('.').first,
                style: const TextStyle(fontSize: 18, color: Color(0xFF2E2D29)),
              ),
            ),
          )
        else ...[
          Text(
            'Исследовано  1 чтение',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6F6D67),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message.body,
            style: const TextStyle(
              fontSize: 17,
              height: 1.45,
              color: Color(0xFF2C2C28),
            ),
          ),
          if (message.tags.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in message.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F1ED),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7E7B75),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}

class _ComposerPanel extends StatelessWidget {
  const _ComposerPanel();

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    return Container(
      height: 182,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD9D6D0)),
      ),
      child: Column(
        children: [
          const Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Спросите что угодно...',
                style: TextStyle(fontSize: 15, color: Color(0xFFA3A19B)),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.selectFile),
                child: const Icon(
                  FluentIcons.add,
                  size: 17,
                  color: Color(0xFF95928C),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.commandPalette),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8B5AF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    FluentIcons.chevron_up,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.selectModel),
                child: const Text(
                  'Build',
                  style: TextStyle(fontSize: 14, color: Color(0xFF686662)),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                FluentIcons.chevron_down,
                size: 10,
                color: Color(0xFF8F8C87),
              ),
              const SizedBox(width: 24),
              const Icon(
                FluentIcons.switch_user,
                size: 14,
                color: Color(0xFF97948E),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => controller.openDialog(AppDialog.selectProvider),
                child: const Text(
                  'Big Pickle',
                  style: TextStyle(fontSize: 14, color: Color(0xFF686662)),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                FluentIcons.chevron_down,
                size: 10,
                color: Color(0xFF8F8C87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomTerminal extends StatelessWidget {
  const _BottomTerminal({required this.session});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final titles = {
      SessionRegionTab.files: 'Файлы',
      SessionRegionTab.review: 'Ревью',
      SessionRegionTab.terminal: 'Терминал 1',
    };

    return Column(
      children: [
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final tab in SessionRegionTab.values)
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: GestureDetector(
                    onTap: () => controller.setSessionTab(tab),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          titles[tab]!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: controller.sessionTab == tab
                                ? const Color(0xFF2E2E2A)
                                : const Color(0xFF9A9792),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 2,
                          width: 72,
                          color: controller.sessionTab == tab
                              ? const Color(0xFF2E2E2A)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: controller.toggleBottomPanel,
                child: const Icon(
                  FluentIcons.chrome_close,
                  size: 11,
                  color: Color(0xFF8E8B86),
                ),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () =>
                    controller.setSessionTab(SessionRegionTab.terminal),
                child: const Icon(
                  FluentIcons.add,
                  size: 16,
                  color: Color(0xFF8E8B86),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: const Color(0xFFE1DED8)),
        Expanded(child: _BottomPanelBody(session: session)),
      ],
    );
  }
}

class _BottomPanelBody extends StatelessWidget {
  const _BottomPanelBody({required this.session});

  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);

    switch (controller.sessionTab) {
      case SessionRegionTab.files:
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          children: [
            for (final item in session.fileItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TerminalCard(
                  title: item.path,
                  subtitle: item.summary,
                  trailing: item.status.isEmpty ? 'tracked' : item.status,
                ),
              ),
          ],
        );
      case SessionRegionTab.review:
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          children: [
            for (final item in session.reviewItems)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TerminalCard(
                  title: item.title,
                  subtitle: item.summary,
                  trailing: item.severity,
                ),
              ),
          ],
        );
      case SessionRegionTab.terminal:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'penkovsky_sa@MacBook-Pro-Sergey-2 acp-protocol % flutter analyze\n${session.terminalEntries.map((item) => item.command).join('\n')}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 17,
                color: Color(0xFF20201D),
              ),
            ),
          ),
        );
    }
  }
}

class _TerminalCard extends StatelessWidget {
  const _TerminalCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0DDD7)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E2D29),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8B86),
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8E8B86)),
          ),
        ],
      ),
    );
  }
}
