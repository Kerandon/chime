import 'package:chime/configs/constants.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/start_button/start_circle_main.dart';
import 'package:chime/pages/timer/timers/app_timer_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../state/app_state.dart';

class TimerPageLayout extends ConsumerStatefulWidget {
  const TimerPageLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerPageLayout> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPageLayout> {

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);


    return Scaffold(
      body: Stack(
        children: [
          if (appState.sessionState == SessionState.countdown) ...[
            Align(
                    alignment: const Alignment(0, -0.85),
                    child: Text(
                      kSessionWillBeginShortly,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))
                .animate()
                .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds)
          ],
          Column(
            children: [
              const SizedBox(height: kToolbarHeight,),
              const AppTimerMain()
                  .animate()
                  .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds),
              const StartButtonMain(),
            ],
          ),
        ],
      ),
    );
  }


}
