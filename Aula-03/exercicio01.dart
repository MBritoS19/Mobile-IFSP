import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrimeiraPagina(),
    ),
  );
}

class PrimeiraPagina extends StatelessWidget {
  const PrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: const Text('Coruja-buraqueira'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlue,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'https://agron.com.br/wp-content/uploads/2025/05/Como-a-coruja-buraqueira-vive-em-grupo-2.webp',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const RolinhaDoPlanaltoPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[600],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Ir para Rolinha-do-planalto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RolinhaDoPlanaltoPage extends StatelessWidget {
  const RolinhaDoPlanaltoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: const Text('Rolinha-do-planalto'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlue,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[600],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Voltar para Coruja-buraqueira'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
