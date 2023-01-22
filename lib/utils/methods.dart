import 'package:chime/state/app_state.dart';

import '../audio/audio_manager.dart';

void playSessionBells(AppState state) {
  if ((state.millisecondsRemaining ~/ 1000) % 60 == 0) {
    int minutesFlat = ((state.millisecondsRemaining ~/ 1000) / 60).round();
    for (var bell in state.bellTimesToRing) {
      if (bell == minutesFlat) {
        AudioManager().playBell(bell: state.bellSelected);
      }
    }
  }
}
