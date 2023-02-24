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
  final BellIntervalTypeEnum intervalBellType;
  final double bellInterval;
  final double maxRandomBell;
  final bool bellOnStart;
  final bool bellOnEnd;
  final bool bellOnBeginHasPlayed;
  final bool bellOnEndHasPlayed;
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
    required this.maxRandomBell,
    required this.bellOnStart,
    required this.bellOnEnd,
    required this.bellOnBeginHasPlayed,
    required this.bellOnEndHasPlayed,
    required this.ambienceSelected,
    required this.ambienceIsOn,
    required this.ambienceVolume,
    required this.playIntervalBell,
  });

  AudioState copyWith({
    Bell? bellSelected,
    double? bellVolume,
    bool? intervalBellsAreOn,
    BellIntervalTypeEnum? intervalBellType,
    double? bellInterval,
    double? maxRandomBell,
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
      maxRandomBell: maxRandomBell ?? this.maxRandomBell,
      bellInterval: bellInterval ?? this.bellInterval,
      bellOnStart: bellOnStart ?? this.bellOnStart,
      bellOnEnd: bellOnEnd ?? this.bellOnEnd,
      bellOnBeginHasPlayed: bellOnBeginHasPlayed ?? this.bellOnBeginHasPlayed,
      bellOnEndHasPlayed: bellOnEndHasPlayed ?? this.bellOnEndHasPlayed,
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

  void setBellSelected(Bell bell, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellSelected: bell);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellSelected.name, v: bell.name);
  }

  void setBellVolume(double volume, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellVolume: volume);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellVolume.name, v: volume);
  }

  void setBellIntervalsAreOn(bool on, {bool insertInDatabase = true}) async {
    state = state.copyWith(intervalBellsAreOn: on);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellIntervalIsOn.name, v: on);
  }

  void setIntervalBellType(BellIntervalTypeEnum bell,
      {bool insertInDatabase = true}) async {
    state = state.copyWith(intervalBellType: bell);
    await DatabaseManager()
        .insertIntoPrefs(k: Prefs.bellIntervalType.name, v: bell.name);
  }

  void setBellFixedInterval(double interval, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellInterval: interval);
    if (insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.bellIntervalFixedTime.name, v: interval);
    }
  }

  void setMaxRandomRange(double max, {bool insertInDatabase = true}) async {
    state = state.copyWith(maxRandomBell: max);
    if (insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.bellIntervalRandomMax.name, v: max);
    }
  }


  void setBellOnStart(bool on, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellOnStart: on);
    if (insertInDatabase) {
      await DatabaseManager().insertIntoPrefs(k: Prefs.bellOnStart.name, v: on);
    }
  }

  void setBellOnEnd(bool on, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellOnEnd: on);
    if (insertInDatabase) {
      await DatabaseManager().insertIntoPrefs(k: Prefs.bellOnEnd.name, v: on);
    }
  }

  void setBellOnBeginHasPlayed(bool played) async {
    state = state.copyWith(bellOnBeginHasPlayed: played);
  }

  void setAudioOnEndHasPlayed(bool played) {
    state = state.copyWith(bellOnEndHasPlayed: played);
  }


  /// AMBIENCE

  void setAmbience(Ambience ambience, {bool insertInDatabase = true}) async {
    state = state.copyWith(ambienceSelected: ambience);
    if (insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.ambienceSelected.name, v: ambience.name);
    }
  }

  void setAmbienceIsOn(bool on, {bool insertInDatabase = true}) async {
    state = state.copyWith(ambienceIsOn: on);
    if (insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.ambienceIsOn.name, v: on);
    }
  }

  void setAmbienceVolume(double volume, {bool insertInDatabase = true}) async {
    state = state.copyWith(ambienceVolume: volume);
    if (insertInDatabase) {
      await DatabaseManager()
          .insertIntoPrefs(k: Prefs.ambienceVolume.name, v: volume);
    }
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier(AudioState(
    bellSelected: Bell.chime,
    bellVolume: 1.0,
    intervalBellsAreOn: true,
    intervalBellType: BellIntervalTypeEnum.fixed,
    maxRandomBell: 5,
    bellInterval: 2,
    bellOnStart: true,
    bellOnEnd: true,
    bellOnBeginHasPlayed: false,
    bellOnEndHasPlayed: false,
    ambienceSelected: Ambience.none,
    ambienceIsOn: false,
    ambienceVolume: 0.50,
    playIntervalBell: false,
  ));
});
