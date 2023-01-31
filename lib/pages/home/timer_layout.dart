import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../animation/fade_in_animation.dart';
import 'clocks/app_timer.dart';
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 70,
                child: FadeInAnimation(child: AppTimer()),
              ),
              const Expanded(
                flex: 50,
                child: StartButton(),
              ),
              Expanded(
                  flex: 40,
                  child: sessionIsUnderway
                      ? const SizedBox.shrink()
                      : const FadeInAnimation(child: IntervalDropdown())),
            ],
          ),
        ],
      ),
    );
  }
}
