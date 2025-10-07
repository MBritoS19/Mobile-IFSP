import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Idade',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const TelaNascimento(),
    );
  }
}

class TelaNascimento extends StatefulWidget {
  const TelaNascimento({super.key});

  @override
  State<TelaNascimento> createState() => _TelaNascimentoState();
}

class _TelaNascimentoState extends State<TelaNascimento> {
  DateTime? _dataSelecionada;

  Future<void> _apresentarDatePicker() async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  void _navegarParaResultado() {
    if (_dataSelecionada != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaIdade(dataNascimento: _dataSelecionada!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o Nascimento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _dataSelecionada == null
                  ? 'Nenhuma data selecionada.'
                  : 'Data de Nascimento: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada!)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _apresentarDatePicker,
              child: const Text('Selecionar Data'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _dataSelecionada == null ? null : _navegarParaResultado,
              child: const Text('Calcular Idade'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaIdade extends StatelessWidget {
  final DateTime dataNascimento;

  const TelaIdade({super.key, required this.dataNascimento});

  int _calcularIdade(DateTime nascimento) {
    final DateTime hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  @override
  Widget build(BuildContext context) {
    final int idade = _calcularIdade(dataNascimento);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Idade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sua idade é:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              '$idade anos',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
