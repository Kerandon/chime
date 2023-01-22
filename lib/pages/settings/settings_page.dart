import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/pages/settings/color_theme_page.dart';
import 'package:chime/pages/settings/meditation_bells_page.dart';
import 'package:chime/pages/settings/countdown_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../components/app/lotus_icon.dart';
import '../../components/settings/bell_on_start_tile.dart';
import '../../components/settings/open_session_tile.dart';
import '../../components/settings/settings_divider.dart';
import '../../components/settings/settings_tile.dart';
import '../../configs/constants.dart';
import 'achievements_page.dart';
import 'ambience_page.dart';
import 'guide_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingsTitleDivider(
              title: 'Session adjustments',
              hideDivider: true,
            ),
            const OpenSessionTile(),
            SettingsTile(
              icon: const Icon(
                FontAwesomeIcons.bell,
              ),
              title: 'Meditation bell',
              subTitle: state.bellSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MeditationBellsPage()));
              },
            ),
            const BellOnStartTile(),
            SettingsTile(
              icon: const Icon(
                Icons.piano_outlined,
              ),
              title: 'Ambience',
              subTitle: state.ambienceSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AmbiencePage()));
              },
            ),
            SettingsTile(
              icon: const Icon(
                Icons.timer_outlined,
              ),
              title: 'Warmup countdown',
              subTitle: '${state.totalCountdownTime.toString()} seconds',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CountdownPage()));
              },
            ),
            const SettingsTitleDivider(title: 'Guide & stats'),
            SettingsTile(
              icon: const Icon(
                  FontAwesomeIcons.book
              ),
              title: 'Meditation Guide',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GuidePage()));
              },
            ),
            SettingsTile(
                icon: const Icon(
                  Icons.bar_chart_outlined,
                ),
                title: 'Meditation stats',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const AchievementsPage()),
                  );
                }),
            const SettingsTitleDivider(
              title: 'Appearance',
            ),
            SettingsTile(
                icon: const Icon(
                  Icons.color_lens_outlined,
                ),
                title: 'Color theme',
                onPressed: () {

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ColorThemePage(),),);
                }),
            SettingsTile(
                icon: const Icon(
                  FontAwesomeIcons.clock,
                ),
                title: 'Hide countdown clock',
                onPressed: () {}),
            const SettingsTitleDivider(),
            SettingsTile(
                icon: const Icon(
                  Icons.restart_alt_outlined,
                ),
                title: 'Reset all settings',
                onPressed: () {}),
            SettingsTile(
                icon: const Icon(
                  Icons.info_outlined,
                ),
                title: 'About',
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: kAppName,
                      applicationVersion: '1.0',
                      applicationIcon: const LotusIcon());
                }),
          ],
        ),
      ),
    );
  }
}
