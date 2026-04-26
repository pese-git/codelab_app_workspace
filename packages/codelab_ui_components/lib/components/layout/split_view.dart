import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A resizable split view component.
class SplitView extends fluent.StatefulWidget {
  const SplitView({
    required this.first,
    required this.second,
    this.axis = fluent.Axis.horizontal,
    this.initialRatio = 0.5,
    this.minRatio = 0.2,
    this.maxRatio = 0.8,
    this.dividerWidth = 8,
    this.dividerColor,
    super.key,
  });

  final fluent.Widget first;
  final fluent.Widget second;
  final fluent.Axis axis;
  final double initialRatio;
  final double minRatio;
  final double maxRatio;
  final double dividerWidth;
  final fluent.Color? dividerColor;

  @override
  fluent.State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends fluent.State<SplitView> {
  late double _ratio;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _ratio = widget.initialRatio;
  }

  void _handleDragUpdate(
    fluent.DragUpdateDetails details,
    fluent.BoxConstraints constraints,
  ) {
    final maxSize = widget.axis == fluent.Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    final delta = widget.axis == fluent.Axis.horizontal
        ? details.delta.dx
        : details.delta.dy;

    setState(() {
      _ratio += delta / maxSize;
      _ratio = _ratio.clamp(widget.minRatio, widget.maxRatio);
    });
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = widget.axis == fluent.Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final firstSize = maxSize * _ratio - widget.dividerWidth / 2;
        final secondSize = maxSize * (1 - _ratio) - widget.dividerWidth / 2;

        final children = <fluent.Widget>[
          fluent.SizedBox(
            width: widget.axis == fluent.Axis.horizontal ? firstSize : null,
            height: widget.axis == fluent.Axis.vertical ? firstSize : null,
            child: widget.first,
          ),
          fluent.GestureDetector(
            onPanStart: (_) => setState(() => _isDragging = true),
            onPanUpdate: (details) => _handleDragUpdate(details, constraints),
            onPanEnd: (_) => setState(() => _isDragging = false),
            child: fluent.MouseRegion(
              cursor: widget.axis == fluent.Axis.horizontal
                  ? fluent.SystemMouseCursors.resizeColumn
                  : fluent.SystemMouseCursors.resizeRow,
              child: fluent.Container(
                width: widget.axis == fluent.Axis.horizontal
                    ? widget.dividerWidth
                    : null,
                height: widget.axis == fluent.Axis.vertical
                    ? widget.dividerWidth
                    : null,
                color: _isDragging
                    ? colors.accentPrimary
                    : (widget.dividerColor ?? colors.borderWeak),
              ),
            ),
          ),
          fluent.SizedBox(
            width: widget.axis == fluent.Axis.horizontal ? secondSize : null,
            height: widget.axis == fluent.Axis.vertical ? secondSize : null,
            child: widget.second,
          ),
        ];

        return widget.axis == fluent.Axis.horizontal
            ? fluent.Row(children: children)
            : fluent.Column(children: children);
      },
    );
  }
}

/// A three-panel layout (left, center, right).
class ThreePanelLayout extends fluent.StatelessWidget {
  const ThreePanelLayout({
    required this.center,
    this.left,
    this.right,
    this.leftWidth = 280,
    this.rightWidth = 280,
    super.key,
  });

  final fluent.Widget center;
  final fluent.Widget? left;
  final fluent.Widget? right;
  final double leftWidth;
  final double rightWidth;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Row(
      children: [
        if (left != null) fluent.SizedBox(width: leftWidth, child: left),
        fluent.Expanded(child: center),
        if (right != null) fluent.SizedBox(width: rightWidth, child: right),
      ],
    );
  }
}
