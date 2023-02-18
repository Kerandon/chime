import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'center_button.dart';
import 'custom_progress_circle.dart';

class StartButtonMain extends ConsumerStatefulWidget {
  const StartButtonMain({
    Key? key,
  }) : super(key: key);


  @override
  ConsumerState<StartButtonMain> createState() =>
      _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState
    extends ConsumerState<StartButtonMain>
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
          ((state.totalTimeMinutes * 60000) - state.millisecondsRemaining) /
              (state.totalTimeMinutes * 60000);
    }

    if (percent.isNegative) {
      percent = 0;
    }

    return SizedBox(
      width: size.width * 0.90,
      height: size.width * 0.90,
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0.0,0.0),
            child: SizedBox(
              height: size.height * 0.32,
              width: size.height * 0.32,
              child: CustomPaint(
                painter: CustomProgressCircle(
                  percentage: percent,
                  circleColor: Theme.of(context).primaryColorDark,
                  dashColor: Theme.of(context).primaryColor,
                ),
                child: CenterButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
