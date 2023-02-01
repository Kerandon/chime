import 'dart:async';

import 'package:chime/audio/audio_manager.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/clocks/set_time_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../state/app_state.dart';
import 'countdown.dart';
import 'session_timer.dart';

class AppTimerMain extends ConsumerStatefulWidget {
  const AppTimerMain({
    super.key,
  });

  @override
  ConsumerState<AppTimerMain> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimerMain> {
  CountdownTimer? _timer;
  int _millisecondsRemaining = 0;
  bool _mainTimerIsSet = false;
  bool _sessionIsCompleted = false;
  bool _firstBellHasRung = false;

  void _setTimer({required Duration duration}) {
    print('set timer');
    _millisecondsRemaining = duration.inMilliseconds;
    // setState(() {
    //
    // });
    Timer(Duration(milliseconds: 2000), () {

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
    });

  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

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

        CountdownTimer(
                Duration(milliseconds: ((state.totalCountdownTime * 1000) + 990)),
                const Duration(milliseconds: 50))
            .listen((event) {
          notifier.setCurrentCountdownTime(event.remaining.inSeconds);
        }, onDone: () async {
          _setTimer(duration: Duration(seconds: totalSeconds));
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state.sessionState == SessionState.notStarted ||
                    state.sessionState == SessionState.ended) ...[
                  SetTimeFieldLayout(),
                  //Countdown(),
                ],
                if (state.sessionState == SessionState.countdown) ...[
                  const Countdown()
                ],
                if (state.sessionState == SessionState.inProgress ||
                    state.sessionState == SessionState.paused) ...[
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
}
