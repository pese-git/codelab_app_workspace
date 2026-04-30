import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A skeleton loading placeholder widget.
class Skeleton extends fluent.StatefulWidget {

  /// Creates a text line skeleton.
  const Skeleton.text({
    this.width = 100,
    this.height = 14,
    this.animate = true,
    super.key,
  }) : borderRadius = null;

  /// Creates a circular skeleton (avatar placeholder).
  factory Skeleton.circle({
    double size = AppDimensions.avatarSizeMd,
    bool animate = true,
    fluent.Key? key,
  }) {
    return _CircleSkeleton(size: size, animate: animate, key: key);
  }

  /// Creates a rectangular skeleton (card placeholder).
  const Skeleton.rect({
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius,
    this.animate = true,
    super.key,
  });
  const Skeleton({
    this.width,
    this.height,
    this.borderRadius,
    this.animate = true,
    super.key,
  });

  /// Width of the skeleton
  final double? width;

  /// Height of the skeleton
  final double? height;

  /// Border radius
  final fluent.BorderRadius? borderRadius;

  /// Whether to animate the shimmer effect
  final bool animate;

  @override
  fluent.State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends fluent.State<Skeleton>
    with fluent.SingleTickerProviderStateMixin {
  late fluent.AnimationController _controller;
  late fluent.Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = fluent.AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = fluent.Tween<double>(begin: -2, end: 2).animate(
      fluent.CurvedAnimation(
        parent: _controller,
        curve: fluent.Curves.easeInOut,
      ),
    );
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Skeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final baseColor = colors.surfaceSubtle;
    final highlightColor = colors.surfaceHover;

    if (!widget.animate) {
      return fluent.Container(
        width: widget.width,
        height: widget.height,
        decoration: fluent.BoxDecoration(
          color: baseColor,
          borderRadius: widget.borderRadius ?? AppRadius.smAll,
        ),
      );
    }

    return fluent.AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return fluent.Container(
          width: widget.width,
          height: widget.height,
          decoration: fluent.BoxDecoration(
            borderRadius: widget.borderRadius ?? AppRadius.smAll,
            gradient: fluent.LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: [0, 0.5 + _animation.value * 0.25, 1],
            ),
          ),
        );
      },
    );
  }
}

class _CircleSkeleton extends Skeleton {
  const _CircleSkeleton({required this.size, super.animate, super.key})
    : super(width: size, height: size);

  final double size;

  @override
  fluent.State<Skeleton> createState() => _CircleSkeletonState();
}

class _CircleSkeletonState extends _SkeletonState {
  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final baseColor = colors.surfaceSubtle;
    final highlightColor = colors.surfaceHover;
    final circleWidget = widget as _CircleSkeleton;

    if (!widget.animate) {
      return fluent.Container(
        width: circleWidget.size,
        height: circleWidget.size,
        decoration: fluent.BoxDecoration(
          color: baseColor,
          shape: fluent.BoxShape.circle,
        ),
      );
    }

    return fluent.AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return fluent.Container(
          width: circleWidget.size,
          height: circleWidget.size,
          decoration: fluent.BoxDecoration(
            shape: fluent.BoxShape.circle,
            gradient: fluent.LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: [0, 0.5 + _animation.value * 0.25, 1],
            ),
          ),
        );
      },
    );
  }
}

/// A skeleton group for multiple lines of text.
class SkeletonParagraph extends fluent.StatelessWidget {
  const SkeletonParagraph({
    this.lines = 3,
    this.spacing = AppSpacing.sm,
    this.animate = true,
    super.key,
  });

  /// Number of lines
  final int lines;

  /// Spacing between lines
  final double spacing;

  /// Whether to animate
  final bool animate;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return fluent.Padding(
          padding: fluent.EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: Skeleton.text(
            width: isLast ? 150 : double.infinity,
            animate: animate,
          ),
        );
      }),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSkeletonDefault() {
  return const fluent.Padding(
    padding: fluent.EdgeInsets.all(AppSpacing.lg),
    child: Skeleton(width: 120, height: 120),
  );
}

@Preview(name: 'Text Line')
@Preview(name: 'Text Line Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSkeletonText() {
  return const fluent.Padding(
    padding: fluent.EdgeInsets.all(AppSpacing.lg),
    child: Skeleton.text(width: 200),
  );
}

@Preview(name: 'Circle')
@Preview(name: 'Circle Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSkeletonCircle() {
  return fluent.Padding(
    padding: const fluent.EdgeInsets.all(AppSpacing.lg),
    child: Skeleton.circle(size: 48),
  );
}

@Preview(name: 'Rectangular')
@Preview(name: 'Rectangular Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSkeletonRect() {
  return const fluent.Padding(
    padding: fluent.EdgeInsets.all(AppSpacing.lg),
    child: Skeleton.rect(width: 250),
  );
}

@Preview(name: 'Paragraph')
@Preview(name: 'Paragraph Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewSkeletonParagraph() {
  return const fluent.Padding(
    padding: fluent.EdgeInsets.all(AppSpacing.lg),
    child: SkeletonParagraph(lines: 4),
  );
}

@Preview(name: 'Card Skeleton')
fluent.Widget previewSkeletonCard() {
  return fluent.Padding(
    padding: const fluent.EdgeInsets.all(AppSpacing.lg),
    child: fluent.Column(
      crossAxisAlignment: fluent.CrossAxisAlignment.start,
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        fluent.Row(
          children: [
            Skeleton.circle(size: 40),
            const fluent.SizedBox(width: AppSpacing.md),
            const Skeleton.text(width: 120),
          ],
        ),
        const fluent.SizedBox(height: AppSpacing.md),
        const Skeleton.rect(width: 280, height: 140),
        const fluent.SizedBox(height: AppSpacing.md),
        const SkeletonParagraph(lines: 2),
      ],
    ),
  );
}
