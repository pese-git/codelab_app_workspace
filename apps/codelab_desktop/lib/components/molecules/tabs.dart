import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A tab bar component.
class AppTabs<T> extends StatelessWidget {
  const AppTabs({
    required this.tabs,
    required this.selected,
    required this.onChanged,
    this.isScrollable = false,
    super.key,
  });

  /// Map of tab values to labels
  final Map<T, String> tabs;

  /// Currently selected tab
  final T selected;

  /// Tab change callback
  final ValueChanged<T> onChanged;

  /// Whether tabs are scrollable
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    final tabWidgets = tabs.entries.map((entry) {
      final isSelected = entry.key == selected;
      return _TabButton(
        label: entry.value,
        isSelected: isSelected,
        onTap: () => onChanged(entry.key),
      );
    }).toList();

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tabWidgets),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderWeak),
        ),
      ),
      child: Row(children: tabWidgets),
    );
  }
}

class _TabButton extends StatefulWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected ? colors.accentPrimary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: AppTypography.bodyMedium(
              color: widget.isSelected
                  ? colors.textStrong
                  : _isHovered
                      ? colors.textBase
                      : colors.textWeak,
            ),
          ),
        ),
      ),
    );
  }
}

/// A closeable tab component.
class CloseableTab extends StatefulWidget {
  const CloseableTab({
    required this.label,
    required this.isSelected,
    required this.onSelect,
    required this.onClose,
    this.icon,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onClose;
  final IconData? icon;

  @override
  State<CloseableTab> createState() => _CloseableTabState();
}

class _CloseableTabState extends State<CloseableTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: widget.onSelect,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected ? colors.surfaceBase : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected ? colors.accentPrimary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 14, color: colors.iconWeak),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                widget.label,
                style: AppTypography.small(
                  color: widget.isSelected ? colors.textStrong : colors.textWeak,
                ),
              ),
              if (_isHovered || widget.isSelected) ...[
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: colors.iconWeak,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
