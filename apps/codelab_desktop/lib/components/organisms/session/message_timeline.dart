import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import 'message_bubble.dart';

export 'message_bubble.dart' show Message, MessageRole;

/// Widget displaying a timeline of messages with markdown rendering.
class MessageTimeline extends StatefulWidget {
  const MessageTimeline({
    required this.messages,
    this.onCopyCode,
    super.key,
  });

  final List<Message> messages;
  final void Function(String code)? onCopyCode;

  @override
  State<MessageTimeline> createState() => _MessageTimelineState();
}

class _MessageTimelineState extends State<MessageTimeline> {
  final ScrollController _scrollController = ScrollController();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
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
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: AppTypography.body(color: colors.textMuted),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return MessageBubble(
          message: message,
          onCopyCode: widget.onCopyCode,
        );
      },
    );
  }
}
