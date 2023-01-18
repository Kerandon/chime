// import 'package:chime/audio/audio_manager.dart';
// import 'package:chime/enums/session_state.dart';
// import 'package:chime/state/app_state.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../../enums/bell.dart';
// import '../../enums/focus_state.dart';
//
// class SoundSelection extends StatelessWidget {
//   const SoundSelection({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const SoundButton(bell: Bell.chime),
//         SizedBox(
//           width: size.width * 0.05,
//         ),
//         const SoundButton(bell: Bell.gong),
//       ],
//     );
//   }
// }
//
// class SoundButton extends ConsumerWidget {
//   const SoundButton({required this.bell, Key? key}) : super(key: key);
//
//   final Bell bell;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//     final state = ref.watch(stateProvider);
//     final notifier = ref.read(stateProvider.notifier);
//
//
//
//     return SizedBox(
//       width: size.width * 0.25,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           side: state.bellSelected == bell
//               ? const BorderSide(color: Colors.teal, width: 2)
//               : null,
//         ),
//         onPressed: () async {
//           if(state.sessionState == SessionState.notStarted) {
//             await AudioManager().playBell(bell.name);
//           }
//           notifier.setBell(bell);
//           notifier.setTimerFocusState(FocusState.unFocus);
//         },
//         child: Text(
//           bell.toText(),
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ),
//     );
//   }
// }
