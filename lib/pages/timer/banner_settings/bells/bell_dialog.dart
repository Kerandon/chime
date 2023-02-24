import 'package:chime/data/bell_times.dart';
import 'package:chime/pages/timer/banner_settings/bells/random_slider_range.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../../../enums/interval_bell.dart';
import '../../../../state/app_state.dart';
import '../../../../state/audio_state.dart';
import 'bell_on_start_tile.dart';
import 'interval_bell_box.dart';
import 'bells_sounds_page.dart';

class BellDialog extends ConsumerWidget {
  const BellDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(stateProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    final size = MediaQuery.of(context).size;

    List<double> times = possibleBellTimes
        .takeWhile((value) => value < appState.totalTimeMinutes)
        .toList();

    final heights = setIntervalHeight(size, times);
    String subtitle = '';
    if (!appState.openSession) {
      subtitle =
          '\n\nFixed session time: ${appState.totalTimeMinutes.formatToHourMin()}';
    } else {
      subtitle = '\n\nOpen time\n';
    }

    return AlertDialog(
      contentPadding: EdgeInsets.all(size.width * 0.05),
      actionsPadding: EdgeInsets.all(size.width * 0.02),
      insetPadding: EdgeInsets.all(size.width * 0.08),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Meditation Bell Setup',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Theme.of(context).primaryColor, fontSize: 20),
          children: [
            // TextSpan(
            //     text: subtitle,
            //     style: Theme.of(context)
            //         .textTheme
            //         .labelMedium!
            //         .copyWith(color: AppColors.lightGrey))
          ],
        ),
      ),
      content: SizedBox(
        width: size.width,
        height: heights.item2,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BellListTile(
                text: 'Bell on begin',
                value: audioState.bellOnStart,
                onChanged: (value) {
                  audioNotifier.setBellOnStart(value);
                },
              ),
              BellListTile(
                text: 'Play interval bells',
                value: audioState.intervalBellsAreOn,
                onChanged: (value) {
                  audioNotifier.setBellIntervalsAreOn(value);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (audioState.intervalBellsAreOn) ...[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: audioState.intervalBellType ==
                                      BellIntervalTypeEnum.fixed
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).secondaryHeaderColor)),
                      onPressed: () {
                        audioNotifier
                            .setIntervalBellType(BellIntervalTypeEnum.fixed);
                      },
                      child: const Text('Fixed Bells'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: audioState.intervalBellType ==
                                      BellIntervalTypeEnum.random
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).secondaryHeaderColor)),
                      onPressed: () {
                        audioNotifier
                            .setIntervalBellType(BellIntervalTypeEnum.random);
                      },
                      child: const Text('Random Bells'),
                    ),
                  ],
                ],
              ),
              Column(
                children: [
                  if (audioState.intervalBellsAreOn &&
                      audioState.intervalBellType ==
                          BellIntervalTypeEnum.fixed) ...[
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.02,
                        bottom: size.height * 0.02,
                      ),
                      child: SizedBox(
                        width: size.width,
                        child: Text(
                          'Play an interval bell every:',
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heights.item1,
                      child: GridView.builder(
                          itemCount: times.length,
                          itemBuilder: (context, index) {
                            return IntervalBellBox(
                                time: times.elementAt(index));
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6)),
                    ),
                  ],
                  if (audioState.intervalBellsAreOn &&
                      audioState.intervalBellType ==
                          BellIntervalTypeEnum.random) ...[
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: SizedBox(
                        width: size.width,
                        child: Text(
                          'Max range for random bell',
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const RandomSliderRange(),
                  ],
                ],
              ),
              Column(
                children: [
                  BellListTile(
                    text: 'Bell on end',
                    value: audioState.bellOnEnd,
                    onChanged: (value) {
                      audioNotifier.setBellOnEnd(value);
                    },
                  ),
                  ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BellsSoundsPage(),
                        ),
                      );
                    },
                    title: const Text('Bell sound'),
                    subtitle: Text(audioState.bellSelected.name,
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

  Tuple2<double, double> setIntervalHeight(Size size, List<double> times) {
    double bellHeight = size.height * 0.15;
    double contentHeight = size.height * 1;
    if (times.length > 5 && times.length <= 10) {
      bellHeight = size.height * 0.18;
      contentHeight * 0.80;
    }
    return Tuple2(bellHeight, contentHeight);
  }
}
