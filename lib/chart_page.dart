// import 'package:chime/models/data_point.dart';
// import 'package:chime/models/stats_model.dart';
// import 'package:chime/pages/stats/custom_line/animated_line_chart.dart';
// import 'package:chime/utils/methods.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ChartPage extends StatefulWidget {
//   const ChartPage({Key? key}) : super(key: key);
//
//   @override
//   State<ChartPage> createState() => _ChartPageState();
// }
//
// class _ChartPageState extends State<ChartPage> {
//   DateTime _oldestDateX = DateTime.now(), _latestDateX = DateTime.now();
//
//   int totalTimeY = 0;
//
//   String oldestDateString = "", latestDateString = "";
//
//   List<SeriesPoint> seriesData = [];
//
//   List<StatsModel> stats = [
//     StatsModel(dateTime: DateTime(2023, 01, 15), totalMeditationTime: 110),
//     StatsModel(dateTime: DateTime(2022, 03, 20), totalMeditationTime: 50),
//     StatsModel(dateTime: DateTime(2021, 09, 15), totalMeditationTime: 250),
//     StatsModel(dateTime: DateTime(2018, 01, 01), totalMeditationTime: 60),
//   ];
//
//   @override
//   void initState() {
//     stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));
//     _oldestDateX = stats.first.dateTime;
//     _latestDateX = stats.last.dateTime;
//
//     DateFormat formatter = DateFormat.yM();
//
//     int runningTotalY = 0;
//
//     for (int i =0; i < stats.length; i++) {
//       var x = stats[i].dateTime.difference(_oldestDateX).inDays;
//       runningTotalY += stats[i].totalMeditationTime;
//
//
//       String? labelX, labelY;
//
//       if(i == 0 || i == stats.length - 1){
//         labelX =  formatter.format(stats[i].dateTime);
//
//       }
//       if(i == stats.length - 1){
//         labelY = runningTotalY.formatToHourMin();
//       }
//       seriesData.add(SeriesPoint(x.toDouble(),
//           runningTotalY.toDouble()));
//     }
//
//     totalTimeY = runningTotalY;
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedLineChart(seriesData: seriesData, labelsX: ,),
//     );
//   }
// }
