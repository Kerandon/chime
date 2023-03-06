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

    int millisecondsElapsed = state.millisecondsElapsed;

    if (state.sessionState == SessionState.inProgress) {

      if (!state.openSession) {
        final millisecondsRemaining =
            ((state.totalTimeMinutes * 60000) - (millisecondsElapsed - 1000));

        hours = (millisecondsRemaining ~/ 3600000);
        minutes = ((millisecondsRemaining ~/ 60000) % 60);
        seconds = ((millisecondsRemaining ~/ 1000) % 60);

      } else {
        hours = (millisecondsElapsed ~/ 3600000);
        minutes = ((millisecondsElapsed ~/ 60000) % 60);
        seconds = ((millisecondsElapsed ~/ 1000) % 60);
      }
    }
    if (state.sessionState == SessionState.paused) {
      if (!state.openSession) {
        final pausedMillisecondsRemaining = ((state.totalTimeMinutes * 60000) -
            state.pausedMillisecondsElapsed + 1000);
        hours = (pausedMillisecondsRemaining ~/ 3600000);
        minutes = ((pausedMillisecondsRemaining ~/ 60000) % 60);
        seconds = ((pausedMillisecondsRemaining ~/ 1000) % 60);
      }else{
        hours = (state.pausedMillisecondsElapsed ~/ 3600000);
        minutes = ((state.pausedMillisecondsElapsed ~/ 60000) % 60);
        seconds = ((state.pausedMillisecondsElapsed ~/ 1000) % 60);
      }
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
          if (state.openSession || state.totalTimeMinutes >= 60) ...[
            NumberBox(hourL),
            NumberBox(hourR),
            const Colon()
          ],
          if (state.totalTimeMinutes >= 60) ...[],
          NumberBox(minL),
          NumberBox(minR),
          const Colon(),
          NumberBox(secL),
          NumberBox(secR),
        ],
      ),
    ).animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds);
  }
}
