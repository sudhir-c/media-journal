import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'tokens.dart';

/// Two complementary accent colors extracted from a cover, plus derived
/// readable companions, giving each detail page its own atmosphere.
class MediaPalette {
  const MediaPalette({
    required this.primary,
    required this.secondary,
    required this.onPrimary,
    required this.tint,
    required this.washTop,
    required this.washBottom,
  });

  /// Dominant, tamed accent — buttons, rating, section accents.
  final Color primary;

  /// Complementary accent — secondary chips, gradients.
  final Color secondary;

  /// Readable foreground on [primary].
  final Color onPrimary;

  /// Soft fill for chips / subtle surfaces.
  final Color tint;

  /// Ambient header wash (top → bottom).
  final Color washTop;
  final Color washBottom;

  /// Refined neutral fallback for entries without usable cover art.
  static const neutral = MediaPalette(
    primary: AppColors.ink,
    secondary: AppColors.inkSoft,
    onPrimary: AppColors.paper,
    tint: AppColors.fill,
    washTop: Color(0xFFF1ECE3),
    washBottom: AppColors.paper,
  );

  /// Build a palette from already-extracted [primary]/[secondary] seeds.
  factory MediaPalette.fromSeeds(Color primary, Color secondary) {
    final tamedPrimary = _tame(primary, minL: 0.26, maxL: 0.5, minS: 0.25);
    final tamedSecondary = _tame(secondary, minL: 0.3, maxL: 0.6, minS: 0.2);
    final hslTint = HSLColor.fromColor(tamedPrimary);
    return MediaPalette(
      primary: tamedPrimary,
      secondary: tamedSecondary,
      onPrimary: tamedPrimary.computeLuminance() < 0.5
          ? AppColors.paper
          : AppColors.ink,
      tint: hslTint.withSaturation((hslTint.saturation * 0.6).clamp(0, 0.5))
          .withLightness(0.9)
          .toColor(),
      // Bolder ambient wash — more saturated, deeper than before.
      washTop: hslTint
          .withSaturation((hslTint.saturation * 0.95).clamp(0.3, 0.9))
          .withLightness(0.78)
          .toColor(),
      washBottom: AppColors.paper,
    );
  }
}

/// Clamp a color's saturation/lightness into a tasteful, readable band so
/// accents stay elegant rather than garish.
Color _tame(Color c, {required double minL, required double maxL, double minS = 0.2}) {
  var hsl = HSLColor.fromColor(c);
  hsl = hsl.withSaturation(hsl.saturation.clamp(minS, 0.82));
  hsl = hsl.withLightness(hsl.lightness.clamp(minL, maxL));
  return hsl.toColor();
}

double _distance(Color a, Color b) {
  final ha = HSLColor.fromColor(a);
  final hb = HSLColor.fromColor(b);
  final dh = (ha.hue - hb.hue).abs();
  return dh + (ha.lightness - hb.lightness).abs() * 60;
}

/// Extracts a [MediaPalette] from a cover image, choosing visually dominant,
/// pleasing swatches. Returns [MediaPalette.neutral] when no image or on error.
Future<MediaPalette> extractMediaPalette(ImageProvider? image) async {
  if (image == null) return MediaPalette.neutral;
  try {
    final gen = await PaletteGenerator.fromImageProvider(
      image,
      maximumColorCount: 16,
      size: const Size(180, 270),
    );

    Color? pick(PaletteColor? p) => p?.color;

    final primary = pick(gen.darkVibrantColor) ??
        pick(gen.vibrantColor) ??
        pick(gen.darkMutedColor) ??
        pick(gen.dominantColor);

    if (primary == null) return MediaPalette.neutral;

    // Choose a secondary that's visually distinct from the primary.
    final candidates = [
      gen.vibrantColor,
      gen.lightVibrantColor,
      gen.mutedColor,
      gen.lightMutedColor,
      gen.dominantColor,
    ].whereType<PaletteColor>().map((p) => p.color).toList();

    Color secondary = primary;
    double best = -1;
    for (final c in candidates) {
      final d = _distance(primary, c);
      if (d > best) {
        best = d;
        secondary = c;
      }
    }

    return MediaPalette.fromSeeds(primary, secondary);
  } catch (_) {
    return MediaPalette.neutral;
  }
}
