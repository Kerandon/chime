import 'dart:async';

import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/clocks/session_countdown/session_timer.dart';
import 'package:chime/pages/timer/clocks/set_time_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../state/app_state.dart';
import 'clocks/countdown/countdown.dart';

class AppTimerMain extends ConsumerStatefulWidget {
  const AppTimerMain({
    super.key,
  });

  @override
  ConsumerState<AppTimerMain> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimerMain> {
  bool _timerIsSet = false;
  CountdownTimer? _timer;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    switch (state.sessionState) {
      case SessionState.notStarted:
        _timerIsSet = false;
        _timer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.setSessionStopped(false);
        });
        break;
      case SessionState.countdown:
        if (!_timerIsSet) {
          _timer = CountdownTimer(
              Duration(milliseconds: (state.totalCountdownTime * 1000)),
              const Duration(milliseconds: 1))
            ..listen((event) {
              notifier.setCurrentCountdownTime(event.remaining.inSeconds);
            }).onDone(() {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (!state.sessionStopped) {
                  notifier.setSessionState(SessionState.inProgress);
                }

                _timerIsSet = false;
              });
            });

          _timerIsSet = true;
        }
        break;
      case SessionState.inProgress:
        if (!_timerIsSet) {
          var t = state.totalTimeMinutes * 60000 + 1000;
          if (state.pausedMillisecondsRemaining != 0) {
            t = state.pausedMillisecondsRemaining;
          }

          _timer = CountdownTimer(
              Duration(milliseconds: t), const Duration(milliseconds: 1))
            ..listen((event) {
              notifier.setMillisecondsRemaining(event.remaining.inMilliseconds);
            });
          _timerIsSet = true;
        }

        break;
      case SessionState.paused:
        _timer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.setPausedTimeMillisecondsRemaining();
        });
        _timerIsSet = false;
        break;
      case SessionState.ended:
        // TODO: Handle this case.
        break;
    }

    print(
        'SESSION STATE ${state.sessionState} and total min ${state.totalTimeMinutes} '
        'and curretn time ${state.millisecondsRemaining} AND current countdown'
        'min ${state.currentCountdownTime}');

    if (state.openSession) {
      return Center(
        child: Text(
          'Open session',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (state.sessionState == SessionState.notStarted ||
                  state.sessionState == SessionState.ended) ...[
                const SetTimeFieldLayout(),
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
        ],
      );
    }
  }
}
