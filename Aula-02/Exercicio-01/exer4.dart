import 'Aluno.dart';

void main() {
  Aluno aluno = Aluno(
      nome: "Matheus Brito Sampaio",
      matricula: "BA3111458",
      notas: [6.3, 5.2, 9.4]);

  aluno.exibir();
}
