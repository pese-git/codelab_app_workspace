import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// An option list for selection.
class OptionList<T> extends StatelessWidget {
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
  final ValueChanged<T> onSelect;

  /// Allow multiple selection
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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

class _OptionRow<T> extends StatefulWidget {
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
  final VoidCallback onTap;

  @override
  State<_OptionRow<T>> createState() => _OptionRowState<T>();
}

class _OptionRowState<T> extends State<_OptionRow<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final isDisabled = widget.option.isDisabled;

    return GestureDetector(
      onTap: isDisabled ? null : widget.onTap,
      child: MouseRegion(
        cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colors.surfaceSelected
                : _isHovered
                    ? colors.surfaceHover
                    : Colors.transparent,
            borderRadius: AppRadius.smAll,
          ),
          child: Row(
            children: [
              if (widget.showCheckbox) ...[
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? colors.accentPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: widget.isSelected
                          ? colors.accentPrimary
                          : colors.borderStrong,
                    ),
                  ),
                  child: widget.isSelected
                      ? Icon(Icons.check, size: 14, color: colors.iconOnAccent)
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              if (widget.option.icon != null) ...[
                Icon(
                  widget.option.icon,
                  size: 16,
                  color: isDisabled ? colors.iconMuted : colors.iconBase,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.option.label,
                      style: AppTypography.body(
                        color: isDisabled ? colors.textMuted : colors.textBase,
                      ),
                    ),
                    if (widget.option.description != null)
                      Text(
                        widget.option.description!,
                        style: AppTypography.caption(color: colors.textWeak),
                      ),
                  ],
                ),
              ),
              if (!widget.showCheckbox && widget.isSelected)
                Icon(Icons.check, size: 16, color: colors.accentPrimary),
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
  final IconData? icon;
  final bool isDisabled;
}
