import 'package:flutter/material.dart';
import '../services/city_service.dart';

class CityWeatherScreen extends StatefulWidget {
  const CityWeatherScreen({super.key});

  @override
  State<CityWeatherScreen> createState() => _CityWeatherScreenState();
}

class _CityWeatherScreenState extends State<CityWeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  final CityService _service = CityService();

  bool _carregando = false;
  String? _erro;
  Map<String, dynamic>? _dadosClima;
  String _nomeCidadeExibida = "";

  // Função principal de busca
  Future<void> _buscar() async {
    // Fecha o teclado para melhorar a UX
    FocusScope.of(context).unfocus();

    if (_controller.text.isEmpty) return;

    setState(() {
      _carregando = true;
      _erro = null;
      _dadosClima = null;
    });

    try {
      // Passo 1: Achar a cidade
      final coords = await _service.buscarCoordenadas(_controller.text);

      if (coords == null) {
        setState(() {
          _erro = "Cidade não encontrada!";
          _carregando = false;
        });
        return;
      }

      // Passo 2: Pegar o clima da cidade encontrada
      final clima = await _service.buscarClima(
        coords['latitude']!,
        coords['longitude']!,
      );

      if (clima == null) {
        setState(() {
          _erro = "Erro ao carregar dados do clima.";
        });
      } else {
        setState(() {
          _dadosClima = clima;
          _nomeCidadeExibida = _controller.text;
        });
      }
    } catch (e) {
      setState(() {
        _erro = "Erro de conexão: $e";
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Busca de Clima por Cidade")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- INPUT DECORADO (Conforme PDF Seção 5) ---
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome da Cidade',
                hintText: 'Ex: Uberaba, São Paulo...',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.location_city), // Ícone decorativo
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
              ),
              onSubmitted: (value) =>
                  _buscar(), // Busca ao dar Enter no teclado
            ),
            const SizedBox(height: 20),

            // --- ESTADO DE CARREGAMENTO (Conforme PDF Seção 3) ---
            if (_carregando)
              const CircularProgressIndicator()
            // --- MENSAGEM DE ERRO ---
            else if (_erro != null)
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.red[100],
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(_erro!, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              )
            // --- EXIBIÇÃO DOS DADOS ---
            else if (_dadosClima != null)
              Card(
                elevation: 4,
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        _nomeCidadeExibida.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      // Temperatura
                      Text(
                        "${_dadosClima!['temperature_2m']}°C", // JSON Parsing
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Temperatura"),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Umidade
                          Column(
                            children: [
                              const Icon(Icons.water_drop, color: Colors.blue),
                              Text("${_dadosClima!['relative_humidity_2m']}%"),
                              const Text("Umidade"),
                            ],
                          ),
                          // Vento
                          Column(
                            children: [
                              const Icon(Icons.air, color: Colors.grey),
                              Text("${_dadosClima!['wind_speed_10m']} km/h"),
                              const Text("Vento"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                "Digite uma cidade para começar.",
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
