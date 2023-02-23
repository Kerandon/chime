import 'package:chime/state/audio_state.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../configs/constants.dart';

class IntervalBellBox extends ConsumerWidget {
  const IntervalBellBox({
    super.key,
    required this.time,
  });

  final double time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);
    final selected = audioState.bellInterval;

    String timeText = setTimeText();

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            audioNotifier.setBellInterval(time);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadius),
                border: Border.all(
                  color: selected == time
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).secondaryHeaderColor,
                )),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: timeText,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String setTimeText() {
    String timeText = "";
    if (time == 0) {
      timeText = "None";
    } else if (time == 0.50) {
      timeText = "30s";
    }
    else if (time == 999){
      timeText = 'Random';
    }
    else{
      timeText = time.toInt().formatToHourMin();
    }
    return timeText;
  }
}
