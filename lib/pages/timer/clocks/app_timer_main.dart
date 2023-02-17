import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/clocks/session_countdown/session_timer.dart';
import 'package:chime/pages/timer/clocks/number_picker/set_time_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../state/app_state.dart';
import 'countdown/countdown.dart';

class AppTimerMain extends ConsumerStatefulWidget {
  const AppTimerMain({
    super.key,
  });

  @override
  ConsumerState<AppTimerMain> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimerMain> {
  bool _timerIsSet = false;
  bool _countDownHasFinished = false;
  CountdownTimer? _timer;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    switch (state.sessionState) {
      case SessionState.notStarted:
        _countDownHasFinished = false;
        _timerIsSet = false;
        _timer?.cancel();

        break;
      case SessionState.countdown:
        if (!_timerIsSet) {
          _timer = CountdownTimer(
              Duration(milliseconds: (state.totalCountdownTime * 1000)),
              const Duration(milliseconds: 1))
            ..listen((event) {
              print(event.remaining.inSeconds);
              if (event.remaining.inSeconds == 0 && !_countDownHasFinished) {
                notifier.setSessionState(SessionState.inProgress);
                _timerIsSet = false;
                _countDownHasFinished = true;
              }
              notifier.setCurrentCountdownTime(event.remaining.inSeconds);
            });

          _timerIsSet = true;
        }
        break;
      case SessionState.inProgress:
        if (!_timerIsSet) {
          if (!state.openSession) {
            var t = state.totalTimeMinutes * 60000 + 1000;
            if (state.pausedMillisecondsRemaining != 0) {
              t = state.pausedMillisecondsRemaining;
            }

            _timer = CountdownTimer(
                Duration(milliseconds: t), const Duration(milliseconds: 1))
              ..listen((event) {
                notifier
                    .setMillisecondsRemaining(event.remaining.inMilliseconds);
              });
            _timerIsSet = true;
          }
        } else {
          if (!_timerIsSet) {
            _timer =
                CountdownTimer(Duration(days: 1), Duration(milliseconds: 1))
                  ..listen((event) {
                    print(event.elapsed.inMilliseconds);
                  });
            _timerIsSet = true;
          }
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (state.sessionState == SessionState.inProgress ||
            state.sessionState == SessionState.paused ||
            state.openSession && state.sessionState != SessionState.countdown) ...[const SessionTimer()],

        if (!state.openSession &&
                state.sessionState == SessionState.notStarted ||
            state.sessionState == SessionState.ended) ...[
          const SetTimeFieldLayout(),
          //Countdown(),
        ],
        if (state.sessionState == SessionState.countdown) ...[
          const Countdown()
        ],
        if(state.openSession)...[  SizedBox(height: size.height * 0.02,)],

      ],
    );
  }
}
