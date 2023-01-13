import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/home/lotus_icon.dart';
import '../components/settings/meditation_guide.dart';

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
                    alignment: Alignment(0.90, 0),
                    child: IconButton(
                        onPressed: () async {
                          await Navigator.of(context).maybePop();
                        },
                        icon: Icon(
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
              leading: FaIcon(
                FontAwesomeIcons.award,
                size: 15,
              ),
              title: Text('Streak stats'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => StreakSettings(),
                );
              },
            ),
            const ListTile(
              leading: FaIcon(
                FontAwesomeIcons.info,
                size: 15,
              ),
              title: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakSettings extends StatelessWidget {
  const StreakSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('Daily Streak', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall
      !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),),
      content: SizedBox(
        height: size.height * 0.15,
        child: Column(
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(child: Text('Current\n', style: Theme.of(context).textTheme.bodySmall
                    !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),)),
                    TableCell(child: Text('5', textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodySmall
                    !.copyWith(fontSize: 20, color: Colors.black),)),
                  ]
                ),
                TableRow(
                    children: [
                      TableCell(child: Text('Best\n', style: Theme.of(context).textTheme.bodySmall
                      !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),)),
                      TableCell(child: Text('25', textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodySmall
                      !.copyWith(fontSize: 20, color: Colors.black),)),
                    ]
                ),
              ],
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
            width: size.width * 0.60,
            child: OutlinedButton(onPressed: (){

              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('Confirm reset?', textAlign: TextAlign.center,),      actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  OutlinedButton(onPressed: (){
                  },
                      child: Text('Yes')),
                  OutlinedButton(onPressed: () async {
                    await Navigator.of(context).maybePop();
                  },
                      child: Text('No')),
                ],
              ),);

            }, child: Text('Reset')))
      ],
    );
  }
}
