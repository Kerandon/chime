import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../configs/constants.dart';
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
  bool _sessionHasStarted = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (state.millisecondsRemaining > 0 || _sessionHasStarted) {
      hours = (state.millisecondsRemaining ~/ 3600000);
      minutes = ((state.millisecondsRemaining ~/ 60000) % 60);
      seconds = ((state.millisecondsRemaining ~/ 1000) % 60);
    }

    if (seconds > 0) {
      _sessionHasStarted = true;
    }

    if (state.sessionState == SessionState.notStarted) {
      _sessionHasStarted = false;
    }

    return Center(
      child: SizedBox(
        height: size.height * kClocksHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(state.totalTimeMinutes >= 60) ... [ NumberBox(hours)],
            if(state.totalTimeMinutes >= 60) ... [ Colon() ],
            NumberBox(minutes),
            Colon(),
            NumberBox(seconds),

          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.milliseconds);
  }
}
