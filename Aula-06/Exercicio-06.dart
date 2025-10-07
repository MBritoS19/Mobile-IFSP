import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Enum para representar as opções de forma clara e segura.
enum Opcao { pedra, papel, tesoura }

// Classe para agrupar as informações de cada jogada
class JogadaInfo {
  final Opcao opcao;
  final String imageUrl;
  final IconData icon;

  JogadaInfo({required this.opcao, required this.imageUrl, required this.icon});
}

void main() {
  runApp(const JokenpoApp());
}

class JokenpoApp extends StatelessWidget {
  const JokenpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const JogoScreen(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class JogoScreen extends StatefulWidget {
  const JogoScreen({super.key});

  @override
  State<JogoScreen> createState() => _JogoScreenState();
}

class _JogoScreenState extends State<JogoScreen> {
  // Estrutura de dados com as informações de cada jogada
  final List<JogadaInfo> _jogadasDisponiveis = [
    JogadaInfo(
      opcao: Opcao.pedra,
      imageUrl:
          'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
      icon: Icons.diamond_outlined,
    ),
    JogadaInfo(
      opcao: Opcao.papel,
      imageUrl:
          'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
      icon: Icons.description_outlined,
    ),
    JogadaInfo(
      opcao: Opcao.tesoura,
      imageUrl:
          'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg',
      icon: Icons.content_cut_rounded,
    ),
  ];

  // Variáveis de estado do jogo
  int _indiceAtual = 0;
  Opcao? _escolhaApp;
  String _resultado = "Escolha uma jogada e clique em Jogar!";
  Color _corResultado = Colors.black54;
  int _contadorJogadas = 0;

  // Instância do player de áudio
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Função para tocar um som a partir dos assets
  void _tocarSom(String nomeArquivo) async {
    await _audioPlayer.play(AssetSource('sounds/$nomeArquivo'));
  }

  // Função para o botão "Escolher"
  void _proximaJogada() {
    setState(() {
      _indiceAtual = (_indiceAtual + 1) % _jogadasDisponiveis.length;
      _resultado = "Escolha uma jogada e clique em Jogar!";
      _corResultado = Colors.black54;
      _escolhaApp = null;
    });
  }

  // Função para o botão "Jogar"
  void _jogar() {
    final escolhaUsuario = _jogadasDisponiveis[_indiceAtual].opcao;

    setState(() {
      _contadorJogadas++;
      _escolhaApp = _obterEscolhaApp(escolhaUsuario);
      _determinarVencedor(escolhaUsuario);

      if (_contadorJogadas == 5) {
        _contadorJogadas = 0;
      }
    });
  }

  Opcao _obterEscolhaApp(Opcao escolhaUsuario) {
    if (_contadorJogadas == 5) {
      switch (escolhaUsuario) {
        case Opcao.pedra:
          return Opcao.tesoura;
        case Opcao.papel:
          return Opcao.pedra;
        case Opcao.tesoura:
          return Opcao.papel;
      }
    } else {
      List<Opcao> opcoesParaNaoPerder;
      switch (escolhaUsuario) {
        case Opcao.pedra:
          opcoesParaNaoPerder = [Opcao.pedra, Opcao.papel];
          break;
        case Opcao.papel:
          opcoesParaNaoPerder = [Opcao.papel, Opcao.tesoura];
          break;
        case Opcao.tesoura:
          opcoesParaNaoPerder = [Opcao.tesoura, Opcao.pedra];
          break;
      }
      return opcoesParaNaoPerder[Random().nextInt(opcoesParaNaoPerder.length)];
    }
  }

  void _determinarVencedor(Opcao escolhaUsuario) {
    if (_escolhaApp == escolhaUsuario) {
      _resultado = "Empate!";
      _corResultado = Colors.orange.shade700;
      _tocarSom('empate.mp3');
    } else if ((escolhaUsuario == Opcao.pedra &&
            _escolhaApp == Opcao.tesoura) ||
        (escolhaUsuario == Opcao.papel && _escolhaApp == Opcao.pedra) ||
        (escolhaUsuario == Opcao.tesoura && _escolhaApp == Opcao.papel)) {
      _resultado = "Você ganhou!";
      _corResultado = Colors.green.shade600;
      _tocarSom('vitoria.mp3');
    } else {
      _resultado = "A máquina ganhou!";
      _corResultado = Colors.red.shade700;
      _tocarSom('derrota.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData? iconeApp;
    if (_escolhaApp != null) {
      iconeApp = _jogadasDisponiveis
          .firstWhere((j) => j.opcao == _escolhaApp)
          .icon;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Jokenpô', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Painel de Resultados
            Text(
              _resultado,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: _corResultado),
              textAlign: TextAlign.center,
            ),

            // Exibição das Escolhas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PainelEscolha(
                  titulo: "Você",
                  imageUrl: _jogadasDisponiveis[_indiceAtual].imageUrl,
                ),
                _PainelEscolha(titulo: "Máquina", icone: iconeApp),
              ],
            ),

            // Texto informativo da regra
            Text(
              _contadorJogadas == 0
                  ? "Nova rodada!"
                  : "Jogada: $_contadorJogadas de 5",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),

            // Botões de Ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text("Escolher"),
                  onPressed: _proximaJogada,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text("Jogar"),
                  onPressed: _jogar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget customizado para exibir a escolha (do usuário ou do app)
class _PainelEscolha extends StatelessWidget {
  final String titulo;
  final String? imageUrl;
  final IconData? icone;

  const _PainelEscolha({required this.titulo, this.imageUrl, this.icone});

  @override
  Widget build(BuildContext context) {
    Widget conteudo;
    if (imageUrl != null) {
      conteudo = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl!,
          height: 120,
          width: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 50, color: Colors.red);
          },
        ),
      );
    } else {
      conteudo = Center(
        child: icone != null
            ? Icon(icone, size: 70, color: Colors.deepPurple)
            : const Icon(Icons.question_mark, size: 70, color: Colors.black45),
      );
    }

    return Column(
      children: [
        Text(titulo, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.deepPurple.withAlpha(77),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: conteudo,
        ),
      ],
    );
  }
}
