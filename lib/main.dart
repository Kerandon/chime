import 'dart:async';
import 'package:chime/enums/app_color_themes.dart';
import 'package:chime/pages/home_page/home.dart';
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
import 'audio/audio_manager_new.dart';
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
  void dispose() {
   AudioManagerNew().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

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
                appNotifier.setOpenSession(prefsModel.isOpenSession,
                    insertInDatabase: false);
                appNotifier.setTotalTimeAfterRestart(
                  prefsModel.totalTime,
                );
                appNotifier.setTotalCountdownTime(prefsModel.totalCountdown,
                    insertInDatabase: false);
                appNotifier.setCountdownIsOn(
                  prefsModel.countdownIsOn,
                );
                appNotifier.setColorTheme(prefsModel.colorTheme,
                    insertInDatabase: false);
                appNotifier.setBrightness(prefsModel.brightness,
                    insertInDatabase: false);
                appNotifier.showTimerDesign(prefsModel.timerShow,
                    insertInDatabase: false);
                appNotifier.setTimerDesign(prefsModel.timerDesign,
                    insertInDatabase: false);

                //AUDIO
                audioNotifier.setBellSelected(prefsModel.bellSelected,
                    insertInDatabase: false);
                audioNotifier.setBellVolume(prefsModel.bellVolume,
                    insertInDatabase: false);
                audioNotifier.setBellFixedInterval(
                    prefsModel.bellIntervalFixedTime,
                    insertInDatabase: false);
                audioNotifier.setBellIntervalsAreOn(prefsModel.bellIntervalIsOn,
                    insertInDatabase: false);
                audioNotifier.setBellOnStart(prefsModel.bellOnStart,
                    insertInDatabase: false);
                audioNotifier.setBellOnEnd(prefsModel.bellOnEnd,
                    insertInDatabase: false);
                audioNotifier.setIntervalBellType(prefsModel.bellIntervalType,
                    insertInDatabase: false);
                audioNotifier.setMaxRandomRange(
                    prefsModel.bellIntervalRandomMax,
                    insertInDatabase: false);
                audioNotifier.setAmbience(prefsModel.ambienceSelected,
                    insertInDatabase: false);
                audioNotifier.setAmbienceIsOn(prefsModel.ambienceIsOn,
                    insertInDatabase: false);
                audioNotifier.setAmbienceVolume(prefsModel.ambienceVolume,
                    insertInDatabase: false);

                _prefsUpdated = true;
                Timer.periodic(
                  const Duration(milliseconds: 800),
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
