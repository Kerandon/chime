import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/bell.dart';
import 'package:chime/pages/bells_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/app/lotus_icon.dart';
import '../components/settings/settings_tile.dart';
import '../configs/constants.dart';
import 'achievements_page.dart';
import 'ambience_page.dart';
import 'meditation_guide_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
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
              icon: const Icon(
                Icons.audiotrack_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Bell',
              subTitle: state.bellSelected.toText(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BellsPage()));
              },
            ),
            SettingsTile(
              icon: const Icon(
                Icons.piano_outlined,
                color: Colors.white,
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
                Icons.tips_and_updates_outlined,
                color: Colors.white,
              ),
              title: 'Meditation Guide',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MeditationGuidePage()));
              },
            ),
            SettingsTile(
                faIcon: const FaIcon(
                  FontAwesomeIcons.award,
                  color: Colors.white,
                ),
                title: 'Achievements',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const AchievementsPage()),
                  );
                }),
            SettingsTile(
                icon: const Icon(
                  Icons.info_outlined,
                  color: Colors.white,
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
