import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A search input field component.
class SearchField extends fluent.StatefulWidget {
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
  final fluent.TextEditingController? controller;

  /// Current value
  final String? value;

  /// Value change callback
  final fluent.ValueChanged<String>? onChanged;

  /// Submit callback
  final fluent.ValueChanged<String>? onSubmitted;

  /// Clear callback
  final fluent.VoidCallback? onClear;

  /// Placeholder text
  final String placeholder;

  /// Autofocus
  final bool autofocus;

  /// Disabled state
  final bool isDisabled;

  @override
  fluent.State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends fluent.State<SearchField> {
  late fluent.TextEditingController _controller;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? fluent.TextEditingController(text: widget.value);
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
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.TextBox(
      controller: _controller,
      placeholder: widget.placeholder,
      enabled: !widget.isDisabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      prefix: fluent.Padding(
        padding: const fluent.EdgeInsets.only(left: AppSpacing.sm),
        child: fluent.Icon(
          fluent.FluentIcons.search,
          size: 14,
          color: colors.iconWeak,
        ),
      ),
      suffix: _hasValue
          ? fluent.GestureDetector(
              onTap: _handleClear,
              child: fluent.Padding(
                padding: const fluent.EdgeInsets.only(right: AppSpacing.sm),
                child: fluent.Icon(
                  fluent.FluentIcons.chrome_close,
                  size: 12,
                  color: colors.iconWeak,
                ),
              ),
            )
          : null,
      style: AppTypography.body(color: colors.textBase),
      placeholderStyle: AppTypography.body(color: colors.textMuted),
      decoration: fluent.WidgetStateProperty.resolveWith((states) {
        fluent.Color borderColor = colors.borderBase;
        if (states.contains(fluent.WidgetState.focused)) {
          borderColor = colors.borderFocus;
        }
        return fluent.BoxDecoration(
          color: colors.surfaceSubtle,
          borderRadius: AppRadius.mdAll,
          border: fluent.Border.all(color: borderColor),
        );
      }),
    );
  }
}
