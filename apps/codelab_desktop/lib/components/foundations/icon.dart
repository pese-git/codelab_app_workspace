import 'package:fluent_ui/fluent_ui.dart' show FluentIcons;
import 'package:flutter/material.dart';

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
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.size = AppIconSize.md,
    this.color,
    this.semanticLabel,
    super.key,
  });

  /// The icon to display
  final IconData icon;

  /// Size variant
  final AppIconSize size;

  /// Icon color (defaults to iconBase from theme)
  final Color? color;

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
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Icon(
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
  static const IconData home = FluentIcons.home;
  static const IconData back = FluentIcons.chevron_left;
  static const IconData forward = FluentIcons.chevron_right;
  static const IconData menu = FluentIcons.global_nav_button;
  static const IconData close = FluentIcons.chrome_close;
  static const IconData more = FluentIcons.more;

  // Actions
  static const IconData add = FluentIcons.add;
  static const IconData remove = FluentIcons.remove;
  static const IconData edit = FluentIcons.edit;
  static const IconData delete = FluentIcons.delete;
  static const IconData copy = FluentIcons.copy;
  static const IconData paste = FluentIcons.paste;
  static const IconData cut = FluentIcons.cut;
  static const IconData save = FluentIcons.save;
  static const IconData refresh = FluentIcons.refresh;
  static const IconData search = FluentIcons.search;
  static const IconData send = FluentIcons.send;

  // Files & folders
  static const IconData file = FluentIcons.page;
  static const IconData folder = FluentIcons.fabric_folder;
  static const IconData folderOpen = FluentIcons.fabric_open_folder_horizontal;
  static const IconData newFile = FluentIcons.page_add;
  static const IconData newFolder = FluentIcons.new_folder;

  // Git
  static const IconData branch = FluentIcons.branch_fork2;
  static const IconData commit = FluentIcons.git_graph;
  static const IconData merge = FluentIcons.branch_merge;
  static const IconData pull = FluentIcons.branch_pull_request;

  // Status
  static const IconData success = FluentIcons.accept;
  static const IconData warning = FluentIcons.warning;
  static const IconData error = FluentIcons.error_badge;
  static const IconData info = FluentIcons.info;

  // UI
  static const IconData sidePanel = FluentIcons.side_panel;
  static const IconData settings = FluentIcons.settings;
  static const IconData help = FluentIcons.help;
  static const IconData terminal = FluentIcons.command_prompt;
  static const IconData server = FluentIcons.server_processes;

  // Chevrons
  static const IconData chevronUp = FluentIcons.chevron_up;
  static const IconData chevronDown = FluentIcons.chevron_down;
  static const IconData chevronLeft = FluentIcons.chevron_left;
  static const IconData chevronRight = FluentIcons.chevron_right;
  static const IconData chevronLeftSmall = FluentIcons.chevron_left_small;
  static const IconData chevronRightSmall = FluentIcons.chevron_right_small;

  // Expand / collapse
  static const IconData expand = FluentIcons.chevron_down_small;
  static const IconData collapse = FluentIcons.chevron_right_small;
}
