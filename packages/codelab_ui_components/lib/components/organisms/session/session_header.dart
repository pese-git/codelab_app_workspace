import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../atoms/icon_button.dart';
import '../../theme/tokens.dart';

/// Session header component with title and actions.
class SessionHeader extends fluent.StatelessWidget {
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
  final fluent.VoidCallback? onBack;
  final fluent.VoidCallback? onFork;
  final fluent.VoidCallback? onShare;
  final fluent.VoidCallback? onMore;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      height: 64,
      padding: const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: fluent.BoxDecoration(
        color: colors.surfaceBase,
        border: fluent.Border(bottom: fluent.BorderSide(color: colors.borderWeak)),
      ),
      child: fluent.Row(
        children: [
          if (onBack != null) ...[
            AppIconButton(
              icon: fluent.FluentIcons.chevron_left,
              onPressed: onBack,
              size: IconButtonSize.sm,
            ),
            const fluent.SizedBox(width: AppSpacing.md),
          ],
          fluent.Expanded(
            child: fluent.Column(
              crossAxisAlignment: fluent.CrossAxisAlignment.start,
              mainAxisAlignment: fluent.MainAxisAlignment.center,
              children: [
                fluent.Text(
                  title,
                  style: AppTypography.subtitle(color: colors.textStrong),
                  maxLines: 1,
                  overflow: fluent.TextOverflow.ellipsis,
                ),
                if (subtitle != null || branchName != null)
                  fluent.Row(
                    children: [
                      if (branchName != null) ...[
                        fluent.Icon(
                          fluent.FluentIcons.branch_fork2,
                          size: 12,
                          color: colors.iconMuted,
                        ),
                        const fluent.SizedBox(width: AppSpacing.xs),
                        fluent.Text(
                          branchName!,
                          style: AppTypography.caption(color: colors.textMuted),
                        ),
                      ],
                      if (branchName != null && subtitle != null)
                        fluent.Text(
                          ' • ',
                          style: AppTypography.caption(color: colors.textMuted),
                        ),
                      if (subtitle != null)
                        fluent.Text(
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
