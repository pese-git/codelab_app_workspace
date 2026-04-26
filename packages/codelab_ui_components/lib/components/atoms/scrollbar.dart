import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A styled scrollbar wrapper.
class AppScrollbar extends fluent.StatelessWidget {
  const AppScrollbar({
    required this.child,
    this.controller,
    this.thumbVisibility = true,
    this.trackVisibility = false,
    this.thickness = 6,
    this.radius = const fluent.Radius.circular(AppRadius.full),
    super.key,
  });

  /// Child scrollable widget
  final fluent.Widget child;

  /// Scroll controller
  final fluent.ScrollController? controller;

  /// Always show thumb
  final bool thumbVisibility;

  /// Show track
  final bool trackVisibility;

  /// Scrollbar thickness
  final double thickness;

  /// Scrollbar radius
  final fluent.Radius radius;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Scrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      child: child,
    );
  }
}

/// A custom styled scrollbar with hover effect.
class HoverScrollbar extends fluent.StatefulWidget {
  const HoverScrollbar({
    required this.child,
    this.controller,
    this.axis = fluent.Axis.vertical,
    super.key,
  });

  /// Child scrollable widget
  final fluent.Widget child;

  /// Scroll controller
  final fluent.ScrollController? controller;

  /// Scroll axis
  final fluent.Axis axis;

  @override
  fluent.State<HoverScrollbar> createState() => _HoverScrollbarState();
}

class _HoverScrollbarState extends fluent.State<HoverScrollbar> {
  bool _isHovering = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: fluent.RawScrollbar(
        controller: widget.controller,
        thumbVisibility: _isHovering,
        thickness: _isHovering ? 8 : 6,
        radius: const fluent.Radius.circular(AppRadius.full),
        thumbColor: _isHovering ? colors.textMuted : colors.borderStrong,
        child: widget.child,
      ),
    );
  }
}
