import 'package:flutter/material.dart';
import 'package:ponto_eletronico/data/repositories/work_day_repository.dart';
import 'package:ponto_eletronico/features/ponto/presentation/home_page.dart';

void main() {
  runApp(const PontoEletronicoApp());
}

class PontoEletronicoApp extends StatelessWidget {
  const PontoEletronicoApp({super.key, this.workDayRepository});

  final WorkDayRepository? workDayRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto Eletronico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC62828)),
        useMaterial3: true,
      ),
      home: HomePage(workDayRepository: workDayRepository),
    );
  }
}
