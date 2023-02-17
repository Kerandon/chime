import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'loading_bar.dart';

class CountdownAnimation extends ConsumerStatefulWidget {
  const CountdownAnimation({
    super.key,
    required this.animate,
    required this.maxLoops,
  });

  final bool animate;
  final int maxLoops;

  @override
  ConsumerState<CountdownAnimation> createState() => _CountdownAnimationState();
}

class _CountdownAnimationState extends ConsumerState<CountdownAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _index = 0;
  int _looped = 0;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this)..addStatusListener((status) {
          if(status == AnimationStatus.completed && _looped < widget.maxLoops - 1){
            _controller.reset();
            _controller.forward();
            _looped++;
          }
        });
    super.initState();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {

        if (_controller.value <= 0.20) {
          _index = 0;
        }
        if (_controller.value > 0.20 && _controller.value <= 0.40) {
          _index = 1;
        }
        if (_controller.value > 0.40 && _controller.value <= 0.60) {
          _index = 2;
        }
        if (_controller.value > 0.60 && _controller.value <= 0.80) {
          _index = 3;
        }
        if (_controller.value > 0.80) {
          _index = 4;
        }

        return Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => LoadingBar(
                        index: index,
                        currentIndex: _index,
                      ))),
        );
      },
    );
  }
}
