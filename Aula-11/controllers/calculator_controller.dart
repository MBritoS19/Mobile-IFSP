import '../database/db_helper.dart';

class CalculatorController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String display = '0';
  double memory = 0.0;
  String? _operation;
  double? _firstOperand;
  bool _shouldResetDisplay = false;
  Future<void> loadLastState(Function updateUI) async {
    final data = await _dbHelper.recuperarEstado();
    if (data != null) {
      display = data['numero_atual'] ?? '0';
      memory = double.tryParse(data['conteudo_memoria'] ?? '0') ?? 0.0;
      updateUI();
    }
  }

  Future<void> onButtonPressed(String label, Function updateUI) async {
    if (RegExp(r'[0-9]').hasMatch(label)) {
      _handleNumber(label);
    } else if (label == '.') {
      _handleDecimal();
    } else if (['+', '-', '*', '/'].contains(label)) {
      await _handleOperation(label); // <--- Adicione o AWAIT aqui
    } else if (label == '=') {
      await _calculateResult();
    } else if (label == 'C') {
      _clear();
    } else if (['MC', 'MR', 'M+', 'M-'].contains(label)) {
      await _handleMemory(label);
    }

    await _dbHelper.salvarEstado(display, memory.toString());

    updateUI();
  }

  void _handleNumber(String number) {
    if (display == '0' || _shouldResetDisplay) {
      display = number;
      _shouldResetDisplay = false;
    } else {
      display += number;
    }
  }

  void _handleDecimal() {
    if (!display.contains('.')) {
      display += '.';
    } else if (_shouldResetDisplay) {
      display = '0.';
      _shouldResetDisplay = false;
    }
  }

  Future<void> _handleOperation(String op) async {
    if (_firstOperand != null && _operation != null) {
      if (!_shouldResetDisplay) {
        await _calculateResult();
      }
    }
    _firstOperand = double.tryParse(display);
    _operation = op;
    _shouldResetDisplay = true;
  }

  Future<void> _calculateResult() async {
    if (_operation == null || _firstOperand == null) return;

    double secondOperand = double.tryParse(display) ?? 0.0;
    double result = 0.0;
    String expressao =
        "${_format(_firstOperand!)} $_operation ${_format(secondOperand)}";

    switch (_operation) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '*':
        result = _firstOperand! * secondOperand;
        break;
      case '/':
        if (secondOperand == 0) {
          display = "Erro";
          _resetLogic();
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
    }

    display = _format(result);

    await _dbHelper.salvarOperacao(expressao, display);

    _resetLogic();
    _shouldResetDisplay = true;
  }

  Future<void> _handleMemory(String command) async {
    double currentVal = double.tryParse(display) ?? 0.0;

    switch (command) {
      case 'MC':
        memory = 0.0;
        break;
      case 'MR':
        display = _format(memory);
        _shouldResetDisplay = true;
        break;
      case 'M+':
        memory += currentVal;
        break;
      case 'M-':
        memory -= currentVal;
        break;
    }
  }

  void _clear() {
    display = '0';
    _resetLogic();
  }

  void _resetLogic() {
    _operation = null;
    _firstOperand = null;
  }

  String _format(double value) {
    // Remove .0 se for inteiro (ex: 5.0 vira 5)
    if (value % 1 == 0) return value.toInt().toString();
    return value.toString();
  }

  String get equation {
    if (_firstOperand != null && _operation != null) {
      // Formatação simples para não mostrar 10.0 (remove o .0 se for inteiro)
      String num1 = _firstOperand! % 1 == 0
          ? _firstOperand!.toInt().toString()
          : _firstOperand.toString();

      return "$num1 $_operation";
    }
    return "";
  }
}
