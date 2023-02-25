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
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    bool sessionUnderWay = false;
    if (state.sessionState != SessionState.notStarted) {
      sessionUnderWay = true;
    }
    return sessionUnderWay ? const SizedBox.shrink() : Align(
      alignment:  state.currentPage != 0 ?
        const Alignment(0, 2) :  const Alignment(0, 0.85),
      child: SlideAnimation(
        animate: !state.homePageTabsAreOpen && state.animateHomePage,
        reverse: state.homePageTabsAreOpen && state.animateHomePage,
        direction: SlideDirection.upIn,
        duration: 220,
        customTween: Tween<Offset>(
            begin: const Offset(0, 0.80), end: const Offset(0, 0)),
        animationCompleted: (open) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            notifier.setHomePageTabsStatus(open);
          });
        },
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 220),
          turns: state.homePageTabsAreOpen ? 0.50 : 0,
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
              notifier.setAnimateHomePage(true);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                notifier.setAnimateHomePage(false);
              });
            },
          ),
        ),
      ),
    );
  }
}
