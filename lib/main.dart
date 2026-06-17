import 'package:flutter/material.dart';

void main() {
  runApp(const PontoEletronicoApp());
}

class PontoEletronicoApp extends StatelessWidget {
  const PontoEletronicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto Eletronico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC62828)),
        useMaterial3: true,
      ),
      home: const HomePlaceholderPage(),
    );
  }
}

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ponto Eletronico')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Mini ponto offline',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text(
                'Base Android criada. As proximas stories adicionam banco local, botoes de meio dia e relatorios.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
