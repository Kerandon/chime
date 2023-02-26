import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/constants.dart';
import 'center_button.dart';
import 'custom_clocks/custom_clock_circle.dart';
import 'custom_clocks/custom_clock_clock.dart';
import 'custom_clocks/custom_clock_dash.dart';
import 'custom_clocks/custom_clock_solid.dart';

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
    final state = ref.read(appProvider);
    double percent = 1.0;

    if (state.totalTimeMinutes != 0 && state.millisecondsRemaining != 0) {
      percent =
          (((state.totalTimeMinutes * 60000)) - state.millisecondsRemaining) /
              ((state.totalTimeMinutes * 60000));
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
            alignment: const Alignment(0.0,0.0),
            child: SizedBox(
              height: size.height * 0.32,
              width: size.height * 0.32,
              child:

              CustomPaint(
                painter:
                    CustomClockClock(
                        percentage: percent,
                        fillColor: Theme.of(context).primaryColor,
                        borderColor: Theme.of(context).colorScheme.secondary,
                        dashColor: Theme.of(context).colorScheme.tertiary,

                    ),
                // CustomClockCircle(
                //   percentage: percent,
                //   backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                //   dashColor: Theme.of(context).primaryColor,
                // ),
                //     CustomClockLine(
                //         percentage: percent,
                //         backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                //         dashColor: Theme.of(context).primaryColor,
                //     ),
                // CustomClockDash(
                //   percentage: percent,
                //   backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
                //   dashColor: Theme.of(context).primaryColor,
                // ),
                child: const CenterButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
