import 'package:chime/configs/constants.dart';
import 'package:chime/data/meditation_quotes.dart';
import 'package:chime/state/database_manager.dart';
import 'package:chime/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/time_period.dart';
import '../../models/stats_model.dart';
import '../../state/app_state.dart';
import '../../utils/methods/stats_methods.dart';
import 'completion_stat_box.dart';

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
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);

    String totalTime = "";
    totalTime = state.totalTimeMinutes.formatToHourMin();

    return AlertDialog(
      title: const Text(
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

              return SizedBox(
                height: size.height * 0.70,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.80,
                          height: size.height * 0.30,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                    image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/completion/completion_1.png'),),),
                              ),
                            ],
                          ).animate().fadeIn(duration: 1.seconds).scaleXY(begin: 0.95),
                        ),
                        Align(
                          alignment: const Alignment(0, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(meditationQuotes.first),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02),
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
                      ],
                    ),
                    Align(
                      alignment: const Alignment(0, 0.95),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).splashColor),
                              onPressed: () {
                                Navigator.of(context)
                                    .maybePop()
                                    .then((value) async {
                                  notifier.setPage(2);
                                });
                              },
                              icon: const Icon(Icons.bar_chart_outlined)),
                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).splashColor),
                              onPressed: () async {
                                await Navigator.of(context).maybePop();
                              },
                              icon: const Icon(Icons.home_outlined)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    ).animate().fadeIn(duration: 1.seconds).scaleXY(begin: 0.50, duration: 1.seconds);
  }
}
