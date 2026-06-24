import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// Editorial type system.
///
/// Fraunces (a soft optical serif) carries titles, numerics, and — importantly
/// — long journal reflections, so reading an entry feels like reading a book.
/// Inter is the utility face for uppercase micro-labels, metadata, and buttons.
abstract final class AppText {
  static TextStyle display(BuildContext _) => GoogleFonts.fraunces(
    fontSize: 40,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.ink,
  );

  static TextStyle title(BuildContext _) => GoogleFonts.fraunces(
    fontSize: 28,
    height: 1.1,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.ink,
  );

  static TextStyle headline(BuildContext _) => GoogleFonts.fraunces(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );

  static TextStyle cardTitle(BuildContext _) => GoogleFonts.fraunces(
    fontSize: 15.5,
    height: 1.18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: AppColors.ink,
  );

  /// Uppercase micro-label. Caller supplies already-uppercased text.
  static TextStyle eyebrow(BuildContext _, {Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: color ?? AppColors.inkFaint,
  );

  static TextStyle body(BuildContext _, {Color? color}) => GoogleFonts.inter(
    fontSize: 14.5,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.ink,
  );

  /// Long-form reading face for journal reflections.
  static TextStyle reading(BuildContext _, {Color? color}) =>
      GoogleFonts.fraunces(
        fontSize: 17,
        height: 1.65,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: color ?? AppColors.ink,
      );

  static TextStyle meta(BuildContext _, {Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.inkSoft,
  );

  static TextStyle label(BuildContext _, {Color? color}) => GoogleFonts.inter(
    fontSize: 13.5,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.ink,
  );

  /// Large tabular numeric (overall score).
  static TextStyle numeral(BuildContext _, {Color? color}) =>
      GoogleFonts.fraunces(
        fontSize: 44,
        height: 1.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? AppColors.ink,
      );
}
