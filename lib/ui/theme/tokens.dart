import 'package:flutter/widgets.dart';

/// Design tokens for the Media Journal app.
///
/// The chrome is deliberately monochrome — warm paper and ink — so nothing
/// competes with the cover art. Per-media accent colors live elsewhere
/// (see media_palette.dart) and only appear on detail surfaces.

/// Neutral chrome palette.
abstract final class AppColors {
  /// Warm paper — the primary app background.
  static const paper = Color(0xFFFAF8F4);

  /// Pure white — cards, sheets, inputs lifted just off the paper.
  static const surface = Color(0xFFFFFFFF);

  /// Near-black warm ink — primary text and neutral interactive elements.
  static const ink = Color(0xFF1B1A17);

  /// Secondary text.
  static const inkSoft = Color(0xFF6F6B63);

  /// Tertiary text / disabled.
  static const inkFaint = Color(0xFF9A958C);

  /// Hairline dividers.
  static const line = Color(0xFFECE7DE);

  /// Subtle fills — chips, placeholders, hover.
  static const fill = Color(0xFFF3EFE8);

  /// Destructive.
  static const danger = Color(0xFFB23B2E);
}

/// Spacing scale (4-based).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double huge = 64;
}

/// Corner radii.
abstract final class AppRadii {
  static const double cover = 10; // poster / book cover
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 22; // sheets, dialogs, large surfaces
  static const double pill = 999;
}

/// Animation durations.
abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 260);
  static const slow = Duration(milliseconds: 420);
}

/// Standard easing.
const Curve appEase = Curves.easeOutCubic;

/// Max content width for comfortable reading on wide desktop windows.
const double kContentMaxWidth = 1120;
const double kReadingMaxWidth = 680;
