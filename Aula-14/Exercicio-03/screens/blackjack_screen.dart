import 'package:flutter/material.dart';
import '../services/deck_service.dart';

class BlackjackScreen extends StatefulWidget {
  const BlackjackScreen({super.key});

  @override
  State<BlackjackScreen> createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends State<BlackjackScreen> {
  final DeckService _service = DeckService();

  String? _deckId;
  List<dynamic> _playerHand = [];
  List<dynamic> _dealerHand = [];

  bool _isLoading = false;
  bool _gameOver = false;
  String _message = "";

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  // Inicia o jogo: Novo baralho + 2 cartas para cada
  Future<void> _startNewGame() async {
    setState(() {
      _isLoading = true;
      _gameOver = false;
      _playerHand = [];
      _dealerHand = [];
      _message = "";
    });

    // Cria novo deck
    _deckId = await _service.newDeck();

    if (_deckId != null) {
      // Compra iniciais
      final playerDraw = await _service.drawCards(_deckId!, 2);
      final dealerDraw = await _service.drawCards(_deckId!, 2);

      setState(() {
        _playerHand = playerDraw;
        _dealerHand = dealerDraw;
        _isLoading = false;
      });

      _checkPlayerBust(); // Verifica se já começou com 21 (Blackjack) ou estourou (raro com 2 cartas)
    }
  }

  // Jogador pede carta
  Future<void> _hit() async {
    if (_deckId == null || _gameOver) return;

    setState(() => _isLoading = true);

    final newCard = await _service.drawCards(_deckId!, 1);

    setState(() {
      _playerHand.addAll(newCard);
      _isLoading = false;
    });

    _checkPlayerBust();
  }

  // Jogador para, vez da Mesa
  Future<void> _stand() async {
    if (_deckId == null || _gameOver) return;

    setState(() => _isLoading = true);

    // Lógica da Mesa: Compra até ter 17 ou mais
    while (_service.calculateScore(_dealerHand) < 17) {
      final newCard = await _service.drawCards(_deckId!, 1);
      setState(() {
        _dealerHand.addAll(newCard);
      });
      // Pequeno delay para dar emoção
      await Future.delayed(const Duration(milliseconds: 600));
    }

    _determineWinner();
    setState(() => _isLoading = false);
  }

  // Verifica se jogador estourou 21
  void _checkPlayerBust() {
    int score = _service.calculateScore(_playerHand);
    if (score > 21) {
      setState(() {
        _gameOver = true;
        _message = "💥 Estourou! Você perdeu.";
      });
    }
  }

  // Verifica quem ganhou
  void _determineWinner() {
    int playerScore = _service.calculateScore(_playerHand);
    int dealerScore = _service.calculateScore(_dealerHand);

    String result;
    if (dealerScore > 21) {
      result = "🎉 Mesa estourou! Você venceu!";
    } else if (playerScore > dealerScore) {
      result = "🏆 Você venceu!";
    } else if (dealerScore > playerScore) {
      result = "😞 A Mesa venceu.";
    } else {
      result = "🤝 Empate.";
    }

    setState(() {
      _gameOver = true;
      _message = "$result (Mesa: $dealerScore vs Você: $playerScore)";
    });
  }

  // WIDGET AUXILIAR: Mostra uma carta
  Widget _buildCard(dynamic card, {double width = 70}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          card['image'],
          width: width,
          height: width * 1.4,
          fit: BoxFit.cover,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return Container(
              width: width,
              height: width * 1.4,
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int playerScore = _service.calculateScore(_playerHand);
    int dealerScore = _service.calculateScore(_dealerHand);

    return Scaffold(
      backgroundColor: const Color(0xFF35654d), // Verde "Mesa de Feltro"
      appBar: AppBar(
        title: const Text("Blackjack 21"),
        backgroundColor: const Color(0xFF234232),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _startNewGame),
        ],
      ),
      body: _isLoading && _playerHand.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- ÁREA DA MESA (Topo) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Mesa (Dealer)",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _dealerHand
                              .map((c) => _buildCard(c))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        // Só mostra pontos da mesa quando o jogo acaba (ou implementar regra de esconder carta)
                        _gameOver ? "Pontos: $dealerScore" : "Pontos: ?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- MENSAGEM CENTRAL ---
                if (_gameOver)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    color: Colors.black54,
                    child: Text(
                      _message,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // --- ÁREA DO JOGADOR (Baixo) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Pontos: $playerScore",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _playerHand
                              .map((c) => _buildCard(c, width: 90))
                              .toList(),
                        ),
                      ),
                      const Text(
                        "Sua Mão",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ],
                  ),
                ),

                // --- BOTÕES DE AÇÃO ---
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("PEDIR CARTA"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: (!_gameOver && !_isLoading) ? _hit : null,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text("PARAR"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: (!_gameOver && !_isLoading) ? _stand : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
