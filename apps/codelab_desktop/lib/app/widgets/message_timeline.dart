import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../theme/tokens.dart';

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
    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: AppTypography.body(color: AppColors.dark.textMuted),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return _MessageBubble(
          message: message,
          onCopyCode: widget.onCopyCode,
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    this.onCopyCode,
  });

  final Message message;
  final void Function(String code)? onCopyCode;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;
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
    final colors = AppColors.dark;

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: AppTypography.body(color: textColor),
        h1: AppTypography.style(
          size: AppTypography.fontSize24,
          weight: AppTypography.bold,
          color: textColor,
        ),
        h2: AppTypography.style(
          size: AppTypography.fontSize20,
          weight: AppTypography.bold,
          color: textColor,
        ),
        h3: AppTypography.style(
          size: AppTypography.fontSize18,
          weight: AppTypography.semiBold,
          color: textColor,
        ),
        code: TextStyle(
          fontFamily: AppTypography.fontFamilyMono,
          fontSize: AppTypography.fontSize13,
          color: colors.infoText,
          backgroundColor: colors.surfaceAccent,
        ),
        codeblockDecoration: BoxDecoration(
          color: colors.backgroundBase,
          borderRadius: AppRadius.smAll,
          border: Border.all(color: colors.borderWeak),
        ),
        codeblockPadding: const EdgeInsets.all(AppSpacing.md),
        blockquote: AppTypography.body(color: colors.textWeak),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colors.borderStrong,
              width: 3,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(
          left: AppSpacing.md,
        ),
        listBullet: AppTypography.body(color: textColor),
        strong: TextStyle(
          fontWeight: AppTypography.bold,
          color: textColor,
        ),
        em: TextStyle(
          fontStyle: FontStyle.italic,
          color: textColor,
        ),
        a: TextStyle(
          color: colors.infoBase,
          decoration: TextDecoration.underline,
        ),
      ),
      builders: {
        'code': _CodeBlockBuilder(onCopyCode: onCopyCode),
      },
    );
  }
}

/// Custom builder for code blocks with copy functionality.
class _CodeBlockBuilder extends MarkdownElementBuilder {
  _CodeBlockBuilder({this.onCopyCode});

  final void Function(String code)? onCopyCode;

  @override
  Widget? visitElementAfter(element, preferredStyle) {
    final String code = element.textContent;
    final colors = AppColors.dark;

    // Check if this is a code block (has newlines or is from a fenced block)
    final isCodeBlock = code.contains('\n') || element.attributes['class'] != null;

    if (!isCodeBlock) {
      // Inline code - use default rendering
      return null;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: colors.borderWeak),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with language label and copy button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                topRight: Radius.circular(AppRadius.sm),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _extractLanguage(element.attributes['class']),
                  style: AppTypography.caption(color: colors.textMuted),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    onCopyCode?.call(code);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.copy,
                          size: 12,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Copy',
                          style: AppTypography.caption(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: AppTypography.fontFamilyMono,
                fontSize: AppTypography.fontSize13,
                color: colors.textBase,
                height: AppTypography.lineHeightRelaxed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractLanguage(String? className) {
    if (className == null) return 'code';
    // Class is usually "language-xyz"
    if (className.startsWith('language-')) {
      return className.substring(9);
    }
    return className;
  }
}
