import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  // 1. Busca Lat/Long pelo nome da cidade
  // Retorna um Map com 'latitude' e 'longitude' ou NULL se não achar
  Future<Map<String, double>?> buscarCoordenadas(String cidade) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$cidade&count=1&language=pt&format=json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verifica se a lista 'results' existe e não está vazia
        if (data['results'] != null && data['results'].isNotEmpty) {
          final cidadeData = data['results'][0];
          return {
            'latitude': cidadeData['latitude'],
            'longitude': cidadeData['longitude'],
          };
        }
      }
    } catch (e) {
      print('Erro na busca da cidade: $e');
    }
    return null; // Retorna null se falhar ou não achar
  }

  // 2. Busca o Clima pela Lat/Long
  Future<Map<String, dynamic>?> buscarClima(double lat, double lon) async {
    // Solicitamos: Temperatura, Umidade e Vento (Conforme exercício 14/Aula 14)
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Retorna o bloco 'current' que tem os dados atuais
        return data['current'];
      }
    } catch (e) {
      print('Erro na busca do clima: $e');
    }
    return null;
  }
}
