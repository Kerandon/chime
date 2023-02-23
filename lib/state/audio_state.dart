import 'package:chime/enums/ambience.dart';
import 'package:chime/enums/interval_bell.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../enums/bell.dart';
import '../enums/prefs.dart';
import 'database_manager.dart';

class AudioState {
  final Bell bellSelected;
  final double bellVolume;
  final bool intervalBellsAreOn;
  final IntervalBell intervalBellType;
  final double bellInterval;
  final bool bellOnStart;
  final bool bellOnEnd;
  final bool bellOnBeginHasPlayed;
  final bool bellOnEndHasPlayed;
  final Map<int, bool> intervalAudio;
  final Ambience ambienceSelected;
  final bool ambienceIsOn;
  final double ambienceVolume;

  final bool playIntervalBell;

  AudioState({
    required this.bellSelected,
    required this.bellVolume,
    required this.intervalBellsAreOn,
    required this.intervalBellType,
    required this.bellInterval,
    required this.bellOnStart,
    required this.bellOnEnd,
    required this.bellOnBeginHasPlayed,
    required this.bellOnEndHasPlayed,
    required this.intervalAudio,
    required this.ambienceSelected,
    required this.ambienceIsOn,
    required this.ambienceVolume,
    required this.playIntervalBell,
  });

  AudioState copyWith({
    Bell? bellSelected,
    double? bellVolume,
    bool? intervalBellsAreOn,
    IntervalBell? intervalBellType,
    double? bellInterval,
    bool? bellOnStart,
    bool? bellOnEnd,
    bool? bellOnBeginHasPlayed,
    bool? bellOnEndHasPlayed,
    Map<int, bool>? intervalAudio,
    Ambience? ambienceSelected,
    bool? ambienceIsOn,
    double? ambienceVolume,
    bool? playIntervalBell,
  }) {
    return AudioState(
      bellSelected: bellSelected ?? this.bellSelected,
      bellVolume: bellVolume ?? this.bellVolume,
      intervalBellsAreOn: intervalBellsAreOn ?? this.intervalBellsAreOn,
      intervalBellType: intervalBellType ?? this.intervalBellType,
      bellInterval: bellInterval ?? this.bellInterval,
      bellOnStart: bellOnStart ?? this.bellOnStart,
      bellOnEnd: bellOnEnd ?? this.bellOnEnd,
      bellOnBeginHasPlayed: bellOnBeginHasPlayed ?? this.bellOnBeginHasPlayed,
      bellOnEndHasPlayed: bellOnEndHasPlayed ?? this.bellOnEndHasPlayed,
      intervalAudio: intervalAudio ?? this.intervalAudio,
      ambienceSelected: ambienceSelected ?? this.ambienceSelected,
      ambienceIsOn: ambienceIsOn ?? this.ambienceIsOn,
      ambienceVolume: ambienceVolume ?? this.ambienceVolume,
      playIntervalBell: playIntervalBell ?? this.playIntervalBell,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  AudioNotifier(AudioState state) : super(state);

  /// BELLS

  void setBellSelected(Bell bell) async {
    state = state.copyWith(bellSelected: bell);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellSelected.name, v: bell.name);
  }

  void setBellVolume(double volume) async {
    state = state.copyWith(bellVolume: volume);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellVolume.name, v: volume);
  }

  void setIntervalBellsAreOn(bool on) async {
    state = state.copyWith(intervalBellsAreOn: on);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellIntervalIsOn.name, v: on);
  }

  void setIntervalBellType(IntervalBell bell) async {
    state = state.copyWith(intervalBellType: bell);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellType.name, v: bell.name);
  }

  void setBellInterval(double interval) async {
    state = state.copyWith(bellInterval: interval);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellInterval.name, v: interval);
  }

  void setBellOnStart(bool on) async {
    state = state.copyWith(bellOnStart: on);
    await DatabaseManager().insertIntoPrefs(k: Prefs.bellOnStart.name, v: on);
  }

  void setBellOnEnd(bool on) async {
    state = state.copyWith(bellOnEnd: on);
    await DatabaseManager().insertIntoPrefs(k: Prefs.bellOnEnd.name, v: on);
  }

  void setBellOnBeginHasPlayed(bool played) async {
    state = state.copyWith(bellOnBeginHasPlayed: played);
  }

  void setAudioOnEndHasPlayed(bool played) {
    state = state.copyWith(bellOnEndHasPlayed: played);
  }

  void setIntervalBellHasPlayed(int interval, bool played) {
    state = state.copyWith(intervalAudio: {interval: played});
  }

  /// AMBIENCE

  void setAmbience(Ambience ambience) async {
    state = state.copyWith(ambienceSelected: ambience);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.ambienceSelected.name, v: ambience.name);
  }

  void setAmbienceIsOn(bool on) async {
    state = state.copyWith(ambienceIsOn: on);
    await DatabaseManager().insertIntoPrefs(k: Prefs.ambienceIsOn.name, v: on);
  }

  void setAmbienceVolume(double volume) async {
    state = state.copyWith(ambienceVolume: volume);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.ambienceVolume.name, v: volume);
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier(AudioState(
    bellSelected: Bell.chime,
    bellVolume: 1.0,
    intervalBellsAreOn: true,
    intervalBellType: IntervalBell.fixed,
    bellInterval: 2,
    bellOnStart: true,
    bellOnEnd: true,
    bellOnBeginHasPlayed: false,
    bellOnEndHasPlayed: false,
    intervalAudio: {},
    ambienceSelected: Ambience.none,
    ambienceIsOn: false,
    ambienceVolume: 0.50,
    playIntervalBell: false,
  ));
});
