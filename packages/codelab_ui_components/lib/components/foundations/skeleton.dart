import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A skeleton loading placeholder widget.
class Skeleton extends StatefulWidget {
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
  final BorderRadius? borderRadius;

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
    Key? key,
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
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final baseColor = colors.surfaceSubtle;
    final highlightColor = colors.surfaceHover;

    if (!widget.animate) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: widget.borderRadius ?? AppRadius.smAll,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? AppRadius.smAll,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
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
  State<Skeleton> createState() => _CircleSkeletonState();
}

class _CircleSkeletonState extends _SkeletonState {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final baseColor = colors.surfaceSubtle;
    final highlightColor = colors.surfaceHover;
    final circleWidget = widget as _CircleSkeleton;

    if (!widget.animate) {
      return Container(
        width: circleWidget.size,
        height: circleWidget.size,
        decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: circleWidget.size,
          height: circleWidget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
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
class SkeletonParagraph extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: Skeleton.text(
            width: isLast ? 150 : double.infinity,
            animate: animate,
          ),
        );
      }),
    );
  }
}
