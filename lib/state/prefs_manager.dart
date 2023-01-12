import 'package:chime/enums/sounds.dart';
import 'package:chime/models/prefs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {

  static setStreak(int number) async {
    final instance = await SharedPreferences.getInstance();
    instance.setInt('streak', number);
  }

  static getStreak() async {


  }

  static setPrefs({int? time, int? interval, Sounds? sound}) async {
    final instance = await SharedPreferences.getInstance();
    if (time != null) {
      print('time set at ${time}');
      await instance.setInt('time', time);
    }
    if (interval != null) {
      await instance.setInt('interval', interval);
    }

    if (sound != null) {
      await instance.setString('sound', sound.name);
    }
  }

  static Future<PrefsModel> getPreferences() async {
    int time;
    int interval;
    Sounds sound = Sounds.chime;
    final instance = await SharedPreferences.getInstance();
    time = instance.getInt('time') ?? 60;
    interval = instance.getInt('interval') ?? 5;
    String? s = instance.getString('sound') ?? 'chime';
    print('get sound string ${s}');
      if (s == Sounds.chime.name) {
        sound = Sounds.chime;
      }
      if(s == Sounds.gong.name){
        sound = Sounds.gong;
      }


    return PrefsModel(time: time, interval: interval, sound: sound);
  }
}
