import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A search input field component.
class SearchField extends StatefulWidget {
  const SearchField({
    this.controller,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.placeholder = 'Search...',
    this.autofocus = false,
    this.isDisabled = false,
    super.key,
  });

  /// Text controller
  final TextEditingController? controller;

  /// Current value
  final String? value;

  /// Value change callback
  final ValueChanged<String>? onChanged;

  /// Submit callback
  final ValueChanged<String>? onSubmitted;

  /// Clear callback
  final VoidCallback? onClear;

  /// Placeholder text
  final String placeholder;

  /// Autofocus
  final bool autofocus;

  /// Disabled state
  final bool isDisabled;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _hasValue = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  void _handleTextChange() {
    final hasValue = _controller.text.isNotEmpty;
    if (hasValue != _hasValue) {
      setState(() => _hasValue = hasValue);
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.TextBox(
      controller: _controller,
      placeholder: widget.placeholder,
      enabled: !widget.isDisabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      prefix: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: Icon(
          fluent.FluentIcons.search,
          size: 14,
          color: colors.iconWeak,
        ),
      ),
      suffix: _hasValue
          ? GestureDetector(
              onTap: _handleClear,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Icon(
                  fluent.FluentIcons.chrome_close,
                  size: 12,
                  color: colors.iconWeak,
                ),
              ),
            )
          : null,
      style: AppTypography.body(color: colors.textBase),
      placeholderStyle: AppTypography.body(color: colors.textMuted),
      decoration: WidgetStateProperty.resolveWith((states) {
        Color borderColor = colors.borderBase;
        if (states.contains(WidgetState.focused)) {
          borderColor = colors.borderFocus;
        }
        return BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: borderColor),
        );
      }),
    );
  }
}
