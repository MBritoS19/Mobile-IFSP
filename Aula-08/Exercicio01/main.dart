import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_brain.dart';

void main() => runApp(const PerguntasApp());

class PerguntasApp extends StatelessWidget {
  const PerguntasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 1.1 - TEMA CENTRALIZADO
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizBrain quizBrain = QuizBrain();
  List<Icon> resultado = [];
  Color? feedbackColor; // 1.2 - Cor para o feedback visual
  bool quizFinalizado = false;

  @override
  void initState() {
    super.initState();
    _carregarEstado();
  }

  // 2.2 - LÓGICA DE PERSISTÊNCIA
  Future<void> _salvarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('numeroPergunta', quizBrain.getNumeroPergunta());
    await prefs.setInt('pontos', quizBrain.getPontos());
    await prefs.setStringList(
      'resultado',
      resultado
          .map((icon) => icon.color == Colors.green ? 'true' : 'false')
          .toList(),
    );
  }

  Future<void> _carregarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    final numero = prefs.getInt('numeroPergunta') ?? 0;
    final pontuacao = prefs.getInt('pontos') ?? 0;
    final resultadoSalvo = prefs.getStringList('resultado') ?? [];

    setState(() {
      quizBrain.restaurarEstado(numero, pontuacao);
      resultado = resultadoSalvo
          .map(
            (res) => Icon(
              res == 'true' ? Icons.check : Icons.close,
              color: res == 'true' ? Colors.green : Colors.red,
            ),
          )
          .toList();
      quizFinalizado =
          quizBrain.isFinalizado() &&
          resultado.length >= quizBrain.getTotalPerguntas();
    });
  }

  void checarResposta(bool respostaUsuario) {
    if (quizFinalizado) return;

    bool acertou = quizBrain.checarResposta(respostaUsuario);

    setState(() {
      // 1.2 - Feedback visual com "flash" de cor
      feedbackColor = acertou
          ? Colors.green.withOpacity(0.5)
          : Colors.red.withOpacity(0.5);
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          feedbackColor = null;
        });
      });

      resultado.add(
        Icon(
          acertou ? Icons.check : Icons.close,
          color: acertou ? Colors.green : Colors.red,
        ),
      );

      if (quizBrain.isFinalizado()) {
        quizFinalizado = true;
      } else {
        quizBrain.proximaPergunta();
      }

      _salvarEstado();
    });
  }

  void reiniciarQuiz() {
    setState(() {
      quizBrain.reiniciar();
      resultado = [];
      quizFinalizado = false;
      _salvarEstado();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Completo'),
        backgroundColor: Colors.grey.shade800,
      ),
      body: AnimatedContainer(
        // Anima a mudança de cor do feedback
        duration: const Duration(milliseconds: 200),
        color: feedbackColor ?? Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          // 1.3 - TELA DE RESULTADOS CONDICIONAL
          child: quizFinalizado ? buildResultScreen() : buildQuizScreen(),
        ),
      ),
    );
  }

  Widget buildQuizScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Center(
            child: Text(
              quizBrain.getTextoPergunta(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        buildAnswerButton(text: 'SIM', color: Colors.green, value: true),
        const SizedBox(height: 15),
        buildAnswerButton(text: 'NÃO', color: Colors.red, value: false),
        const SizedBox(height: 20),
        SizedBox(height: 30, child: Row(children: resultado)),
      ],
    );
  }

  Widget buildResultScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Fim de Jogo!',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 40),
        ),
        const SizedBox(height: 20),
        Text(
          'Sua pontuação final foi:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          '${quizBrain.getPontos()} / ${quizBrain.getTotalPerguntas()}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 50,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.refresh),
          label: Text(
            'REINICIAR',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onPressed: reiniciarQuiz,
        ),
      ],
    );
  }

  Widget buildAnswerButton({
    required String text,
    required Color color,
    required bool value,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () => checarResposta(value),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
