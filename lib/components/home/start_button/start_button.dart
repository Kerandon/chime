import 'package:chime/animation/bounce_animation.dart';
import 'package:chime/animation/fade_in_animation.dart';
import 'package:chime/components/home/start_button/start_progress_indicator.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import '../../app/lotus_icon.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({
    super.key,
  });

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  CountdownTimer? _timer;

  // bool _longTapInProgress = false;
  Widget _buttonImage = const Icon(Icons.play_arrow_outlined);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    _setButtonIcon(state);

    Color progressBarColor = Theme.of(context).primaryColor;
    if (state.sessionState == SessionState.countdown) {
      progressBarColor = Colors.transparent;
    }
    if (state.sessionState == SessionState.paused) {
      progressBarColor = Theme.of(context).primaryColor.withOpacity(0.50);
    }
    if (state.longTapInProgress) {
      progressBarColor = AppColors.darkGrey;
    }
    if (state.sessionState == SessionState.inProgress &&
        state.millisecondsRemaining == 0) {
      progressBarColor = Colors.transparent;
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
        }, (LongPressGestureRecognizer instance) {
          instance.onLongPress = () {
            if (state.sessionHasStarted) {
              notifier.setLongTapInProgress(true);

              _timer = CountdownTimer(
                  const Duration(milliseconds: kLongPressDurationMilliseconds),
                  const Duration(milliseconds: 20));

              _timer?.listen((event) {
                // setState(() {});
              }, onDone: () {
                notifier.setSessionState(
                  SessionState.notStarted,
                );
                notifier.resetSession();
                // setState(() {
                notifier.setLongTapInProgress(false);
                // });
              });
            }
          };
          instance.onLongPressEnd = (details) {
            // setState(
            //   () {
            //     _longTapInProgress = false;
            notifier.setLongTapInProgress(false);
            _timer?.cancel();
            //   },
            // );
          };
          instance.onLongPressCancel = () {
            // setState(
            //   () {
            notifier.setLongTapInProgress(false);
            //_longTapInProgress = false;//
            _timer?.cancel();
            //   },
            // );
          };
        }),
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: StartCircularIndicator(
              progressColor: progressBarColor,
              radius: size.width * kStartButtonRadius,
              duration: state.totalTimeMinutes,
              pause: state.sessionState == SessionState.paused,
              cancel: state.sessionState == SessionState.notStarted,
              backgroundColor: Colors.white10,
            ),
          ),
          FadeInAnimation(
            delayMilliseconds: 800,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.width),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: SizedBox(
                      width: size.width * kStartButtonRadius * 2,
                      height: size.width * kStartButtonRadius * 2,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: BounceAnimation(
                          animate:
                              state.sessionState == SessionState.inProgress,
                          stop: state.sessionState != SessionState.inProgress,
                          child: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            child: _buttonImage,
                          ),
                        ),
                      ),
                    ),
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
      _buttonImage = const Icon(
        Icons.play_arrow_outlined,
        size: kStartButtonIconSize,
      );
    }
    if (state.sessionState == SessionState.inProgress) {
      _buttonImage = const LotusIcon();
    }
    if (state.sessionState == SessionState.paused) {
      _buttonImage = const Icon(
        Icons.pause,
        size: kStartButtonIconSize,
      );
    }
    if (state.longTapInProgress) {
      _buttonImage = const Icon(
        Icons.stop,
        size: kStartButtonIconSize,
      );
    }
  }
}
