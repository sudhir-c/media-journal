import 'package:flutter/material.dart';

/// Renders text in [baseColor] with a brighter highlight that sweeps across the
/// glyphs on a loop — a quiet shimmer that keeps the text on-color. Honors
/// reduce-motion (renders solid [baseColor]).
class ShimmerText extends StatefulWidget {
  const ShimmerText({
    super.key,
    required this.text,
    required this.style,
    required this.baseColor,
    this.period = const Duration(milliseconds: 4800),
  });

  final String text;
  final TextStyle style;
  final Color baseColor;
  final Duration period;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return Text(widget.text, style: widget.style.copyWith(color: widget.baseColor));
    }
    final highlight = Color.alphaBlend(
      Colors.white.withValues(alpha: 0.3),
      widget.baseColor,
    );
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value * 2 - 1; // -1 → 1
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (rect) => LinearGradient(
            colors: [widget.baseColor, highlight, widget.baseColor],
            stops: const [0.2, 0.5, 0.8],
            transform: _SlideGradient(t * 1.7),
          ).createShader(rect),
          child: child,
        );
      },
      child: Text(
        widget.text,
        style: widget.style.copyWith(color: Colors.white),
      ),
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
