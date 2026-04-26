import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../../atoms/icon_button.dart';
import '../../theme/tokens.dart';

/// Session header component with title and actions.
class SessionHeader extends StatelessWidget {
  const SessionHeader({
    required this.title,
    this.subtitle,
    this.branchName,
    this.onBack,
    this.onFork,
    this.onShare,
    this.onMore,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? branchName;
  final VoidCallback? onBack;
  final VoidCallback? onFork;
  final VoidCallback? onShare;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        border: Border(bottom: BorderSide(color: colors.borderWeak)),
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            AppIconButton(
              icon: fluent.FluentIcons.chevron_left,
              onPressed: onBack,
              size: IconButtonSize.sm,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle(color: colors.textStrong),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null || branchName != null)
                  Row(
                    children: [
                      if (branchName != null) ...[
                        Icon(
                          fluent.FluentIcons.branch_fork2,
                          size: 12,
                          color: colors.iconMuted,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          branchName!,
                          style: AppTypography.caption(color: colors.textMuted),
                        ),
                      ],
                      if (branchName != null && subtitle != null)
                        Text(
                          ' • ',
                          style: AppTypography.caption(color: colors.textMuted),
                        ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: AppTypography.caption(color: colors.textMuted),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          if (onFork != null)
            AppIconButton(
              icon: fluent.FluentIcons.branch_fork,
              onPressed: onFork,
              tooltip: 'Fork session',
              size: IconButtonSize.sm,
            ),
          if (onShare != null)
            AppIconButton(
              icon: fluent.FluentIcons.share,
              onPressed: onShare,
              tooltip: 'Share',
              size: IconButtonSize.sm,
            ),
          if (onMore != null)
            AppIconButton(
              icon: fluent.FluentIcons.more,
              onPressed: onMore,
              tooltip: 'More options',
              size: IconButtonSize.sm,
            ),
        ],
      ),
    );
  }
}
