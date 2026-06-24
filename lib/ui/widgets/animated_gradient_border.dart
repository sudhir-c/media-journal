import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Wraps [child] in an accent border whose two colors flow around the frame.
/// Used to give the media picture and reflection blocks a bold, living edge
/// drawn from the cover's extracted accents. Honors reduce-motion.
class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.colorA,
    required this.colorB,
    this.radius = AppRadii.md,
    this.thickness = 2,
    this.period = const Duration(seconds: 6),
    this.backgroundColor,
  });

  final Widget child;
  final Color colorA;
  final Color colorB;
  final double radius;
  final double thickness;
  final Duration period;
  final Color? backgroundColor;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final inner = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          (widget.radius - widget.thickness).clamp(0, widget.radius),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          (widget.radius - widget.thickness).clamp(0, widget.radius),
        ),
        child: widget.child,
      ),
    );

    if (reduceMotion) {
      return CustomPaint(
        foregroundPainter: _BorderPainter(
          t: 0,
          colorA: widget.colorA,
          colorB: widget.colorB,
          radius: widget.radius,
          thickness: widget.thickness,
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.thickness),
          child: inner,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => CustomPaint(
        foregroundPainter: _BorderPainter(
          t: _c.value,
          colorA: widget.colorA,
          colorB: widget.colorB,
          radius: widget.radius,
          thickness: widget.thickness,
        ),
        child: child,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.thickness),
        child: inner,
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.t,
    required this.colorA,
    required this.colorB,
    required this.radius,
    required this.thickness,
  });

  final double t;
  final Color colorA;
  final Color colorB;
  final double radius;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(thickness / 2),
      Radius.circular(radius - thickness / 2),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..shader = SweepGradient(
        colors: [colorA, colorB, colorA, colorB, colorA],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        transform: GradientRotation(t * 2 * math.pi),
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_BorderPainter old) =>
      old.t != t || old.colorA != colorA || old.colorB != colorB;
}
