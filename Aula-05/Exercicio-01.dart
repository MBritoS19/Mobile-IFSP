import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0.0;
  String _operator = "";

  void _buttonPressed(String buttonText) {
    // Lógica da calculadora
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0.0;
        _operator = "";
      } else if (buttonText == "+" || buttonText == "=") {
        if (_operator.isEmpty) {
          // Primeira vez que um operador é pressionado
          _num1 = double.parse(_output);
          _operator = buttonText;
          _currentInput = "";
          print("Operador 1: $_num1");
        } else {
          double num2 = double.parse(_output);
          double result = 0.0;

          if (_operator == "+") {
            result = _num1 + num2;
          }

          print("Operador 1: $_num1");
          print("Operador 2: $num2");
          print("Resultado: $result");

          _output = result.toStringAsFixed(
            result.truncateToDouble() == result ? 0 : 2,
          );

          if (buttonText == "=") {
            _operator = ""; // Reseta para próximo cálculo
            _num1 = result;
          } else {
            _operator = buttonText; // Prepara para cálculo encadeado
            _num1 = result;
            _currentInput = "";
          }
        }
      } else {
        if (_currentInput.length < 9) {
          // Limita o número de dígitos
          _currentInput += buttonText;
          _output = _currentInput;
        }
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24.0),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Calculadora Flutter'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          // Visor da Calculadora
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Expanded(child: Divider()),
          // Linhas de botões
          Column(
            children: [
              Row(
                children: <Widget>[
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("0"),
                  _buildButton("="),
                  _buildButton("+"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("C"), // Botão extra para limpar
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
