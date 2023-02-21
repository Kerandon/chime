import 'package:chime/enums/bell.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../state/app_state.dart';
import 'bell_on_start_tile.dart';
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

    double bellHeight = size.height * 0.15;
    if(times.length > 5 && times.length <= 10){
      bellHeight = size.height * 0.20;
    }
    if(times.length > 10){
      bellHeight = size.height * 0.25;
    }

    return AlertDialog(
      title: const Text(' Meditation bell options', textAlign: TextAlign.center,),
      content: SizedBox(
        width: size.width,
        height: size.height * 0.80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.03, bottom: size.height * 0.01),
              child: const Text(
                ' Set interval bell every:',
              ),
            ),
            SizedBox(
              height: bellHeight,
              child: GridView.builder(
                  itemCount: times.length,
                  itemBuilder: (context, index) {
                    return IntervalBellBox(time: times.elementAt(index));
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6)),
            ),
            const Divider(),
            Column(
              children: [
                BellListTile(
                  text: 'Bell on begin',
                  value: state.bellOnSessionStart,
                  onChanged: (value) {
                    notifier.setBellOnSessionStart(value);
                  },
                ),
                BellListTile(
                  text: 'Bell on end',
                  value: state.bellOnSessionEnd,
                  onChanged: (value) {
                    notifier.setBellOnSessionEnd(value);
                  },
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BellsSoundsPage()));
                  },
                  title: const Text('Bell sound'),
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
                child: const Text('OK')))
      ],
    );
  }
}
