import 'package:flutter/material.dart';

import '../theme/app_text.dart';
import '../theme/tokens.dart';

/// Uppercase editorial micro-label used to head sections.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppText.eyebrow(context, color: color));
  }
}

/// A restrained metadata pill. Neutral by default; pass [background]/[foreground]
/// to tint it with a media accent.
class AppChip extends StatelessWidget {
  const AppChip(
    this.label, {
    super.key,
    this.background,
    this.foreground,
    this.icon,
  });

  final String label;
  final Color? background;
  final Color? foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? AppColors.inkSoft;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: icon != null ? 10 : 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background ?? AppColors.fill,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppText.eyebrow(context, color: fg).copyWith(letterSpacing: 0.6),
          ),
        ],
      ),
    );
  }
}

/// Small overall-score badge for browsing surfaces.
class ScoreBadge extends StatelessWidget {
  const ScoreBadge(this.score, {super.key});

  final double? score;

  @override
  Widget build(BuildContext context) {
    if (score == null) return const SizedBox.shrink();
    return Text(
      score!.toStringAsFixed(1),
      style: AppText.label(context).copyWith(
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
