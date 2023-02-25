import 'package:flutter/material.dart';

import '../enums/slide_direction.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({
    required this.child,
    this.direction = SlideDirection.none,
    this.animate = true,
    this.duration = 1000,
    this.reset,
    this.reverse,
    this.animationCompleted,
    this.animationDelay = 0,
    Key? key,
    this.customTween,
  }) : super(key: key);

  final Widget child;
  final SlideDirection direction;
  final bool animate;
  final bool? reset;
  final bool? reverse;
  final Function(bool)? animationCompleted;
  final int duration;
  final int animationDelay;
  final Tween<Offset>? customTween;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this)
      ..addListener(() {
        if (_animationController.isCompleted) {
          widget.animationCompleted?.call(true);
        }
        if (_animationController.isDismissed) {
          widget.animationCompleted?.call(false);
        }
      });

    super.initState();
  }

  @override
  didUpdateWidget(covariant oldWidget) {
    if (widget.reset == true) {
      _animationController.reset();
    }

    if (widget.animate && !_animationController.isAnimating) {
      if (widget.animationDelay > 0) {
        Future.delayed(Duration(milliseconds: widget.animationDelay), () {
          if (mounted) {
            _animationController.reset();
            _animationController.forward();
          }
        });
      } else {
       // _animationController.reset();
        _animationController.forward();
      }
    }

    if (widget.reverse == true) {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Animation<Offset> animation;
    Tween<Offset> tween;

    if(widget.customTween == null) {
      switch (widget.direction) {
        case SlideDirection.leftAway:
          tween =
              Tween<Offset>(
                  begin: const Offset(0, 0), end: const Offset(-1, 0));
          break;
        case SlideDirection.rightAway:
          tween =
              Tween<Offset>(begin: const Offset(0, 0), end: const Offset(1, 0));
          break;
        case SlideDirection.leftIn:
          tween =
              Tween<Offset>(
                  begin: const Offset(-1, 0), end: const Offset(0, 0));
          break;
        case SlideDirection.rightIn:
          tween =
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
          break;
        case SlideDirection.upIn:
          tween =
              Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0));
          break;
        case SlideDirection.none:
          tween =
              Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0));
          break;
        case SlideDirection.downAway:
          tween =
              Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 1));
          break;
        case SlideDirection.downIn:
          tween =
              Tween<Offset>(
                  begin: const Offset(0, -1), end: const Offset(0, 0));
          break;
      }
    }else{
      tween = widget.customTween!;
    }

    animation = tween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubic));

    return SlideTransition(
      position: animation,
      child: widget.child,
    );
  }
}
