import 'package:flutter/material.dart';
import 'package:ponto_eletronico/data/repositories/settings_repository.dart';
import 'package:ponto_eletronico/data/repositories/work_day_repository.dart';
import 'package:ponto_eletronico/features/report/application/month_report_pdf_generator.dart';
import 'package:ponto_eletronico/features/report/domain/month_report.dart';
import 'package:ponto_eletronico/models/work_day.dart';
import 'package:ponto_eletronico/shared/money/money_formatter.dart';

class MonthReportPage extends StatefulWidget {
  const MonthReportPage({
    super.key,
    this.workDayRepository,
    this.settingsRepository,
    this.pdfGenerator = const MonthReportPdfGenerator(),
  });

  final WorkDayRepository? workDayRepository;
  final SettingsRepository? settingsRepository;
  final MonthReportPdfGenerator pdfGenerator;

  @override
  State<MonthReportPage> createState() => _MonthReportPageState();
}

class _MonthReportPageState extends State<MonthReportPage> {
  late final WorkDayRepository _workDayRepository;
  late final SettingsRepository _settingsRepository;
  late final TextEditingController _monthController;

  bool _isLoading = false;
  bool _isGeneratingPdf = false;
  String? _message;
  MonthReport? _report;

  @override
  void initState() {
    super.initState();
    _workDayRepository = widget.workDayRepository ?? WorkDayRepository();
    _settingsRepository = widget.settingsRepository ?? SettingsRepository();
    _monthController = TextEditingController(text: _currentMonth());
    _loadReport();
  }

  Future<void> _generatePdf() async {
    final report = _report;
    if (report == null || _isGeneratingPdf) {
      return;
    }

    setState(() {
      _isGeneratingPdf = true;
      _message = null;
    });

    final bytes = await widget.pdfGenerator.generate(report);

    if (!mounted) {
      return;
    }

    setState(() {
      _isGeneratingPdf = false;
      _message = 'PDF gerado (${bytes.length} bytes).';
    });
  }

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  Future<void> _loadReport() async {
    final month = _monthController.text.trim();
    if (month.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final settings = await _settingsRepository.getSettings();
    final workDays = await _workDayRepository.findMarkedByMonth(month);

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _report = MonthReport(
        month: month,
        workDays: workDays,
        halfDayValueCents: settings.halfDayValueCents,
      );
      _message = workDays.isEmpty ? 'Nenhum ponto marcado nesse mes.' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;

    return Scaffold(
      appBar: AppBar(title: const Text('Relatorio mensal')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _monthController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mes',
                  helperText: 'Formato: 2026-06',
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _isLoading ? null : _loadReport,
                child: const Text('Gerar relatorio'),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                if (_message != null) ...[
                  Text(_message!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                ],
                if (report != null && report.workDays.isNotEmpty)
                  Expanded(
                    child: MonthReportView(
                      report: report,
                      isGeneratingPdf: _isGeneratingPdf,
                      onGeneratePdf: _generatePdf,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _currentMonth() {
    final now = DateTime.now();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');

    return '$year-$month';
  }
}

class MonthReportView extends StatelessWidget {
  const MonthReportView({
    super.key,
    required this.report,
    required this.isGeneratingPdf,
    required this.onGeneratePdf,
  });

  final MonthReport report;
  final bool isGeneratingPdf;
  final VoidCallback onGeneratePdf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          report.month,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: report.workDays.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return MonthReportTile(workDay: report.workDays[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
        Text('Dias trabalhados: ${report.workedDays}'),
        Text('Periodos: ${report.workedPeriods}'),
        Text('Total: ${MoneyFormatter.formatCents(report.totalValueCents)}'),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: isGeneratingPdf ? null : onGeneratePdf,
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(isGeneratingPdf ? 'Gerando...' : 'Gerar PDF'),
          ),
        ),
      ],
    );
  }
}

class MonthReportTile extends StatelessWidget {
  const MonthReportTile({super.key, required this.workDay});

  final WorkDay workDay;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(workDay.date),
      subtitle: Text(
        'Antes: ${_yesNo(workDay.workedBeforeLunch)} | Depois: ${_yesNo(workDay.workedAfterLunch)}',
      ),
    );
  }

  String _yesNo(bool value) => value ? 'Sim' : 'Nao';
}
