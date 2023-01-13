import 'package:chime/pages/home_page.dart';
import 'package:chime/state/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configs/app_theme.dart';

void main() => runApp(const ChimeApp());

class ChimeApp extends StatefulWidget {
  const ChimeApp({Key? key}) : super(key: key);

  @override
  State<ChimeApp> createState() => _ChimeAppState();
}

class _ChimeAppState extends State<ChimeApp> {
  @override
  void initState() {
    // _checkIfStreakStillCurrent();
    super.initState();
  }

  // Future<void> _checkIfStreakStillCurrent() async {
  //   final isSuccessive = PrefsManager.checkIfSuccessiveDate(
  //       await PrefsManager.getExistingStreakDates(
  //           await SharedPreferences.getInstance()),
  //       DateTime.now().copyWith(day: 16));
  //   if(!isSuccessive){
  //     await PrefsManager.clearStreakDates();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomePage(),
      ),
    );
  }
}
