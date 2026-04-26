import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// Icon size variants.
enum AppIconSize {
  /// 16px
  sm,

  /// 20px
  md,

  /// 24px
  lg,

  /// 28px
  xl,
}

/// A themed icon widget with standardized sizes.
class AppIcon extends fluent.StatelessWidget {
  const AppIcon(
    this.icon, {
    this.size = AppIconSize.md,
    this.color,
    this.semanticLabel,
    super.key,
  });

  /// The icon to display
  final fluent.IconData icon;

  /// Size variant
  final AppIconSize size;

  /// Icon color (defaults to iconBase from theme)
  final fluent.Color? color;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Small icon (16px)
  const AppIcon.sm(this.icon, {this.color, this.semanticLabel, super.key})
      : size = AppIconSize.sm;

  /// Medium icon (20px) - default
  const AppIcon.md(this.icon, {this.color, this.semanticLabel, super.key})
      : size = AppIconSize.md;

  /// Large icon (24px)
  const AppIcon.lg(this.icon, {this.color, this.semanticLabel, super.key})
      : size = AppIconSize.lg;

  /// Extra large icon (28px)
  const AppIcon.xl(this.icon, {this.color, this.semanticLabel, super.key})
      : size = AppIconSize.xl;

  double get _pixelSize {
    switch (size) {
      case AppIconSize.sm:
        return AppDimensions.iconSizeSm;
      case AppIconSize.md:
        return AppDimensions.iconSizeMd;
      case AppIconSize.lg:
        return AppDimensions.iconSizeLg;
      case AppIconSize.xl:
        return AppDimensions.iconSizeXl;
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Icon(
      icon,
      size: _pixelSize,
      color: color ?? colors.iconBase,
      semanticLabel: semanticLabel,
    );
  }
}

/// Common app icons using FluentIcons.
abstract final class AppIcons {
  // Navigation
  static const fluent.IconData home = fluent.FluentIcons.home;
  static const fluent.IconData back = fluent.FluentIcons.chevron_left;
  static const fluent.IconData forward = fluent.FluentIcons.chevron_right;
  static const fluent.IconData menu = fluent.FluentIcons.global_nav_button;
  static const fluent.IconData close = fluent.FluentIcons.chrome_close;
  static const fluent.IconData more = fluent.FluentIcons.more;

  // Actions
  static const fluent.IconData add = fluent.FluentIcons.add;
  static const fluent.IconData remove = fluent.FluentIcons.remove;
  static const fluent.IconData edit = fluent.FluentIcons.edit;
  static const fluent.IconData delete = fluent.FluentIcons.delete;
  static const fluent.IconData copy = fluent.FluentIcons.copy;
  static const fluent.IconData paste = fluent.FluentIcons.paste;
  static const fluent.IconData cut = fluent.FluentIcons.cut;
  static const fluent.IconData save = fluent.FluentIcons.save;
  static const fluent.IconData refresh = fluent.FluentIcons.refresh;
  static const fluent.IconData search = fluent.FluentIcons.search;
  static const fluent.IconData send = fluent.FluentIcons.send;

  // Files & folders
  static const fluent.IconData file = fluent.FluentIcons.page;
  static const fluent.IconData folder = fluent.FluentIcons.fabric_folder;
  static const fluent.IconData folderOpen =
      fluent.FluentIcons.fabric_open_folder_horizontal;
  static const fluent.IconData newFile = fluent.FluentIcons.page_add;
  static const fluent.IconData newFolder = fluent.FluentIcons.new_folder;

  // Git
  static const fluent.IconData branch = fluent.FluentIcons.branch_fork2;
  static const fluent.IconData commit = fluent.FluentIcons.git_graph;
  static const fluent.IconData merge = fluent.FluentIcons.branch_merge;
  static const fluent.IconData pull = fluent.FluentIcons.branch_pull_request;

  // Status
  static const fluent.IconData success = fluent.FluentIcons.accept;
  static const fluent.IconData warning = fluent.FluentIcons.warning;
  static const fluent.IconData error = fluent.FluentIcons.error_badge;
  static const fluent.IconData info = fluent.FluentIcons.info;

  // UI
  static const fluent.IconData sidePanel = fluent.FluentIcons.side_panel;
  static const fluent.IconData settings = fluent.FluentIcons.settings;
  static const fluent.IconData help = fluent.FluentIcons.help;
  static const fluent.IconData terminal = fluent.FluentIcons.command_prompt;
  static const fluent.IconData server = fluent.FluentIcons.server_processes;

  // Chevrons
  static const fluent.IconData chevronUp = fluent.FluentIcons.chevron_up;
  static const fluent.IconData chevronDown = fluent.FluentIcons.chevron_down;
  static const fluent.IconData chevronLeft = fluent.FluentIcons.chevron_left;
  static const fluent.IconData chevronRight = fluent.FluentIcons.chevron_right;
  static const fluent.IconData chevronLeftSmall =
      fluent.FluentIcons.chevron_left_small;
  static const fluent.IconData chevronRightSmall =
      fluent.FluentIcons.chevron_right_small;

  // Expand / collapse
  static const fluent.IconData expand = fluent.FluentIcons.chevron_down_small;
  static const fluent.IconData collapse =
      fluent.FluentIcons.chevron_right_small;
}
