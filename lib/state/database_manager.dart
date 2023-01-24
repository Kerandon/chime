import 'package:chime/models/prefs_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      statsDateTime = 'date',
      statsTotalMeditationTime = 'v';

  Future<Database> initDatabase() async {
    final devicePath = await getDatabasesPath();
    final path = join(devicePath, _databaseName);

    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $_prefsTable($statsDateTime TEXT PRIMARY KEY, $prefsValue BLOB NOT NULL)');
      await db.execute(
          'CREATE TABLE $_statsTable($statsDateTime TEXT PRIMARY KEY $statsTotalMeditationTime TEXT NOT NULL');
    }, version: 1);
  }

  Future<int> insertIntoPrefs({required String k, required dynamic v}) async {
    final db = await initDatabase();
    return await db.rawInsert(
        'INSERT OR REPLACE INTO $_prefsTable($statsDateTime, $prefsValue) VALUES(?, ?)',
        [k, v]);
  }

  Future<PrefsModel2> getPrefs() async {
    final db = await initDatabase();
    final data = await db.rawQuery('SELECT * FROM $_prefsTable');
    return PrefsModel2.fromMap(data);
  }

  Future<int> insertIntoStats(
      {required DateTime dateTime, required int minutes}) async {
    final db = await initDatabase();
    return await db.rawInsert(
        'INSERT OR REPLACE INTO $_statsTable($statsDateTime, $statsTotalMeditationTime');
  }

  getStats() async {
    final db = await initDatabase();
    db.rawQuery('SELECT * FROM $_statsTable');

  }
}
