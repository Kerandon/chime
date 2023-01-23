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
  bool _prefsUpdated = false;

  late final Future<PrefsModel2> _futurePref;

  @override
  void initState() {
    _futurePref = DatabaseManager().getPrefs();
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
      future: _futurePref,
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
            if (!_prefsUpdated) {

              print('bell ${prefsModel!.bellSelected}');
              notifier.setTotalTime(prefsModel!.totalTime);
              notifier.setTotalCountdownTime(prefsModel.totalCountdown);
              notifier.setBellSelected(prefsModel.bellSelected);
              notifier.setBellIntervalTime(prefsModel.bellInterval);
              notifier.setBellVolume(prefsModel.bellVolume);
              notifier.setBellOnSessionStart(prefsModel.bellOnStart);
              notifier.setAmbienceSelected(prefsModel.ambienceSelected);
              notifier.setAmbienceVolume(prefsModel.ambienceVolume);
              notifier.setColorTheme(prefsModel.colorTheme);
              notifier.setHideClock(prefsModel.hideClock);

              _prefsUpdated = true;
            }
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
