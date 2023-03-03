import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../configs/constants.dart';
import '../../../../enums/session_state.dart';
import '../../../../state/app_state.dart';
import 'colon.dart';
import 'number_box.dart';

class SessionTimer extends ConsumerStatefulWidget {
  const SessionTimer({
    super.key,
  });

  @override
  ConsumerState<SessionTimer> createState() => _SessionClockState();
}

class _SessionClockState extends ConsumerState<SessionTimer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    int millisecondsRemaining = state.millisecondsRemaining + 1000;
    int millisecondsElapsed = state.millisecondsElapsed  + 1000;
    int pausedMilliseconds = state.pausedMilliseconds + 1000;

    if (state.sessionState == SessionState.inProgress) {
      if (!state.openSession) {
       millisecondsRemaining;
        hours = (millisecondsRemaining ~/ 3600000);
        minutes = ((millisecondsRemaining ~/ 60000) % 60);
        seconds = ((millisecondsRemaining ~/ 1000) % 60);
      }
      if (state.openSession) {
        hours = (millisecondsElapsed  ~/ 3600000);
        minutes = ((millisecondsElapsed  ~/ 60000) % 60);
        seconds = ((millisecondsElapsed ~/ 1000) % 60);
      }
    }
    if (state.sessionState == SessionState.paused) {
      hours = (pausedMilliseconds~/ 3600000);
      minutes = ((pausedMilliseconds ~/ 60000) % 60);
      seconds = ((pausedMilliseconds ~/ 1000) % 60);
    }

    String hourL = '0';
    String hourR = '0';
    String minL = '0';
    String minR = '0';
    String secL = '0';
    String secR = '0';

    if (hours > 9) {
      hourR = hours.toString()[1];
      hourL = hours.toString()[0];

    }
    if (hours <= 9) {
      hourR = hours.toString()[0];
    }


    if (minutes > 9) {
      minR = minutes.toString()[1];
      minL = minutes.toString()[0];

    }
    if (minutes <= 9) {
      minR = minutes.toString()[0];
    }

    if (seconds > 9) {
      secR = seconds.toString()[1];
      secL = seconds.toString()[0];

    }
    if (seconds <= 9) {
      secR = seconds.toString()[0];
    }


    return SizedBox(
      height: size.height * 0.20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// SESSION TIMER
          if (state.openSession ||
              state.sessionState == SessionState.inProgress ||
              state.sessionState == SessionState.paused) ...[
            if (state.totalTimeMinutes >= 60) ...[
              NumberBox(hourL),
              NumberBox(hourR),
            ],
            if (state.totalTimeMinutes >= 60) ...[const Colon()],
            NumberBox(minL),
            NumberBox(minR),
            const Colon(),
            NumberBox(secL),
            NumberBox(secR),
          ],
        ],
      ),
    ).animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds);
  }
}
