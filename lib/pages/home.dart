import 'package:chime/pages/guide_page.dart';
import 'package:chime/pages/settings/settings_page.dart';
import 'package:chime/pages/stats/stats_page.dart';
import 'package:chime/pages/timer/clocks/timer_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    return Align(
      alignment: Alignment.center,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _pageOptions.elementAt(state.currentPage),
            // Align(
            //   alignment: const Alignment(-1,-0.10),
            //   child: ElevatedButton(onPressed: () async {
            //     await DatabaseManager().insertIntoStats(dateTime: DateTime.now().copyWith(year: 2022, month: 01, day:20), minutes: 60);
            //   }, child: const Text('Insert Stat')),
            // ),
            // Align(
            //     alignment: const Alignment(-1,0.10),
            //     child: ElevatedButton(onPressed: (){
            //       DatabaseManager().getStatsByTimePeriod(period: TimePeriod.week);
            //     }, child: const Text('Get Stats'),),),
            // Align(
            //     alignment: const Alignment(-1,0.20),
            //     child: ElevatedButton(onPressed: (){
            //       DatabaseManager().clearAllStats();
            //     }, child: const Text('delete')))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
        )
      ),
    );
  }
}

DateTime roundToMinute(DateTime dateTime) {
  dateTime = dateTime.add(const Duration(seconds: 30));
  return (dateTime.isUtc ? DateTime.utc : DateTime.new)(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
  );
}