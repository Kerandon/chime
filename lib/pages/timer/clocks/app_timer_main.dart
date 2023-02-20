import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/clocks/session_countdown/countdown_timer.dart';
import 'package:chime/pages/timer/clocks/session_countdown/session_timer.dart';
import 'package:chime/pages/timer/clocks/number_picker/set_time_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../state/app_state.dart';
import '../../completion_page.dart';

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
              Duration(
                  milliseconds: ((
                      state.totalCountdownTime * 1000
                      ) + 1000)),
              const Duration(milliseconds: 1))
            ..listen((event) {
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
          if (!state.openSession) {
            if(!_timerIsSet){
            var t = (
               // state.totalTimeMinutes * 60000
                1000
            )
                + 900;
            if (state.pausedMilliseconds != 0) {
              t = state.pausedMilliseconds;
            }

            _timer = CountdownTimer(
                Duration(milliseconds: t), const Duration(milliseconds: 1))
              ..listen((event) {
                notifier
                    .setMillisecondsRemaining(event.remaining.inMilliseconds);
              }).onDone(() {
                if(state.sessionState == SessionState.inProgress){
                  print('session done');
                  notifier.setSessionState(SessionState.ended);
                  showDialog(context: context, builder: (context) => CompletionPage()).then((value) async {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      notifier.setSessionState(SessionState.notStarted);
                      notifier.resetSession();
                    });
                  });
                }

              });
            _timerIsSet = true;
          }
        } else {
          if (!_timerIsSet) {
            /// AFTER 23 HOURS, 59 MINUTES AND 59 SECONDS (MAX)
            _timer = CountdownTimer(const Duration(seconds: 86399),
                const Duration(milliseconds: 1))
              ..listen((event) {
                print(event.elapsed.inMilliseconds);
                notifier.setMillisecondsElapsed(event.elapsed.inMilliseconds);
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

    bool showTimePicker = false;
    bool showSessionTimer = false;

    if (state.sessionState == SessionState.notStarted && !state.openSession) {
      showTimePicker = true;
    }
    if (!showTimePicker && state.sessionState != SessionState.countdown) {
      showSessionTimer = true;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showTimePicker) ...[
          const TimePickerMain(),
        ],
        if (state.sessionState == SessionState.countdown) ...[
          const CountDownTimer(),
        ],
        if (showSessionTimer) ...[
          const SessionTimer(),
        ]
      ],
    );
  }
}
