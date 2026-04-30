import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

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

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewAppStackDefault() {
  return fluent.SizedBox(
    width: 300,
    height: 200,
    child: AppStack(
      children: [
        fluent.Container(color: const fluent.Color.fromARGB(255, 219, 234, 254)),
        fluent.Container(
          width: 100,
          height: 100,
          color: const fluent.Color.fromARGB(255, 254, 202, 202),
        ),
        fluent.Container(
          width: 50,
          height: 50,
          color: const fluent.Color.fromARGB(255, 187, 247, 208),
        ),
      ],
    ),
  );
}

@Preview(name: 'Stack Item Default')
fluent.Widget previewStackItemDefault() {
  return fluent.SizedBox(
    width: 300,
    height: 200,
    child: fluent.Stack(
      children: [
        fluent.Container(color: const fluent.Color.fromARGB(255, 243, 244, 246)),
        StackItem(
          top: 20,
          left: 20,
          child: fluent.Container(
            width: 80,
            height: 80,
            decoration: fluent.BoxDecoration(
              color: const fluent.Color.fromARGB(255, 191, 219, 254),
              borderRadius: AppRadius.mdAll,
            ),
            alignment: fluent.Alignment.center,
            child: const fluent.Text('Top Left'),
          ),
        ),
        StackItem(
          bottom: 20,
          right: 20,
          child: fluent.Container(
            width: 80,
            height: 80,
            decoration: fluent.BoxDecoration(
              color: const fluent.Color.fromARGB(255, 254, 215, 170),
              borderRadius: AppRadius.mdAll,
            ),
            alignment: fluent.Alignment.center,
            child: const fluent.Text('Bottom Right'),
          ),
        ),
      ],
    ),
  );
}

@Preview(name: 'Stack Item Fill')
fluent.Widget previewStackItemFill() {
  return fluent.SizedBox(
    width: 300,
    height: 200,
    child: fluent.Stack(
      children: [
        fluent.Container(color: const fluent.Color.fromARGB(255, 243, 244, 246)),
        StackItem(
          fill: true,
          child: fluent.Container(
            decoration: fluent.BoxDecoration(
              color: const fluent.Color.fromARGB(255, 233, 213, 255),
              border: fluent.Border.all(
                color: const fluent.Color.fromARGB(255, 192, 132, 252),
              ),
            ),
            alignment: fluent.Alignment.center,
            child: const fluent.Text('Fill Overlay'),
          ),
        ),
      ],
    ),
  );
}

@Preview(name: 'Layered Default')
@Preview(name: 'Layered Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewLayeredStackDefault() {
  return fluent.SizedBox(
    width: 300,
    height: 200,
    child: LayeredStack(
      layers: [
        fluent.Container(color: const fluent.Color.fromARGB(255, 204, 251, 241)),
        fluent.Align(
          child: fluent.Container(
            width: 150,
            height: 100,
            decoration: fluent.BoxDecoration(
              color: const fluent.Color.fromARGB(255, 255, 255, 255),
              borderRadius: AppRadius.lgAll,
              boxShadow: [
                const fluent.BoxShadow(
                  color: fluent.Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 8,
                ),
              ],
            ),
            alignment: fluent.Alignment.center,
            child: const fluent.Text('Center Card'),
          ),
        ),
      ],
    ),
  );
}
