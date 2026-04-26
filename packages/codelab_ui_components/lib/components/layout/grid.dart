import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A responsive grid layout component.
class AppGrid extends fluent.StatelessWidget {
  const AppGrid({
    required this.children,
    this.columns = 2,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    this.childAspectRatio = 1.0,
    super.key,
  });

  final List<fluent.Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: runSpacing,
      crossAxisSpacing: spacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: true,
      physics: const fluent.NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// A responsive grid that adapts based on available width.
class ResponsiveGrid extends fluent.StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.minChildWidth = 200,
    this.spacing = AppSpacing.md,
    this.runSpacing = AppSpacing.md,
    super.key,
  });

  final List<fluent.Widget> children;
  final double minChildWidth;
  final double spacing;
  final double runSpacing;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minChildWidth).floor().clamp(
          1,
          6,
        );

        return fluent.Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final itemWidth =
                (constraints.maxWidth - (columns - 1) * spacing) / columns;
            return fluent.SizedBox(width: itemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}

/// A masonry-style grid (staggered).
class MasonryGrid extends fluent.StatelessWidget {
  const MasonryGrid({
    required this.children,
    this.columns = 2,
    this.spacing = AppSpacing.md,
    super.key,
  });

  final List<fluent.Widget> children;
  final int columns;
  final double spacing;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final columnChildren = List.generate(columns, (_) => <fluent.Widget>[]);

    for (var i = 0; i < children.length; i++) {
      columnChildren[i % columns].add(
        fluent.Padding(
          padding: fluent.EdgeInsets.only(bottom: spacing),
          child: children[i],
        ),
      );
    }

    return fluent.Row(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      children: columnChildren.asMap().entries.map((entry) {
        final isLast = entry.key == columns - 1;
        return fluent.Expanded(
          child: fluent.Padding(
            padding: fluent.EdgeInsets.only(right: isLast ? 0 : spacing),
            child: fluent.Column(children: entry.value),
          ),
        );
      }).toList(),
    );
  }
}
