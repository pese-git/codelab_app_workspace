import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../atoms/icon_button.dart';
import '../theme/tokens.dart';

/// A toolbar component.
class Toolbar extends fluent.StatelessWidget {
  const Toolbar({
    required this.items,
    this.padding,
    this.spacing = AppSpacing.xs,
    this.backgroundColor,
    this.borderColor,
    super.key,
  });

  /// Toolbar items
  final List<ToolbarItem> items;

  /// Toolbar padding
  final fluent.EdgeInsetsGeometry? padding;

  /// Spacing between items
  final double spacing;

  /// Background color
  final fluent.Color? backgroundColor;

  /// Border color
  final fluent.Color? borderColor;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      padding:
          padding ??
          const fluent.EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
      decoration: fluent.BoxDecoration(
        color: backgroundColor ?? colors.surfaceBase,
        border: borderColor != null
            ? fluent.Border(bottom: fluent.BorderSide(color: borderColor!))
            : null,
      ),
      child: fluent.Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (items[i] is ToolbarDivider)
              _buildDivider(colors)
            else if (items[i] is ToolbarSpacer)
              const fluent.Spacer()
            else if (items[i] is ToolbarButton)
              _buildButton(items[i] as ToolbarButton)
            else if (items[i] is ToolbarWidget)
              (items[i] as ToolbarWidget).child,
            if (i < items.length - 1 && items[i] is! ToolbarSpacer)
              fluent.SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }

  fluent.Widget _buildButton(ToolbarButton item) {
    return AppIconButton(
      icon: item.icon,
      onPressed: item.onPressed,
      tooltip: item.tooltip,
      size: IconButtonSize.sm,
      isDisabled: item.isDisabled,
    );
  }

  fluent.Widget _buildDivider(LightColors colors) {
    return fluent.Container(
      width: 1,
      height: 20,
      margin: const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      color: colors.borderWeak,
    );
  }
}

/// Base class for toolbar items.
abstract class ToolbarItem {
  const ToolbarItem();
}

/// A toolbar button item.
class ToolbarButton extends ToolbarItem {
  const ToolbarButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isDisabled = false,
  });

  final fluent.IconData icon;
  final fluent.VoidCallback? onPressed;
  final String? tooltip;
  final bool isDisabled;
}

/// A toolbar divider.
class ToolbarDivider extends ToolbarItem {
  const ToolbarDivider();
}

/// A flexible spacer in the toolbar.
class ToolbarSpacer extends ToolbarItem {
  const ToolbarSpacer();
}

/// A custom widget in the toolbar.
class ToolbarWidget extends ToolbarItem {
  const ToolbarWidget({required this.child});

  final fluent.Widget child;
}
