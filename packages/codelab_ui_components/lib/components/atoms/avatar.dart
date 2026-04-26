import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../theme/tokens.dart';

/// Avatar size variants.
enum AvatarSize {
  /// 24px
  sm,

  /// 32px (default)
  md,

  /// 40px
  lg,
}

/// An avatar component for user/entity representation.
class Avatar extends fluent.StatelessWidget {
  const Avatar({
    this.imageUrl,
    this.initials,
    this.icon,
    this.size = AvatarSize.md,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    super.key,
  });

  /// Image URL for avatar
  final String? imageUrl;

  /// Initials to display when no image
  final String? initials;

  /// Icon to display when no image or initials
  final fluent.IconData? icon;

  /// Avatar size
  final AvatarSize size;

  /// Background color
  final fluent.Color? backgroundColor;

  /// Foreground (text/icon) color
  final fluent.Color? foregroundColor;

  /// Tap callback
  final fluent.VoidCallback? onTap;

  double get _pixelSize {
    switch (size) {
      case AvatarSize.sm:
        return AppDimensions.avatarSizeSm;
      case AvatarSize.md:
        return AppDimensions.avatarSizeMd;
      case AvatarSize.lg:
        return AppDimensions.avatarSizeLg;
    }
  }

  double get _fontSize {
    switch (size) {
      case AvatarSize.sm:
        return 10;
      case AvatarSize.md:
        return 12;
      case AvatarSize.lg:
        return 14;
    }
  }

  double get _iconSize {
    switch (size) {
      case AvatarSize.sm:
        return 14;
      case AvatarSize.md:
        return 16;
      case AvatarSize.lg:
        return 20;
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final bgColor = backgroundColor ?? colors.surfaceAccent;
    final fgColor = foregroundColor ?? colors.textBase;

    fluent.Widget content;

    if (imageUrl != null) {
      content = fluent.ClipOval(
        child: fluent.Image.network(
          imageUrl!,
          width: _pixelSize,
          height: _pixelSize,
          fit: fluent.BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildFallback(bgColor, fgColor, colors),
        ),
      );
    } else {
      content = _buildFallback(bgColor, fgColor, colors);
    }

    if (onTap != null) {
      content = fluent.GestureDetector(
        onTap: onTap,
        child: fluent.MouseRegion(
          cursor: fluent.SystemMouseCursors.click,
          child: content,
        ),
      );
    }

    return content;
  }

  fluent.Widget _buildFallback(
    fluent.Color bgColor,
    fluent.Color fgColor,
    LightColors colors,
  ) {
    return fluent.Container(
      width: _pixelSize,
      height: _pixelSize,
      decoration: fluent.BoxDecoration(
        color: bgColor,
        shape: fluent.BoxShape.circle,
      ),
      alignment: fluent.Alignment.center,
      child: initials != null
          ? fluent.Text(
              initials!.toUpperCase().substring(
                0,
                initials!.length.clamp(0, 2),
              ),
              style: fluent.TextStyle(
                fontSize: _fontSize,
                fontWeight: AppTypography.semiBold,
                color: fgColor,
              ),
            )
          : fluent.Icon(
              icon ?? fluent.FluentIcons.contact,
              size: _iconSize,
              color: fgColor,
            ),
    );
  }
}

/// A stack of overlapping avatars.
class AvatarStack extends fluent.StatelessWidget {
  const AvatarStack({
    required this.avatars,
    this.maxDisplay = 3,
    this.size = AvatarSize.md,
    this.overlap = 8,
    super.key,
  });

  /// List of avatar data (imageUrl, initials, or null)
  final List<AvatarData> avatars;

  /// Maximum avatars to display
  final int maxDisplay;

  /// Avatar size
  final AvatarSize size;

  /// Overlap amount in pixels
  final double overlap;

  double get _pixelSize {
    switch (size) {
      case AvatarSize.sm:
        return AppDimensions.avatarSizeSm;
      case AvatarSize.md:
        return AppDimensions.avatarSizeMd;
      case AvatarSize.lg:
        return AppDimensions.avatarSizeLg;
    }
  }

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final displayAvatars = avatars.take(maxDisplay).toList();
    final remaining = avatars.length - maxDisplay;

    return fluent.SizedBox(
      height: _pixelSize,
      child: fluent.Stack(
        children: [
          for (var i = 0; i < displayAvatars.length; i++)
            fluent.Positioned(
              left: i * (_pixelSize - overlap),
              child: fluent.Container(
                decoration: fluent.BoxDecoration(
                  shape: fluent.BoxShape.circle,
                  border: fluent.Border.all(
                    color: colors.surfaceBase,
                    width: 2,
                  ),
                ),
                child: Avatar(
                  imageUrl: displayAvatars[i].imageUrl,
                  initials: displayAvatars[i].initials,
                  size: size,
                ),
              ),
            ),
          if (remaining > 0)
            fluent.Positioned(
              left: displayAvatars.length * (_pixelSize - overlap),
              child: fluent.Container(
                width: _pixelSize,
                height: _pixelSize,
                decoration: fluent.BoxDecoration(
                  color: colors.surfaceSubtle,
                  shape: fluent.BoxShape.circle,
                  border: fluent.Border.all(
                    color: colors.surfaceBase,
                    width: 2,
                  ),
                ),
                alignment: fluent.Alignment.center,
                child: fluent.Text(
                  '+$remaining',
                  style: AppTypography.caption(color: colors.textMuted),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Data for an avatar in a stack.
class AvatarData {
  const AvatarData({this.imageUrl, this.initials});

  final String? imageUrl;
  final String? initials;
}
