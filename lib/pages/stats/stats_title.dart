// import 'package:chime/enums/time_period.dart';
// import 'package:chime/models/stats_model.dart';
// import 'package:chime/state/database_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// import '../../utils/methods.dart';
//
// class StatsTitle extends ConsumerStatefulWidget {
//   const StatsTitle({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<StatsTitle> createState() => _StatsTitleState();
// }
//
// class _StatsTitleState extends ConsumerState<StatsTitle> {
//   late final Future<List<StatsModel>> _statsFuture;
//
//   @override
//   void initState() {
//     _statsFuture =
//         DatabaseManager().getStatsByTimePeriod(period: TimePeriod.allTime);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//       String totalText = calculateTotalMeditationTime(snapshot.data!, state);
//       String periodText = " in total";
//       if (snapshot.data!.isNotEmpty) {
//         TimePeriod? period = snapshot.data?.first.timePeriod;
//         switch (period!) {
//           case TimePeriod.week:
//             periodText = ' over the last week';
//             break;
//           case TimePeriod.fortnight:
//             periodText = ' over the last fortnight';
//             break;
//           case TimePeriod.year:
//             periodText = ' over the last year';
//             break;
//           case TimePeriod.allTime:
//             ' in total';
//             break;
//         }
//       }
//
//
//
//
//     }
//
//     return SizedBox(
//       child: RichText(
//         text: TextSpan(
//           text: 'You have meditated for ',
//           style: Theme.of(context)
//               .textTheme
//               .bodySmall!
//               .copyWith(fontWeight: FontWeight.w300),
//           children: [
//             TextSpan(
//               //  text: totalText,
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).primaryColor),
//             ),
//             TextSpan(
//               // text: periodText,
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     fontWeight: FontWeight.w300,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
// //   }
// // }
