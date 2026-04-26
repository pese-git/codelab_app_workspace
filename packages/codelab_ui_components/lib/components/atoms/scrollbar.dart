import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A styled scrollbar wrapper.
class AppScrollbar extends StatelessWidget {
  const AppScrollbar({
    required this.child,
    this.controller,
    this.thumbVisibility = true,
    this.trackVisibility = false,
    this.thickness = 6,
    this.radius = const Radius.circular(AppRadius.full),
    super.key,
  });

  /// Child scrollable widget
  final Widget child;

  /// Scroll controller
  final ScrollController? controller;

  /// Always show thumb
  final bool thumbVisibility;

  /// Show track
  final bool trackVisibility;

  /// Scrollbar thickness
  final double thickness;

  /// Scrollbar radius
  final Radius radius;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thickness: thickness,
      radius: radius,
      child: child,
    );
  }
}

/// A custom styled scrollbar with hover effect.
class HoverScrollbar extends StatefulWidget {
  const HoverScrollbar({
    required this.child,
    this.controller,
    this.axis = Axis.vertical,
    super.key,
  });

  /// Child scrollable widget
  final Widget child;

  /// Scroll controller
  final ScrollController? controller;

  /// Scroll axis
  final Axis axis;

  @override
  State<HoverScrollbar> createState() => _HoverScrollbarState();
}

class _HoverScrollbarState extends State<HoverScrollbar> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: RawScrollbar(
        controller: widget.controller,
        thumbVisibility: _isHovering,
        thickness: _isHovering ? 8 : 6,
        radius: const Radius.circular(AppRadius.full),
        thumbColor: _isHovering
            ? Theme.of(context).brightness == Brightness.light
                  ? AppColors.light.textMuted
                  : AppColors.dark.textMuted
            : Theme.of(context).brightness == Brightness.light
            ? AppColors.light.borderStrong
            : AppColors.dark.borderStrong,
        child: widget.child,
      ),
    );
  }
}
