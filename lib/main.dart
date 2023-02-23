import 'dart:async';
import 'package:chime/enums/app_color_themes.dart';
import 'package:chime/pages/home.dart';
import 'package:chime/state/audio_state.dart';
import 'package:chime/state/database_manager.dart';
import 'package:chime/models/prefs_model.dart';
import 'package:chime/state/app_state.dart';
import 'package:chime/utils/methods/cache_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'configs/app_colors.dart';
import 'configs/themes/custom_app_theme.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  late final Future<PrefsModel> _prefFuture;
  late final Future<int> _cacheImagesFuture;

  @override
  void initState() {
    _prefFuture = DatabaseManager().getPrefs();
    _cacheImagesFuture =
        cacheImage(context: context, url: 'assets/images/meditation.png');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(stateProvider);
    final appNotifier = ref.read(stateProvider.notifier);

    final audioNotifier = ref.read(audioProvider.notifier);

    AppColorTheme colorTheme = AppColorTheme.turquoise;
    return FutureBuilder<dynamic>(
      future: Future.wait(
        [_prefFuture, _cacheImagesFuture],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final prefsModel = snapshot.data[0];

          colorTheme = AppColors.themeColors
              .firstWhere(
                  (element) => element.color.name == appState.colorTheme.name)
              .color;
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              if (!_prefsUpdated) {
                //APP
                appNotifier.setOpenSession(prefsModel.isOpenSession);
                appNotifier.setTotalTimeAfterRestart(prefsModel.totalTime);
                appNotifier.setTotalCountdownTime(prefsModel.totalCountdown);
                appNotifier.setCountdownIsOn(prefsModel.countdownIsOn);
                appNotifier.setColorTheme(prefsModel.colorTheme);
                appNotifier.setBrightness(prefsModel.brightness);

                //AUDIO
                audioNotifier.setBellSelected(prefsModel.bellSelected);
                audioNotifier.setBellVolume(prefsModel.bellVolume);
                audioNotifier.setBellInterval(prefsModel.bellInterval);
                audioNotifier.setIntervalBellsAreOn(prefsModel.intervalBellsAreOn);
                audioNotifier.setBellOnStart(prefsModel.bellOnStart);
                audioNotifier.setBellOnEnd(prefsModel.bellOnEnd);
                audioNotifier.setAmbience(prefsModel.ambienceSelected);
                audioNotifier.setAmbienceIsOn(prefsModel.ambienceIsOn);
                audioNotifier.setAmbienceVolume(prefsModel.ambienceVolume);

                _prefsUpdated = true;
                Timer.periodic(
                  const Duration(milliseconds: 500),
                  (timer) {
                    FlutterNativeSplash.remove();
                  },
                );
              }
            },
          );
        }

        final appTheme = CustomAppTheme.getThemeData(
            theme: colorTheme,
            brightness:
                appState.isDarkTheme ? Brightness.dark : Brightness.light);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: const Home(),
        );
      },
    );
  }
}
