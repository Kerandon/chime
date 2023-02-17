import 'package:chime/enums/bell.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../state/app_state.dart';
import '../../../settings/bell_on_start/bell_on_start_tile.dart';
import 'interval_bell_box.dart';
import 'bells_sounds_page.dart';

class BellDialog extends ConsumerWidget {
  const BellDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    final size = MediaQuery.of(context).size;

    List<int> times = state.bellIntervalMenuSelection.toList();

    times.insert(times.length, 0);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.bell),
          Text(' Meditation bell setup'),
        ],
      ),
      content: SizedBox(
        width: size.width,
        height: size.height * 0.65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.03, bottom: size.height * 0.01),
              child: Text(
                ' Interval bell frequency',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(
              height: size.height * 0.25,
              child: GridView.builder(
                  itemCount: times.length,
                  itemBuilder: (context, index) {
                    return IntervalBellBox(time: times.elementAt(index));
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6)),
            ),
            Divider(),
            Column(
              children: [
                BellListTile(
                  text: 'Bell on session begin',
                  value: state.bellOnSessionStart,
                  onChanged: (value) {
                    notifier.setBellOnSessionStart(value);
                  },
                ),
                BellListTile(
                  text: 'Bell on session end',
                  value: state.bellOnSessionEnd,
                  onChanged: (value) {
                    notifier.setBellOnSessionEnd(value);
                  },
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BellsSoundsPage()));
                  },
                  title: Text('Bell sound'),
                  subtitle: Text(state.bellSelected.toText(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Theme.of(context).primaryColor)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
            width: size.width * 0.50,
            child: OutlinedButton(
                onPressed: () async {
                  await Navigator.of(context).maybePop();
                },
                child: Text('OK')))
      ],
    );
  }
}
