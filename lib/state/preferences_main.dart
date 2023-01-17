import 'package:chime/enums/sounds.dart';
import 'package:chime/models/prefs_model.dart';
import 'package:chime/utils/pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesMain {


  static setPreferences({int? time, int? interval, Sounds? sound}) async {
    final instance = await SharedPreferences.getInstance();
    if (time != null) {
      await instance.setInt(PrefConstants.time, time);
    }
    if (interval != null) {
      await instance.setInt(PrefConstants.interval, interval);
    }

    if (sound != null) {
      await instance.setString(PrefConstants.sound, sound.name);
    }
  }

  static Future<PrefsModel> getPreferences() async {
    int time;
    int interval;
    Sounds sound = Sounds.chime;
    final instance = await SharedPreferences.getInstance();
    time = instance.getInt(PrefConstants.time) ?? 60;
    interval = instance.getInt(PrefConstants.interval) ?? 5;
    String? s = instance.getString(PrefConstants.sound) ?? 'chime';
    if (s == Sounds.chime.name) {
      sound = Sounds.chime;
    }
    if (s == Sounds.gong.name) {
      sound = Sounds.gong;
    }

    return PrefsModel(time: time, interval: interval, sound: sound);
  }

}
