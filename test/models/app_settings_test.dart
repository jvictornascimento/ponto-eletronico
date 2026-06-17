import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_eletronico/models/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('uses one fixed settings row', () {
      final settings = AppSettings.empty();

      expect(settings.id, AppSettings.defaultId);
      expect(settings.halfDayValueCents, 0);
    });

    test('maps the half day value to database columns', () {
      final createdAt = DateTime(2026, 6, 7, 8);
      final updatedAt = DateTime(2026, 6, 7, 12);
      final settings = AppSettings(
        halfDayValueCents: 8000,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(settings.toMap(), {
        'id': 1,
        'half_day_value_cents': 8000,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      });
    });

    test('restores the half day value from a database map', () {
      final settings = AppSettings.fromMap({
        'id': 1,
        'half_day_value_cents': 8000,
        'created_at': '2026-06-07T08:00:00.000',
        'updated_at': '2026-06-07T12:00:00.000',
      });

      expect(settings.halfDayValueCents, 8000);
    });
  });
}
