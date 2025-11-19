import 'package:flutter/material.dart';
import '../services/localizacao.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final Localizacao _localizacao = Localizacao();
  final WeatherService _weatherService = WeatherService();

  bool _carregando = true;
  String? _mensagemErro;
  Map<String, dynamic>? _dadosClima;

  @override
  void initState() {
    super.initState();
    _iniciarBusca();
  }

  Future<void> _iniciarBusca() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      await _localizacao.pegaLocalizacaoAtual();

      final clima = await _weatherService.getClima(
        _localizacao.latitude!,
        _localizacao.longitude!,
      );

      setState(() {
        _dadosClima = clima;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = e.toString();
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima e Localização')),
      body: Center(
        child: _carregando
            ? const CircularProgressIndicator()
            : _mensagemErro != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ocorreu um erro:\n$_mensagemErro',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _iniciarBusca,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            "📍 Sua Localização",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text("Latitude: ${_localizacao.latitude}"),
                          Text("Longitude: ${_localizacao.longitude}"),
                        ],
                      ),
                    ),
                  ),

                  if (_dadosClima != null)
                    Card(
                      margin: const EdgeInsets.all(16),
                      elevation: 4,
                      color: Colors.lightBlue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              "☁️ Clima Atual",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Text(
                              "${_dadosClima!['main']['temp'].toStringAsFixed(1)}°C",
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.water_drop,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Umidade: ${_dadosClima!['main']['humidity']}%",
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.air, color: Colors.grey),
                                    Text(
                                      "Vento: ${_dadosClima!['wind']['speed']} m/s",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
