// import 'package:chime/enums/focus_state.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../../../configs/app_colors.dart';
// import '../../../state/database_manager.dart';
// import '../../../enums/prefs.dart';
// import '../../../state/app_state.dart';
//
// class TimeAdjustmentIcons extends ConsumerWidget {
//   const TimeAdjustmentIcons({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//
//     final state = ref.watch(stateProvider);
//     final notifier = ref.read(stateProvider.notifier);
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         IconButton(
//           color: AppColors.lightGrey,
//           onPressed: () async {
//             notifier.setTimerFocusState(FocusState.unFocus);
//             notifier.incrementTotalTime();
//             if (state.totalTimeMinutes < 9999) {
//               DatabaseManager().insertIntoPrefs(k: Prefs.timeTotal.name, v: state.totalTimeMinutes + 1);
//             }
//           },
//           icon: Icon(
//             Icons.add,
//             size: 20,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         SizedBox(
//           width: size.width * 0.05,
//         ),
//         IconButton(
//           color: AppColors.lightGrey,
//           onPressed: () async {
//             notifier.setTimerFocusState(FocusState.unFocus);
//             notifier.decrementTotalTime();
//             if (state.totalTimeMinutes > 0) {
//               DatabaseManager().insertIntoPrefs(k: Prefs.timeTotal.name, v: state.totalTimeMinutes - 1);
//             }
//           },
//           icon: Icon(
//             Icons.remove,
//             size: 20,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
