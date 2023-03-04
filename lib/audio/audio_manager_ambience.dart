// import 'package:chime/enums/session_state.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:just_audio/just_audio.dart';
//
// import '../enums/ambience.dart';
// import '../state/app_state.dart';
// import '../state/audio_state.dart';
//
// class AudioManagerAmbience extends ConsumerStatefulWidget {
//   const AudioManagerAmbience({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<AudioManagerAmbience> createState() => _AudioManagerAmbienceState();
// }
//
// class _AudioManagerAmbienceState extends ConsumerState<AudioManagerAmbience> {
//   final AudioPlayer _player = AudioPlayer();
//   bool _setPlayAudio = false;
//   Ambience _ambienceSelected = Ambience.fireplace;
//
//   Future<void> _setAmbience(Ambience ambience) async {
//     await _player.setAsset('assets/audio/ambience/${ambience.name}.mp3',
//         preload: true);
//     _ambienceSelected = ambience;
//   }
//
//   Future<void> _playAudio({required Ambience ambience, bool reset = false}) async {
//     if(reset) {
//       await _player.seek(Duration.zero);
//     }
//     if(!_player.playing) {
//
//       print('play audio');
//
//       await _player.setAsset('assets/audio/ambience/${ambience.name}.mp3').then((value) async {
//         await _player.play();
//       });
//
//     }
//   }
//
//   Future<void> _stopAudio() async {
//     await _player.stop();
//   }
//
//   Future<void> _pauseAudio() async {
//     await _player.pause();
//   }
//
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final appState = ref.watch(appProvider);
//     final audioState = ref.watch(audioProvider);
//
//     if(appState.sessionState == SessionState.notStarted){
//
//       if(audioState.ambiencePageOpen && !_setPlayAudio){
//         print('play audio ${audioState.ambienceSelected}');
//
//         _playAudio(ambience: audioState.ambienceSelected);
//         _setPlayAudio = true;
//       }
//       if(!audioState.ambiencePageOpen){
//         _stopAudio();
//         print('stop audio');
//       }
//     }
//
//     if(audioState.ambienceSelected != _ambienceSelected){
//       _setAmbience(audioState.ambienceSelected);
//       print('ambience set to ${audioState.ambienceSelected}');
//       _setPlayAudio = false;
//     }
//
//
//
//     return   SizedBox(
//       height: 300,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//            ElevatedButton(
//                 onPressed: () async {
//                   await _playAudio(ambience: audioState.ambienceSelected);
//
//                 },
//                 child: const SizedBox(
//                   width: 150,
//                   child: Text('play'),
//                 ),
//               ),
//             ElevatedButton(
//               onPressed: () async {
//                _pauseAudio();
//
//               },
//               child: const SizedBox(
//                 width: 150,
//                 child: Text('pause'),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
