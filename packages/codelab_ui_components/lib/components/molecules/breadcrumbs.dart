import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widget_previews.dart';

import '../theme/tokens.dart';

/// A breadcrumbs navigation component.
class Breadcrumbs extends fluent.StatelessWidget {
  const Breadcrumbs({
    required this.items,
    this.separator,
    this.maxItems,
    super.key,
  });

  /// Breadcrumb items
  final List<BreadcrumbItem> items;

  /// Custom separator widget
  final fluent.Widget? separator;

  /// Maximum items to display (shows ellipsis)
  final int? maxItems;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final effectiveSeparator =
        separator ??
        fluent.Padding(
          padding: const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: fluent.Icon(
            fluent.FluentIcons.chevron_right,
            size: 16,
            color: colors.iconMuted,
          ),
        );

    List<BreadcrumbItem> displayItems = items;
    bool showEllipsis = false;

    if (maxItems != null && items.length > maxItems!) {
      displayItems = [
        items.first,
        ...items.sublist(items.length - maxItems! + 1),
      ];
      showEllipsis = true;
    }

    return fluent.Row(
      mainAxisSize: fluent.MainAxisSize.min,
      children: [
        for (var i = 0; i < displayItems.length; i++) ...[
          if (i == 1 && showEllipsis) ...[
            fluent.Text(
              '...',
              style: AppTypography.body(color: colors.textMuted),
            ),
            effectiveSeparator,
          ],
          _BreadcrumbButton(
            item: displayItems[i],
            isLast: i == displayItems.length - 1,
          ),
          if (i < displayItems.length - 1) effectiveSeparator,
        ],
      ],
    );
  }
}

class _BreadcrumbButton extends fluent.StatefulWidget {
  const _BreadcrumbButton({required this.item, required this.isLast});

  final BreadcrumbItem item;
  final bool isLast;

  @override
  fluent.State<_BreadcrumbButton> createState() => _BreadcrumbButtonState();
}

class _BreadcrumbButtonState extends fluent.State<_BreadcrumbButton> {
  bool _isHovered = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isClickable = widget.item.onTap != null && !widget.isLast;

    return fluent.GestureDetector(
      onTap: isClickable ? widget.item.onTap : null,
      child: fluent.MouseRegion(
        cursor: isClickable
            ? fluent.SystemMouseCursors.click
            : fluent.SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: fluent.Row(
          mainAxisSize: fluent.MainAxisSize.min,
          children: [
            if (widget.item.icon != null) ...[
              fluent.Icon(
                widget.item.icon,
                size: 14,
                color: widget.isLast ? colors.iconBase : colors.iconWeak,
              ),
              const fluent.SizedBox(width: AppSpacing.xs),
            ],
            fluent.Text(
              widget.item.label,
              style:
                  AppTypography.body(
                    color: widget.isLast
                        ? colors.textStrong
                        : _isHovered
                        ? colors.textBase
                        : colors.textWeak,
                  ).copyWith(
                    decoration: _isHovered && isClickable
                        ? fluent.TextDecoration.underline
                        : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A breadcrumb item.
class BreadcrumbItem {
  const BreadcrumbItem({required this.label, this.icon, this.onTap});

  /// Item label
  final String label;

  /// Optional icon
  final fluent.IconData? icon;

  /// Tap callback
  final fluent.VoidCallback? onTap;
}

// MARK: - Previews

@Preview(name: 'Default')
@Preview(name: 'Dark', brightness: fluent.Brightness.dark)
fluent.Widget previewBreadcrumbsDefault() {
  return const Breadcrumbs(
    items: [
      BreadcrumbItem(label: 'Home', icon: fluent.FluentIcons.home),
      BreadcrumbItem(label: 'Projects'),
      BreadcrumbItem(label: 'Current Project'),
    ],
  );
}

@Preview(name: 'With Max Items')
fluent.Widget previewBreadcrumbsMaxItems() {
  return const Breadcrumbs(
    items: [
      BreadcrumbItem(label: 'Home'),
      BreadcrumbItem(label: 'Level 1'),
      BreadcrumbItem(label: 'Level 2'),
      BreadcrumbItem(label: 'Level 3'),
      BreadcrumbItem(label: 'Current'),
    ],
    maxItems: 3,
  );
}
