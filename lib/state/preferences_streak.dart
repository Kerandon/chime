import 'package:shared_preferences/shared_preferences.dart';

import '../models/streak_model.dart';
import '../utils/pref_constants.dart';

class PreferencesStreak {
  static Future<int> getCurrentStreakTotal() async {
    final instance = await SharedPreferences.getInstance();
    final streaks = instance.getStringList(Prefs.streak) ?? [];
    return streaks.length;
  }

  static Future<bool> checkIfStreakStillCurrent() async {
    Set<DateTime> currentDates =
        await getExistingStreakDates(
            await SharedPreferences.getInstance());

    if (currentDates.isEmpty) {
      return false;
    } else {
      final isSuccessive = checkIfEqualOrSuccessiveDay(
          currentDates, DateTime.now());
      if (isSuccessive) {
        return true;
      } else {
        await _clearStreakDates();
        return false;
      }
    }
  }

  static Future<bool> addToStreak(DateTime now) async {
    final instance = await SharedPreferences.getInstance();
    final existingDates = await getExistingStreakDates(instance);
    bool duplicateDay = false;

    if (existingDates.isNotEmpty) {
      duplicateDay = _checkIfDuplicateDay(existingDates, now);
      if (duplicateDay) {
        return true;
      } else {
        bool successiveDay = _checkIfSuccessiveDay(existingDates, now);
        if (successiveDay) {
          existingDates.add(now);
          _checkIfRecord(existingDates, instance);
        } else {
          existingDates.clear();
          _checkIfRecord(existingDates, instance);
        }
      }
    }

    existingDates.add(now);

    List<String> stringDates = [];

    for (var s in existingDates) {
      stringDates.add(s.toString());
    }

    return await instance.setStringList(Prefs.streak, stringDates);
  }

  static Future<Set<DateTime>> getExistingStreakDates(
      SharedPreferences instance) async {
    Set<DateTime> dates = {};
    List<String> existing = instance.getStringList(Prefs.streak) ?? [];
    for (var d in existing) {
      dates.add(DateTime.parse(d));
    }
    return dates;
  }

  static bool _checkIfDuplicateDay(Set<DateTime> existingDates, DateTime now) {
    return existingDates.any((element) =>
        DateTime(element.year, element.month, element.day) ==
        DateTime(now.year, now.month, now.day));
  }

  static bool _checkIfSuccessiveDay(Set<DateTime> existingDates, DateTime now) {
    return existingDates.any((element) =>
        DateTime(element.year, element.month, element.day) ==
        DateTime(now.year, now.month, now.day - 1));
  }

  static bool checkIfEqualOrSuccessiveDay(
      Set<DateTime> existingDates, DateTime now) {
    bool isDuplicate = _checkIfDuplicateDay(existingDates, now);
    bool isSuccessive = _checkIfSuccessiveDay(existingDates, now);
    return isDuplicate || isSuccessive;
  }

  static bool _checkIfRecord(
      Set<DateTime> existingDates, SharedPreferences instance) {
    int currentStreakTotal = existingDates.length;
    final record = instance.getInt(Prefs.record) ?? 0;
    if (currentStreakTotal > record) {
      instance.setInt(Prefs.record, currentStreakTotal);
      return true;
    }
    return false;
  }

  static Future<StreakData> getStreakData() async {
    final current = await getCurrentStreakTotal();
    final instance = await SharedPreferences.getInstance();
    final best = instance.getInt(Prefs.record) ?? 0;
    return StreakData(current: current, best: best);
  }

  static Future<bool> _clearStreakDates() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(Prefs.streak);
    return true;
  }

  static Future<bool> _clearStreakRecord() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(Prefs.record);
    return true;
  }

  static Future<bool> clearAllStreakData() async {
    await _clearStreakDates();
    await _clearStreakRecord();
    return true;
  }
}
