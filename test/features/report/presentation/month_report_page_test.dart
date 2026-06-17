import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_eletronico/data/repositories/work_day_repository.dart';
import 'package:ponto_eletronico/features/report/presentation/month_report_page.dart';
import 'package:ponto_eletronico/models/work_day.dart';

void main() {
  testWidgets('shows marked days and totals for a month', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MonthReportPage(
          workDayRepository: FakeWorkDayRepository(
            monthResults: [
              _workDay('2026-06-16', before: true),
              _workDay('2026-06-17', before: true, after: true),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '2026-06');
    await tester.tap(find.text('Gerar relatorio'));
    await tester.pumpAndSettle();

    expect(find.text('2026-06-16'), findsOneWidget);
    expect(find.text('2026-06-17'), findsOneWidget);
    expect(find.text('Dias trabalhados: 2'), findsOneWidget);
    expect(find.text('Periodos: 3'), findsOneWidget);
  });
}

class FakeWorkDayRepository extends WorkDayRepository {
  FakeWorkDayRepository({this.monthResults = const []})
    : super(databaseProvider: () => throw StateError('Database not used.'));

  final List<WorkDay> monthResults;

  @override
  Future<List<WorkDay>> findMarkedByMonth(String month) async => monthResults;
}

WorkDay _workDay(String date, {bool before = false, bool after = false}) {
  final now = DateTime(2026, 6, 16);

  return WorkDay(
    id: 1,
    date: date,
    workedBeforeLunch: before,
    workedAfterLunch: after,
    createdAt: now,
    updatedAt: now,
  );
}
