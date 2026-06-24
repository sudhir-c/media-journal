import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Cover image with graceful fallbacks: a quiet paper placeholder when there's
/// no URL, and the same placeholder if the image fails to load.
class CoverImage extends StatelessWidget {
  const CoverImage({super.key, required this.url, this.iconSize = 28});

  final String? url;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AppColors.fill,
      child: Center(
        child: Icon(
          Icons.menu_book_outlined,
          size: iconSize,
          color: AppColors.inkFaint,
        ),
      ),
    );

    if (url == null || url!.isEmpty) return placeholder;

    return Image.network(
      url!,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => placeholder,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(color: AppColors.fill);
      },
    );
  }
}

/// Frames a cover like an object on a shelf: rounded corners and a soft,
/// realistic drop shadow. The hero of every browsing surface.
class PosterFrame extends StatelessWidget {
  const PosterFrame({
    super.key,
    required this.url,
    this.aspectRatio = 2 / 3,
    this.radius = AppRadii.cover,
    this.elevated = true,
    this.heroTag,
    this.fill = false,
  });

  final String? url;
  final double aspectRatio;
  final double radius;
  final bool elevated;
  final Object? heroTag;

  /// When true, fills the available height instead of imposing [aspectRatio]
  /// (used inside flexible grid cells).
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final inner = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: AppColors.fill,
          boxShadow: elevated
              ? const [
                  BoxShadow(
                    color: Color(0x1A1B1A17),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                    spreadRadius: -6,
                  ),
                  BoxShadow(
                    color: Color(0x0F1B1A17),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CoverImage(url: url),
        ),
      );

    Widget frame = fill
        ? inner
        : AspectRatio(aspectRatio: aspectRatio, child: inner);
    if (heroTag != null) {
      frame = Hero(tag: heroTag!, child: frame);
    }
    return frame;
  }
}
