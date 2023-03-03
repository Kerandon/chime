import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../animation/slide_animation.dart';
import '../../enums/session_state.dart';
import '../../enums/slide_direction.dart';


class HomePageTabArrow extends ConsumerWidget {
  const HomePageTabArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    // final tabState = ref.read(tabProvider);
    // final tabNotifier = ref.watch(tabProvider.notifier);
    bool sessionUnderWay = false;
    if (appState.sessionState != SessionState.notStarted) {
      sessionUnderWay = true;
    }
    return sessionUnderWay ? const SizedBox.shrink() : Align(
      alignment:  appState.currentPage != 0 ?
        const Alignment(0, 2) :  const Alignment(0, 0.85),
      child: SlideAnimation(
        animate: !appState.homePageTabsAreOpen && appState.animateHomePage,
        reverse: appState.homePageTabsAreOpen && appState.animateHomePage,
        direction: SlideDirection.upIn,
        duration: 220,
        customTween: Tween<Offset>(
            begin: const Offset(0, 0.80), end: const Offset(0, 0)),
        animationCompleted: (open) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        appNotifier.setHomePageTabsOpen(open);
      });
        },
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 220),
          turns:appState.homePageTabsAreOpen ? 0.50 : 0,
          child: IconButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500)),
              side: BorderSide.none,
            ),
            icon: const Icon(
              FontAwesomeIcons.angleUp,
              size: 30,
            ),
            onPressed: () {
                appNotifier.setAnimateHomePage(true);
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  appNotifier.setAnimateHomePage(false);
                });
            }
          ),
        ),
      ),
    );
  }
}
