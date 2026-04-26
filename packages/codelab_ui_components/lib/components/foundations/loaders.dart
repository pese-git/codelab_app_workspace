import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A circular progress indicator.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    this.value,
    this.size = 24,
    this.strokeWidth = 3,
    this.color,
    this.backgroundColor,
    super.key,
  });

  /// Progress value (0.0 to 1.0). Null for indeterminate.
  final double? value;

  /// Size of the ring
  final double size;

  /// Stroke width
  final double strokeWidth;

  /// Progress color (defaults to accent)
  final Color? color;

  /// Background track color
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        color: color ?? colors.accentPrimary,
        backgroundColor: backgroundColor ?? colors.surfaceSubtle,
      ),
    );
  }
}

/// A linear progress bar.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    this.value,
    this.height = 4,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    super.key,
  });

  /// Progress value (0.0 to 1.0). Null for indeterminate.
  final double? value;

  /// Height of the bar
  final double height;

  /// Progress color (defaults to accent)
  final Color? color;

  /// Background track color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return ClipRRect(
      borderRadius: borderRadius ?? AppRadius.fullAll,
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        color: color ?? colors.accentPrimary,
        backgroundColor: backgroundColor ?? colors.surfaceSubtle,
      ),
    );
  }
}

/// A loading spinner with optional message.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.message, this.size = 32, super.key});

  /// Optional loading message
  final String? message;

  /// Size of the spinner
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        fluent.ProgressRing(strokeWidth: 3),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(message!, style: AppTypography.body(color: colors.textMuted)),
        ],
      ],
    );
  }
}

/// A full-screen loading overlay.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.message,
    this.opacity = 0.5,
    super.key,
  });

  /// Whether the overlay is visible
  final bool isLoading;

  /// Child widget
  final Widget child;

  /// Optional loading message
  final String? message;

  /// Overlay opacity
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: colors.overlay.withValues(alpha: opacity),
              child: Center(child: LoadingIndicator(message: message)),
            ),
          ),
      ],
    );
  }
}

/// A button loading state indicator.
class ButtonLoader extends StatelessWidget {
  const ButtonLoader({this.size = 18, this.color, super.key});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? Colors.white,
      ),
    );
  }
}

/// Animated dots loading indicator.
class DotsLoader extends StatefulWidget {
  const DotsLoader({this.size = 8, this.spacing = 4, this.color, super.key});

  final double size;
  final double spacing;
  final Color? color;

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final color = widget.color ?? colors.textMuted;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.only(right: index < 2 ? widget.spacing : 0),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.3 + _animations[index].value * 0.7,
                ),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
