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
      title: 'Flutter Calculator Pro',
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

  void _clear() {
    _output = "0";
    _currentInput = "";
    _num1 = 0.0;
    _operator = "";
  }

  void _calculate() {
    if (_operator.isEmpty || _currentInput.isEmpty) return;

    double num2 = double.parse(_currentInput);
    double result = 0.0;

    if (_operator == "/" && num2 == 0) {
      _output = "Erro";
      _num1 = 0.0;
      _operator = "";
      _currentInput = "";
      return;
    }

    switch (_operator) {
      case "+":
        result = _num1 + num2;
        break;
      case "-":
        result = _num1 - num2;
        break;
      case "*":
        result = _num1 * num2;
        break;
      case "/":
        result = _num1 / num2;
        break;
    }

    _output = result.toStringAsFixed(
      result.truncateToDouble() == result ? 0 : 4,
    );
    _num1 = result;
    _currentInput = "";
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (_output == "Erro") _clear();

      switch (buttonText) {
        case "C":
          _clear();
          break;
        case "+":
        case "-":
        case "*":
        case "/":
          if (_currentInput.isNotEmpty) {
            _calculate();
          }
          _operator = buttonText;
          _num1 = double.parse(_output);
          _currentInput = "";
          break;
        case "=":
          _calculate();
          _operator = "";
          break;
        case ".":
          if (!_currentInput.contains(".")) {
            _currentInput += ".";
            _output = _currentInput;
          }
          break;
        default:
          if (_currentInput.length < 9) {
            _currentInput += buttonText;
            _output = _currentInput;
          }
      }
    });
  }

  Widget _buildButton(
    String buttonText, {
    int flex = 1,
    Color color = Colors.black54,
    Color textColor = Colors.white,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: color,
            foregroundColor: textColor,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
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
    final operatorColor = Colors.orange;
    final numberColor = Colors.grey[850]!;
    final functionColor = Colors.grey[400]!;
    final functionTextColor = Colors.black;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 22,
                ),
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      _buildButton("7", color: numberColor),
                      _buildButton("8", color: numberColor),
                      _buildButton("9", color: numberColor),
                      _buildButton("/", color: operatorColor),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton("4", color: numberColor),
                      _buildButton("5", color: numberColor),
                      _buildButton("6", color: numberColor),
                      _buildButton("*", color: operatorColor),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton("1", color: numberColor),
                      _buildButton("2", color: numberColor),
                      _buildButton("3", color: numberColor),
                      _buildButton("-", color: operatorColor),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton(
                        "C",
                        color: functionColor,
                        textColor: functionTextColor,
                      ),
                      _buildButton("0", color: numberColor),
                      _buildButton(".", color: numberColor),
                      _buildButton("+", color: operatorColor),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton("=", flex: 4, color: operatorColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
