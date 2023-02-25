import 'package:chime/pages/guide_page.dart';
import 'package:chime/pages/settings/settings_page.dart';
import 'package:chime/pages/stats/stats_page.dart';
import 'package:chime/pages/timer/banner_settings/banner_main.dart';
import 'package:chime/pages/timer/stop_button.dart';
import 'package:chime/pages/timer/timer_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../animation/slide_animation.dart';
import '../../audio/audio_manager.dart';
import '../../configs/constants.dart';
import '../../enums/session_state.dart';
import '../../enums/slide_direction.dart';
import '../../state/app_state.dart';
import 'home_page_tab_arrow.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomePageContentsState();
}

class _HomePageContentsState extends ConsumerState<Home> {
  static const List<Widget> _pageOptions = [
    TimerPageLayout(),
    SettingsPage(),
    StatsPage(),
    GuidePage(),
  ];

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);

    bool sessionUnderWay = false;
    if (state.sessionState == SessionState.countdown ||
        state.sessionState == SessionState.inProgress) {
      sessionUnderWay = true;
    }
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.black,
            child: SafeArea(
              child: _pageOptions.elementAt(state.currentPage),
            ),
          ),
          bottomNavigationBar: IgnorePointer(
            ignoring: state.sessionState != SessionState.notStarted,
            child: SlideAnimation(
              animate: (!state.homePageTabsAreOpen && state.animateHomePage) ||
                  sessionUnderWay,
              reverse: (state.homePageTabsAreOpen && state.animateHomePage) ||
                  sessionUnderWay,
              direction: SlideDirection.upIn,
              duration: kHomePageAnimationDuration,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.timer_outlined),
                    label: 'Timer',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    label: 'Settings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart_outlined),
                    label: 'Stats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    label: 'Guidance',
                  ),
                ],
                currentIndex: state.currentPage,
                onTap: (index) {
                  notifier.setPage(index);
                },
              ),
            ),
          ),
        ),
        const AudioManager(),
        const Align(
          alignment: Alignment(0, 0.96),
          child: StopButton(),
        ),
        const BannerMain(),
        const HomePageTabArrow(),
      ],
    );
  }
}
