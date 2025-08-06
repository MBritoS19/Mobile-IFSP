import 'dart:convert';
import 'package:http/http.dart' as http;

// Função para formatar um objeto DateTime para uma string de data no formato MM-dd-yyyy.
String formataData(DateTime data) {
  String mes = data.month.toString().padLeft(2, '0');
  String dia = data.day.toString().padLeft(2, '0');
  String ano = data.year.toString();
  return '$mes-$dia-$ano';
}

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
  print('Iniciando a busca pela cotação do dólar...');

  DateTime dataDeHoje = DateTime.now();

  DateTime dataParaBuscar = dataDeHoje.subtract(Duration(days: 1));

  if (dataParaBuscar.weekday == DateTime.sunday) {
    dataParaBuscar = dataParaBuscar.subtract(Duration(days: 2));
  }

  String dataFormatada = formataData(dataParaBuscar);

  String resultado = await buscaCotacaoDolar(dataFormatada);
  print(resultado);
}
