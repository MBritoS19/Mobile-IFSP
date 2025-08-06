import 'dart:convert';
import 'package:http/http.dart' as http;

// Função assíncrona para buscar a cotação do dólar para uma data específica.
Future<String> buscaCotacaoDolar(String data) async {
  var url = Uri.parse(
    'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)?@dataCotacao=\'$data\'&\$top=100&\$format=json&\$select=cotacaoCompra',
  );

  var response = await http.get(url);

  var jsonBody = json.decode(response.body);

  var cotacao = jsonBody['value'][0]['cotacaoCompra'];

  return 'Cotação de Compra do Dólar em ${data.substring(3, 5)}/${data.substring(0, 2)}/${data.substring(6)}: $cotacao';
}

void main() async {
  print('Iniciando a busca pela cotação do dólar para 03/07/2025...');

  String dataFixa = '07-03-2025';

  String resultado = await buscaCotacaoDolar(dataFixa);
  print(resultado);
}
