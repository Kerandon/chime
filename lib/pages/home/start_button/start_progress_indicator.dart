import 'package:chime/pages/home/custom_clock.dart';
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
    this.strokeWidth = kSessionTimerStrokeWidth,
    required this.progressColor,
    this.backgroundColor = Colors.transparent,
    this.pause = false,
  }) : super(key: key);

  final double radius;
  final bool cancel;
  final int duration;
  final double strokeWidth;
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
    final size = MediaQuery.of(context).size;
    final state = ref.read(stateProvider);
    double percent = 1.0;

    if (state.totalTimeMinutes != 0 && state.millisecondsRemaining != 0) {
      percent =
          ((state.totalTimeMinutes * 60 * 1000) - state.millisecondsRemaining) /
              (state.totalTimeMinutes * 60 * 1000);
    }

    if (!state.sessionHasStarted) {
      percent = 1.0;
    }

    if (state.longTapInProgress) {
      percent = state.pausedMillisecondsRemaining.toDouble();
    }

    if (percent.isNegative) {
      percent = 0;
    }

    return Center(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: widget.radius * 2,
              height: widget.radius * 2,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: size.height * 0.20,
                      width: size.height * 0.20,
                      child: CustomPaint(
                        painter: CustomClock(
                          percentage: percent,
                          circleColor: Theme.of(context).primaryColor,
                          handColor: Theme.of(context).primaryColor,
                          dashColor: Theme.of(context).primaryColor,

                        ),

                        // CustomProgressPainter(
                        //     percent: percent,
                        //     progressColor: widget.progressColor,
                        //     backgroundColor: widget.backgroundColor,
                        //     strokeWidth: widget.strokeWidth,
                        //
                        //   ),
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
