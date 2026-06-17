import 'package:ponto_eletronico/data/database/app_database.dart';
import 'package:ponto_eletronico/models/app_settings.dart';
import 'package:sqflite/sqflite.dart';

class SettingsRepository {
  SettingsRepository({Future<Database> Function()? databaseProvider})
    : _databaseProvider = databaseProvider ?? AppDatabase.open;

  final Future<Database> Function() _databaseProvider;

  Future<AppSettings> getSettings() async {
    final database = await _databaseProvider();
    final rows = await database.query(
      AppDatabase.settingsTable,
      where: 'id = ?',
      whereArgs: [AppSettings.defaultId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return AppSettings.empty();
    }

    return AppSettings.fromMap(rows.first);
  }

  Future<AppSettings> saveHalfDayValueCents(int valueCents) async {
    if (valueCents < 0) {
      throw ArgumentError.value(
        valueCents,
        'valueCents',
        'Half day value cannot be negative.',
      );
    }

    final database = await _databaseProvider();
    final currentSettings = await getSettings();
    final now = DateTime.now();
    final valueToSave = currentSettings.copyWith(
      halfDayValueCents: valueCents,
      updatedAt: now,
    );

    await database.insert(
      AppDatabase.settingsTable,
      valueToSave.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return valueToSave;
  }
}
