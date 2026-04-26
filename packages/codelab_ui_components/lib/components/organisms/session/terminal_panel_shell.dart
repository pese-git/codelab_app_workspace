import 'package:flutter/material.dart';

import '../../foundations/loaders.dart';
import '../../theme/tokens.dart';

/// A terminal panel shell/wrapper component.
/// The actual terminal implementation uses xterm/flutter_pty
/// which requires platform-specific setup.
class TerminalPanelShell extends StatelessWidget {
  const TerminalPanelShell({
    required this.child,
    this.title = 'Terminal',
    this.onClose,
    this.onMinimize,
    this.onMaximize,
    super.key,
  });

  /// Terminal view widget
  final Widget child;

  /// Terminal title
  final String title;

  /// Close callback
  final VoidCallback? onClose;

  /// Minimize callback
  final VoidCallback? onMinimize;

  /// Maximize callback
  final VoidCallback? onMaximize;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        border: Border(top: BorderSide(color: colors.borderWeak)),
      ),
      child: Column(
        children: [
          // Header bar
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              border: Border(bottom: BorderSide(color: colors.borderWeak)),
            ),
            child: Row(
              children: [
                Icon(Icons.terminal, size: 14, color: colors.iconWeak),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: AppTypography.small(color: colors.textBase)),
                const Spacer(),
                if (onMinimize != null)
                  _TerminalButton(icon: Icons.minimize, onTap: onMinimize!),
                if (onMaximize != null)
                  _TerminalButton(icon: Icons.crop_square, onTap: onMaximize!),
                if (onClose != null)
                  _TerminalButton(icon: Icons.close, onTap: onClose!),
              ],
            ),
          ),
          // Terminal content
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _TerminalButton extends StatelessWidget {
  const _TerminalButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Icon(icon, size: 14, color: colors.iconWeak),
      ),
    );
  }
}

/// Terminal loading state.
class TerminalLoading extends StatelessWidget {
  const TerminalLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      color: colors.backgroundBase,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppProgressRing(),
            const SizedBox(height: AppSpacing.md),
            Text(
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
class TerminalError extends StatelessWidget {
  const TerminalError({required this.error, this.onRetry, super.key});

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return Container(
      color: colors.backgroundBase,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 32, color: colors.errorBase),
            const SizedBox(height: AppSpacing.md),
            Text(
              error,
              style: AppTypography.body(color: colors.errorText),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
