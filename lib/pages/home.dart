import 'package:chime/animation/pop_in_animation.dart';
import 'package:chime/pages/guide_page.dart';
import 'package:chime/pages/settings/settings_page.dart';
import 'package:chime/pages/stats/stats_page.dart';
import 'package:chime/pages/timer/timer_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../animation/slide_animation.dart';
import '../enums/session_state.dart';
import '../enums/slide_direction.dart';
import '../state/app_state.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomePageContentsState();
}

class _HomePageContentsState extends ConsumerState<Home> {
  static const List<Widget> _pageOptions = [
    TimerLayout(),
    SettingsPage(),
    StatsPage(),
    GuidePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                _pageOptions.elementAt(state.currentPage),
                // Align(
                //   alignment: const Alignment(-1, -0.80),
                //   child: ElevatedButton(
                //       onPressed: () async {
                //         await DatabaseManager().insertIntoStats(
                //             dateTime: DateTime.now()
                //                 .copyWith(year: 2021, month: 04, day: 10),
                //             minutes: 300);
                //       },
                //       child: const Text('Insert Stat')),
                // ),
                // Align(
                //   alignment: const Alignment(-0.80, -0.60),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       DatabaseManager().removeAllPrefsAndStats();
                //     },
                //     child: const Text('delete'),
                //   ),
                // )
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: PopInAnimation(
              animate: state.sessionState == SessionState.countdown,
              reset: state.sessionState == SessionState.notStarted,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500)
                ),
                backgroundColor: Theme.of(context).splashColor.withOpacity(0.10),

                  child: Icon(Icons.stop_outlined, color: Theme.of(context)
                      .secondaryHeaderColor,),
                  onPressed: () {
                    notifier.setSessionStopped(true);
                  notifier.setSessionState(SessionState.notStarted);
                  notifier.resetSession();


              }),
            ),
            bottomNavigationBar: SlideAnimation(
              animate: state.sessionState == SessionState.countdown,
              reset: state.sessionState == SessionState.notStarted,
              direction: SlideDirection.downAway,
              duration: 800,
              child: IgnorePointer(
                ignoring: state.sessionState != SessionState.notStarted,
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
            )),
      ],
    );
  }
}
