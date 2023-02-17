import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../configs/constants.dart';
import '../../../../state/app_state.dart';

class IntervalBellBox extends ConsumerWidget {
  const IntervalBellBox({
    super.key,
    required this.time,
  });

  final int time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    final selected = state.selectedIntervalBellTime;

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            notifier.setBellIntervalTime(time);
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
                      text: time == 0 ? 'None' : time.formatToHourMin(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium,
                    )),
              )),
        ),
      ),
    );
  }
}