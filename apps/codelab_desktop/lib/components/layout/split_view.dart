import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A resizable split view component.
class SplitView extends StatefulWidget {
  const SplitView({
    required this.first,
    required this.second,
    this.axis = Axis.horizontal,
    this.initialRatio = 0.5,
    this.minRatio = 0.2,
    this.maxRatio = 0.8,
    this.dividerWidth = 8,
    this.dividerColor,
    super.key,
  });

  final Widget first;
  final Widget second;
  final Axis axis;
  final double initialRatio;
  final double minRatio;
  final double maxRatio;
  final double dividerWidth;
  final Color? dividerColor;

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  late double _ratio;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _ratio = widget.initialRatio;
  }

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final maxSize = widget.axis == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    final delta = widget.axis == Axis.horizontal
        ? details.delta.dx
        : details.delta.dy;

    setState(() {
      _ratio += delta / maxSize;
      _ratio = _ratio.clamp(widget.minRatio, widget.maxRatio);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = widget.axis == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final firstSize = maxSize * _ratio - widget.dividerWidth / 2;
        final secondSize = maxSize * (1 - _ratio) - widget.dividerWidth / 2;

        final children = <Widget>[
          SizedBox(
            width: widget.axis == Axis.horizontal ? firstSize : null,
            height: widget.axis == Axis.vertical ? firstSize : null,
            child: widget.first,
          ),
          GestureDetector(
            onPanStart: (_) => setState(() => _isDragging = true),
            onPanUpdate: (details) => _handleDragUpdate(details, constraints),
            onPanEnd: (_) => setState(() => _isDragging = false),
            child: MouseRegion(
              cursor: widget.axis == Axis.horizontal
                  ? SystemMouseCursors.resizeColumn
                  : SystemMouseCursors.resizeRow,
              child: Container(
                width: widget.axis == Axis.horizontal ? widget.dividerWidth : null,
                height: widget.axis == Axis.vertical ? widget.dividerWidth : null,
                color: _isDragging
                    ? colors.accentPrimary
                    : (widget.dividerColor ?? colors.borderWeak),
              ),
            ),
          ),
          SizedBox(
            width: widget.axis == Axis.horizontal ? secondSize : null,
            height: widget.axis == Axis.vertical ? secondSize : null,
            child: widget.second,
          ),
        ];

        return widget.axis == Axis.horizontal
            ? Row(children: children)
            : Column(children: children);
      },
    );
  }
}

/// A three-panel layout (left, center, right).
class ThreePanelLayout extends StatelessWidget {
  const ThreePanelLayout({
    required this.center,
    this.left,
    this.right,
    this.leftWidth = 280,
    this.rightWidth = 280,
    super.key,
  });

  final Widget center;
  final Widget? left;
  final Widget? right;
  final double leftWidth;
  final double rightWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (left != null)
          SizedBox(width: leftWidth, child: left),
        Expanded(child: center),
        if (right != null)
          SizedBox(width: rightWidth, child: right),
      ],
    );
  }
}
