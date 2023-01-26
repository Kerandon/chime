import 'package:chime/enums/time_period.dart';
import 'package:chime/models/prefs_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/stats_model.dart';

class DatabaseManager {
  DatabaseManager._internal();

  static final _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  Database? _database;

  static const String _databaseName = 'app_data',
      _prefsTable = 'prefs_table',
      prefsKey = 'k',
      prefsValue = 'v',
      _statsTable = 'stats_table',
      statsDateTime = 'date_time',
      statsTotalMeditationTime = 'meditation_time';

  Future<Database> initDatabase() async {
    final devicePath = await getDatabasesPath();
    final path = join(devicePath, _databaseName);

    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_prefsTable($prefsKey TEXT PRIMARY KEY, $prefsValue BLOB NOT NULL)');
      await db.execute(
          'CREATE TABLE $_statsTable($statsDateTime TEXT PRIMARY KEY, $statsTotalMeditationTime INT NOT NULL)');
    }, version: 1);
  }

  Future<int> insertIntoPrefs({required String k, required dynamic v}) async {
    final db = await initDatabase();
    return await db.rawInsert(
        'INSERT OR REPLACE INTO $_prefsTable($prefsKey, $prefsValue) VALUES(?, ?)',
        [k, v]);
  }

  Future<PrefsModel2> getPrefs() async {
    final db = await initDatabase();
    final data = await db.rawQuery('SELECT * FROM $_prefsTable');
    return PrefsModel2.fromListMap(data);
  }

  Future<int> insertIntoStats(
      {required DateTime dateTime, required int minutes}) async {
    final db = await initDatabase();
    return await db.rawInsert(
        'INSERT OR REPLACE INTO $_statsTable($statsDateTime, $statsTotalMeditationTime) VALUES (?,?)',
        [dateTime.toString(), minutes]);
  }

  Future<List<StatsModel>> getStats(TimePeriod period) async {
    final db = await initDatabase();
    //final data = await db.rawQuery('SELECT * FROM $_statsTable');

    List<Map<String, dynamic>> data = [];

    if (period == TimePeriod.week) {
      data = await db.rawQuery('SELECT SUM($statsTotalMeditationTime) as $statsTotalMeditationTime,  strftime(\"%d-%m-%Y\", $statsDateTime) as \'$statsDateTime\' from $_statsTable WHERE $statsDateTime > (SELECT DATETIME(\'now\', \'-7 day\')) group by strftime("%d-%m-%Y", $statsDateTime)');
    }else if(period == TimePeriod.monthly){
     data = await db.rawQuery('SELECT SUM($statsTotalMeditationTime) as $statsTotalMeditationTime,  strftime(\"%m-%Y\", $statsDateTime) as \'$statsDateTime\' from $_statsTable WHERE $statsDateTime > (SELECT DATETIME(\'now\', \'-1 year\')) group by strftime("%m-%Y", $statsDateTime)');
    }

    final allData = await db.rawQuery('SELECT * FROM $_statsTable');

    for(var d in allData){
      print('sqlite data is ${d.entries}');
    }

     return List.generate(
      data.length,
      (index) => StatsModel.fromMap(
        data.elementAt(index),
      ),
    ).toList();
  }

  Future clearAllStats() async {
    final db = await initDatabase();
    db.delete(_statsTable);
    db.delete(_prefsTable);
  }
}
