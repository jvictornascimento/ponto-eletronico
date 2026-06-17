import 'package:ponto_eletronico/models/work_day.dart';

class MonthReport {
  const MonthReport({required this.month, required this.workDays});

  final String month;
  final List<WorkDay> workDays;

  int get workedDays => workDays.length;

  int get workedPeriods {
    return workDays.fold(0, (total, workDay) {
      final before = workDay.workedBeforeLunch ? 1 : 0;
      final after = workDay.workedAfterLunch ? 1 : 0;

      return total + before + after;
    });
  }
}
