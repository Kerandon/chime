import 'package:flutter/material.dart';

class PopInAnimation extends StatefulWidget {
  const PopInAnimation({Key? key, required this.child, required this.animate,
  this.reset= false,
  })
      : super(key: key);

  final Widget child;
  final bool animate, reset;

  @override
  State<PopInAnimation> createState() => _PopInAnimationState();
}

class _PopInAnimationState extends State<PopInAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _scale = Tween<double>(begin: 0.0, end: 1.0)
    .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PopInAnimation oldWidget) {
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
