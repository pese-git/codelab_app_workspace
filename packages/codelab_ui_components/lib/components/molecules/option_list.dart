import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// An option list for selection.
class OptionList<T> extends fluent.StatelessWidget {
  const OptionList({
    required this.options,
    required this.selected,
    required this.onSelect,
    this.multiSelect = false,
    super.key,
  });

  /// Available options
  final List<OptionItem<T>> options;

  /// Selected value(s)
  final Set<T> selected;

  /// Selection callback
  final fluent.ValueChanged<T> onSelect;

  /// Allow multiple selection
  final bool multiSelect;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return fluent.Column(
      mainAxisSize: fluent.MainAxisSize.min,
      children: options.map((option) {
        final isSelected = selected.contains(option.value);
        return _OptionRow(
          option: option,
          isSelected: isSelected,
          showCheckbox: multiSelect,
          onTap: () => onSelect(option.value),
        );
      }).toList(),
    );
  }
}

class _OptionRow<T> extends fluent.StatefulWidget {
  const _OptionRow({
    required this.option,
    required this.isSelected,
    required this.showCheckbox,
    required this.onTap,
    super.key,
  });

  final OptionItem<T> option;
  final bool isSelected;
  final bool showCheckbox;
  final fluent.VoidCallback onTap;

  @override
  fluent.State<_OptionRow<T>> createState() => _OptionRowState<T>();
}

class _OptionRowState<T> extends fluent.State<_OptionRow<T>> {
  bool _isHovered = false;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;
    final isDisabled = widget.option.isDisabled;

    return fluent.GestureDetector(
      onTap: isDisabled ? null : widget.onTap,
      child: fluent.MouseRegion(
        cursor: isDisabled
            ? fluent.SystemMouseCursors.basic
            : fluent.SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: fluent.AnimatedContainer(
          duration: AppDurations.fast,
          padding: const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: fluent.BoxDecoration(
            color: widget.isSelected
                ? colors.surfaceSelected
                : _isHovered
                ? colors.surfaceHover
                : fluent.Colors.transparent,
            borderRadius: AppRadius.smAll,
          ),
          child: fluent.Row(
            children: [
              if (widget.showCheckbox) ...[
                fluent.Container(
                  width: 18,
                  height: 18,
                  decoration: fluent.BoxDecoration(
                    color: widget.isSelected
                        ? colors.accentPrimary
                        : fluent.Colors.transparent,
                    borderRadius: fluent.BorderRadius.circular(4),
                    border: fluent.Border.all(
                      color: widget.isSelected
                          ? colors.accentPrimary
                          : colors.borderStrong,
                    ),
                  ),
                  child: widget.isSelected
                      ? fluent.Icon(fluent.FluentIcons.check_mark, size: 14, color: colors.iconOnAccent)
                      : null,
                ),
                const fluent.SizedBox(width: AppSpacing.md),
              ],
              if (widget.option.icon != null) ...[
                fluent.Icon(
                  widget.option.icon,
                  size: 16,
                  color: isDisabled ? colors.iconMuted : colors.iconBase,
                ),
                const fluent.SizedBox(width: AppSpacing.md),
              ],
              fluent.Expanded(
                child: fluent.Column(
                  crossAxisAlignment: fluent.CrossAxisAlignment.start,
                  children: [
                    fluent.Text(
                      widget.option.label,
                      style: AppTypography.body(
                        color: isDisabled ? colors.textMuted : colors.textBase,
                      ),
                    ),
                    if (widget.option.description != null)
                      fluent.Text(
                        widget.option.description!,
                        style: AppTypography.caption(color: colors.textWeak),
                      ),
                  ],
                ),
              ),
              if (!widget.showCheckbox && widget.isSelected)
                fluent.Icon(fluent.FluentIcons.check_mark, size: 16, color: colors.accentPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

/// An option item.
class OptionItem<T> {
  const OptionItem({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.isDisabled = false,
  });

  final T value;
  final String label;
  final String? description;
  final fluent.IconData? icon;
  final bool isDisabled;
}
