import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatefulWidget {
  const CustomCircularIndicator({
    Key? key,
    required this.radius,
    required this.animate,
    required this.colorStart,
    required this.colorEnd,
    this.cancel = false,
    this.duration = 1000,
    this.strokeWidth = 2,
    this.reverse = false,
    this.backgroundColor = Colors.white10,
    this.pause = false,
  }) : super(key: key);

  final double radius;
  final bool animate;
  final bool cancel;
  final Color colorStart;
  final Color colorEnd;
  final int duration;
  final double strokeWidth;
  final bool reverse;
  final Color backgroundColor;
  final bool pause;

  @override
  State<CustomCircularIndicator> createState() =>
      _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState extends State<CustomCircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animationColor;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _animationColor = ColorTween(
      begin: widget.colorStart,
      end: widget.colorEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    double begin = 0.0, end = 1.0;
    if (widget.reverse) {
      begin = 1.0;
      end = 0.0;
    }

    _animation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomCircularIndicator oldWidget) {
    if (widget.animate) {
      _controller.forward();
    }

    if(widget.pause){
      _controller.stop();
    }

    if (widget.cancel) {
      _controller.reset();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: widget.radius * 2,
            height: widget.radius * 2,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => CircularProgressIndicator(
                backgroundColor: widget.backgroundColor,
                valueColor: _animationColor,
                value: _animation.value,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
