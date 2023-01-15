import 'package:flutter/material.dart';

class StopColorRing extends StatefulWidget {
  const StopColorRing({
    super.key,
    required this.animate,
    this.cancel = false,
    required this.radius,
    this.duration = 2000,
    this.loop = false,
    required this.colorsList,
  }) : assert(
            colorsList.length >= 2 &&
                colorsList.length <= 8 &&
                colorsList.length % 2 == 0,
            'Colors list length must be between 2 and 8 inclusive and an even number');

  final bool animate;
  final bool cancel;
  final double radius;
  final int duration;
  final bool loop;
  final List<Color> colorsList;

  @override
  State<StopColorRing> createState() => _StopColorRingState();
}

class _StopColorRingState extends State<StopColorRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;
  late final List<TweenSequenceItem<Color?>> colors;

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(
          milliseconds: widget.duration,
        ),
        vsync: this);
    super.initState();

    colors = <TweenSequenceItem<Color?>>[
      TweenSequenceItem(
        weight: 1.0,
        tween:
            ColorTween(begin: widget.colorsList[0], end: widget.colorsList[1]),
      ),
      if (widget.colorsList.length >= 4) ...[
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
              begin: widget.colorsList[2], end: widget.colorsList[3]),
        ),
      ],
      if (widget.colorsList.length >= 6) ...[
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
              begin: widget.colorsList[4], end: widget.colorsList[5]),
        ),
      ],
      if (widget.colorsList.length >= 8) ...[
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
              begin: widget.colorsList[6], end: widget.colorsList[7]),
        ),
      ],
    ];
    _colorAnimation = TweenSequence<Color?>(colors).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant StopColorRing oldWidget) {
    if (widget.animate) {
      if (widget.loop) {
        _controller.repeat();
        print('animate!!!!');
      } else {
        _controller.forward();
      }
    }
    if (widget.cancel) {
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
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          width: widget.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _controller.isAnimating || _controller.isCompleted
                  ? _colorAnimation.value!
                  : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
