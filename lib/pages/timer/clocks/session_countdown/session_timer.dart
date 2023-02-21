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
    final state = ref.watch(stateProvider);

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (state.sessionState == SessionState.inProgress) {
      if (!state.openSession) {
        hours = (state.millisecondsRemaining ~/ 3600000);
        minutes = ((state.millisecondsRemaining ~/ 60000) % 60);
        seconds = ((state.millisecondsRemaining ~/ 1000) % 60);
      }
      if (state.openSession) {
        hours = (state.millisecondsElapsed ~/ 3600000);
        minutes = ((state.millisecondsElapsed ~/ 60000) % 60);
        seconds = ((state.millisecondsElapsed ~/ 1000) % 60);
      }
    }
    if (state.sessionState == SessionState.paused) {
      hours = (state.pausedMilliseconds ~/ 3600000);
      minutes = ((state.pausedMilliseconds ~/ 60000) % 60);
      seconds = ((state.pausedMilliseconds ~/ 1000) % 60);
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
            if (state.totalTimeMinutes >= 60) ...[NumberBox(hours)],
            if (state.totalTimeMinutes >= 60) ...[const Colon()],
            NumberBox(minutes),
            const Colon(),
            NumberBox(seconds),
          ],
        ],
      ),
    ).animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds);
  }
}
