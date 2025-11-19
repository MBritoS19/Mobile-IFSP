import 'dart:convert';
import 'package:http/http.dart' as http;

class DeckService {
  static const String baseUrl = 'https://deckofcardsapi.com/api/deck';

  // 1. Inicia um novo baralho embaralhado
  Future<String?> newDeck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/new/shuffle/?deck_count=1'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['deck_id'];
      }
    } catch (e) {
      print('Erro ao criar baralho: $e');
    }
    return null;
  }

  // 2. Compra X cartas de um baralho específico
  Future<List<dynamic>> drawCards(String deckId, int count) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$deckId/draw/?count=$count'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['cards']; // Retorna a lista de objetos carta
      }
    } catch (e) {
      print('Erro ao comprar cartas: $e');
    }
    return [];
  }

  // 3. Lógica de Pontuação do Blackjack
  int calculateScore(List<dynamic> hand) {
    int score = 0;
    int aces = 0;

    for (var card in hand) {
      String value = card['value'];

      if (['KING', 'QUEEN', 'JACK', '10'].contains(value)) {
        score += 10;
      } else if (value == 'ACE') {
        score += 11;
        aces += 1;
      } else {
        score += int.tryParse(value) ?? 0;
      }
    }

    // Tratamento do Ás: Se estourou 21 e tem Ás, ele passa a valer 1 (subtrai 10)
    while (score > 21 && aces > 0) {
      score -= 10;
      aces--;
    }

    return score;
  }
}
