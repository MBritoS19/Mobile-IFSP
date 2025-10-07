import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno({required this.nome, required this.matricula, List<double>? notas})
      : this.notas = notas ?? [];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Alunos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 2,
        ),
      ),
      home: const CadastroAlunoTela(),
    );
  }
}

class CadastroAlunoTela extends StatefulWidget {
  const CadastroAlunoTela({super.key});

  @override
  State<CadastroAlunoTela> createState() => _CadastroAlunoTelaState();
}

class _CadastroAlunoTelaState extends State<CadastroAlunoTela> {
  final _controladorNome = TextEditingController();
  final _controladorMatricula = TextEditingController();

  void _navegarParaNotas() {
    if (_controladorNome.text.isNotEmpty &&
        _controladorMatricula.text.isNotEmpty) {
      final aluno = Aluno(
        nome: _controladorNome.text,
        matricula: _controladorMatricula.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LancarNotasTela(aluno: aluno),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorMatricula.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controladorNome,
              decoration: const InputDecoration(labelText: 'Nome do Aluno'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controladorMatricula,
              decoration: const InputDecoration(labelText: 'Matrícula'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navegarParaNotas,
              child: const Text('Lançar Notas'),
            ),
          ],
        ),
      ),
    );
  }
}

class LancarNotasTela extends StatefulWidget {
  final Aluno aluno;

  const LancarNotasTela({super.key, required this.aluno});

  @override
  State<LancarNotasTela> createState() => _LancarNotasTelaState();
}

class _LancarNotasTelaState extends State<LancarNotasTela> {
  final _controladorNota = TextEditingController();

  void _exibirSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  void _adicionarNota() {
    final textoNota = _controladorNota.text.replaceAll(',', '.');
    final double? nota = double.tryParse(textoNota);

    if (nota == null) {
      _exibirSnackBar('Valor inválido.', Colors.orange);
      return;
    }

    if (nota >= 0 && nota <= 100) {
      setState(() {
        widget.aluno.notas.add(nota);
        _controladorNota.clear();
      });
    } else {
      _exibirSnackBar('A nota deve ser entre 0 e 100.', Colors.red);
    }
  }

  void _removerNota(int index) {
    setState(() {
      widget.aluno.notas.removeAt(index);
    });
  }

  void _navegarParaResumo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumoAlunoTela(aluno: widget.aluno),
      ),
    );
  }

  @override
  void dispose() {
    _controladorNota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de ${widget.aluno.nome}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorNota,
                    decoration:
                        const InputDecoration(labelText: 'Nova Nota (0-100)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{1,3}[,.]?\d{0,2}')),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: Colors.blue, size: 30),
                  onPressed: _adicionarNota,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: widget.aluno.notas.isEmpty
                  ? const Center(child: Text('Nenhuma nota adicionada.'))
                  : ListView.builder(
                      itemCount: widget.aluno.notas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              'Nota ${index + 1}: ${widget.aluno.notas[index]}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerNota(index),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _navegarParaResumo,
              child: const Text('Ver Resumo Final'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResumoAlunoTela extends StatelessWidget {
  final Aluno aluno;

  const ResumoAlunoTela({super.key, required this.aluno});

  double _calcularMedia() {
    if (aluno.notas.isEmpty) {
      return 0.0;
    }
    return aluno.notas.reduce((a, b) => a + b) / aluno.notas.length;
  }

  @override
  Widget build(BuildContext context) {
    final media = _calcularMedia();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${aluno.nome}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Matrícula: ${aluno.matricula}',
                style: const TextStyle(fontSize: 18)),
            const Divider(height: 30),
            Text('Média Final: ${media.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Notas Lançadas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: aluno.notas.isEmpty
                  ? const Center(child: Text('Nenhuma nota foi lançada.'))
                  : ListView.builder(
                      itemCount: aluno.notas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.note),
                          title: Text('Nota: ${aluno.notas[index]}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
