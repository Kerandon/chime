import 'dart:math' as math;

import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  const FlipAnimation({Key? key, required this.child, this.animateOnStart = true, this.animate = false, })
      : super(key: key);

  final Widget child;
  final bool animateOnStart;
  final bool animate;

  @override
  State<FlipAnimation> createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3200), vsync: this);
    _rotation = Tween<double>(begin: 0.20, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if(widget.animateOnStart){
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlipAnimation oldWidget) {
    if (widget.animate) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0005)
          ..rotateY(
            _rotation.value * math.pi,
          ),
        child: widget.child,
      ),
    );
  }
}
