import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

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
class MessageBubble extends fluent.StatelessWidget {
  const MessageBubble({required this.message, this.onCopyCode, super.key});

  final Message message;
  final void Function(String code)? onCopyCode;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isUser = message.role == MessageRole.user;
    final isSystem = message.role == MessageRole.system;

    fluent.Color backgroundColor;
    fluent.Color textColor;
    fluent.CrossAxisAlignment alignment;
    fluent.EdgeInsets padding;

    if (isUser) {
      backgroundColor = colors.accentSubtle;
      textColor = colors.textBase;
      alignment = fluent.CrossAxisAlignment.end;
      padding = const fluent.EdgeInsets.only(left: AppSpacing.huge);
    } else if (isSystem) {
      backgroundColor = colors.warningSubtle;
      textColor = colors.warningText;
      alignment = fluent.CrossAxisAlignment.center;
      padding = const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
    } else {
      backgroundColor = colors.surfaceSubtle;
      textColor = colors.textBase;
      alignment = fluent.CrossAxisAlignment.start;
      padding = const fluent.EdgeInsets.only(right: AppSpacing.huge);
    }

    return fluent.Padding(
      padding: const fluent.EdgeInsets.only(bottom: AppSpacing.md),
      child: fluent.Column(
        crossAxisAlignment: alignment,
        children: [
          if (!isSystem)
            fluent.Padding(
              padding: const fluent.EdgeInsets.only(bottom: AppSpacing.xs),
              child: fluent.Text(
                _roleLabel(message.role),
                style: AppTypography.caption(color: colors.textMuted),
              ),
            ),
          fluent.Padding(
            padding: padding,
            child: fluent.Container(
              decoration: fluent.BoxDecoration(
                color: backgroundColor,
                borderRadius: AppRadius.lgAll,
              ),
              padding: const fluent.EdgeInsets.all(AppSpacing.md),
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

class _MessageContent extends fluent.StatelessWidget {
  const _MessageContent({
    required this.content,
    required this.textColor,
    this.onCopyCode,
  });

  final String content;
  final fluent.Color textColor;
  final void Function(String code)? onCopyCode;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return MarkdownView(data: content);
  }
}

// MARK: - Previews

@Preview(name: 'User')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewMessageBubbleUser() {
  return MessageBubble(
    message: Message(
      id: '1',
      role: MessageRole.user,
      content: 'Can you help me refactor this code to use the repository pattern?',
    ),
  );
}

@Preview(name: 'Assistant')
fluent.Widget previewMessageBubbleAssistant() {
  return MessageBubble(
    message: Message(
      id: '2',
      role: MessageRole.assistant,
      content: 'Sure! Here\'s how you can implement the repository pattern:\n\n```dart\nclass UserRepository {\n  Future<User> getUser(String id) async {\n    // Implementation\n  }\n}\n```\n\nThis separates your data access logic from the rest of the application.',
    ),
  );
}

@Preview(name: 'System')
fluent.Widget previewMessageBubbleSystem() {
  return MessageBubble(
    message: Message(
      id: '3',
      role: MessageRole.system,
      content: 'Session context updated. 3 files modified.',
    ),
  );
}

@Preview(name: 'Long Message')
fluent.Widget previewMessageBubbleLong() {
  return MessageBubble(
    message: Message(
      id: '4',
      role: MessageRole.assistant,
      content: 'Here\'s a comprehensive explanation of the changes:\n\n1. **Repository Pattern**: Abstracts data access\n2. **Dependency Injection**: Makes testing easier\n3. **Error Handling**: Centralized error management\n\n```dart\nabstract class Repository<T> {\n  Future<T> getById(String id);\n  Future<List<T>> getAll();\n  Future<void> save(T entity);\n  Future<void> delete(String id);\n}\n```\n\nEach method handles its own error cases and returns appropriate results.',
    ),
  );
}
