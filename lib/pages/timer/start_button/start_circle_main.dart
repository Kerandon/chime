import 'package:chime/animation/fade_in_animation.dart';
import 'package:chime/enums/clock_design.dart';
import 'package:chime/enums/session_state.dart';
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

class _CustomCircularIndicatorState extends ConsumerState<StartButtonMain>
    with TickerProviderStateMixin {
  late AnimationController _controllerPercent;
  double _percent = 1.0;
  bool _pausePercentConfirmed = false;

  @override
  void initState() {
    super.initState();
    _controllerPercent = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..addListener(() {
        _percent = _controllerPercent.value;
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controllerPercent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    if (!appState.openSession) {
      if (appState.sessionState == SessionState.inProgress) {
        _percent =
            appState.millisecondsElapsed / (appState.totalTimeMinutes * 60000);
      }
    } else {
      if (appState.sessionState == SessionState.inProgress) {
        if (!_controllerPercent.isAnimating) {
          _controllerPercent.repeat();
        }
      }
      if (appState.sessionState == SessionState.paused) {
        _controllerPercent.stop();
      }
    }
    if (appState.sessionState == SessionState.ended ||
        appState.sessionState == SessionState.notStarted) {
      _controllerPercent.reset();
      _percent = 1.0;
    }
    if (_percent.isNegative) {
      _percent = 0;
    }
    if (appState.openSession &&
        appState.sessionState == SessionState.paused &&
        !_pausePercentConfirmed) {
      _pausePercentConfirmed = true;
    }

    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: size.width * 0.90,
      height: size.width * 0.90,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0.0, 0.0),
            child: FadeInAnimation(
              animateOnDemand: appState.appHasLoaded && !appState.introAnimationHasRun,
              durationMilliseconds:  kIntroAnimationDuration,
              beginScale: appState.introAnimationHasRun ? 1 : 1.30,
              beginOpacity: appState.introAnimationHasRun ? 1 : kStartAnimationOpacity,
              animationCompleted: (){
                appNotifier.setIntroAnimationHasRun();
              },
              child: SizedBox(
                height: size.height * 0.30,
                width: size.height * 0.30,
                child: CustomPaint(
                  painter: appState.timerDesign == TimerDesign.solid
                      ? CustomClockSolid(
                          percentage: _percent,
                          backgroundColor:
                              secondaryColor.withOpacity(kTimerOpacityShade),
                          dashColor: primaryColor,
                        )
                      : appState.timerDesign == TimerDesign.clock
                          ? CustomClockClock(
                              percentage: _percent,
                              fillColor: primaryColor,
                              borderColor: secondaryColor,
                            )
                          : appState.timerDesign == TimerDesign.circle
                              ? CustomClockCircle(
                                  percentage: _percent,
                                  backgroundColor: secondaryColor
                                      .withOpacity(kTimerOpacityShade),
                                  circlesColor: primaryColor,
                                  radius: 0.45,
                                )
                              : appState.timerDesign == TimerDesign.dash
                                  ? CustomClockDash(
                                      percentage: _percent,
                                      backgroundColor: secondaryColor
                                          .withOpacity(kTimerOpacityShade),
                                      dashColor: secondaryColor,
                                    )
                                  : null,
                  child: FadeInAnimation(
                      animateOnDemand: appState.appHasLoaded,
                      beginScale: appState.introAnimationHasRun ? 1 : 0.20,
                      beginOpacity: appState.introAnimationHasRun ? 1 : kStartAnimationOpacity,
                      durationMilliseconds:  kIntroAnimationDuration,
                      child: const CenterButton()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
