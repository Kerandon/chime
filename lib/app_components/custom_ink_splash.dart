import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/app_state.dart';

class CustomInkSplash extends ConsumerStatefulWidget {
  const CustomInkSplash({
    super.key,
  });

  @override
  ConsumerState<CustomInkSplash> createState() => _CustomSplashState();
}

class _CustomSplashState extends ConsumerState<CustomInkSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    if (state.animateSplash && !_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 100), () {
        notifier.setAnimateSplash(false);
      });
    }

    return IgnorePointer(
      ignoring: true,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          return _controller.value != 0.0 && _controller.value != 1.0
              ? Container(
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).splashColor,
                )).animate().scaleXY(end: 1.10, curve: Curves.easeOut).fadeOut()
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
