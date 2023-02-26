import 'package:chime/animation/slide_animation.dart';
import 'package:chime/configs/constants.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';
import '../../../state/audio_state.dart';
import '../../../state/database_manager.dart';
import 'ambience/ambience_page.dart';
import 'bells/bell_dialog.dart';
import 'custom_home_button.dart';

class BannerMain extends ConsumerStatefulWidget {
  const BannerMain({
    super.key,
  });

  @override
  ConsumerState<BannerMain> createState() => _BannerMainState();
}

class _BannerMainState extends ConsumerState<BannerMain> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding.top;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioState = ref.watch(audioProvider);
    String bellText = _setBellText(audioState);

    bool sessionUnderWay = false;
    if (appState.sessionState != SessionState.notStarted) {

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        appNotifier.setHomePageTabsStatus(false);
        appNotifier.setAnimateHomePage(false);
      });


      sessionUnderWay = true;
    }

    return Stack(
      children: [
        Align(
          alignment: appState.currentPage != 0 ? const Alignment(0, -2) : Alignment.topCenter,
          child: IgnorePointer(
            ignoring: appState.sessionState != SessionState.notStarted ,
            child: SafeArea(
              child: SlideAnimation(
                animate: !appState.homePageTabsAreOpen && appState.animateHomePage || sessionUnderWay,
                reverse: appState.homePageTabsAreOpen && appState.animateHomePage || sessionUnderWay,
                duration: kHomePageAnimationDuration,
                customTween: Tween<Offset>(begin: const Offset(0,-1), end: const Offset(0,-0)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).splashColor.withOpacity(0.50),
                      width: 1,
                    ),
                  )),
                  width: size.width,
                  height: kToolbarHeight * 0.80,
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
                        onPressed: () async => appNotifier.setOpenSession(!appState.openSession),
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
              ),
            ),
          ),
        ),
        Positioned(
          child: Container(
            color: Theme.of(context).canvasColor,
            height: padding,
            width: size.width,
          ),
        ),
      ],
    );
  }

  String _setBellText(AudioState audioState) {
    String bellText = "";

    if (audioState.bellInterval == 0.50) {
      bellText = 'every 30s';
    } else if (audioState.bellInterval == 0) {
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
    } else {
      bellText = 'Every ${audioState.bellInterval.toInt().formatToHourMin()}';
    }
    return bellText;
  }
}
