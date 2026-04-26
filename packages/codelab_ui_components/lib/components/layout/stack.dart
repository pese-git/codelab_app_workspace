import 'package:flutter/material.dart';

/// A stack layout component with alignment options.
class AppStack extends StatelessWidget {
  const AppStack({
    required this.children,
    this.alignment = Alignment.topLeft,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

  final List<Widget> children;
  final AlignmentGeometry alignment;
  final StackFit fit;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

/// A positioned child within an AppStack.
class StackItem extends StatelessWidget {
  const StackItem({
    required this.child,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.fill = false,
    super.key,
  });

  final Widget child;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    if (fill) {
      return Positioned.fill(child: child);
    }

    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: child,
    );
  }
}

/// A z-stack with layers.
class LayeredStack extends StatelessWidget {
  const LayeredStack({required this.layers, super.key});

  final List<Widget> layers;

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: layers);
  }
}
