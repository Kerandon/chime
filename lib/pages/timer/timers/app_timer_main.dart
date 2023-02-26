import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/timers/session_countdown/countdown_timer.dart';
import 'package:chime/pages/timer/timers/session_countdown/session_timer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../state/app_state.dart';
import '../../../state/database_manager.dart';
import '../../completion_page/completion_page.dart';
import 'number_picker/set_time_layout.dart';

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
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    switch (appState.sessionState) {
      case SessionState.notStarted:
        _countDownHasFinished = false;
        _timerIsSet = false;
        _endSessionNotified = false;
        _timer?.cancel();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          appNotifier.resetSession();
        });

        break;
      case SessionState.countdown:
        if (!_timerIsSet) {
          _timer = CountdownTimer(
              Duration(
                  milliseconds: ((appState.totalCountdownTime * 1000) + 1000)),
              const Duration(milliseconds: 1))
            ..listen((event) {
              if (event.remaining.inSeconds == 0 && !_countDownHasFinished) {
                appNotifier.setSessionState(SessionState.inProgress);
                _timerIsSet = false;
                _countDownHasFinished = true;
              }
              appNotifier.setCurrentCountdownTime(event.remaining.inSeconds);

            });

          _timerIsSet = true;
        }
        break;
      case SessionState.inProgress:
        if (!_timerIsSet) {
          if (!appState.openSession) {
            int time = appState.totalTimeMinutes;
            if (appState.pausedMilliseconds != 0) {
              time = appState.pausedMilliseconds;
            }
            var t = (time * 60000
                );
            if (appState.pausedMilliseconds != 0) {
              t = appState.pausedMilliseconds;
            }

            _timer = CountdownTimer(
                Duration(milliseconds: t), const Duration(milliseconds: 1))
              ..listen((event) {


                appNotifier
                    .setMillisecondsRemaining(event.remaining.inMilliseconds);
                appNotifier.setMillisecondsElapsed(event.elapsed.inMilliseconds + appState.pausedMilliseconds);
                if (event.remaining.inSeconds == 0) {
                  if (!_endSessionNotified) {
                    DatabaseManager().insertIntoStats(
                        dateTime: DateTime.now(),
                        minutes: appState.totalTimeMinutes);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      showDialog(
                              context: context,
                              builder: (context) => const CompletionPage())
                          .then((value) async {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          appNotifier.setSessionState(SessionState.notStarted);
                          appNotifier.resetSession();
                        });
                      });

                      appNotifier.setSessionState(SessionState.ended);
                    });
                    _endSessionNotified = true;
                  }
                }
              });
            _timerIsSet = true;
          } else {
            /// AFTER 23 HOURS, 59 MINUTES AND 59 SECONDS (MAX)

            _timer = CountdownTimer(const Duration(seconds: 86399000),
                const Duration(milliseconds: 1))
              ..listen((event) {

                appNotifier.setMillisecondsRemaining(event.remaining.inMilliseconds);


                appNotifier.setMillisecondsElapsed(
                    (event.elapsed.inMilliseconds +
                        appState.pausedMilliseconds));



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

    bool showTimePicker = false;
    bool showSessionTimer = false;

    if (appState.sessionState == SessionState.notStarted &&
        !appState.openSession) {
      showTimePicker = true;
    }
    if (!showTimePicker && appState.sessionState != SessionState.countdown) {
      showSessionTimer = true;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showTimePicker) ...[
          const TimePickerMain(),
        ],
        if (appState.sessionState == SessionState.countdown) ...[
          const CountDownTimer(),
        ],
        if (showSessionTimer) ...[
          const SessionTimer(),
        ]
      ],
    );
  }
}
