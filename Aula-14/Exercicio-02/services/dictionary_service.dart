import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryService {
  // Retorna a definição (String) ou NULL se der erro/não achar
  Future<String?> getFirstDefinition(String word) async {
    final url = Uri.parse(
      'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Navegação segura no JSON para pegar a primeira definição
        // Estrutura: [0] -> meanings -> [0] -> definitions -> [0] -> definition
        if (data.isNotEmpty) {
          final meanings = data[0]['meanings'];
          if (meanings != null && meanings.isNotEmpty) {
            final definitions = meanings[0]['definitions'];
            if (definitions != null && definitions.isNotEmpty) {
              return definitions[0]['definition'];
            }
          }
        }
      } else if (response.statusCode == 404) {
        return "Palavra não encontrada.";
      }
    } catch (e) {
      print('Erro na API: $e');
      return "Erro de conexão.";
    }
    return null;
  }
}
