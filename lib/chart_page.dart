import 'package:chime/models/stats_model.dart';
import 'package:chime/pages/stats/custom_line/custom_line_animation.dart';
import 'package:flutter/material.dart';

List<StatsModel> stats = [
  StatsModel(dateTime: DateTime(2023, 01, 15), totalMeditationTime: 110),
  StatsModel(dateTime: DateTime(2022, 03, 20), totalMeditationTime: 50),
  StatsModel(dateTime: DateTime(2021, 09, 15), totalMeditationTime: 250),
  StatsModel(dateTime: DateTime(2020, 01, 01), totalMeditationTime: 60),
];

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LinePainterAnimation(
        stats: stats,
      ),
    );
  }
}
