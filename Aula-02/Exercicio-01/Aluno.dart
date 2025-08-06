class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno({required this.nome, required this.matricula, required this.notas});

  double media() {
    if (notas.isEmpty) return 0.0;
    double soma = notas.reduce((a, b) => a + b);
    return soma / notas.length;
  }

  void exibir() {
    print("Nome: $nome");
    print("Matricula: $matricula");
    print("Notas: $notas");
  }
}
