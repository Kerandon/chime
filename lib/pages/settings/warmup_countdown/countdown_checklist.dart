import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../state/database_manager.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';

class CountdownChecklist extends ConsumerWidget {
  const CountdownChecklist({
    required this.countdownTime,
    super.key,
  });

  final int countdownTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title = "";

    if (countdownTime > 0 && countdownTime < 60) {
      title = '$countdownTime seconds';
    }
    if (countdownTime >= 60) {
      title = '${countdownTime ~/ 60} minute';
    }

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return CheckboxListTile(
      enabled: state.countdownIsOn ,
      title: Text(
        title,),
      value: state.countdownIsOn ? countdownTime == state.totalCountdownTime : false,
      onChanged: (value) async {
        notifier.setTotalCountdownTime(countdownTime);
        await DatabaseManager().insertIntoPrefs(k: Prefs.timeCountdown.name, v: countdownTime);
      },
    );
  }
}
