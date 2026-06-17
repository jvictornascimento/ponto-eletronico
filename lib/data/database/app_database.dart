import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static const databaseName = 'ponto_eletronico.db';
  static const databaseVersion = 1;

  static const workDayTable = 'work_day';

  static Database? _database;

  static Future<Database> open() => instance;

  static Future<Database> get instance async {
    final currentDatabase = _database;
    if (currentDatabase != null) {
      return currentDatabase;
    }

    final databasePath = await getDatabasesPath();
    final fullPath = path.join(databasePath, databaseName);

    _database = await openDatabase(
      fullPath,
      version: databaseVersion,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE $workDayTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            worked_before_lunch INTEGER NOT NULL DEFAULT 0 CHECK (worked_before_lunch IN (0, 1)),
            worked_after_lunch INTEGER NOT NULL DEFAULT 0 CHECK (worked_after_lunch IN (0, 1)),
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }
}
