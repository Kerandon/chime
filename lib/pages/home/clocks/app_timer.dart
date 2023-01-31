import 'package:chime/audio/audio_manager.dart';
import 'package:chime/pages/home/clocks/time_adjustment_icons.dart';
import 'package:chime/pages/home/clocks/time_field.dart';
import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../enums/focus_state.dart';
import '../../../state/app_state.dart';
import '../../../utils/vibration_method.dart';
import 'session_timer.dart';
import 'countdown_text.dart';

class AppTimer extends ConsumerStatefulWidget {
  const AppTimer({
    super.key,
  });

  @override
  ConsumerState<AppTimer> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimer> {
  CountdownTimer? _timer;
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  int _millisecondsRemaining = 0;
  bool _mainTimerIsSet = false;
  bool _sessionIsCompleted = false;
  bool _firstBellHasRung = false;

  void _setTimer({required Duration duration}) {
    _timer = CountdownTimer(duration, const Duration(milliseconds: 100))
      ..listen(
        (event) {
          _millisecondsRemaining = event.remaining.inMilliseconds;
          setState(() {});
        },
        onDone: () {
          _sessionIsCompleted = true;
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    _setFocus(state);

    if (state.sessionState == SessionState.notStarted) {
      _millisecondsRemaining = 0;
      _timer?.cancel();
      _mainTimerIsSet = false;
      _sessionIsCompleted = false;
      _firstBellHasRung = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setSessionHasStarted(false);
      });
    } else if (state.sessionState == SessionState.countdown) {
      if (!_mainTimerIsSet) {
        int totalSeconds = state.totalTimeMinutes * 60;

        CountdownTimer(Duration(milliseconds: (state.totalCountdownTime * 1000)),
                const Duration(milliseconds: 100))
            .listen((event) {
          notifier.setCurrentCountdownTime(event.remaining.inSeconds);
        }, onDone: () async {
              if(state.vibrateOnCompletion) {
                await vibrateDevice();
              }
          _setTimer(duration: Duration(seconds: totalSeconds + 1));
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            notifier.setSessionState(SessionState.inProgress);
            notifier.setSessionHasStarted(true);
          });
        });

        setState(() {
          _mainTimerIsSet = true;
        });
      }
    } else if (state.sessionState == SessionState.inProgress) {
      if (!_firstBellHasRung && state.bellOnSessionStart) {
        AudioManager().playBell(bell: state.bellSelected);
        _firstBellHasRung = true;
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.seMillisecondsRemaining(_millisecondsRemaining);
      });
      if (state.pausedMillisecondsRemaining != 0) {
        _setTimer(
            duration:
                Duration(milliseconds: state.pausedMillisecondsRemaining));
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.setPausedTimeMillisecondsRemaining(reset: true);
        });
      }
    } else if (state.sessionState == SessionState.paused) {
      _cancelTimer();
      _sessionIsCompleted = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_sessionIsCompleted) {
        if (state.sessionState != SessionState.notStarted) {
          notifier.setSessionState(SessionState.ended);
        }
      }
    });

    final size = MediaQuery.of(context).size;
    if (state.openSession) {
      return Text(
            'Open session',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          );
    } else {
      return Stack(
            children: [
              SizedBox(
                width: size.width * 0.90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (state.sessionState == SessionState.notStarted ||
                        state.sessionState == SessionState.ended) ...[
                      Expanded(
                        flex: 2,
                        child: TimeField(
                          focusNode: _focusNode,
                          textEditingController: _textEditingController,
                        ),
                      ),
                      const Expanded(child: TimeAdjustmentIcons())
                    ],
                    if (state.sessionState == SessionState.countdown) ...[
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      const CountdownText(),
                    ],
                    if (state.sessionState == SessionState.inProgress ||
                        state.sessionState == SessionState.paused) ...[
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      const SessionTimer()
                    ],
                  ],
                ),
              ),
            ],
          );
    }
  }

  _cancelTimer() {
    _timer?.cancel();
    setState(() {});
  }

  void _setFocus(AppState state) {
    if (!_focusNode.hasFocus) {
      _textEditingController.text = state.totalTimeMinutes.toString();
    }

    if (state.focusState == FocusState.unFocus) {
      _focusNode.unfocus();
    }
  }
}
