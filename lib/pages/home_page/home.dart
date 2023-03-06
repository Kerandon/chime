import 'package:chime/enums/time_period.dart';
import 'package:chime/pages/guide_page.dart';
import 'package:chime/pages/settings/settings_page.dart';
import 'package:chime/pages/stats/stats_page.dart';
import 'package:chime/pages/timer/banner_settings/banner_main.dart';
import 'package:chime/pages/timer/stop_button.dart';
import 'package:chime/pages/timer/timer_page_layout.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../animation/slide_animation.dart';
import '../../audio/audio_manager_bells.dart';
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

  late bool _animateBottomBarAfterMeditationPageClose;

  @override
  void initState() {
    _animateBottomBarAfterMeditationPageClose = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    if (!_animateBottomBarAfterMeditationPageClose &&
        appState.currentPage == 2) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        appNotifier.setHomePageTabsOpen(false);
        appNotifier.setAnimateHomePage(true);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          appNotifier.setAnimateHomePage(false);
        });
      });
      _animateBottomBarAfterMeditationPageClose = true;
    }

    bool sessionUnderWay = false;
    if (appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.inProgress) {
      sessionUnderWay = true;
    }

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.black,
            child: SafeArea(
              child: _pageOptions.elementAt(appState.currentPage),
            ),
          ),
          bottomNavigationBar: IgnorePointer(
            ignoring: appState.sessionState != SessionState.notStarted,
            child: SlideAnimation(
              animate: ((!appState.homePageTabsAreOpen &&
                      appState.animateHomePage) ||
                  sessionUnderWay),
              reverse:
                  (appState.homePageTabsAreOpen && appState.animateHomePage) ||
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
                currentIndex: appState.currentPage,
                onTap: (index) {
                  appNotifier.setPage(index);
                },
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(0, 0.96),
          child: StopButton(),
        ),
        const BannerMain(),
        const HomePageTabArrow(),
        const AudioManagerBells(),
        Align(
          alignment: const Alignment(0, 0.50),
          child: ElevatedButton(
              onPressed: () async {
                await DatabaseManager().insertIntoStats(
                    dateTime: DateTime(2021, 02, 15), minutes: 80);
              },
              child: const Text('Insert into DB')),
        ),
        ElevatedButton(
          onPressed: () async {
            await DatabaseManager()
                .getStatsByTimePeriod(period: TimePeriod.week);
          },
          child: const SizedBox(
            width: 150,
            child: Text('get'),
          ),
        ),
        Align(
            alignment: const Alignment(0.80,0.80),
            child: Material(child: Text(' elapsed ${appState.millisecondsElapsed.toString()}'))),
        Align(
            alignment: const Alignment(0.80,0.60),
            child: Material(child: Text(' paused elapsed ${appState.pausedMillisecondsElapsed.toString()}'))),
      ],
    );
  }
}
