import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();

  @override
  void initState() {
    super.initState();
    _controller.loadLastState(() => setState(() {}));
  }

  void _refreshUI() {
    setState(() {});
  }

  Widget _buildButton(
    String text, {
    Color bgColor = Colors.grey,
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _controller.onButtonPressed(text, _refreshUI),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _controller.memory != 0 ? 'M' : '',
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Text(
                    _controller.equation,
                    style: const TextStyle(fontSize: 30, color: Colors.white54),
                  ),
                  Text(
                    _controller.display,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          Column(
            children: [
              Row(
                children: [
                  _buildButton('MC', bgColor: Colors.orange),
                  _buildButton('MR', bgColor: Colors.orange),
                  _buildButton('M+', bgColor: Colors.orange),
                  _buildButton('M-', bgColor: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('C', bgColor: Colors.redAccent),
                  _buildButton('/', bgColor: Colors.blue),
                  _buildButton('*', bgColor: Colors.blue),
                  _buildButton('-', bgColor: Colors.blue),
                ],
              ),
              Row(
                children: [
                  _buildButton('7', bgColor: Colors.white24),
                  _buildButton('8', bgColor: Colors.white24),
                  _buildButton('9', bgColor: Colors.white24),
                  _buildButton('+', bgColor: Colors.blue),
                ],
              ),
              Row(
                children: [
                  _buildButton('4', bgColor: Colors.white24),
                  _buildButton('5', bgColor: Colors.white24),
                  _buildButton('6', bgColor: Colors.white24),
                  _buildButton('=', bgColor: Colors.green),
                ],
              ),
              Row(
                children: [
                  _buildButton('1', bgColor: Colors.white24),
                  _buildButton('2', bgColor: Colors.white24),
                  _buildButton('3', bgColor: Colors.white24),
                  _buildButton('.', bgColor: Colors.white24),
                ],
              ),
              Row(children: [_buildButton('0', bgColor: Colors.white24)]),
            ],
          ),
        ],
      ),
    );
  }
}
