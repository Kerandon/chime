import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/constants.dart';
import 'custom_progress_circle.dart';

class StartCircleMain extends ConsumerStatefulWidget {
  const StartCircleMain({
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
  ConsumerState<StartCircleMain> createState() =>
      _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState
    extends ConsumerState<StartCircleMain>
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
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.30,
                    width: size.height * 0.30,
                    child: Center(
                      child: CustomPaint(
                        painter: CustomProgressCircle(
                          percentage: percent,
                          circleColor: Theme.of(context).primaryColorDark,
                          dashColor: Theme.of(context).primaryColor,
                        ),
                        child: Container(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
