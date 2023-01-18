import 'package:shared_preferences/shared_preferences.dart';

import '../enums/ambience.dart';
import '../utils/pref_constants.dart';
//
// class PreferencesAmbience {
//   static Future<void> setAmbienceSelected(Ambience ambience) async {
//     final instance = await SharedPreferences.getInstance();
//     await instance.setString(PrefConstants.ambienceSelected, ambience.name);
//   }
//
//   static Future<void> setAmbienceVolume(double volume) async {
//     final instance = await SharedPreferences.getInstance();
//     await instance.setDouble(PrefConstants.ambienceVolume, volume);
//   }
//
//   static Future<Ambience> getAmbience() async {
//     Ambience ambience = Ambience.none;
//     final instance = await SharedPreferences.getInstance();
//     final result = instance.getString(PrefConstants.ambienceSelected) ??
//         Ambience.none.name;
//
//     for (var a in Ambience.values) {
//       if (a.name == result) {
//         ambience = a;
//       }
//     }
//     return ambience;
//   }
//
//   static Future<double> getAmbienceVolume() async {
//     final instance = await SharedPreferences.getInstance();
//     return instance.getDouble(PrefConstants.ambienceVolume) ?? 0;
//   }
// }
