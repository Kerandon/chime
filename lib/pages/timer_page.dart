import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../animation/fade_in_animation.dart';
import '../animation/flip_animation.dart';
import '../components/home/clocks/app_timer.dart';
import '../components/home/interval_dropdown.dart';
import '../components/home/start_button/start_button.dart';
import '../enums/session_state.dart';
import '../state/app_state.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    bool _sessionIsUnderway = false;
    if (state.sessionState == SessionState.countdown ||
        state.sessionState == SessionState.inProgress ||
        state.sessionState == SessionState.paused) {
      _sessionIsUnderway = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 50,
                child: FadeInAnimation(child: AppTimer()),
              ),
              const Expanded(
                flex: 80,
                child: FlipAnimation(child: StartButton()),
              ),
              Expanded(
                  flex: 30,
                  child: _sessionIsUnderway
                      ? const SizedBox.shrink()
                      : const FadeInAnimation(child: IntervalDropdown())),
            ],
          ),
        ],
      ),
    );
  }
}
