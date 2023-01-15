import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../state/app_state.dart';

class SessionClock extends ConsumerStatefulWidget {
  const SessionClock({
    super.key,
  });

  @override
  ConsumerState<SessionClock> createState() => _SessionClockState();
}

class _SessionClockState extends ConsumerState<SessionClock> {

  bool _sessionHasStarted = false;


  @override
  Widget build(BuildContext context) {

    final state = ref.watch(stateProvider);

    int minutes = state.totalTimeMinutes;
    int seconds = 0;

    if (state.secondsRemaining > 0 || _sessionHasStarted) {
      minutes = state.secondsRemaining ~/ 60;
      seconds = state.secondsRemaining % 60;
    }

    if(seconds > 0){
      _sessionHasStarted = true;
    }

    if(state.sessionState == SessionState.notStarted){
      _sessionHasStarted = false;
    }


    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: minutes.toString(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextSpan(
            text: seconds.toString(),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
