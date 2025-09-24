import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TabuadaApp());
}

class TabuadaApp extends StatelessWidget {
  const TabuadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino de Tabuada',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const TabuadaPage(),
    );
  }
}

class TabuadaPage extends StatefulWidget {
  const TabuadaPage({super.key});

  @override
  State<TabuadaPage> createState() => _TabuadaPageState();
}

class _TabuadaPageState extends State<TabuadaPage> {
  // --- ESTADO DA APLICAÇÃO ---
  int fator1 = 1;
  int fator2 = 1;
  bool jogoFinalizado = false;

  final _controller = TextEditingController();
  String _feedback = '';
  Color _feedbackColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _carregarEstado();
  }

  // --- LÓGICA DE PERSISTÊNCIA ---
  Future<void> _salvarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fator1', fator1);
    await prefs.setInt('fator2', fator2);
  }

  Future<void> _carregarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fator1 = prefs.getInt('fator1') ?? 1;
      fator2 = prefs.getInt('fator2') ?? 1;
      if (fator1 > 10) {
        jogoFinalizado = true;
      }
    });
  }

  // --- LÓGICA DO JOGO ---
  void _checarResposta() {
    if (jogoFinalizado) return;

    final int respostaCorreta = fator1 * fator2;
    final int? respostaUsuario = int.tryParse(_controller.text);

    setState(() {
      if (respostaUsuario == null) {
        _feedback = 'Por favor, insira um número.';
        _feedbackColor = Colors.orange;
      } else if (respostaUsuario == respostaCorreta) {
        _feedback = 'Correto!';
        _feedbackColor = Colors.green;

        // Avança para a próxima conta
        fator2++;
        if (fator2 > 10) {
          fator1++;
          fator2 = 1;
        }

        // Verifica se o jogo terminou
        if (fator1 > 10) {
          jogoFinalizado = true;
          _feedback = 'Parabéns, você completou todas as tabuadas!';
        }
      } else {
        _feedback =
            'Incorreto. A resposta era $respostaCorreta. Tente de novo.';
        _feedbackColor = Colors.red;
      }
    });

    _controller.clear();
    _salvarEstado(); // Salva o progresso após cada tentativa
  }

  void _reiniciarJogo() {
    setState(() {
      fator1 = 1;
      fator2 = 1;
      jogoFinalizado = false;
      _feedback = '';
      _feedbackColor = Colors.grey;
    });
    _salvarEstado();
  }

  // --- INTERFACE DO USUÁRIO ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treino de Tabuada')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: jogoFinalizado ? _buildTelaFinal() : _buildTelaJogo(),
        ),
      ),
    );
  }

  Widget _buildTelaJogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$fator1 x $fator2 = ?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
          decoration: const InputDecoration(
            hintText: 'Sua resposta',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) =>
              _checarResposta(), // Permite enviar com o "Enter" do teclado
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _checarResposta,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Verificar'),
        ),
        const SizedBox(height: 30),
        Text(
          _feedback,
          style: TextStyle(
            fontSize: 18,
            color: _feedbackColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTelaFinal() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.celebration, color: Colors.amber, size: 80),
        const SizedBox(height: 20),
        Text('Parabéns!', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 10),
        Text(
          'Você completou todas as tabuadas de 1 a 10.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Recomeçar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: _reiniciarJogo,
        ),
      ],
    );
  }
}
