import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponto_eletronico/data/repositories/settings_repository.dart';
import 'package:ponto_eletronico/shared/money/money_formatter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.settingsRepository});

  final SettingsRepository? settingsRepository;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsRepository _settingsRepository;
  late final TextEditingController _halfDayValueController;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _settingsRepository = widget.settingsRepository ?? SettingsRepository();
    _halfDayValueController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _halfDayValueController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsRepository.getSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        _halfDayValueController.text = MoneyFormatter.formatInputCents(
          settings.halfDayValueCents,
        );
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _message = 'Nao foi possivel carregar as configuracoes.';
      });
    }
  }

  Future<void> _saveSettings() async {
    final valueCents = MoneyFormatter.parseToCents(
      _halfDayValueController.text,
    );

    setState(() {
      _isSaving = true;
      _message = null;
    });

    try {
      final settings = await _settingsRepository.saveHalfDayValueCents(
        valueCents,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _halfDayValueController.text = MoneyFormatter.formatInputCents(
          settings.halfDayValueCents,
        );
        _isSaving = false;
        _message = 'Valor salvo.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _message = 'Nao foi possivel salvar.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuracoes')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Valor de meio dia',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _halfDayValueController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor',
                        prefixText: 'R\$ ',
                        helperText: 'Exemplo: 80,00',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: _isSaving ? null : _saveSettings,
                        child: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                      ),
                    ),
                    if (_message != null) ...[
                      const SizedBox(height: 16),
                      Text(_message!, textAlign: TextAlign.center),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
