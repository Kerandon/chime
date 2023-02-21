import 'package:flutter/material.dart';

class PopAnimation extends StatefulWidget {
  const PopAnimation({Key? key, required this.child, required this.animate, this.reverse = false,
  this.reset= false,
  })
      : super(key: key);

  final Widget child;
  final bool animate, reset;
  final bool reverse;

  @override
  State<PopAnimation> createState() => _PopAnimationState();
}

class _PopAnimationState extends State<PopAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    double begin = 0.0, end = 1.0;
    if(widget.reverse){
      begin = 1.0; end = 0.0;
    }
    _scale = Tween<double>(begin: begin, end: end)
    .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PopAnimation oldWidget) {
    if(widget.animate && !_controller.isAnimating){
      _controller.forward();
    }
    if(widget.reset){
    _controller.reset();
    }


    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale,
    child: widget.child,
    );
  }
}
