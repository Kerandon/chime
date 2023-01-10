import 'package:chime/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'configs/app_theme.dart';

void main() => runApp(const ChimeApp());

class ChimeApp extends StatefulWidget {
  const ChimeApp({Key? key}) : super(key: key);

  @override
  State<ChimeApp> createState() => _ChimeAppState();
}

class _ChimeAppState extends State<ChimeApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomePage(),
      ),
    );
  }
}
//
// class AnimatedSwitcherExample extends StatefulWidget {
//   const AnimatedSwitcherExample({Key? key}) : super(key: key);
//
//   @override
//   State<AnimatedSwitcherExample> createState() =>
//       _AnimatedSwitcherExampleState();
// }
//
// class _AnimatedSwitcherExampleState extends State<AnimatedSwitcherExample> {
//   int _state = 3;
//   Icon _icon = const Icon(Icons.play_arrow);
//
//   _changeIcon() {
//
//
//     if (_state == 0) {
//       _icon = const Icon(Icons.play_arrow);
//     } else if (_state == 1) {
//       _icon = const Icon(Icons.pause);
//     } else if (_state == 2) {
//       _icon = const Icon(Icons.stop);
//     }else{
//       _icon = const Icon(Icons.fast_rewind);
//     }
//
//     _state++;
//     if(_state == 4){
//       _state = 0;
//     }
//
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('state is $_state and icon is ${_icon.icon}');
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//             onPressed: () {
//               _changeIcon();
//             },
//             child: const Text('Change')),
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           child: _icon,
//         )
//       ],
//     );
//   }
// }
