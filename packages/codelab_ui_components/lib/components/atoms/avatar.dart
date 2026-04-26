import 'package:flutter/material.dart';

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
class Avatar extends StatelessWidget {
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
  final IconData? icon;

  /// Avatar size
  final AvatarSize size;

  /// Background color
  final Color? backgroundColor;

  /// Foreground (text/icon) color
  final Color? foregroundColor;

  /// Tap callback
  final VoidCallback? onTap;

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
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final bgColor = backgroundColor ?? colors.surfaceAccent;
    final fgColor = foregroundColor ?? colors.textBase;

    Widget content;

    if (imageUrl != null) {
      content = ClipOval(
        child: Image.network(
          imageUrl!,
          width: _pixelSize,
          height: _pixelSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildFallback(bgColor, fgColor, colors),
        ),
      );
    } else {
      content = _buildFallback(bgColor, fgColor, colors);
    }

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: content),
      );
    }

    return content;
  }

  Widget _buildFallback(Color bgColor, Color fgColor, LightColors colors) {
    return Container(
      width: _pixelSize,
      height: _pixelSize,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: initials != null
          ? Text(
              initials!.toUpperCase().substring(
                0,
                initials!.length.clamp(0, 2),
              ),
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: AppTypography.semiBold,
                color: fgColor,
              ),
            )
          : Icon(icon ?? Icons.person, size: _iconSize, color: fgColor),
    );
  }
}

/// A stack of overlapping avatars.
class AvatarStack extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? AppColors.light
        : AppColors.dark;

    final displayAvatars = avatars.take(maxDisplay).toList();
    final remaining = avatars.length - maxDisplay;

    return SizedBox(
      height: _pixelSize,
      child: Stack(
        children: [
          for (var i = 0; i < displayAvatars.length; i++)
            Positioned(
              left: i * (_pixelSize - overlap),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surfaceBase, width: 2),
                ),
                child: Avatar(
                  imageUrl: displayAvatars[i].imageUrl,
                  initials: displayAvatars[i].initials,
                  size: size,
                ),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: displayAvatars.length * (_pixelSize - overlap),
              child: Container(
                width: _pixelSize,
                height: _pixelSize,
                decoration: BoxDecoration(
                  color: colors.surfaceSubtle,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surfaceBase, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
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
