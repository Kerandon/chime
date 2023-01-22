import 'package:chime/audio/audio_manager.dart';
import 'package:chime/configs/themes/dark_blue_theme.dart';
import 'package:chime/configs/themes/dark_orange_theme.dart';
import 'package:chime/configs/themes/light_theme.dart';
import 'package:chime/database_manager.dart';
import 'package:chime/models/prefs_model.dart';
import 'package:chime/pages/home_page.dart';
import 'package:chime/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'components/app/lotus_icon.dart';
import 'configs/themes/dark_red_theme.dart';
import 'configs/themes/dark_teal_theme.dart';
import 'enums/color_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions? options;
  if (kIsWeb) {
    options = const FirebaseOptions(
        apiKey: "AIzaSyCi67qBQTR_E2aaGB-Oxeh4-EozNhkrLBk",
        authDomain: "pbs-app-d73fc.firebaseapp.com",
        projectId: "pbs-app-d73fc",
        storageBucket: "pbs-app-d73fc.appspot.com",
        messagingSenderId: "815682859282",
        appId: "1:815682859282:web:6c9d266e23a582fdc4c3cb",
        measurementId: "G-WF2D389QEV");

    await Firebase.initializeApp(options: options);
  }

  runApp(const ProviderScope(child: ChimeApp()));
}

class ChimeApp extends ConsumerStatefulWidget {
  const ChimeApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ChimeApp> createState() => _ChimeAppState();
}

class _ChimeAppState extends ConsumerState<ChimeApp> {
  @override
  void initState() {
    _initAudioPlayers();
    super.initState();
  }

  _initAudioPlayers() async {
    await AudioManager().initAudioPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    ThemeData appTheme = darkTealTheme;

    return FutureBuilder<PrefsModel2>(
      future: DatabaseManager().getPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final prefsModel = snapshot.data;

          switch (state.colorTheme) {
            case ColorTheme.darkBlue:
              appTheme = darkBlueTheme;
              break;
            case ColorTheme.darkTeal:
              appTheme = darkTealTheme;
              break;
            case ColorTheme.darkOrange:
              appTheme = darkOrangeTheme;
              break;
            case ColorTheme.darkRed:
              appTheme = darkRedTheme;
              break;
            case ColorTheme.light:
              appTheme = lightTheme;
              break;
          }
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            notifier.setColorTheme(prefsModel!.colorTheme);
          });
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: const HomePage(),
          );
        }
        return const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: LotusIcon(),
            ),
          ),
        );
      },
    );
  }
}

//
// class DATABASETEST extends StatefulWidget {
//   const DATABASETEST({Key? key}) : super(key: key);
//
//   @override
//   State<DATABASETEST> createState() => _DATABASETESTState();
// }
//
// class _DATABASETESTState extends State<DATABASETEST> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(onPressed: (){
//             DatabaseManager().insertIntoPrefs(k: Prefs.colorTheme.name, v: ColorTheme.darkOrange.name);
//           }, child: const Text('insert')),
//           ElevatedButton(onPressed: () async {
//             final data = await DatabaseManager().getPrefs();
//           }, child: const Text('get')),
//         ],
//       ),
//     );
//   }
// }
