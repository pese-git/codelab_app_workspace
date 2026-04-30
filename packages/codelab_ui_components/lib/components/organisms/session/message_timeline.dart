import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';
import 'message_bubble.dart';

export 'message_bubble.dart' show Message, MessageRole;

/// Widget displaying a timeline of messages with markdown rendering.
class MessageTimeline extends fluent.StatefulWidget {
  const MessageTimeline({required this.messages, this.onCopyCode, super.key});

  final List<Message> messages;
  final void Function(String code)? onCopyCode;

  @override
  fluent.State<MessageTimeline> createState() => _MessageTimelineState();
}

class _MessageTimelineState extends fluent.State<MessageTimeline> {
  final fluent.ScrollController _scrollController = fluent.ScrollController();
  int _previousMessageCount = 0;

  @override
  void didUpdateWidget(MessageTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > _previousMessageCount) {
      _scrollToBottom();
    }
    _previousMessageCount = widget.messages.length;
  }

  void _scrollToBottom() {
    fluent.WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: fluent.Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    if (widget.messages.isEmpty) {
      return fluent.Center(
        child: fluent.Text(
          'No messages yet',
          style: AppTypography.body(color: colors.textMuted),
        ),
      );
    }

    return fluent.ListView.builder(
      controller: _scrollController,
      padding: const fluent.EdgeInsets.all(AppSpacing.md),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return MessageBubble(message: message, onCopyCode: widget.onCopyCode);
      },
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewMessageTimelineDefault() {
  return MessageTimeline(
    messages: [
      Message(
        id: '1',
        role: MessageRole.user,
        content: 'How do I implement a simple counter in Flutter?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        role: MessageRole.assistant,
        content: 'Here\'s a simple counter implementation:\n\n```dart\nclass Counter extends StatefulWidget {\n  @override\n  _CounterState createState() => _CounterState();\n}\n\nclass _CounterState extends State<Counter> {\n  int _count = 0;\n\n  @override\n  Widget build(BuildContext context) {\n    return Column(\n      children: [\n        Text(\'Count: \$_count\'),\n        ElevatedButton(\n          onPressed: () => setState(() => _count++),\n          child: Text(\'Increment\'),\n        ),\n      ],\n    );\n  }\n}\n```',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      Message(
        id: '3',
        role: MessageRole.user,
        content: 'Can you add a decrement button too?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      Message(
        id: '4',
        role: MessageRole.assistant,
        content: 'Sure! Just add another button:\n\n```dart\nElevatedButton(\n  onPressed: () => setState(() => _count--),\n  child: Text(\'Decrement\'),\n),\n```',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ],
  );
}

@Preview(name: 'Empty')
fluent.Widget previewMessageTimelineEmpty() {
  return const MessageTimeline(messages: []);
}

@Preview(name: 'System Message')
fluent.Widget previewMessageTimelineSystem() {
  return MessageTimeline(
    messages: [
      Message(
        id: '1',
        role: MessageRole.system,
        content: 'Workspace initialized. 12 files loaded.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      Message(
        id: '2',
        role: MessageRole.user,
        content: 'Let\'s start working on the new feature.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      ),
    ],
  );
}
