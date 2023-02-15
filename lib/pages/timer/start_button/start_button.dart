import 'package:chime/animation/flip_animation.dart';
import 'package:chime/pages/Timer/start_button/start_circle_main.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../animation/bounce_animation.dart';
import '../../../app_components/custom_ink_splash.dart';
import '../../../app_components/lotus_icon.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import 'countdown_animation/count_down_animation.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({
    super.key,
  });

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  CountdownTimer? _timer;
  bool cancel = false;

  Widget _buttonImage = const Icon(Icons.play_arrow_outlined);



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    Color backgroundProgressColor = Theme.of(context).primaryColor;

    _setButtonIcon(state);

    print('Button image is ${_buttonImage}');

    Color progressBarColor = Theme.of(context).primaryColor;
    // if (state.sessionState == SessionState.notStarted) {
    //   backgroundProgressColor = Theme.of(context).primaryColor;
    // }
    // if (state.sessionState == SessionState.inProgress) {
    //   backgroundProgressColor = Theme.of(context).secondaryHeaderColor;
    // }
    // if (state.sessionState == SessionState.countdown) {
    //   progressBarColor = Colors.transparent;
    //   backgroundProgressColor = Theme.of(context).secondaryHeaderColor;
    // }
    // if (state.sessionState == SessionState.paused) {
    //   progressBarColor = Theme.of(context).primaryColor.withRed(100);
    //   backgroundProgressColor = Theme.of(context).secondaryHeaderColor;
    // }
    // if (state.sessionState == SessionState.inProgress &&
    //     state.millisecondsRemaining == 0) {
    //   progressBarColor = Colors.transparent;
    //   backgroundProgressColor = AppColors.veryDarkGrey;
    // }

    print('SESSION ${state.sessionState}');



    return Stack(
      children: [
        FlipAnimation(
          child: StartCircleMain(
            progressColor: progressBarColor,
            radius: size.width * kStartButtonRadius,
            duration: state.totalTimeMinutes,
            pause: state.sessionState == SessionState.paused,
            cancel: state.sessionState == SessionState.notStarted,
            backgroundColor: backgroundProgressColor,
          ),
        ),
        Center(
          child: SizedBox(
            width: size.width * 0.20,
            height: size.width * 0.20,
            child: Stack(
              children: [
                Center(
                  child: Material(
                    child: GestureDetector(
                      onTap: state.sessionState == SessionState.countdown ? null : () {


                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            notifier.setAnimateSplash(true);
                          });
                          if (state.sessionState == SessionState.notStarted) {
                            notifier.setSessionState(SessionState.countdown);
                          }

                          if (state.sessionState == SessionState.inProgress

                          ) {
                            notifier.setSessionState(SessionState.paused);
                          }
                          if (state.sessionState == SessionState.paused) {
                            notifier.setPausedTimeMillisecondsRemaining();
                            notifier.setSessionState(SessionState.inProgress);
                          }

                      },
                      child: BounceAnimation(
                        animate: state.sessionState == SessionState.inProgress,
                        stop: state.sessionState != SessionState.inProgress,
                        child: AnimatedSwitcher(
                          duration: const Duration(
                            milliseconds: 800,
                          ),
                          child: _buttonImage,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomInkSplash(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _setButtonIcon(AppState state) {
    if (state.sessionState == SessionState.notStarted) {
      _buttonImage = Icon(
        Icons.play_arrow_outlined,
        size: kStartButtonIconSize,
        color: Theme.of(context).primaryColor,
      );
    }
    if (state.sessionState == SessionState.countdown) {

      final maxLoops = state.totalCountdownTime ~/ 5;

      _buttonImage = CountdownAnimation(
        animate: true,
        maxLoops: maxLoops,
      );
    }
    if (state.sessionState == SessionState.inProgress) {
      _buttonImage = const LotusIcon();
    }
    if (state.sessionState == SessionState.paused) {
      _buttonImage = Icon(
        Icons.pause,
        size: kStartButtonIconSize,
        color: Theme.of(context).primaryColor,
      );
    }
  }
}
