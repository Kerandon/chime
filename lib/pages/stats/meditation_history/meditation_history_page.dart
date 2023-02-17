import 'package:chime/app_components/lotus_icon.dart';
import 'package:chime/pages/stats/meditation_history/select_history.dart';
import 'package:chime/pages/stats/stats_page.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/constants.dart';
import '../../../models/stats_model.dart';
import '../../home.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        title: const Text('Meditiation history'),
      ),
      body: FutureBuilder(
          future: _allMeditationFuture,
          builder: (context, snapshot) {
            List<StatsModel> stats = [];

            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                stats.addAll(snapshot.data!);
              }
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                  child: RichText(
                    text: TextSpan(
                      text: 'You have meditated ',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: stats.length.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text: stats.length == 1 ? ' time' : ' times',
                          style: Theme.of(context).textTheme.bodySmall,
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
            );
          }),
    );
  }
}
