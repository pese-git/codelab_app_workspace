import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// A tab bar component.
class AppTabs<T> extends fluent.StatelessWidget {
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
  final fluent.ValueChanged<T> onChanged;

  /// Whether tabs are scrollable
  final bool isScrollable;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final tabWidgets = tabs.entries.map((entry) {
      final isSelected = entry.key == selected;
      return _TabButton(
        label: entry.value,
        isSelected: isSelected,
        onTap: () => onChanged(entry.key),
      );
    }).toList();

    if (isScrollable) {
      return fluent.SingleChildScrollView(
        scrollDirection: fluent.Axis.horizontal,
        child: fluent.Row(children: tabWidgets),
      );
    }

    return fluent.Container(
      decoration: fluent.BoxDecoration(
        border: fluent.Border(bottom: fluent.BorderSide(color: colors.borderWeak)),
      ),
      child: fluent.Row(children: tabWidgets),
    );
  }
}

class _TabButton extends fluent.StatefulWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final fluent.VoidCallback onTap;

  @override
  fluent.State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends fluent.State<_TabButton> {
  bool _isHovered = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: widget.onTap,
      child: fluent.MouseRegion(
        cursor: fluent.SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: fluent.Container(
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: fluent.BoxDecoration(
            border: fluent.Border(
              bottom: fluent.BorderSide(
                color: widget.isSelected
                    ? colors.accentPrimary
                    : fluent.Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: fluent.Text(
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
class CloseableTab extends fluent.StatefulWidget {
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
  final fluent.VoidCallback onSelect;
  final fluent.VoidCallback onClose;
  final fluent.IconData? icon;

  @override
  fluent.State<CloseableTab> createState() => _CloseableTabState();
}

class _CloseableTabState extends fluent.State<CloseableTab> {
  bool _isHovered = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: widget.onSelect,
      child: fluent.MouseRegion(
        cursor: fluent.SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: fluent.Container(
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: fluent.BoxDecoration(
            color: widget.isSelected ? colors.surfaceBase : fluent.Colors.transparent,
            border: fluent.Border(
              bottom: fluent.BorderSide(
                color: widget.isSelected
                    ? colors.accentPrimary
                    : fluent.Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: fluent.Row(
            mainAxisSize: fluent.MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                fluent.Icon(widget.icon, size: 14, color: colors.iconWeak),
                const fluent.SizedBox(width: AppSpacing.sm),
              ],
              fluent.Text(
                widget.label,
                style: AppTypography.small(
                  color: widget.isSelected
                      ? colors.textStrong
                      : colors.textWeak,
                ),
              ),
              if (_isHovered || widget.isSelected) ...[
                const fluent.SizedBox(width: AppSpacing.sm),
                fluent.GestureDetector(
                  onTap: widget.onClose,
                  child: fluent.Icon(fluent.FluentIcons.chrome_close, size: 14, color: colors.iconWeak),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
