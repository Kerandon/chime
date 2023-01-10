import 'package:chime/components/stop_color_ring.dart';
import 'package:chime/components/custom_circular_indicator.dart';
import 'package:chime/enums/session_status.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({
    super.key,
  });

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  CountdownTimer? _timer;
  static const _kLongPressDuration = 1;
  bool _longTapInProgress = false;
  int _restartMillisecondsRemaining = 0;

  bool _startIndicator = false;

  Widget _buttonImage = Icon(Icons.play_arrow_outlined);

  @override
  Widget build(BuildContext context) {
    double restartPercent = _restartMillisecondsRemaining / _kLongPressDuration;
    if (restartPercent.isNegative) {
      restartPercent = 0;
    }
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    final size = MediaQuery.of(context).size;

    if (state.sessionStatus == SessionStatus.inProgress) {
      _buttonImage = Icon(Icons.play_arrow);
    }
    if (state.sessionStatus == SessionStatus.paused) {
      _buttonImage = Icon(Icons.pause);
    }
    if (_longTapInProgress) {
      _buttonImage = Icon(Icons.stop);
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
            _startIndicator = true;
            setState(() {});
            if (state.sessionStatus == SessionStatus.notStarted) {
              notifier.setSessionStatus(SessionStatus.inProgress);
            }
            if (state.sessionStatus == SessionStatus.inProgress) {
              notifier.setPausedTime();
              notifier.setSessionStatus(SessionStatus.paused);
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
              setState(() {});

              _timer = CountdownTimer(
                  const Duration(milliseconds: _kLongPressDuration),
                  const Duration(milliseconds: 20));

              _timer?.listen(
                (event) {
                  _restartMillisecondsRemaining =
                      event.remaining.inMilliseconds;
                  setState(() {});
                },
              );
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
          },
        ),
      },
      child: Stack(
        children: [
          // StopColorRing(
          //   animate: _longTapInProgress,
          //   cancel: !_longTapInProgress,
          //   radius: size.width * 0.16,
          //   colorsList: [],
          // ),
          StopColorRing(
            animate: state.sessionStatus == SessionStatus.paused,
            cancel: state.sessionStatus != SessionStatus.paused,
            radius: size.width * 0.16,
            duration: 8000,
            loop: true,
            colorsList: [
              Colors.yellow,
              Colors.orange,
              Colors.orangeAccent,
              Colors.redAccent,
              Colors.red,
              Colors.yellow
            ],
          ),
          CustomCircularIndicator(
            radius: size.width * 0.15,
            animate: _startIndicator,
            colorStart: Colors.teal,
            colorEnd: Colors.green,
            duration: 5,
            pause: state.sessionStatus == SessionStatus.paused,
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
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        child: _buttonImage,
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
}
