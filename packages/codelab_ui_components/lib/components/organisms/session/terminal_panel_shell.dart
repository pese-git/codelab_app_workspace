import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../foundations/loaders.dart';
import '../../theme/tokens.dart';

/// A terminal panel shell/wrapper component.
/// The actual terminal implementation uses xterm/flutter_pty
/// which requires platform-specific setup.
class TerminalPanelShell extends fluent.StatelessWidget {
  const TerminalPanelShell({
    required this.child,
    this.title = 'Terminal',
    this.onClose,
    this.onMinimize,
    this.onMaximize,
    super.key,
  });

  /// Terminal view widget
  final fluent.Widget child;

  /// Terminal title
  final String title;

  /// Close callback
  final fluent.VoidCallback? onClose;

  /// Minimize callback
  final fluent.VoidCallback? onMinimize;

  /// Maximize callback
  final fluent.VoidCallback? onMaximize;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      decoration: fluent.BoxDecoration(
        color: colors.backgroundBase,
        border: fluent.Border(top: fluent.BorderSide(color: colors.borderWeak)),
      ),
      child: fluent.Column(
        children: [
          // Header bar
          fluent.Container(
            height: 32,
            padding: const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: fluent.BoxDecoration(
              color: colors.surfaceSubtle,
              border: fluent.Border(bottom: fluent.BorderSide(color: colors.borderWeak)),
            ),
            child: fluent.Row(
              children: [
                fluent.Icon(fluent.FluentIcons.command_prompt, size: 14, color: colors.iconWeak),
                const fluent.SizedBox(width: AppSpacing.sm),
                fluent.Text(title, style: AppTypography.small(color: colors.textBase)),
                const fluent.Spacer(),
                if (onMinimize != null)
                  _TerminalButton(icon: fluent.FluentIcons.chrome_minimize, onTap: onMinimize!),
                if (onMaximize != null)
                  _TerminalButton(icon: fluent.FluentIcons.full_screen, onTap: onMaximize!),
                if (onClose != null)
                  _TerminalButton(icon: fluent.FluentIcons.chrome_close, onTap: onClose!),
              ],
            ),
          ),
          // Terminal content
          fluent.Expanded(child: child),
        ],
      ),
    );
  }
}

class _TerminalButton extends fluent.StatelessWidget {
  const _TerminalButton({required this.icon, required this.onTap});

  final fluent.IconData icon;
  final fluent.VoidCallback onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Padding(
        padding: const fluent.EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: fluent.Icon(icon, size: 14, color: colors.iconWeak),
      ),
    );
  }
}

/// Terminal loading state.
class TerminalLoading extends fluent.StatelessWidget {
  const TerminalLoading({super.key});

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      color: colors.backgroundBase,
      child: fluent.Center(
        child: fluent.Column(
          mainAxisSize: fluent.MainAxisSize.min,
          children: [
            const AppProgressRing(),
            const fluent.SizedBox(height: AppSpacing.md),
            fluent.Text(
              'Starting terminal...',
              style: AppTypography.body(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Terminal error state.
class TerminalError extends fluent.StatelessWidget {
  const TerminalError({required this.error, this.onRetry, super.key});

  final String error;
  final fluent.VoidCallback? onRetry;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      color: colors.backgroundBase,
      padding: const fluent.EdgeInsets.all(AppSpacing.lg),
      child: fluent.Center(
        child: fluent.Column(
          mainAxisSize: fluent.MainAxisSize.min,
          children: [
            fluent.Icon(fluent.FluentIcons.error_badge, size: 32, color: colors.errorBase),
            const fluent.SizedBox(height: AppSpacing.md),
            fluent.Text(
              error,
              style: AppTypography.body(color: colors.errorText),
              textAlign: fluent.TextAlign.center,
            ),
            if (onRetry != null) ...[
              const fluent.SizedBox(height: AppSpacing.lg),
              fluent.Button(onPressed: onRetry, child: const fluent.Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
