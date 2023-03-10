import 'package:chime/pages/settings/vibrate/vibrate_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../configs/app_colors.dart';
import '../../enums/prefs.dart';
import '../../state/database_manager.dart';
import 'clock_design/clock_design_page.dart';
import 'color_theme/color_theme_page.dart';
import 'mute_device/mute_device_page.dart';
import 'components/settings_divider.dart';
import 'components/settings_tile.dart';
import 'countdown/countdown_page.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingsTitleDivider(
              title: 'More Setup options',
              hideDivider: true,
            ),
            SettingsTile(
              icon: const Icon(
                Icons.timer_outlined,
              ),
              title: 'Warmup countdown',
              subTitle: state.countdownIsOn ? '${state.totalCountdownTime.toString()} seconds' : 'Countdown is off',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CountdownPage()));
              },
            ),
            const Vibrate(),
            const MuteDevicePage(),
            const SettingsTitleDivider(
              title: 'App theme',
            ),
            SettingsTile(
              icon: const Icon(
                Icons.color_lens_outlined,
              ),
              title: 'Color theme',
              subTitle: state.colorTheme.name.capitalize(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ColorTheme(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: const Icon(
                FontAwesomeIcons.clock
              ),
              title: 'Timer design',
              subTitle: state.timerDesign.name.capitalize(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TimerDesignPage(),
                  ),
                );
              },
            ),
            const SettingsTitleDivider(),
            SettingsTile(
                icon: const Icon(
                  Icons.restart_alt_outlined,
                ),
                title: 'Reset all settings',
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

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
