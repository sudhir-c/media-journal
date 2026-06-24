import 'package:flutter/material.dart';

import '../../core/categories.dart';
import '../theme/app_text.dart';
import '../theme/tokens.dart';

/// A 1–10 rating as a tappable fill meter. Filled segments use [accent].
class RatingInput extends StatelessWidget {
  const RatingInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.error,
    this.accent = AppColors.ink,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final String? error;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppText.label(context))),
            AnimatedSwitcher(
              duration: AppDurations.fast,
              child: Text(
                value?.toString() ?? '—',
                key: ValueKey(value),
                style: AppText.label(context).copyWith(
                  color: value == null ? AppColors.inkFaint : accent,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: () => onChanged(null),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Clear',
                    style: AppText.meta(context, color: AppColors.inkFaint),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            for (int v = axisMin; v <= axisMax; v++) ...[
              if (v > axisMin) const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(value == v ? null : v),
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    height: 8,
                    decoration: BoxDecoration(
                      color: (value ?? 0) >= v ? accent : AppColors.fill,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              error!,
              style: AppText.meta(context, color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}

/// Read-only meter used on the detail page. The fill grows in on appear and
/// carries a slow passive sheen; the label/value are set in the display serif.
class RatingMeter extends StatefulWidget {
  const RatingMeter({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final int? value;

  /// Bar fill color — the media's secondary accent.
  final Color accent;

  @override
  State<RatingMeter> createState() => _RatingMeterState();
}

class _RatingMeterState extends State<RatingMeter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheen = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat();

  @override
  void dispose() {
    _sheen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final fraction = (widget.value ?? 0) / axisMax;
    final labelStyle = AppText.headline(context).copyWith(
      fontSize: 16.5,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.label, style: labelStyle)),
            Text(
              widget.value?.toString() ?? '—',
              style: labelStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.value == null ? AppColors.inkFaint : AppColors.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: SizedBox(
            height: 9,
            child: Stack(
              children: [
                const Positioned.fill(child: ColoredBox(color: AppColors.line)),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: fraction),
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 750),
                  curve: appEase,
                  builder: (context, f, _) => FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: f.clamp(0.0, 1.0),
                    child: reduceMotion
                        ? ColoredBox(color: widget.accent)
                        : _SheenFill(accent: widget.accent, animation: _sheen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The accent-filled portion of a meter with a translucent light band that
/// slides across on a loop — a quiet, living sheen.
class _SheenFill extends StatelessWidget {
  const _SheenFill({required this.accent, required this.animation});

  final Color accent;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value * 2 - 1; // -1 → 1
        return DecoratedBox(
          decoration: BoxDecoration(
            color: accent,
            gradient: LinearGradient(
              colors: [
                accent,
                Color.alphaBlend(Colors.white.withValues(alpha: 0.18), accent),
                accent,
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(t * 1.6),
            ),
          ),
        );
      },
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.t);
  final double t;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * t, 0, 0);
}
