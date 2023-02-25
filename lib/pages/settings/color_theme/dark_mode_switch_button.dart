
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/app_colors.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';
import '../../../state/database_manager.dart';

class DarkThemeSwitchButton extends ConsumerWidget {
  const DarkThemeSwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);

    return SwitchListTile(
        title: Row(
          children: [
            const Icon(Icons.dark_mode_outlined),
            Padding(

              padding: EdgeInsets.only(left: size.width * 0.08),
              child: const Text('Dark Mode'),
            ),
          ],
        ),
        inactiveTrackColor: AppColors.grey,
        inactiveThumbColor: AppColors.lightGrey,
        value: state.isDarkTheme,
        onChanged: (value) async {
          notifier.setBrightness(value);
          await DatabaseManager()
              .insertIntoPrefs(k: Prefs.themeBrightness.toString(), v: value);
        });
  }
}
