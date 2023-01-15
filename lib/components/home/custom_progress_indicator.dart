import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomCircularIndicator extends ConsumerStatefulWidget {
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
  ConsumerState<CustomCircularIndicator> createState() =>
      _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState
    extends ConsumerState<CustomCircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animationColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );

    _animationColor = ColorTween(
      begin: widget.colorStart,
      end: widget.colorEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomCircularIndicator oldWidget) {
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    }

    if (widget.pause) {
      _controller.stop();
    }

    if (widget.cancel) {
      _controller.reset();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(stateProvider);
    double percent = 1.0;

    if (state.totalTimeMinutes != 0 && state.secondsRemaining != 0) {
      percent = ((state.totalTimeMinutes * 60) - state.secondsRemaining) /
          (state.totalTimeMinutes * 60);
    }
    if (!state.sessionHasStarted) {
      percent = 1.0;
    }

    return Center(
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: _animationColor,
          value: percent,
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }
}
