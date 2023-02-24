import 'package:chime/configs/constants.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/timer/start_button/start_circle_main.dart';
import 'package:chime/state/audio_state.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/prefs.dart';
import '../../state/database_manager.dart';
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
    final appState = ref.watch(stateProvider);
    final appNotifier = ref.read(stateProvider.notifier);
    final audioState = ref.watch(audioProvider);

    String bellText = _setBellText(audioState);

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
          SizedBox(
            height: size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomHomeButton(
                  text: bellText,
                  iconData: !audioState.bellOnStart &&
                          !audioState.bellOnEnd &&
                      audioState.bellInterval == 0
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
                  text: appState.openSession ? 'Open time' : 'Fixed time',
                  increaseSpacing: appState.openSession ? true : false,
                  iconData: appState.openSession
                      ? FontAwesomeIcons.infinity
                      : Icons.timer_outlined,
                  onPressed: () async {
                    appNotifier.setOpenSession(!appState.openSession);
                    await DatabaseManager().insertIntoPrefs(k: Prefs.isOpenSession.name, v: !appState.openSession);
                  },
                  alignment: const Alignment(0.95, -0.98),
                ),
                CustomHomeButton(
                  text: 'Ambience',
                  iconData: audioState.ambienceIsOn
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
          ),
        ],
      ),
    );
  }

  String _setBellText(AudioState audioState) {
    String bellText = 'Every ${audioState.bellInterval.toInt().formatToHourMin()}';
    if (audioState.bellInterval == 0) {
      if (audioState.bellOnStart && audioState.bellOnEnd) {
        bellText = 'Begin & end';
      }
      if (audioState.bellOnStart && !audioState.bellOnEnd) {
        bellText = 'Begin only';
      }
      if (!audioState.bellOnStart && audioState.bellOnEnd) {
        bellText = 'End only';
      }
      if (!audioState.bellOnStart && !audioState.bellOnEnd) {
        bellText = ' Interval bells';
      }
    }
    return bellText;
  }
}
