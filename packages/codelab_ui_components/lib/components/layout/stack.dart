import 'package:fluent_ui/fluent_ui.dart' as fluent;

/// A stack layout component with alignment options.
class AppStack extends fluent.StatelessWidget {
  const AppStack({
    required this.children,
    this.alignment = fluent.Alignment.topLeft,
    this.fit = fluent.StackFit.loose,
    this.clipBehavior = fluent.Clip.hardEdge,
    super.key,
  });

  final List<fluent.Widget> children;
  final fluent.AlignmentGeometry alignment;
  final fluent.StackFit fit;
  final fluent.Clip clipBehavior;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

/// A positioned child within an AppStack.
class StackItem extends fluent.StatelessWidget {
  const StackItem({
    required this.child,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.fill = false,
    super.key,
  });

  final fluent.Widget child;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final bool fill;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    if (fill) {
      return fluent.Positioned.fill(child: child);
    }

    return fluent.Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: child,
    );
  }
}

/// A z-stack with layers.
class LayeredStack extends fluent.StatelessWidget {
  const LayeredStack({required this.layers, super.key});

  final List<fluent.Widget> layers;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Stack(fit: fluent.StackFit.expand, children: layers);
  }
}
