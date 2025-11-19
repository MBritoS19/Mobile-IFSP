import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IFSP',
      theme: ThemeData.dark(), // Tema escuro fica bonito para calculadoras
      home: const CalculatorScreen(),
    );
  }
}
