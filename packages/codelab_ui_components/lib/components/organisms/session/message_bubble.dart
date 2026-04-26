import 'package:flutter/material.dart';

import '../../molecules/markdown_view.dart';
import '../../theme/tokens.dart';

/// Role of a message sender.
enum MessageRole { user, assistant, system }

/// A single message in the timeline.
class Message {
  Message({
    required this.id,
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
}

/// A message bubble component.
class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, this.onCopyCode, super.key});

  final Message message;
  final void Function(String code)? onCopyCode;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isUser = message.role == MessageRole.user;
    final isSystem = message.role == MessageRole.system;

    Color backgroundColor;
    Color textColor;
    CrossAxisAlignment alignment;
    EdgeInsets padding;

    if (isUser) {
      backgroundColor = colors.accentSubtle;
      textColor = colors.textBase;
      alignment = CrossAxisAlignment.end;
      padding = const EdgeInsets.only(left: AppSpacing.huge);
    } else if (isSystem) {
      backgroundColor = colors.warningSubtle;
      textColor = colors.warningText;
      alignment = CrossAxisAlignment.center;
      padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
    } else {
      backgroundColor = colors.surfaceSubtle;
      textColor = colors.textBase;
      alignment = CrossAxisAlignment.start;
      padding = const EdgeInsets.only(right: AppSpacing.huge);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (!isSystem)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                _roleLabel(message.role),
                style: AppTypography.caption(color: colors.textMuted),
              ),
            ),
          Padding(
            padding: padding,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: AppRadius.lgAll,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _MessageContent(
                content: message.content,
                textColor: textColor,
                onCopyCode: onCopyCode,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(MessageRole role) {
    switch (role) {
      case MessageRole.user:
        return 'You';
      case MessageRole.assistant:
        return 'Assistant';
      case MessageRole.system:
        return 'System';
    }
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.content,
    required this.textColor,
    this.onCopyCode,
  });

  final String content;
  final Color textColor;
  final void Function(String code)? onCopyCode;

  @override
  Widget build(BuildContext context) {
    return MarkdownView(data: content, selectable: true, shrinkWrap: true);
  }
}
