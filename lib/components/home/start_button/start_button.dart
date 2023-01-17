import 'package:chime/animation/bounce_animation.dart';
import 'package:chime/components/home/start_button/start_progress_indicator.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';

import '../../../utils/constants.dart';
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

  bool _longTapInProgress = false;

  bool _animateLight = false;

  Widget _buttonImage = const Icon(Icons.play_arrow_outlined);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    _setButtonIcon(state);

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
            if (state.sessionState == SessionState.inProgress) {
              notifier.setPausedTime();
              notifier.setSessionState(SessionState.paused);
              setState(() {
                _animateLight = true;
              });
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
              _longTapInProgress = true;

              _timer = CountdownTimer(
                  const Duration(milliseconds: kLongPressDurationMilliseconds),
                  const Duration(milliseconds: 20));

              _timer?.listen((event) {
                setState(() {});
              }, onDone: () {
                notifier.setSessionState(
                  SessionState.notStarted,
                );
                notifier.resetSession();
                setState(() {
                  _longTapInProgress = false;

                });
              });
            }
          };
          instance.onLongPressEnd = (details) {
            setState(
              () {
                _longTapInProgress = false;
                _timer?.cancel();
              },
            );
          };
          instance.onLongPressCancel = () {
            setState(
              () {
                _longTapInProgress = false;
                _timer?.cancel();
              },
            );
          };
        }),
      },
      child: Stack(
        children: [
          // Padding(
          //   padding: EdgeInsets.all(size.width * 0.02),
          //   child: StopColorRing(
          //     animate: _longTapInProgress,
          //     cancel: !_longTapInProgress,
          //     radius: (size.width * kStartButtonRadius) + (size.width * 0.01),
          //     duration: kLongPressDurationMilliseconds,
          //     colorsList: const [
          //       Colors.orangeAccent,
          //       Colors.orange,
          //       Colors.redAccent,
          //       Colors.red,
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(size.width * 0.02),
          //   child: StopColorRing(
          //     animate: state.sessionState == SessionState.paused,
          //     cancel: state.sessionState != SessionState.paused &&
          //         state.sessionHasStarted,
          //     radius: (size.width * kStartButtonRadius) + (size.width * 0.01),
          //     duration: kLongPressDurationMilliseconds,
          //     loop: true,
          //     colorsList: const [
          //       Colors.yellow,
          //       Colors.yellowAccent,
          //       Colors.yellow,
          //       Colors.amberAccent,
          //       Colors.amber,
          //       Colors.yellow
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: StartCircularIndicator(
              radius: size.width * kStartButtonRadius,
              animate: _animateLight,
              colorStart: Colors.teal,
              colorEnd: Colors.teal,
              duration: state.totalTimeMinutes,
              pause: state.sessionState == SessionState.paused,
              cancel: state.sessionState == SessionState.notStarted,
              backgroundColor: Colors.white10,
            ),
          ),
          Center(
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
                            milliseconds: 300,
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
    if (_longTapInProgress) {
      _buttonImage = const Icon(
        Icons.stop,
        size: kStartButtonIconSize,
      );
    }
  }
}
