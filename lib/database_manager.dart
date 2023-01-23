import 'package:chime/enums/color_themes.dart';
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
      column1Prefs = 'k',
      column2Prefs = 'v';

  Future<Database> initDatabase() async {
    final devicePath = await getDatabasesPath();
    final path = join(devicePath, _databaseName);

    return await openDatabase(path, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $_prefsTable($column1Prefs TEXT PRIMARY KEY, $column2Prefs BLOB NOT NULL)');
    }, version: 1);
  }

  Future<int> insertIntoPrefs({required String k, required dynamic v}) async {
    final db = await initDatabase();
    return await db.rawInsert(
        'INSERT OR REPLACE INTO $_prefsTable($column1Prefs, $column2Prefs) VALUES(?, ?)',
        [k, v]);
  }

 Future<PrefsModel2> getPrefs() async {

    print('get prefs');

    final db = await initDatabase();
    final data = await db.rawQuery('SELECT * FROM $_prefsTable');

    return PrefsModel2.fromMap(data);
  }

}
