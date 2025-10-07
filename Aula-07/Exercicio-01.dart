import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo de Área',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TelaRaio(),
    );
  }
}

class TelaRaio extends StatefulWidget {
  const TelaRaio({super.key});

  @override
  State<TelaRaio> createState() => _TelaRaioState();
}

class _TelaRaioState extends State<TelaRaio> {
  final _controladorRaio = TextEditingController();

  @override
  void dispose() {
    _controladorRaio.dispose();
    super.dispose();
  }

  void _navegarParaResultado() {
    final double? raio = double.tryParse(_controladorRaio.text);

    if (raio != null && raio > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaArea(raio: raio),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Por favor, digite um número válido e positivo para o raio.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Área - Raio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controladorRaio,
              decoration: const InputDecoration(
                labelText: 'Digite o raio do círculo',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navegarParaResultado,
              child: const Text('Calcular Área'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaArea extends StatelessWidget {
  final double raio;

  const TelaArea({super.key, required this.raio});

  @override
  Widget build(BuildContext context) {
    final double area = pi * raio * raio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Área'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Para um círculo com raio de:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              raio.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'A área calculada é:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              area.toStringAsFixed(2),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
