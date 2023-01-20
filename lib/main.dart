import 'package:chime/audio/audio_manager.dart';
import 'package:chime/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'configs/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  runApp(const ChimeApp());
}

class ChimeApp extends StatefulWidget {
  const ChimeApp({Key? key}) : super(key: key);

  @override
  State<ChimeApp> createState() => _ChimeAppState();
}

class _ChimeAppState extends State<ChimeApp> {
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
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomePage(),
      ),
    );
  }
}
