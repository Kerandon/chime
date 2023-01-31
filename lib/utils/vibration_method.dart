import 'package:vibration/vibration.dart';

Future<void> vibrateDevice() async {
  if (await Vibration.hasVibrator() == true) {
    Vibration.vibrate();
  }
}
