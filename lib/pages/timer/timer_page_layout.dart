import 'package:chime/configs/constants.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/start_button/start_circle_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'banner_settings/ambience/ambience_page.dart';
import 'banner_settings/bells/bell_dialog.dart';
import 'banner_settings/custom_home_button.dart';
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
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    String bellText = _setBellText(state);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (state.sessionState == SessionState.countdown) ...[
            Align(
                    alignment: const Alignment(0, -0.40),
                    child: Text(
                      kSessionWillBeginShortly,
                      style: Theme.of(context).textTheme.bodySmall,
                    ))
                .animate()
                .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds)
          ],
          Column(
            children: [
              Container(
                height: size.height * 0.30,
                child: const AppTimerMain()
                    .animate()
                    .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds),
              ),
              Container(
                height: size.height * 0.50,
                width: size.width,
                child: const Center(
                  child: StartButtonMain(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomHomeButton(
                  text: bellText,
                  iconData: !state.bellOnSessionStart &&
                          !state.bellOnSessionEnd &&
                          state.selectedIntervalBellTime == 0
                      ? FontAwesomeIcons.solidBellSlash
                      : FontAwesomeIcons.bell,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => const BellDialog());
                  },
                  alignment: const Alignment(-0.95, -0.98),
                ),
                CustomHomeButton(
                  text: state.openSession ? 'Open time' : 'Fixed time',
                  increaseSpacing: state.openSession ? true : false,
                  iconData: state.openSession
                      ? FontAwesomeIcons.infinity
                      : Icons.timer_outlined,
                  onPressed: () {
                    notifier.setOpenSession();
                  },
                  alignment: const Alignment(0.95, -0.98),
                ),
                CustomHomeButton(
                  text: 'Ambience',
                  iconData: state.ambienceIsOn
                      ? Icons.piano_outlined
                      : Icons.piano_off_outlined,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AmbiencePage()));
                  },
                  alignment: const Alignment(0.95, -0.98),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _setBellText(AppState state) {
    String bellText = 'every ${state.selectedIntervalBellTime.toString()}m';
    if (state.selectedIntervalBellTime == 0) {
      if (state.bellOnSessionStart && state.bellOnSessionEnd) {
        bellText = 'begin & end';
      }
      if (state.bellOnSessionStart && !state.bellOnSessionEnd) {
        bellText = 'begin only';
      }
      if (!state.bellOnSessionStart && state.bellOnSessionEnd) {
        bellText = 'end only';
      }
      if (!state.bellOnSessionStart && !state.bellOnSessionEnd) {
        bellText = ' no bells';
      }
    }
    return bellText;
  }
}
