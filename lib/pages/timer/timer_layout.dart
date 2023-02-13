import 'package:chime/pages/timer/timed_or_open_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'clocks/app_timer_main.dart';
import 'interval_dropdown/interval_dropdown.dart';
import 'start_button/start_button.dart';
import '../../enums/session_state.dart';
import '../../state/app_state.dart';

class TimerLayout extends ConsumerStatefulWidget {
  const TimerLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerLayout> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerLayout> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    bool sessionIsUnderway = false;
    if (state.sessionState == SessionState.countdown ||
        state.sessionState == SessionState.inProgress ||
        state.sessionState == SessionState.paused) {
      sessionIsUnderway = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const TimedOrOpenButton(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 30,
                child: const AppTimerMain().animate().fadeIn()
              ),
              const Expanded(
                flex: 30,
                child: StartButton(),
              ),
              Expanded(
                  flex: 10,
                  child: sessionIsUnderway
                      ? const SizedBox.shrink()
                      : const IntervalDropdown()).animate().fadeIn()
            ],
          ),
        ],
      ),
    );
  }
}
