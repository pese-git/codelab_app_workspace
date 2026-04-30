import 'package:codelab_ui_components/components/atoms/text.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A tooltip wrapper component.
class AppTooltip extends fluent.StatelessWidget {
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
  final fluent.Widget child;

  /// Prefer showing below the widget
  final bool preferBelow;

  /// Wait duration before showing
  final Duration? waitDuration;

  /// Duration to show the tooltip
  final Duration? showDuration;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Tooltip(
      message: message,
      child: child,
    );
  }
}

/// A rich tooltip with custom content (uses standard Tooltip as fallback).
class RichTooltip extends fluent.StatelessWidget {
  const RichTooltip({
    required this.message,
    required this.child,
    this.preferBelow = true,
    super.key,
  });

  /// Tooltip message
  final String message;

  /// Child widget
  final fluent.Widget child;

  /// Prefer showing below the widget
  final bool preferBelow;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Tooltip(
      message: message,
      child: child,
    );
  }
}

/// A help icon with tooltip.
class HelpTooltip extends fluent.StatelessWidget {
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
  final fluent.Color? iconColor;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return AppTooltip(
      message: message,
      child: fluent.Icon(
        fluent.FluentIcons.info,
        size: iconSize,
        color: iconColor ?? colors.iconMuted,
      ),
    );
  }
}

// MARK: - Previews

@Preview(name: 'Tooltip')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewTooltip() {
  return const AppTooltip(
    message: 'This is a tooltip',
    child: AppText('Hover me'),
  );
}

@Preview(name: 'Rich Tooltip')
fluent.Widget previewRichTooltip() {
  return const RichTooltip(
    message: 'Rich tooltip content',
    child: AppText('Hover me'),
  );
}

@Preview(name: 'Help Icon')
fluent.Widget previewHelpTooltip() {
  return const HelpTooltip(message: 'Need help? Click here for more info.');
}
