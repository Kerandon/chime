import 'package:chime/models/prefs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../utils/pref_constants.dart';

class PreferencesMain {
  static setPreferences({
    int? totalTime,
    int? bellInterval,
    Bell? bellSelected,
    double? bellVolume,
    Ambience? ambienceSelected,
    double? ambienceVolume,
  }) async {
    final instance = await SharedPreferences.getInstance();

    print('set preference ${bellVolume}');


    if (totalTime != null) {
      await instance.setInt(Prefs.totalTime, totalTime);
    }
    if (bellInterval != null) {
      await instance.setInt(Prefs.bellInterval, bellInterval);
    }

    if (bellSelected != null) {
      await instance.setString(Prefs.bellSelected, bellSelected.name);
    }
    if (bellVolume != null) {
      print('set bell volune ${bellVolume}');
      await instance.setDouble(Prefs.bellVolume, bellVolume);
    }
    if (ambienceSelected != null) {
      await instance.setString(Prefs.ambienceSelected, ambienceSelected.name);
    }
    if (ambienceVolume != null) {
      await instance.setDouble(Prefs.ambienceVolume, ambienceVolume);
    }
  }

  static Future<PrefsModel> getPreferences() async {
    final instance = await SharedPreferences.getInstance();

    // int totalTime;
    // int bellInterval;

    int totalTime = instance.getInt(Prefs.totalTime) ?? 60;
    int bellInterval = instance.getInt(Prefs.bellInterval) ?? 5;
    String? b = instance.getString(Prefs.bellSelected) ?? 'chime';
    Bell bellSelected = Bell.chime;
    for (var e in Bell.values) {
      if (b == e.name) {
        bellSelected = e;
      }
    }
    double bellVolume = instance.getDouble(Prefs.bellVolume) ?? 0.50;
    String result =
        instance.getString(Prefs.ambienceSelected) ?? Ambience.none.name;
    Ambience ambienceSelected = Ambience.none;
    for (var a in Ambience.values) {
      if (a.name == result) {
        ambienceSelected = a;
      }
    }
    double ambienceVolume = instance.getDouble(Prefs.ambienceVolume) ?? 0.50;

    return PrefsModel(
      totalTime: totalTime,
      bellInterval: bellInterval,
      bellSelected: bellSelected,
      bellVolume: bellVolume,
      ambienceSelected: ambienceSelected,
      ambienceVolume: ambienceVolume,
    );
  }
}
