import 'package:chime/pages/stats/meditation_history/select_history.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../models/stats_model.dart';
import 'meditiation_event_tile.dart';

class MeditationHistoryPage extends ConsumerStatefulWidget {
  const MeditationHistoryPage({
    super.key,
  });

  @override
  ConsumerState<MeditationHistoryPage> createState() =>
      _AllMeditationsListState();
}

class _AllMeditationsListState extends ConsumerState<MeditationHistoryPage> {
  late final Future<List<StatsModel>> _allMeditationFuture;

  @override
  void initState() {
    _allMeditationFuture = DatabaseManager().getAllStats();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String timeText = "";

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await Navigator.maybePop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        title: const Text('Meditation history'),
      ),
      body: FutureBuilder(
          future: _allMeditationFuture,
          builder: (context, snapshot) {
            List<StatsModel> stats = [];

            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                stats.addAll(snapshot.data!);
                stats = stats.reversed.toList();
              }

              if (stats.length == 1) {
                timeText = ' time';
              } else {
                timeText = ' times';
              }
            }

            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge!,
                        text: 'You have meditated ',
                        children: [
                          TextSpan(
                            text: stats.length.toString(),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          TextSpan(
                            text: timeText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (stats.isNotEmpty) ...[
                    SelectHistory(
                      stats: stats,
                    ),
                  ],
                  ListView.builder(
                    itemCount: stats.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MeditationEventTile(
                      stat: stats[index],
                      index: index,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
