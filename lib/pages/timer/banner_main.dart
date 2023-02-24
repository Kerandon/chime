import 'package:chime/configs/constants.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../configs/app_colors.dart';
import '../../enums/prefs.dart';
import '../../state/app_state.dart';
import '../../state/audio_state.dart';
import '../../state/database_manager.dart';
import 'banner_settings/ambience/ambience_page.dart';
import 'banner_settings/bells/bell_dialog.dart';
import 'banner_settings/custom_home_button.dart';

class BannerMain extends ConsumerWidget {
  const BannerMain({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(stateProvider);
    final appNotifier = ref.read(stateProvider.notifier);
    final audioState = ref.watch(audioProvider);
    String bellText = _setBellText(audioState);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(kBorderRadius * 2),
            bottomRight: Radius.circular(kBorderRadius * 2)),
        color: appState.sessionState == SessionState.notStarted ? AppColors.darkGrey : Colors.transparent,
      ),
      height: size.height * 0.08,
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
                  context: context, builder: (context) => const BellDialog());
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
              await DatabaseManager().insertIntoPrefs(
                  k: Prefs.isOpenSession.name, v: !appState.openSession);
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
    );
  }

  String _setBellText(AudioState audioState) {
    String bellText =
        'Every ${audioState.bellInterval.toInt().formatToHourMin()}';
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
