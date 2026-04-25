import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A responsive grid layout component.
class AppGrid extends StatelessWidget {
  const AppGrid({
    required this.children,
    this.columns = 2,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    this.childAspectRatio = 1.0,
    super.key,
  });

  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: runSpacing,
      crossAxisSpacing: spacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// A responsive grid that adapts based on available width.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.minChildWidth = 200,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    super.key,
  });

  final List<Widget> children;
  final double minChildWidth;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minChildWidth).floor().clamp(1, 6);

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final itemWidth = (constraints.maxWidth - (columns - 1) * spacing) / columns;
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// A masonry-style grid (staggered).
class MasonryGrid extends StatelessWidget {
  const MasonryGrid({
    required this.children,
    this.columns = 2,
    this.spacing = AppSpacing.md,
    super.key,
  });

  final List<Widget> children;
  final int columns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final columnChildren = List.generate(columns, (_) => <Widget>[]);

    for (var i = 0; i < children.length; i++) {
      columnChildren[i % columns].add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: children[i],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren.asMap().entries.map((entry) {
        final isLast = entry.key == columns - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : spacing),
            child: Column(
              children: entry.value,
            ),
          ),
        );
      }).toList(),
    );
  }
}
