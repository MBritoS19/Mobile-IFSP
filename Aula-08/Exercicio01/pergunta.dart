class Pergunta {
  String texto = '';
  String resposta = '';
  bool correta = false;

  Pergunta({required String t, required String r, required bool c}) {
    texto = t;
    resposta = r;
    correta = c;
  }
}
