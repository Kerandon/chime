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
      prefsKeyColumn = 'k',
      prefsValueColumn = 'v',
      _statsTable = 'stats_table',
      statsDateTimeColumn = 'date_time',
      statsTotalMeditationTimeColumn = 'meditation_time';

  Future<Database> initDatabase() async {
    final devicePath = await getDatabasesPath();
    final path = join(devicePath, _databaseName);

    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_prefsTable($prefsKeyColumn TEXT PRIMARY KEY, $prefsValueColumn BLOB NOT NULL)');
      await db.execute(
          'CREATE TABLE $_statsTable($statsDateTimeColumn TEXT PRIMARY KEY, $statsTotalMeditationTimeColumn INT NOT NULL)');
    }, version: 1);
  }

  Future<int> insertIntoPrefs({required String k, required dynamic v}) async {
    _database = await initDatabase();
    return await _database!.rawInsert(
        'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
        [k, v]);
  }

  Future<PrefsModel> getPrefs() async {
    _database = await initDatabase();
    final data = await _database!.rawQuery('SELECT * FROM $_prefsTable');
    return PrefsModel.fromListMap(data);
  }

  Future<int> insertIntoStats(
      {required DateTime dateTime, required int minutes}) async {
    _database = await initDatabase();
    return await _database!.rawInsert(
        'INSERT OR REPLACE INTO $_statsTable($statsDateTimeColumn, $statsTotalMeditationTimeColumn) VALUES (?,?)',
        [dateTime.toString(), minutes]);
  }

  Future<List<StatsModel>> getStatsByTimePeriod(
      {TimePeriod? period,
      bool? allTimeGroupedByDay,
      bool? allTimeUngrouped}) async {
    final db = await initDatabase();

    List<Map<String, dynamic>> data = [];

    if (allTimeUngrouped == true) {
      data = await db.rawQuery(
          'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable ORDER BY date($statsDateTimeColumn) DESC');
    } else if (allTimeGroupedByDay == true) {
      data = await db.rawQuery(
          'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable GROUP BY strftime("%d-%m-%Y", $statsDateTimeColumn) ORDER BY date($statsDateTimeColumn) DESC');
    } else {
      if (period == TimePeriod.week) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable WHERE $statsDateTimeColumn > (SELECT DATETIME(\'now\', \'-7 day\')) GROUP BY strftime("%d-%m-%Y", $statsDateTimeColumn)');
      } else if (period == TimePeriod.fortnight) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable WHERE $statsDateTimeColumn > (SELECT DATETIME(\'now\', \'-14 day\')) GROUP BY strftime("%d-%m-%Y", $statsDateTimeColumn)');
      } else if (period == TimePeriod.year) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable WHERE $statsDateTimeColumn > (SELECT DATETIME(\'now\', \'-1 year\')) GROUP BY strftime("%m-%Y", $statsDateTimeColumn)');
      } else if (period == TimePeriod.allTime) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable GROUP BY strftime("%Y", $statsDateTimeColumn)');
      }
    }

    return List.generate(
      data.length,
      (index) => StatsModel.fromMap(
        map: data.elementAt(index),
        timePeriod: period!,
      ),
    ).toList();
  }

  Future<StatsModel> getLastEntry() async {
    _database = await initDatabase();
    final map = await _database!.rawQuery(
        'SELECT * FROM $_statsTable ORDER BY $statsDateTimeColumn DESC LIMIT 1');
    return StatsModel.fromMap(map: map.first, timePeriod: TimePeriod.allTime);
  }

  Future<List<StatsModel>> getAllStats() async {
    _database = await initDatabase();

    final maps = await _database!.rawQuery('SELECT * FROM $_statsTable');

    return List.generate(
        maps.length, (index) => StatsModel.fromMap(map: maps[index]));
  }

  Future<void> removeStats(List<DateTime> dateTimes) async {
    _database = await initDatabase();

    for (var d in dateTimes) {
      await _database!.rawQuery(
          'DELETE FROM $_statsTable WHERE $statsDateTimeColumn = ?',
          [d.toString()]);
    }
  }

  Future removeAllPrefsAndStats() async {
    _database = await initDatabase();
    _database!.delete(_prefsTable);
    _database!.delete(_statsTable);


  }
}
