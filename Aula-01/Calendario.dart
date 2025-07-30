void main() {
  final agora = DateTime.now();
  final ano = agora.year;
  final mes = agora.month;
  final diaAtual = agora.day;

  final primeiroDiaMes = DateTime(ano, mes, 1);
  final int offsetInicio = primeiroDiaMes.weekday % 7;

  print('| D | S | T | Q | Q | S | S |');

  final List<String> celulasCalendario = [];

  for (int i = 0; i < offsetInicio; i++) {
    celulasCalendario.add('   ');
  }

  for (int d = 1; d <= diaAtual; d++) {
    celulasCalendario.add(d.toString().padLeft(3));
  }

  String linhaCorrente = '|';
  for (int i = 0; i < celulasCalendario.length; i++) {
    linhaCorrente += '${celulasCalendario[i]}|';

    if (i % 7 == 6 || i == celulasCalendario.length - 1) {
      print(linhaCorrente);
      linhaCorrente = '|';
    }
  }
}