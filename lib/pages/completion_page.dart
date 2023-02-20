import 'package:chime/configs/constants.dart';
import 'package:chime/pages/stats/streak/streak_stats_box.dart';
import 'package:chime/state/database_manager.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/time_period.dart';
import '../models/stats_model.dart';
import '../state/app_state.dart';
import '../utils/methods/stats_methods.dart';

class CompletionPage extends ConsumerStatefulWidget {
  const CompletionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CompletionPage> createState() => _CompletionPageState();
}

class _CompletionPageState extends ConsumerState<CompletionPage> {
  late final Future<List<StatsModel>> _allGroupedFuture;

  @override
  void initState() {
    _allGroupedFuture = DatabaseManager().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);

    String totalTime = "";
    totalTime = state.totalTimeMinutes.formatToHourMin();

    return AlertDialog(
      title: Text(
        'Congratulations,\nsession completed',
        textAlign: TextAlign.center,
      ),
      content: FutureBuilder(
          future: _allGroupedFuture,
          builder: (context, snapshot) {
            String currentStreakString = '0';
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                List<StatsModel> stats = snapshot.data!;
                currentStreakString = getCurrentStreak(stats).toString();
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: size.width * 0.80,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/completion/completion_1.png'))),
                      ).animate().fadeIn().scaleXY(begin: 0.95),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CompletionStatBox(
                              text: 'Time',
                              value: totalTime,
                            ),
                            CompletionStatBox(
                              text: 'Streak',
                              value: currentStreakString,
                            )
                          ],
                        ),
                      ),
                      Divider(),

                    ],
                  ),
                  Align(
                    alignment: Alignment(0,0.95),
                    child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).splashColor
                        ),
                        onPressed:() async {

                         await Navigator.of(context).maybePop();

                        }, icon: Icon(Icons.home_outlined)),
                  )
                ],
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}

class CompletionStatBox extends StatelessWidget {
  const CompletionStatBox({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        Text(text),
      ],
    );
  }
}
