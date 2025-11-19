import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_key.dart';

class WeatherService {
  Future<Map<String, dynamic>> getClima(double lat, double lon) async {
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherApiKey&units=metric&lang=pt_br';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Erro ao carregar dados do clima: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }
}
