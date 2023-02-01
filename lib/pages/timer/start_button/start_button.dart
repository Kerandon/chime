import 'package:chime/animation/flip_animation.dart';
import 'package:chime/pages/Timer/start_button/start_circle_main.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../animation/bounce_animation.dart';
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

  Widget _buttonImage = const Icon(Icons.play_arrow_outlined);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    Color backgroundProgressColor = Theme.of(context).primaryColor;

    _setButtonIcon(state);

    Color progressBarColor = Theme.of(context).primaryColor;
    if (state.sessionState == SessionState.notStarted) {
      backgroundProgressColor = Theme.of(context).primaryColor;
    }
    if (state.sessionState == SessionState.inProgress) {
      backgroundProgressColor = AppColors.veryDarkGrey;
    }
    if (state.sessionState == SessionState.countdown) {
      progressBarColor = Colors.transparent;
      backgroundProgressColor = AppColors.veryDarkGrey;
    }
    if (state.sessionState == SessionState.paused) {
      progressBarColor = Theme.of(context).primaryColor.withRed(100);
      backgroundProgressColor = AppColors.veryDarkGrey;
    }
    if (state.longTapInProgress) {
      progressBarColor = AppColors.grey;
      backgroundProgressColor = AppColors.almostBlack;
    }
    if (state.sessionState == SessionState.inProgress &&
        state.millisecondsRemaining == 0) {
      progressBarColor = Colors.transparent;
      backgroundProgressColor = AppColors.veryDarkGrey;
    }

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(() {
          return TapGestureRecognizer(
            debugOwner: this,
          );
        }, (TapGestureRecognizer instance) {
          instance.onTap = () {
            if (state.sessionState == SessionState.notStarted) {
              notifier.setSessionState(SessionState.countdown);
            }
            if (state.sessionState == SessionState.inProgress &&
                state.millisecondsRemaining > 0) {
              notifier.setPausedTimeMillisecondsRemaining();
              notifier.setSessionState(SessionState.paused);
            }
            if (state.sessionState == SessionState.paused) {
              notifier.setSessionState(SessionState.inProgress);
            }
          };
        }),
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () {
            return LongPressGestureRecognizer(
              debugOwner: this,
              duration: const Duration(milliseconds: 500),
            );
          },
          (LongPressGestureRecognizer instance) {
            instance.onLongPress = () {
              if (state.sessionHasStarted) {
                notifier.setLongTapInProgress(true);

                _timer = CountdownTimer(
                    const Duration(
                        milliseconds: kLongPressDurationMilliseconds),
                    const Duration(milliseconds: 20));

                _timer?.listen((event) {}, onDone: () {
                  notifier.setSessionState(
                    SessionState.notStarted,
                  );
                  notifier.resetSession();

                  notifier.setLongTapInProgress(false);
                });
              }
            };
            instance.onLongPressEnd = (details) {
              notifier.setLongTapInProgress(false);
              _timer?.cancel();
            };
            instance.onLongPressCancel = () {
              notifier.setLongTapInProgress(false);

              _timer?.cancel();
            };
          },
        ),
      },
      child: Stack(
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
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
        ],
      ),
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
    if(state.sessionState == SessionState.countdown){
      _buttonImage = CountdownAnimation(animate: true);
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
    if (state.longTapInProgress) {
      _buttonImage = Icon(
        Icons.stop,
        size: kStartButtonIconSize,
        color: Theme.of(context).primaryColor,
      );
    }
  }
}
