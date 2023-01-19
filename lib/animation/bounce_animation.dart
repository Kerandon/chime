import 'package:flutter/material.dart';

class BounceAnimation extends StatefulWidget {
  const BounceAnimation({
    Key? key,
    required this.child,
    this.animate = false,
    this.duration = 8000,
    this.stop = false,
  }) : super(key: key);

  final Widget child;
  final bool animate;
  final int duration;
  final bool stop;

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.80, end: 1.10), weight: 0.50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.10, end: 0.80), weight: 0.80),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant BounceAnimation oldWidget) {
    if (widget.animate) {
      _controller.repeat();
    }
    if (widget.stop) {
      _controller.reset();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
