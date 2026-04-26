import 'package:fluent_ui/fluent_ui.dart';

import 'package:codelab_ui_components/codelab_ui_components.dart'
    hide SessionRegionTab;
import '../models/workspace_models.dart';
import '../state/app_controller.dart';
import '../state/app_scope.dart';
import 'terminal_panel.dart';

/// Main session region containing message timeline, prompt composer, and tabs.
///
/// {@template deprecated_widget}
/// **Deprecated:** This widget is being migrated to the components library.
/// Use widgets from `package:codelab_desktop/components.dart` directly.
/// {@endtemplate}
@Deprecated('Use components from lib/components instead')
class SessionRegion extends StatefulWidget {
  const SessionRegion({required this.session, super.key});

  final SessionModel session;

  @override
  State<SessionRegion> createState() => _SessionRegionState();
}

class _SessionRegionState extends State<SessionRegion> {
  @override
  Widget build(BuildContext context) {
    final controller = CodeLabAppScope.of(context);
    final colors = AppColors.dark;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundSubtle,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: colors.borderBase),
      ),
      child: Column(
        children: [
          // Tab bar
          _buildTabBar(controller, colors),
          // Content area
          Expanded(child: _buildContent(controller.sessionTab, colors)),
        ],
      ),
    );
  }

  Widget _buildTabBar(CodeLabAppController controller, DarkColors colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md2),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderWeak)),
      ),
      child: Row(
        children: [
          for (final tab in SessionRegionTab.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm2),
              child: Button(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    controller.sessionTab == tab
                        ? colors.surfaceAccent
                        : colors.surfaceBase,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    controller.sessionTab == tab
                        ? colors.textStrong
                        : colors.textWeak,
                  ),
                ),
                onPressed: () => controller.setSessionTab(tab),
                child: Text(_label(tab)),
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

  Widget _buildContent(SessionRegionTab tab, DarkColors colors) {
    switch (tab) {
      case SessionRegionTab.files:
        return _buildFilesTab(colors);
      case SessionRegionTab.review:
        return _buildReviewTab(colors);
      case SessionRegionTab.terminal:
        return _buildTerminalTab();
    }
  }

  Widget _buildFilesTab(DarkColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      children: widget.session.fileItems
          .map(
            (item) => _RegionCard(
              title: item.path,
              summary: item.summary,
              trailing: item.status,
            ),
          )
          .toList(),
    );
  }

  Widget _buildReviewTab(DarkColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      children: widget.session.reviewItems
          .map(
            (item) => _RegionCard(
              title: item.title,
              summary: item.summary,
              trailing: item.severity,
            ),
          )
          .toList(),
    );
  }

  Widget _buildTerminalTab() {
    return const TerminalPanel();
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
    final colors = AppColors.dark;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md2),
      padding: const EdgeInsets.all(AppSpacing.lg2),
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: colors.borderWeak),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyMedium(color: colors.textStrong),
                ),
              ),
              Text(
                trailing,
                style: AppTypography.caption(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(summary, style: AppTypography.caption(color: colors.textWeak)),
        ],
      ),
    );
  }
}

/// Chat panel with message timeline and prompt composer.
/// Can be used alongside SessionRegion or independently.
class ChatPanel extends StatefulWidget {
  const ChatPanel({super.key});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final List<Message> _messages = [];
  int _messageIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _initMockMessages();
  }

  void _initMockMessages() {
    _messages.addAll([
      Message(
        id: 'msg_${++_messageIdCounter}',
        role: MessageRole.system,
        content: 'Session started. Ready to assist you.',
      ),
      Message(
        id: 'msg_${++_messageIdCounter}',
        role: MessageRole.user,
        content: 'Can you help me write a function to sort an array?',
      ),
      Message(
        id: 'msg_${++_messageIdCounter}',
        role: MessageRole.assistant,
        content: '''Sure! Here's a simple quicksort implementation in Dart:

```dart
List<T> quickSort<T extends Comparable>(List<T> list) {
  if (list.length <= 1) return list;
  
  final pivot = list[list.length ~/ 2];
  final less = list.where((e) => e.compareTo(pivot) < 0).toList();
  final equal = list.where((e) => e.compareTo(pivot) == 0).toList();
  final greater = list.where((e) => e.compareTo(pivot) > 0).toList();
  
  return [...quickSort(less), ...equal, ...quickSort(greater)];
}
```

This implementation:
- Uses the **divide and conquer** approach
- Has average time complexity of O(n log n)
- Is easy to understand and modify

Would you like me to explain any part in more detail?''',
      ),
    ]);
  }

  void _handleSendMessage(String content) {
    setState(() {
      _messages.add(
        Message(
          id: 'msg_${++_messageIdCounter}',
          role: MessageRole.user,
          content: content,
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _messages.add(
              Message(
                id: 'msg_${++_messageIdCounter}',
                role: MessageRole.assistant,
                content: _generateMockResponse(content),
              ),
            );
          });
        }
      });
    });
  }

  String _generateMockResponse(String userMessage) {
    if (userMessage.toLowerCase().contains('hello') ||
        userMessage.toLowerCase().contains('hi')) {
      return 'Hello! How can I help you today?';
    }
    if (userMessage.toLowerCase().contains('help')) {
      return '''I can help you with:
- Writing and reviewing code
- Debugging issues
- Explaining concepts
- Refactoring suggestions

Just let me know what you need!''';
    }
    return 'I understand. Let me think about that...\n\nBased on your message, here\'s what I suggest:\n\n1. First, we should analyze the requirements\n2. Then, design the solution\n3. Finally, implement and test\n\nWould you like me to elaborate on any of these steps?';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundSubtle,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: colors.borderBase),
      ),
      child: Column(
        children: [
          // Message timeline
          Expanded(
            child: MessageTimeline(messages: _messages, onCopyCode: (_) {}),
          ),
          // Prompt composer
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.borderWeak)),
            ),
            child: PromptComposer(
              onSend: _handleSendMessage,
              placeholder: 'Type a message... (Cmd/Ctrl+Enter to send)',
            ),
          ),
        ],
      ),
    );
  }
}
