import 'package:chime/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/home/lotus_icon.dart';
import '../components/settings/meditation_guide.dart';
import '../components/settings/streak_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.08,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: const LotusIcon(),
                      ),
                      Text(
                        'Zense Meditation Timer',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                      ),
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0.90, 0),
                    child: IconButton(
                        onPressed: () async {
                          await Navigator.of(context).maybePop();
                        },
                        icon: const Icon(
                          Icons.clear_outlined,
                          color: Colors.white,
                          size: 18,
                        )),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.tips_and_updates_outlined,
                size: 15,
              ),
              title: const Text('Meditation guide'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const MeditationGuide(),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.award,
                size: 15,
              ),
              title: const Text('Streak stats'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const StreakSettings(),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.info,
                size: 15,
              ),
              title:
              const Text('About app'),
              onTap: () => showAboutDialog(context: context, applicationName: 'Zense Meditation Timer',
                applicationVersion: '1.0',
                applicationIcon: LotusIcon(),

              ))

          ],
        ),
      ),
    );
  }
}
