import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A tooltip wrapper component.
class AppTooltip extends StatelessWidget {
  const AppTooltip({
    required this.message,
    required this.child,
    this.preferBelow = true,
    this.waitDuration,
    this.showDuration,
    super.key,
  });

  /// Tooltip message
  final String message;

  /// Child widget
  final Widget child;

  /// Prefer showing below the widget
  final bool preferBelow;

  /// Wait duration before showing
  final Duration? waitDuration;

  /// Duration to show the tooltip
  final Duration? showDuration;

  @override
  Widget build(BuildContext context) {
    return fluent.Tooltip(
      message: message,
      displayHorizontally: false,
      child: child,
    );
  }
}

/// A rich tooltip with custom content (uses standard Tooltip as fallback).
class RichTooltip extends StatelessWidget {
  const RichTooltip({
    required this.message,
    required this.child,
    this.preferBelow = true,
    super.key,
  });

  /// Tooltip message
  final String message;

  /// Child widget
  final Widget child;

  /// Prefer showing below the widget
  final bool preferBelow;

  @override
  Widget build(BuildContext context) {
    return fluent.Tooltip(
      message: message,
      displayHorizontally: false,
      child: child,
    );
  }
}

/// A help icon with tooltip.
class HelpTooltip extends StatelessWidget {
  const HelpTooltip({
    required this.message,
    this.iconSize = 14,
    this.iconColor,
    super.key,
  });

  /// Help message
  final String message;

  /// Icon size
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return AppTooltip(
      message: message,
      child: Icon(
        fluent.FluentIcons.info,
        size: iconSize,
        color: iconColor ?? colors.iconMuted,
      ),
    );
  }
}
