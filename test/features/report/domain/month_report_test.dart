import 'package:flutter_test/flutter_test.dart';
import 'package:ponto_eletronico/features/report/domain/month_report.dart';
import 'package:ponto_eletronico/models/work_day.dart';

void main() {
  test('counts worked days and periods', () {
    final report = MonthReport(
      month: '2026-06',
      workDays: [
        _workDay('2026-06-16', before: true),
        _workDay('2026-06-17', before: true, after: true),
      ],
    );

    expect(report.workedDays, 2);
    expect(report.workedPeriods, 3);
  });
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
