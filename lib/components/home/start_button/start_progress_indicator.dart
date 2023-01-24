import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/constants.dart';

class StartCircularIndicator extends ConsumerStatefulWidget {
  const StartCircularIndicator({
    Key? key,
    required this.radius,
    this.cancel = false,
    this.duration = 1000,
    this.progressWidth = kSessionTimerStrokeWidth * 0.5,
    required this.progressColor,
    this.backgroundColor = Colors.transparent,
    this.pause = false,
  }) : super(key: key);

  final double radius;
  final bool cancel;
  final int duration;
  final double progressWidth;
  final Color progressColor;
  final Color backgroundColor;
  final bool pause;

  @override
  ConsumerState<StartCircularIndicator> createState() =>
      _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState
    extends ConsumerState<StartCircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(stateProvider);
    double percent = 1.0;

    if (state.totalTimeMinutes != 0 && state.millisecondsRemaining != 0) {
      percent = ((state.totalTimeMinutes * 60 * 1000)
      - state.millisecondsRemaining) / (state.totalTimeMinutes * 60 * 1000);
    }

    if (!state.sessionHasStarted) {
      percent = 1.0;
    }

    if(state.longTapInProgress){
      percent = state.pausedMillisecondsRemaining.toDouble();
    }

    return Center(
      child: Stack(
        children: [

          Center(
            child: SizedBox(
              width: widget.radius * 2,
              height: widget.radius * 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
                  backgroundColor: widget.backgroundColor,
                  value: percent,
                  strokeWidth: widget.progressWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
