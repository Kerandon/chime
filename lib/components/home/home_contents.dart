import 'package:chime/animation/flip_animation.dart';
import 'package:chime/components/home/start_button/start_button.dart';
import 'package:chime/components/home/streak_counter.dart';
import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../animation/fade_in_animation.dart';
import '../../state/app_state.dart';
import 'ambience_display.dart';
import 'clocks/app_timer.dart';
import 'interval_dropdown.dart';

class HomePageContents extends ConsumerStatefulWidget {
  const HomePageContents({
    super.key,
  });

  @override
  ConsumerState<HomePageContents> createState() => _HomePageContentsState();
}

class _HomePageContentsState extends ConsumerState<HomePageContents> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    bool sessionUnderway = false;
    if (state.sessionState == SessionState.countdown ||
        state.sessionState == SessionState.inProgress ||

        state.sessionState == SessionState.paused){
      sessionUnderway = true;
    }
      return Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 10,
                    child:  sessionUnderway ? SizedBox.shrink() : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AmbienceDisplay(),
                        StreakCounter(),
                      ],
                    )),
                const Expanded(
                    flex: 35, child: FadeInAnimation(child: AppTimer())),
                const Expanded(
                  flex: 80,
                  child: FlipAnimation(child: StartButton()),
                ),
                Expanded(
                    flex: 40,
                    child: sessionUnderway ? SizedBox.shrink() : FadeInAnimation(child: IntervalDropdown())),
              ],
            ),
          ],
        ),
      );
  }
}
