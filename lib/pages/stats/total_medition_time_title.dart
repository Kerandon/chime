import 'package:chime/animation/fade_in_animation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';
import '../../models/stats_model.dart';
import '../../state/chart_state.dart';
import '../../state/database_manager.dart';
import '../../utils/methods/stats_methods.dart';

class TotalMeditationTimeTitle extends ConsumerStatefulWidget {
  const TotalMeditationTimeTitle({
    super.key,
  });

  @override
  ConsumerState<TotalMeditationTimeTitle> createState() => _TotalMeditationTimeTitleState();
}

class _TotalMeditationTimeTitleState extends ConsumerState<TotalMeditationTimeTitle> {


  TimePeriod currentPeriod = TimePeriod.week;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chartStateProvider);
    final chartState = ref.watch(chartStateProvider);
    String totalText = "0";
    String periodText = "";



      periodText = " in total";

  switch (state.barChartTimePeriod) {
    case TimePeriod.week:
      periodText = ' in the last week';
      break;
    case TimePeriod.fortnight:
      periodText = ' in the last fortnight';
      break;
    case TimePeriod.year:
      periodText = ' in the last year';
      break;
    case TimePeriod.allTime:
      ' in total';
      break;
  }




    return FutureBuilder(
      future: DatabaseManager()
          .getStatsByTimePeriod(period: chartState.barChartTimePeriod),
      builder: (context, snapshot) {



        List<StatsModel> statsData = [];
        totalText = '0 minutes';
        if(snapshot.hasData && snapshot.data!.isNotEmpty){
          statsData = snapshot.data!;
          totalText = calculateTotalMeditationTime(statsData, state);
        }


        return FadeInAnimation(
        durationMilliseconds: 1000,
        delayMilliseconds: 200,
        animateOnDemand: state.barChartTimePeriod != currentPeriod,
        animationCompleted: (){
          currentPeriod = state.barChartTimePeriod;
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: state.barChartTimePeriod == TimePeriod.allTime
                ? 'You have meditated for '
                : 'You meditated for ',
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              TextSpan(
                text: totalText,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              TextSpan(
                  text: periodText, style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
      );
      },
    );
  }
}
