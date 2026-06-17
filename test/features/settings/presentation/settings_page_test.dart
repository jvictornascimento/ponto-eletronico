import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_eletronico/data/repositories/settings_repository.dart';
import 'package:ponto_eletronico/features/settings/presentation/settings_page.dart';
import 'package:ponto_eletronico/models/app_settings.dart';

void main() {
  testWidgets('shows the saved half day value', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(
          settingsRepository: FakeSettingsRepository(valueCents: 8000),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Valor de meio dia'), findsOneWidget);
    expect(find.widgetWithText(TextField, '80,00'), findsOneWidget);
  });

  testWidgets('saves the typed half day value', (tester) async {
    final repository = FakeSettingsRepository();

    await tester.pumpWidget(
      MaterialApp(home: SettingsPage(settingsRepository: repository)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '120,50');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(repository.savedValueCents, 12050);
    expect(find.text('Valor salvo.'), findsOneWidget);
  });
}

class FakeSettingsRepository extends SettingsRepository {
  FakeSettingsRepository({this.valueCents = 0})
    : super(databaseProvider: () => throw StateError('Database not used.'));

  int valueCents;
  int? savedValueCents;

  @override
  Future<AppSettings> getSettings() async {
    final now = DateTime(2026, 6, 16);

    return AppSettings(
      halfDayValueCents: valueCents,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<AppSettings> saveHalfDayValueCents(int valueCents) async {
    savedValueCents = valueCents;
    this.valueCents = valueCents;

    return getSettings();
  }
}
