import 'package:exercicios/pergunta.dart';

class QuizBrain {
  int _numeroPergunta = 0;
  int _pontos = 0;

  final List<Pergunta> _perguntas = [
    Pergunta(t: 'O maior deserto do mundo é o Saara?', r: 'Saara', c: false),
    Pergunta(
      t: 'A teoria da relatividade foi proposta por Albert Einstein?',
      r: 'Albert Einstein',
      c: true,
    ),
    Pergunta(
      t: 'O esporte mais popular do mundo é o Futebol?',
      r: 'Futebol',
      c: true,
    ),
    Pergunta(
      t: 'A língua mais falada no mundo (nativos) é o Inglês?',
      r: 'Inglês',
      c: false,
    ),
    Pergunta(
      t: 'O primeiro homem a pisar na Lua foi Neil Armstrong?',
      r: 'Neil Armstrong',
      c: true,
    ),
    Pergunta(
      t: 'O autor de "O Pequeno Príncipe" é Antoine de Saint-Exupéry?',
      r: 'Antoine de Saint-Exupéry',
      c: true,
    ),
    Pergunta(t: 'A capital do Canadá é Toronto?', r: 'Toronto', c: false),
    Pergunta(
      t: '"A Noite Estrelada" foi pintada por Vincent van Gogh?',
      r: 'Vincent van Gogh',
      c: true,
    ),
    Pergunta(
      t: 'O processo pelo qual as plantas produzem alimento é a Respiração?',
      r: 'Respiração',
      c: false,
    ),
    Pergunta(
      t: 'O maior mamífero terrestre é o Elefante Africano?',
      r: 'Elefante Africano',
      c: true,
    ),
    Pergunta(
      t: 'A lei da gravitação universal foi desenvolvida por Isaac Newton?',
      r: 'Isaac Newton',
      c: true,
    ),
  ];

  // Funções para a UI interagir com a lógica
  String getTextoPergunta() {
    return _perguntas[_numeroPergunta].texto;
  }

  bool checarResposta(bool respostaUsuario) {
    bool respostaCorreta = _perguntas[_numeroPergunta].correta;
    if (respostaUsuario == respostaCorreta) {
      _pontos++;
      return true;
    }
    return false;
  }

  void proximaPergunta() {
    if (_numeroPergunta < _perguntas.length - 1) {
      _numeroPergunta++;
    }
  }

  bool isFinalizado() {
    return _numeroPergunta >= _perguntas.length - 1;
  }

  int getPontos() => _pontos;

  int getTotalPerguntas() => _perguntas.length;

  int getNumeroPergunta() => _numeroPergunta;

  void reiniciar() {
    _numeroPergunta = 0;
    _pontos = 0;
  }

  // Para persistência
  void restaurarEstado(int numero, int pontuacao) {
    _numeroPergunta = numero;
    _pontos = pontuacao;
  }
}
