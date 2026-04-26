import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A skeleton loading placeholder widget.
class Skeleton extends fluent.StatefulWidget {
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
              begin: fluent.Alignment.centerLeft,
              end: fluent.Alignment.centerRight,
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
              begin: fluent.Alignment.centerLeft,
              end: fluent.Alignment.centerRight,
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
