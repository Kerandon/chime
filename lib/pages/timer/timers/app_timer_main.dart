import 'dart:async';

import 'package:chime/animation/fade_in_animation.dart';
import 'package:chime/audio/audio_manager_new.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/timers/session_countdown/countdown_timer.dart';
import 'package:chime/pages/timer/timers/session_countdown/session_timer.dart';
import 'package:chime/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../configs/constants.dart';
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
  bool _initialAmbienceSet = false;
  CountdownTimer? _timer;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioState = ref.watch(audioProvider);

    switch (appState.sessionState) {
      case SessionState.notStarted:
        _countDownHasFinished = false;
        _timerIsSet = false;
        _endSessionNotified = false;
        _initialAmbienceSet = false;
        _timer?.cancel();

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          appNotifier.resetSession();
        });

        break;
      case SessionState.countdown:
        if (!_timerIsSet) {
          _timer = CountdownTimer(
              Duration(milliseconds: ((appState.totalCountdownTime * 1000) + 1000)),
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
        if(audioState.ambienceIsOn) {
          if (!_initialAmbienceSet) {
            AudioManagerAmbience().playAmbience(
                ambience: audioState.ambienceSelected,
                volume: audioState.ambienceVolume);
            _initialAmbienceSet = true;
          } else {
            AudioManagerAmbience().resumeAmbience();
          }
        }

        if (!_timerIsSet) {
          if (!appState.openSession) {

            //////////// FIXED TIME

            int time = appState.totalTimeMinutes;
            var t = (time * 60000);
            if (appState.pausedMillisecondsElapsed != 0) {
              t = appState.pausedMillisecondsElapsed;
            }

            _timer = CountdownTimer(
                Duration(milliseconds: t), const Duration(milliseconds: 1))
              ..listen((event) {
                appNotifier.setMillisecondsElapsed(
                    event.elapsed.inMilliseconds
                        + appState.pausedMillisecondsElapsed
                    );
                if (event.elapsed.inSeconds == (appState.totalTimeMinutes * 60)) {
                  if (!_endSessionNotified) {
                    Timer(const Duration(milliseconds: 1500), () {
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
                            appNotifier
                                .setSessionState(SessionState.notStarted);
                            appNotifier.resetSession();
                          });
                        });

                        appNotifier.setSessionState(SessionState.ended);
                      });
                    });

                    _endSessionNotified = true;
                  }
                }
              });
            _timerIsSet = true;
          } else {
            //////// AFTER 23 HOURS, 59 MINUTES AND 59 SECONDS (MAX)

            _timer = CountdownTimer(const Duration(seconds: 86399000),
                const Duration(milliseconds: 1))
              ..listen((event) {

                appNotifier.setMillisecondsElapsed(
                    (event.elapsed.inMilliseconds
                        + appState.pausedMillisecondsElapsed
                    ));
              });
            _timerIsSet = true;
          }
        }

        break;
      case SessionState.paused:
        AudioManagerAmbience().pauseAmbience();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _timer?.cancel();
          _timerIsSet = false;
        });
        break;
      case SessionState.ended:
        AudioManagerAmbience().stopAmbience();
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

    return FadeInAnimation(
      durationMilliseconds:  kIntroAnimationDuration,
      animateOnDemand: appState.appHasLoaded,
      beginScale: appState.introAnimationHasRun ? 1 : 0.90,
      beginOpacity: appState.introAnimationHasRun ? 1 : 0,
      child: Column(
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
      ),
    );
  }
}
