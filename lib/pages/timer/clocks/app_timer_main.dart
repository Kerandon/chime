import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/clocks/session_countdown/countdown_timer.dart';
import 'package:chime/pages/timer/clocks/session_countdown/session_timer.dart';
import 'package:chime/pages/timer/clocks/number_picker/set_time_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../configs/constants.dart';
import '../../../state/app_state.dart';
import '../../../state/database_manager.dart';
import '../../completion_page/completion_page.dart';

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
  bool _endSessionNotified = false;
  CountdownTimer? _timer;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    switch (state.sessionState) {
      case SessionState.notStarted:
        _countDownHasFinished = false;
        _timerIsSet = false;
        _endSessionNotified = false;
        _timer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          notifier.resetSession();
        });


        break;
      case SessionState.countdown:
        if (!_timerIsSet) {
          _timer = CountdownTimer(
              Duration(
                  milliseconds: ((state.totalCountdownTime * 1000) + 1000)),
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
        if (!_timerIsSet) {
          if (!state.openSession) {
            int time = state.totalTimeMinutes;
            if (state.pausedMilliseconds != 0) {
              time = state.pausedMilliseconds;
            }
            var t = (
               time * 60000
                //1000
            ) + kAdditionalStartTime;
            if (state.pausedMilliseconds != 0) {
              t = state.pausedMilliseconds;
            }

            _timer = CountdownTimer(
                Duration(milliseconds: t), const Duration(milliseconds: 1))
              ..listen((event) {
                notifier
                    .setMillisecondsRemaining(event.remaining.inMilliseconds);
                if (event.remaining.inSeconds == 0) {
                  if (!_endSessionNotified) {
                    DatabaseManager().insertIntoStats(dateTime: DateTime.now(), minutes: state.totalTimeMinutes);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      showDialog(
                          context: context,
                          builder: (context) => const CompletionPage())
                          .then((value) async {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          notifier.setSessionState(SessionState.notStarted);
                          notifier.resetSession();
                        });
                      });

                      notifier.setSessionState(SessionState.ended);
                    });
                    _endSessionNotified = true;
                  }
                }
              });
            _timerIsSet = true;
          }
          else {

            /// AFTER 23 HOURS, 59 MINUTES AND 59 SECONDS (MAX)


            _timer = CountdownTimer(
                const Duration(seconds: 86399000), const Duration(milliseconds: 1))
              ..listen((event) {
                notifier.setMillisecondsElapsed((event.elapsed.inMilliseconds + state.pausedMilliseconds));
              });
            _timerIsSet = true;
          }
        }

        break;
      case SessionState.paused:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _timer?.cancel();
          _timerIsSet = false;
        });
        break;
      case SessionState.ended:

        _timer?.cancel();
        break;
    }

    print('session state is ${state.sessionState}');

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
