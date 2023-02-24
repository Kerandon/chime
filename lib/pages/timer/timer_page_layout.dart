import 'package:chime/configs/constants.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/start_button/start_circle_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'banner_main.dart';
import 'clocks/app_timer_main.dart';
import '../../state/app_state.dart';

class TimerPageLayout extends ConsumerStatefulWidget {
  const TimerPageLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerPageLayout> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPageLayout> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(stateProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (appState.sessionState == SessionState.countdown) ...[
            Align(
                    alignment: const Alignment(0, -0.80),
                    child: Text(
                      kSessionWillBeginShortly,
                      style: Theme.of(context).textTheme.bodySmall,
                    ))
                .animate()
                .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds)
          ],
          Column(
            children: [
              SizedBox(
                height: size.height * 0.30,
                child: const AppTimerMain()
                    .animate()
                    .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds),
              ),
              SizedBox(
                height: size.height * 0.50,
                width: size.width,
                child: const Center(
                  child: StartButtonMain(),
                ),
              ),
            ],
          ),
          const BannerMain(),
        ],
      ),
    );
  }


}
