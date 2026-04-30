import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';

import '../../theme/tokens.dart';

/// Callback type for when the user sends a message.
typedef OnSendMessage = void Function(String message);

/// A composable input widget for sending messages.
/// Supports multi-line input with auto-grow, Cmd/Ctrl+Enter to send,
/// and Shift+Enter for new lines.
class PromptComposer extends fluent.StatefulWidget {
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
  fluent.State<PromptComposer> createState() => _PromptComposerState();
}

class _PromptComposerState extends fluent.State<PromptComposer> {
  final fluent.TextEditingController _controller =
      fluent.TextEditingController();
  final fluent.FocusNode _focusNode = fluent.FocusNode();

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

  fluent.KeyEventResult _handleKeyEvent(fluent.FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return fluent.KeyEventResult.ignored;

    final isModPressed =
        HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (isModPressed && !isShiftPressed) {
        // Cmd/Ctrl+Enter: Send
        _handleSend();
        return fluent.KeyEventResult.handled;
      } else if (!isShiftPressed) {
        // Plain Enter: Send (Shift+Enter allows newline via default behavior)
        _handleSend();
        return fluent.KeyEventResult.handled;
      }
    }

    return fluent.KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      decoration: fluent.BoxDecoration(
        color: colors.surfaceBase,
        borderRadius: AppRadius.xxlAll,
        border: fluent.Border.all(color: colors.borderBase),
      ),
      padding: const fluent.EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: fluent.Row(
        crossAxisAlignment: fluent.CrossAxisAlignment.end,
        children: [
          fluent.Expanded(
            child: fluent.Focus(
              onKeyEvent: _handleKeyEvent,
              child: fluent.TextBox(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: widget.placeholder,
                maxLines: null,
                minLines: widget.minLines,
                style: AppTypography.body(color: colors.textBase),
                placeholderStyle: AppTypography.body(color: colors.textMuted),
                decoration: fluent.WidgetStateProperty.all(
                  fluent.BoxDecoration(
                    color: fluent.Colors.transparent,
                    border: fluent.Border.all(color: fluent.Colors.transparent),
                  ),
                ),
                padding: const fluent.EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const fluent.SizedBox(width: AppSpacing.sm),
          fluent.Padding(
            padding: const fluent.EdgeInsets.only(bottom: AppSpacing.xs2),
            child: fluent.IconButton(
              icon: fluent.Icon(
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

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewPromptComposerDefault() {
  return PromptComposer(
    onSend: (message) {},
  );
}

@Preview(name: 'Custom Placeholder')
fluent.Widget previewPromptComposerCustomPlaceholder() {
  return PromptComposer(
    onSend: (message) {},
    placeholder: 'Ask me anything about your code...',
  );
}
