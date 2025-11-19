import 'dart:async'; // Necessário para o TimeoutException
import 'package:geolocator/geolocator.dart';

class Localizacao {
  double? latitude;
  double? longitude;

  Future<void> pegaLocalizacaoAtual() async {
    // 1. Verifica se o serviço está ativo
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      throw Exception('O GPS está desligado. Por favor, ative-o.');
    }

    // 2. Verifica permissões
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão negada permanentemente. Altere nas configurações.',
      );
    }

    // 3. Tenta pegar a posição (Com Plano B)
    try {
      // Tenta pegar a posição atual com limite de 6 segundos
      Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      latitude = posicao.latitude;
      longitude = posicao.longitude;
    } on TimeoutException {
      print('Tempo esgotado. Tentando última posição conhecida...');
      Position? ultimaPosicao = await Geolocator.getLastKnownPosition();

      if (ultimaPosicao != null) {
        latitude = ultimaPosicao.latitude;
        longitude = ultimaPosicao.longitude;
      } else {
        // Dica extra na mensagem de erro
        throw Exception(
          'Não foi possível obter o GPS. Tente mover um pouco a localização no menu do emulador.',
        );
      }
    } catch (e) {
      throw Exception('Erro ao obter localização: $e');
    }
  }
}
