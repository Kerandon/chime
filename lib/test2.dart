import 'package:flutter/material.dart';

class Test2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TEST2ANIM extends StatefulWidget {
  const TEST2ANIM({Key? key}) : super(key: key);

  @override
  State<TEST2ANIM> createState() => _TEST2ANIMState();
}

class _TEST2ANIMState extends State<TEST2ANIM>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _tweenAnimation;

  Offset _beginValue = const Offset(0, 0);
  Offset _endValue = const Offset(0, 0);

  final List<TweenSequenceItem<Offset>> _tweens = [
    TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(200, 200)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(200, 200), end: const Offset(80, 600)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(80, 600), end: const Offset(90, 90)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<Offset>(
            begin: const Offset(90, 90), end: const Offset(190, 350)),
        weight: 2)
  ];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this)..addListener(() {
          _beginValue = _tweenAnimation.value;

        });

    _tweenAnimation = TweenSequence(_tweens).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
