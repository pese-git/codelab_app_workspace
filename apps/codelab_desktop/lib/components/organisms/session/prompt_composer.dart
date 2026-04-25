import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/tokens.dart';

/// Callback type for when the user sends a message.
typedef OnSendMessage = void Function(String message);

/// A composable input widget for sending messages.
/// Supports multi-line input with auto-grow, Cmd/Ctrl+Enter to send,
/// and Shift+Enter for new lines.
class PromptComposer extends StatefulWidget {
  const PromptComposer({
    required this.onSend,
    this.placeholder = 'Type a message...',
    this.minLines = 1,
    this.maxLines = 10,
    super.key,
  });

  final OnSendMessage onSend;
  final String placeholder;
  final int minLines;
  final int maxLines;

  @override
  State<PromptComposer> createState() => _PromptComposerState();
}

class _PromptComposerState extends State<PromptComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get _canSend => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final isModPressed = HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (isModPressed && !isShiftPressed) {
        // Cmd/Ctrl+Enter: Send
        _handleSend();
        return KeyEventResult.handled;
      } else if (!isShiftPressed) {
        // Plain Enter: Send (Shift+Enter allows newline via default behavior)
        _handleSend();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        borderRadius: AppRadius.xxlAll,
        border: Border.all(color: colors.borderBase),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Focus(
              onKeyEvent: _handleKeyEvent,
              child: fluent.TextBox(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: widget.placeholder,
                maxLines: null,
                minLines: widget.minLines,
                style: AppTypography.body(color: colors.textBase),
                placeholderStyle: AppTypography.body(color: colors.textMuted),
                decoration: WidgetStateProperty.all(
                  BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.transparent),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs2),
            child: fluent.IconButton(
              icon: Icon(
                fluent.FluentIcons.send,
                size: 18,
                color: _canSend ? colors.accentPrimary : colors.iconMuted,
              ),
              onPressed: _canSend ? _handleSend : null,
            ),
          ),
        ],
      ),
    );
  }
}
