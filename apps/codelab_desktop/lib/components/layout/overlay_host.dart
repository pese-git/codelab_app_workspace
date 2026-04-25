import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A host widget for overlays (toasts, modals, etc.).
class OverlayHost extends StatefulWidget {
  const OverlayHost({
    required this.child,
    super.key,
  });

  final Widget child;

  static OverlayHostState? of(BuildContext context) {
    return context.findAncestorStateOfType<OverlayHostState>();
  }

  @override
  State<OverlayHost> createState() => OverlayHostState();
}

class OverlayHostState extends State<OverlayHost> {
  final List<_OverlayEntry> _entries = [];

  /// Show an overlay widget.
  void showOverlay(Widget overlay, {String? id, bool dismissible = true}) {
    setState(() {
      _entries.add(_OverlayEntry(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        widget: overlay,
        dismissible: dismissible,
      ));
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        for (final entry in _entries)
          Positioned.fill(
            child: GestureDetector(
              onTap: entry.dismissible ? () => removeOverlay(entry.id) : null,
              behavior: HitTestBehavior.translucent,
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
  final Widget widget;
  final bool dismissible;
}

/// A modal overlay with backdrop.
class ModalOverlay extends StatelessWidget {
  const ModalOverlay({
    required this.child,
    this.onDismiss,
    this.barrierColor,
    super.key,
  });

  final Widget child;
  final VoidCallback? onDismiss;
  final Color? barrierColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: barrierColor ?? colors.overlay,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {}, // Prevent tap from passing through
          child: child,
        ),
      ),
    );
  }
}

/// A toast container positioned at the top or bottom.
class ToastContainer extends StatelessWidget {
  const ToastContainer({
    required this.child,
    this.position = ToastPosition.top,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final ToastPosition position;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position == ToastPosition.top ? 0 : null,
      bottom: position == ToastPosition.bottom ? 0 : null,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: padding,
          child: Align(
            alignment: position == ToastPosition.top
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: child,
          ),
        ),
      ),
    );
  }
}

enum ToastPosition { top, bottom }
