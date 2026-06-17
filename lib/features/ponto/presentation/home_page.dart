import 'package:flutter/material.dart';
import 'package:ponto_eletronico/data/repositories/work_day_repository.dart';
import 'package:ponto_eletronico/models/work_day.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.workDayRepository});

  final WorkDayRepository? workDayRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WorkDayRepository _workDayRepository;
  late final String _todayKey;

  WorkDay? _workDay;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _workDayRepository = widget.workDayRepository ?? WorkDayRepository();
    _todayKey = WorkDay.dateKey(DateTime.now());
    _loadToday();
  }

  Future<void> _loadToday() async {
    try {
      final savedWorkDay = await _workDayRepository.findByDate(_todayKey);
      final workDay = savedWorkDay ?? WorkDay.emptyFor(DateTime.now());

      if (!mounted) {
        return;
      }

      setState(() {
        _workDay = workDay;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Nao foi possivel carregar o ponto de hoje.';
      });
    }
  }

  Future<void> _toggleBeforeLunch() async {
    final currentWorkDay = _workDay;
    if (currentWorkDay == null || _isSaving) {
      return;
    }

    await _save(
      currentWorkDay.copyWith(
        workedBeforeLunch: !currentWorkDay.workedBeforeLunch,
      ),
    );
  }

  Future<void> _toggleAfterLunch() async {
    final currentWorkDay = _workDay;
    if (currentWorkDay == null || _isSaving) {
      return;
    }

    await _save(
      currentWorkDay.copyWith(
        workedAfterLunch: !currentWorkDay.workedAfterLunch,
      ),
    );
  }

  Future<void> _save(WorkDay workDay) async {
    setState(() {
      _workDay = workDay;
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final savedWorkDay = await _workDayRepository.save(workDay);

      if (!mounted) {
        return;
      }

      setState(() {
        _workDay = savedWorkDay;
        _isSaving = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _errorMessage = 'Nao foi possivel salvar. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workDay = _workDay;

    return Scaffold(
      appBar: AppBar(title: const Text('Ponto Eletronico')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hoje',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(_todayKey, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              if (_isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (workDay != null) ...[
                PeriodButton(
                  label: 'Antes do almoco',
                  isMarked: workDay.workedBeforeLunch,
                  isSaving: _isSaving,
                  onPressed: _toggleBeforeLunch,
                ),
                const SizedBox(height: 16),
                PeriodButton(
                  label: 'Depois do almoco',
                  isMarked: workDay.workedAfterLunch,
                  isSaving: _isSaving,
                  onPressed: _toggleAfterLunch,
                ),
                const Spacer(),
                Text(
                  _isSaving ? 'Salvando automaticamente...' : 'Autosave ativo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PeriodButton extends StatelessWidget {
  const PeriodButton({
    super.key,
    required this.label,
    required this.isMarked,
    required this.isSaving,
    required this.onPressed,
  });

  final String label;
  final bool isMarked;
  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isMarked
        ? const Color(0xFFC62828)
        : const Color(0xFFECEFF1);
    final foregroundColor = isMarked ? Colors.white : const Color(0xFF263238);

    return SizedBox(
      height: 144,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.65),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMarked ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
