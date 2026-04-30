import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A widget that displays a focus ring around its child when focused.
class FocusRing extends fluent.StatefulWidget {
  const FocusRing({
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.skipTraversal = false,
    this.ringColor,
    this.ringWidth = 2.0,
    this.ringOffset = 2.0,
    this.borderRadius,
    this.onFocusChange,
    super.key,
  });

  /// Child widget
  final fluent.Widget child;

  /// Optional focus node
  final fluent.FocusNode? focusNode;

  /// Whether to autofocus
  final bool autofocus;

  /// Whether this widget can request focus
  final bool canRequestFocus;

  /// Whether to skip in traversal
  final bool skipTraversal;

  /// Color of the focus ring
  final fluent.Color? ringColor;

  /// Width of the focus ring
  final double ringWidth;

  /// Offset of the ring from the child
  final double ringOffset;

  /// Border radius of the focus ring
  final fluent.BorderRadius? borderRadius;

  /// Callback when focus changes
  final fluent.ValueChanged<bool>? onFocusChange;

  @override
  fluent.State<FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends fluent.State<FocusRing> {
  late fluent.FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? fluent.FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(FocusRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode = widget.focusNode ?? fluent.FocusNode();
      _focusNode.addListener(_handleFocusChange);
    }
  }

  void _handleFocusChange() {
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
      widget.onFocusChange?.call(_hasFocus);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveRingColor = widget.ringColor ?? colors.borderFocus;
    final effectiveBorderRadius = widget.borderRadius ?? AppRadius.mdAll;

    return fluent.Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      child: fluent.AnimatedContainer(
        duration: AppDurations.fast,
        decoration: _hasFocus
            ? fluent.BoxDecoration(
                borderRadius: effectiveBorderRadius.add(
                  fluent.BorderRadius.circular(widget.ringOffset),
                ),
                border: fluent.Border.all(
                  color: effectiveRingColor,
                  width: widget.ringWidth,
                ),
              )
            : fluent.BoxDecoration(
                borderRadius: effectiveBorderRadius.add(
                  fluent.BorderRadius.circular(widget.ringOffset),
                ),
                border: fluent.Border.all(
                  color: const fluent.Color(0x00000000),
                  width: widget.ringWidth,
                ),
              ),
        child: fluent.Padding(
          padding: fluent.EdgeInsets.all(widget.ringOffset),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A simple focus indicator that only shows a border when focused.
class FocusBorder extends fluent.StatelessWidget {
  const FocusBorder({
    required this.focused,
    required this.child,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius,
    super.key,
  });

  final bool focused;
  final fluent.Widget child;
  final fluent.Color? borderColor;
  final double borderWidth;
  final fluent.BorderRadius? borderRadius;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveBorderColor = borderColor ?? colors.borderFocus;

    return fluent.AnimatedContainer(
      duration: AppDurations.fast,
      decoration: fluent.BoxDecoration(
        borderRadius: borderRadius ?? AppRadius.mdAll,
        border: fluent.Border.all(
          color: focused
              ? effectiveBorderColor
              : const fluent.Color(0x00000000),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewFocusRingDefault() {
  return fluent.Padding(
    padding: const fluent.EdgeInsets.all(AppSpacing.lg),
    child: FocusRing(
      autofocus: true,
      child: fluent.Container(
        width: 200,
        height: 48,
        alignment: fluent.Alignment.center,
        child: const fluent.Text('Focusable Element'),
      ),
    ),
  );
}

@Preview(name: 'Custom Color')
fluent.Widget previewFocusRingCustomColor() {
  return fluent.Padding(
    padding: const fluent.EdgeInsets.all(AppSpacing.lg),
    child: FocusRing(
      autofocus: true,
      ringColor: fluent.Colors.red,
      ringWidth: 3,
      child: fluent.Container(
        width: 200,
        height: 48,
        alignment: fluent.Alignment.center,
        child: const fluent.Text('Custom Focus Ring'),
      ),
    ),
  );
}

@Preview(name: 'Focus Border Default')
@Preview(name: 'Focus Border Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewFocusBorderDefault() {
  return fluent.Padding(
    padding: const fluent.EdgeInsets.all(AppSpacing.lg),
    child: FocusBorder(
      focused: true,
      child: fluent.Container(
        width: 200,
        height: 48,
        alignment: fluent.Alignment.center,
        child: const fluent.Text('Focused Border'),
      ),
    ),
  );
}

@Preview(name: 'Focus Border Unfocused')
fluent.Widget previewFocusBorderUnfocused() {
  return fluent.Padding(
    padding: const fluent.EdgeInsets.all(AppSpacing.lg),
    child: FocusBorder(
      focused: false,
      child: fluent.Container(
        width: 200,
        height: 48,
        alignment: fluent.Alignment.center,
        child: const fluent.Text('Unfocused Border'),
      ),
    ),
  );
}
