import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendário do Mês',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const CalendarioMensalTela(),
    );
  }
}

class CalendarioMensalTela extends StatefulWidget {
  const CalendarioMensalTela({super.key});

  @override
  State<CalendarioMensalTela> createState() => _CalendarioMensalTelaState();
}

class _CalendarioMensalTelaState extends State<CalendarioMensalTela> {
  late DateTime _dataAtual;
  late int _diasNoMes;
  late int _primeiroDiaDoMesOffset;

  @override
  void initState() {
    super.initState();
    _dataAtual = DateTime.now();
    _calcularDadosDoMes();
  }

  void _calcularDadosDoMes() {
    _diasNoMes = DateTime(_dataAtual.year, _dataAtual.month + 1, 0).day;
    final primeiroDia = DateTime(_dataAtual.year, _dataAtual.month, 1);
    _primeiroDiaDoMesOffset = primeiroDia.weekday % 7;
  }

  void _navegarParaDetalhe(int dia) {
    final dataSelecionada = DateTime(_dataAtual.year, _dataAtual.month, dia);
    final textoFormatado =
        DateFormat('EEEE, d \'de\' MMMM', 'pt_BR').format(dataSelecionada);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaDetalheTela(textoExibido: textoFormatado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM \'de\' y', 'pt_BR')
            .format(_dataAtual)
            .toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCabecalhoDiasSemana(),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: _diasNoMes + _primeiroDiaDoMesOffset,
              itemBuilder: (context, index) {
                if (index < _primeiroDiaDoMesOffset) {
                  return Container();
                } else {
                  final dia = index - _primeiroDiaDoMesOffset + 1;
                  return TextButton(
                    onPressed: () => _navegarParaDetalhe(dia),
                    child: Text(
                      '$dia',
                      style: TextStyle(
                        color: dia == _dataAtual.day
                            ? Colors.deepPurple
                            : Colors.black87,
                        fontWeight: dia == _dataAtual.day
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabecalhoDiasSemana() {
    final dias = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dias
            .map((dia) =>
                Text(dia, style: const TextStyle(fontWeight: FontWeight.bold)))
            .toList(),
      ),
    );
  }
}

class DiaDetalheTela extends StatelessWidget {
  final String textoExibido;

  const DiaDetalheTela({super.key, required this.textoExibido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Selecionada'),
      ),
      body: Center(
        child: Text(
          textoExibido,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
