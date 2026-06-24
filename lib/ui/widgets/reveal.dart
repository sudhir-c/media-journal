import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Fades and lifts its child into place once, on mount. Used for tasteful,
/// understated entrances. Honors the platform "reduce motion" setting.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 12,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppDurations.slow,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _c,
    curve: appEase,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _fade,
      child: AnimatedBuilder(
        animation: _fade,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, widget.offset * (1 - _fade.value)),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
