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
      title: 'Calculadora com Abas',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalculadoraCirculoComAbas(),
    );
  }
}

class CalculadoraCirculoComAbas extends StatefulWidget {
  const CalculadoraCirculoComAbas({super.key});

  @override
  State<CalculadoraCirculoComAbas> createState() =>
      _CalculadoraCirculoComAbasState();
}

class _CalculadoraCirculoComAbasState extends State<CalculadoraCirculoComAbas>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controladorRaio = TextEditingController();

  double? _diametro;
  double? _circunferencia;
  double? _area;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controladorRaio.dispose();
    super.dispose();
  }

  void _calcular() {
    final double? raio = double.tryParse(_controladorRaio.text);

    if (raio != null && raio > 0) {
      setState(() {
        _diametro = 2 * raio;
        _circunferencia = 2 * pi * raio;
        _area = pi * pow(raio, 2);
      });

      _tabController.animateTo(1);
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
        title: const Text('Cálculos de Círculo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Raio', icon: Icon(Icons.settings_input_component)),
            Tab(text: 'Diâmetro', icon: Icon(Icons.straighten)),
            Tab(text: 'Circunferência', icon: Icon(Icons.circle_outlined)),
            Tab(text: 'Área', icon: Icon(Icons.pie_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAbaRaio(),
          _buildAbaResultado('Diâmetro', _diametro, 'un'),
          _buildAbaResultado('Circunferência', _circunferencia, 'un'),
          _buildAbaResultado('Área', _area, 'un²'),
        ],
      ),
    );
  }

  Widget _buildAbaRaio() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controladorRaio,
            decoration: const InputDecoration(
              labelText: 'Digite o valor do raio',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calcular,
            child: const Text('Calcular'),
          ),
        ],
      ),
    );
  }

  Widget _buildAbaResultado(String titulo, double? valor, String unidade) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'O $titulo é:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            valor != null ? '${valor.toStringAsFixed(2)} $unidade' : '...',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
