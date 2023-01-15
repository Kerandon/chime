
import 'package:chime/animation/bounce_animation.dart';
import 'package:chime/components/home/stop_color_ring.dart';
import 'package:chime/enums/session_status.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';

import '../../utils/constants.dart';
import 'custom_progress_indicator.dart';
import 'lotus_icon.dart';

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
  int _restartMillisecondsRemaining = 0;

  bool _animateLight = false;

  Widget _buttonImage = const Icon(Icons.play_arrow_outlined);

  @override
  Widget build(BuildContext context) {
    double restartPercent =
        _restartMillisecondsRemaining / kLongPressDurationMilliseconds;
    if (restartPercent.isNegative) {
      restartPercent = 0;
    }
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    final size = MediaQuery.of(context).size;

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




            if (state.sessionStatus == SessionStatus.notStarted) {
              notifier.setSessionStatus(SessionStatus.inProgress);
            }
            if (state.sessionStatus == SessionStatus.inProgress) {

                notifier.setPausedTime();
                notifier.setSessionStatus(SessionStatus.paused);
                setState(() {
                  _animateLight = true;
                });
            }
            if (state.sessionStatus == SessionStatus.paused) {
              notifier.setSessionStatus(SessionStatus.inProgress);
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
                _longTapInProgress = true;

                _timer = CountdownTimer(
                    const Duration(
                        milliseconds: kLongPressDurationMilliseconds),
                    const Duration(milliseconds: 20));

                _timer?.listen((event) {
                  _restartMillisecondsRemaining =
                      event.remaining.inMilliseconds;
                  setState(() {});
                }, onDone: () {
                  notifier.setSessionStatus(SessionStatus.notStarted,
                  );
                  setState(() {
                    _longTapInProgress = false;
                    notifier.resetSession();
                  });
                });
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
            }
        ),
      },


      child: Stack(
        children: [
          StopColorRing(
            animate: _longTapInProgress,
            cancel: !_longTapInProgress,
            radius: size.width * 0.16,
            duration: kLongPressDurationMilliseconds,
            colorsList: const [
              Colors.orangeAccent,
              Colors.orange,
              Colors.redAccent,
              Colors.red,
            ],
          ),

          StopColorRing(
            animate: state.sessionStatus == SessionStatus.paused,
            cancel: state.sessionStatus != SessionStatus.paused && state.sessionHasStarted,
            radius: size.width * 0.16,
            duration: kLongPressDurationMilliseconds,
            loop: true,
            colorsList: const [
              Colors.yellow,
              Colors.yellowAccent,
              Colors.yellow,
              Colors.amberAccent,
              Colors.amber,
              Colors.yellow
            ],
          ),
          CustomCircularIndicator(
            radius: size.width * 0.15,
            animate: _animateLight,
            colorStart: Colors.teal,
            colorEnd: Colors.yellowAccent,
            duration: state.totalTime * 60,
            pause: state.sessionStatus == SessionStatus.paused,
            cancel: state.sessionStatus == SessionStatus.notStarted,
            backgroundColor: Colors.transparent,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: SizedBox(
                    width: size.width * 0.25,
                    height: size.width * 0.25,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: BounceAnimation(
                        animate: state.sessionStatus == SessionStatus.inProgress,
                        stop: state.sessionStatus != SessionStatus.inProgress,
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
    if(state.sessionStatus == SessionStatus.notStarted){
      _buttonImage = const Icon(Icons.play_arrow_outlined, size: 25);
    }
    if (state.sessionStatus == SessionStatus.inProgress) {
      _buttonImage = const LotusIcon();
    }
    if (state.sessionStatus == SessionStatus.paused) {
      _buttonImage = const Icon(Icons.pause, size: 25,);
    }
    if (_longTapInProgress) {
      _buttonImage = const Icon(Icons.stop, size: 25);
    }
  }
}
