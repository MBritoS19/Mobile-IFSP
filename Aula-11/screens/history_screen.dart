import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Operações')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().listarOperacoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }

          final operations = snapshot.data;

          if (operations == null || operations.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma operação registrada.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: operations.length,
            itemBuilder: (context, index) {
              final op = operations[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.calculate)),
                  title: Text(
                    '${op['expressao']} = ${op['resultado']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text('Data: ${op['data_hora']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
