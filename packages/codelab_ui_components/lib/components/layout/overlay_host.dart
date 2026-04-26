import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A host widget for overlays (toasts, modals, etc.).
class OverlayHost extends fluent.StatefulWidget {
  const OverlayHost({required this.child, super.key});

  final fluent.Widget child;

  static OverlayHostState? of(fluent.BuildContext context) {
    return context.findAncestorStateOfType<OverlayHostState>();
  }

  @override
  fluent.State<OverlayHost> createState() => OverlayHostState();
}

class OverlayHostState extends fluent.State<OverlayHost> {
  final List<_OverlayEntry> _entries = [];

  /// Show an overlay widget.
  void showOverlay(fluent.Widget overlay, {String? id, bool dismissible = true}) {
    setState(() {
      _entries.add(
        _OverlayEntry(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          widget: overlay,
          dismissible: dismissible,
        ),
      );
    });
  }

  /// Remove an overlay by id.
  void removeOverlay(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
  }

  /// Remove all overlays.
  void clearOverlays() {
    setState(() {
      _entries.clear();
    });
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Stack(
      children: [
        widget.child,
        for (final entry in _entries)
          fluent.Positioned.fill(
            child: fluent.GestureDetector(
              onTap: entry.dismissible ? () => removeOverlay(entry.id) : null,
              behavior: fluent.HitTestBehavior.translucent,
              child: entry.widget,
            ),
          ),
      ],
    );
  }
}

class _OverlayEntry {
  const _OverlayEntry({
    required this.id,
    required this.widget,
    required this.dismissible,
  });

  final String id;
  final fluent.Widget widget;
  final bool dismissible;
}

/// A modal overlay with backdrop.
class ModalOverlay extends fluent.StatelessWidget {
  const ModalOverlay({
    required this.child,
    this.onDismiss,
    this.barrierColor,
    super.key,
  });

  final fluent.Widget child;
  final fluent.VoidCallback? onDismiss;
  final fluent.Color? barrierColor;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onDismiss,
      child: fluent.Container(
        color: barrierColor ?? colors.overlay,
        alignment: fluent.Alignment.center,
        child: fluent.GestureDetector(
          onTap: () {}, // Prevent tap from passing through
          child: child,
        ),
      ),
    );
  }
}

/// A toast container positioned at the top or bottom.
class ToastContainer extends fluent.StatelessWidget {
  const ToastContainer({
    required this.child,
    this.position = ToastPosition.top,
    this.padding = const fluent.EdgeInsets.all(16),
    super.key,
  });

  final fluent.Widget child;
  final ToastPosition position;
  final fluent.EdgeInsets padding;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Positioned(
      top: position == ToastPosition.top ? 0 : null,
      bottom: position == ToastPosition.bottom ? 0 : null,
      left: 0,
      right: 0,
      child: fluent.SafeArea(
        child: fluent.Padding(
          padding: padding,
          child: fluent.Align(
            alignment: position == ToastPosition.top
                ? fluent.Alignment.topCenter
                : fluent.Alignment.bottomCenter,
            child: child,
          ),
        ),
      ),
    );
  }
}

enum ToastPosition { top, bottom }
