import 'package:fluent_ui/fluent_ui.dart' as fluent;

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
