import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A breadcrumbs navigation component.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({
    required this.items,
    this.separator,
    this.maxItems,
    super.key,
  });

  /// Breadcrumb items
  final List<BreadcrumbItem> items;

  /// Custom separator widget
  final Widget? separator;

  /// Maximum items to display (shows ellipsis)
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    final effectiveSeparator = separator ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Icon(
            Icons.chevron_right,
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < displayItems.length; i++) ...[
          if (i == 1 && showEllipsis) ...[
            Text('...', style: AppTypography.body(color: colors.textMuted)),
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

class _BreadcrumbButton extends StatefulWidget {
  const _BreadcrumbButton({
    required this.item,
    required this.isLast,
  });

  final BreadcrumbItem item;
  final bool isLast;

  @override
  State<_BreadcrumbButton> createState() => _BreadcrumbButtonState();
}

class _BreadcrumbButtonState extends State<_BreadcrumbButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final isClickable = widget.item.onTap != null && !widget.isLast;

    return GestureDetector(
      onTap: isClickable ? widget.item.onTap : null,
      child: MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.item.icon != null) ...[
              Icon(
                widget.item.icon,
                size: 14,
                color: widget.isLast ? colors.iconBase : colors.iconWeak,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              widget.item.label,
              style: AppTypography.body(
                color: widget.isLast
                    ? colors.textStrong
                    : _isHovered
                        ? colors.textBase
                        : colors.textWeak,
              ).copyWith(
                decoration: _isHovered && isClickable
                    ? TextDecoration.underline
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
  const BreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
  });

  /// Item label
  final String label;

  /// Optional icon
  final IconData? icon;

  /// Tap callback
  final VoidCallback? onTap;
}
