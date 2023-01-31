import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    Key? key,
    required this.child,
    this.durationMilliseconds = 800,
    this.delayMilliseconds = 0,
    this.beginScale = 0.90,
    this.beginOpacity = 0.50,
  }) : super(key: key);

  final Widget child;
  final int durationMilliseconds;
  final int delayMilliseconds;
  final double beginScale;
  final double beginOpacity;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale, _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.durationMilliseconds),
        vsync: this);

    _scale = Tween<double>(begin: widget.beginScale, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacity = Tween<double>(begin: widget.beginScale, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
