// import 'dart:async';
//
// import 'package:chime/enums/time_period.dart';
// import 'package:chime/pages/stats/line_chart_total/line_chart_data.dart';
// import 'package:chime/state/database_manager.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../../../configs/constants.dart';
// import '../../../models/stats_model.dart';
//
// FlBorderData get borderData => FlBorderData(
//       show: false,
//       border: Border.all(color: Colors.transparent),
//     );
//
// class TotalTimeChart extends ConsumerStatefulWidget {
//   const TotalTimeChart({
//     super.key,
//   });
//
//   @override
//   ConsumerState<TotalTimeChart> createState() => _TotalTimeChartState();
// }
//
// class _TotalTimeChartState extends ConsumerState<TotalTimeChart> {
//   late final Future<List<StatsModel>> _statsFuture;
//
//   @override
//   void initState() {
//     _statsFuture = DatabaseManager().getStatsByTimePeriod(
//         period: TimePeriod.allTime, allTimeGroupedByDay: true);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: EdgeInsets.all(kPageIndentation * size.width),
//       child: FutureBuilder<List<StatsModel>>(
//         future: _statsFuture,
//         builder: (context, snapshot) {
//           List<StatsModel> data = [];
//           List<LineChartAxis> axisData = [
//           ];
//           if (snapshot.hasData) {
//             data = snapshot.data!.toList();
//             _addTodaysDate(data);
//           }
//
//           return SizedBox(
//             height: size.height * 0.50,
//             child: LineChart(
//               swapAnimationDuration:
//                   Duration.zero,
//               getData(
//                   context: context,
//                   size: size,
//                   data: data,
//                   axisData: axisData),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _addTodaysDate(List<StatsModel> data) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final hasTodayDate = data.any((element) => element.dateTime == today);
//     if (!hasTodayDate) {
//       data.add(StatsModel(dateTime: today, totalMeditationTime: 0));
//     }
//   }
// }
//
// class LineChartAxis {
//   double x;
//   double y;
//
//   LineChartAxis(this.x, this.y);
// }
