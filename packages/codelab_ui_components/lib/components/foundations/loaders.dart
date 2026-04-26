import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A circular progress indicator.
class AppProgressRing extends fluent.StatelessWidget {
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
  final fluent.Color? color;

  /// Background track color
  final fluent.Color? backgroundColor;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.SizedBox(
      width: size,
      height: size,
      child: fluent.ProgressRing(
        value: value != null ? value! * 100 : null,
        strokeWidth: strokeWidth,
        activeColor: color ?? colors.accentPrimary,
        backgroundColor: backgroundColor ?? colors.surfaceSubtle,
      ),
    );
  }
}

/// A linear progress bar.
class AppProgressBar extends fluent.StatelessWidget {
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
  final fluent.Color? color;

  /// Background track color
  final fluent.Color? backgroundColor;

  /// Border radius
  final fluent.BorderRadius? borderRadius;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.ClipRRect(
      borderRadius: borderRadius ?? AppRadius.fullAll,
      child: fluent.SizedBox(
        height: height,
        child: fluent.ProgressBar(
          value: value != null ? value! * 100 : null,
          activeColor: color ?? colors.accentPrimary,
          backgroundColor: backgroundColor ?? colors.surfaceSubtle,
        ),
      ),
    );
  }
}

/// A loading spinner with optional message.
class LoadingIndicator extends fluent.StatelessWidget {
  const LoadingIndicator({this.message, this.size = 32, super.key});

  /// Optional loading message
  final String? message;

  /// Size of the spinner
  final double size;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Column(
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        fluent.SizedBox(
          width: size,
          height: size,
          child: const fluent.ProgressRing(strokeWidth: 3),
        ),
        if (message != null) ...[
          const fluent.SizedBox(height: AppSpacing.md),
          fluent.Text(
            message!,
            style: AppTypography.body(color: colors.textMuted),
          ),
        ],
      ],
    );
  }
}

/// A full-screen loading overlay.
class LoadingOverlay extends fluent.StatelessWidget {
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
  final fluent.Widget child;

  /// Optional loading message
  final String? message;

  /// Overlay opacity
  final double opacity;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Stack(
      children: [
        child,
        if (isLoading)
          fluent.Positioned.fill(
            child: fluent.Container(
              color: colors.overlay.withValues(alpha: opacity),
              child: fluent.Center(child: LoadingIndicator(message: message)),
            ),
          ),
      ],
    );
  }
}

/// A button loading state indicator.
class ButtonLoader extends fluent.StatelessWidget {
  const ButtonLoader({this.size = 18, this.color, super.key});

  final double size;
  final fluent.Color? color;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.SizedBox(
      width: size,
      height: size,
      child: fluent.ProgressRing(
        strokeWidth: 2,
        activeColor: color ?? const fluent.Color(0xFFFFFFFF),
      ),
    );
  }
}

/// Animated dots loading indicator.
class DotsLoader extends fluent.StatefulWidget {
  const DotsLoader({this.size = 8, this.spacing = 4, this.color, super.key});

  final double size;
  final double spacing;
  final fluent.Color? color;

  @override
  fluent.State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends fluent.State<DotsLoader>
    with fluent.TickerProviderStateMixin {
  late List<fluent.AnimationController> _controllers;
  late List<fluent.Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return fluent.AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _animations = _controllers.map((controller) {
      return fluent.Tween<double>(begin: 0, end: 1).animate(
        fluent.CurvedAnimation(
          parent: controller,
          curve: fluent.Curves.easeInOut,
        ),
      );
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
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final color = widget.color ?? colors.textMuted;

    return fluent.Row(
      mainAxisSize: fluent.MainAxisSize.min,
      children: List.generate(3, (index) {
        return fluent.AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return fluent.Container(
              margin: fluent.EdgeInsets.only(
                right: index < 2 ? widget.spacing : 0,
              ),
              width: widget.size,
              height: widget.size,
              decoration: fluent.BoxDecoration(
                color: color.withValues(
                  alpha: 0.3 + _animations[index].value * 0.7,
                ),
                shape: fluent.BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
