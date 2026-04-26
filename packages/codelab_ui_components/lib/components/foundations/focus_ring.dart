import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A widget that displays a focus ring around its child when focused.
class FocusRing extends StatefulWidget {
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
  final Widget child;

  /// Optional focus node
  final FocusNode? focusNode;

  /// Whether to autofocus
  final bool autofocus;

  /// Whether this widget can request focus
  final bool canRequestFocus;

  /// Whether to skip in traversal
  final bool skipTraversal;

  /// Color of the focus ring
  final Color? ringColor;

  /// Width of the focus ring
  final double ringWidth;

  /// Offset of the ring from the child
  final double ringOffset;

  /// Border radius of the focus ring
  final BorderRadius? borderRadius;

  /// Callback when focus changes
  final ValueChanged<bool>? onFocusChange;

  @override
  State<FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<FocusRing> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(FocusRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode = widget.focusNode ?? FocusNode();
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
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveRingColor = widget.ringColor ?? colors.borderFocus;
    final effectiveBorderRadius = widget.borderRadius ?? AppRadius.mdAll;

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      skipTraversal: widget.skipTraversal,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        decoration: _hasFocus
            ? BoxDecoration(
                borderRadius: effectiveBorderRadius.add(
                  BorderRadius.circular(widget.ringOffset),
                ),
                border: Border.all(
                  color: effectiveRingColor,
                  width: widget.ringWidth,
                ),
              )
            : BoxDecoration(
                borderRadius: effectiveBorderRadius.add(
                  BorderRadius.circular(widget.ringOffset),
                ),
                border: Border.all(
                  color: Colors.transparent,
                  width: widget.ringWidth,
                ),
              ),
        child: Padding(
          padding: EdgeInsets.all(widget.ringOffset),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A simple focus indicator that only shows a border when focused.
class FocusBorder extends StatelessWidget {
  const FocusBorder({
    required this.focused,
    required this.child,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius,
    super.key,
  });

  final bool focused;
  final Widget child;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final effectiveBorderColor = borderColor ?? colors.borderFocus;

    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? AppRadius.mdAll,
        border: Border.all(
          color: focused ? effectiveBorderColor : Colors.transparent,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
