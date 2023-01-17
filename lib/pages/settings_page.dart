import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/sounds.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/app/lotus_icon.dart';
import '../components/settings/meditation_guide.dart';
import '../components/settings/settings_tile.dart';
import '../components/settings/streak_settings.dart';
import '../utils/constants.dart';
import 'achievements_page.dart';
import 'ambience_page.dart';
import 'meditation_guide_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.read(stateProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.05, bottom: size.height * 0.01),
            child: Column(
              children: [
                Text(
                  kAppName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: const LotusIcon(),
                ),
              ],
            ),
          ),
          SettingsTile(
            icon: Icon(
              Icons.piano_outlined,
              color: Colors.white,
            ),
            title: 'Ambience',
            subTitle: state.ambienceSelected.toText(),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AmbiencePage()));
            },
          ),
          SettingsTile(
            icon: Icon(
              Icons.tips_and_updates_outlined,
              color: Colors.white,
            ),
            title: 'Meditation Guide',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MeditationGuidePage()));
            },
          ),
          SettingsTile(
              faIcon: FaIcon(
                FontAwesomeIcons.award,
                color: Colors.white,
              ),
              title: 'Achievements',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AchievementsPage()),
                );
              }),
          ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.info,
              ),
              title: const Text('About app'),
              onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Zense Meditation Timer',
                    applicationVersion: '1.0',
                    applicationIcon: const LotusIcon(),
                  ))
        ],
      ),
    );
  }
}
