import 'package:flutter/material.dart';

void main() {
  runApp(const NovoWidgetEstado());
}

class NovoWidgetEstado extends StatefulWidget {
  const NovoWidgetEstado({super.key});

  @override
  State<NovoWidgetEstado> createState() => _NovoWidgetEstadoState();
}

class _NovoWidgetEstadoState extends State<NovoWidgetEstado> {
  final _imagens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg',
  ];

  var _indiceAtual = 0;

  void _proximaImagem() {
    setState(() {
      _indiceAtual = (_indiceAtual + 1) % _imagens.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Seletor de Imagens'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                _imagens[_indiceAtual],
                height: 250,
                width: 250,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Erro ao carregar a imagem 😞');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _proximaImagem,
                child: const Text('Escolher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
