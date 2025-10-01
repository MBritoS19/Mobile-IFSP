import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1664280284972-97b2c423021b?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE1fHx8ZW58MHx8fHx8',
                ), // Exemplo de imagem para o verbo "to write"
              ),

              // Card para o tempo PASSADO
              criaFlashcard(
                tempo: 'Past',
                frase: 'She wrote a letter yesterday.',
                icone: Icons.history,
                corIcone: Colors.brown,
              ),

              const SizedBox(
                height: 10,
                width: 250,
                child: Divider(color: Colors.grey),
              ),

              // Card para o tempo PRESENTE
              criaFlashcard(
                tempo: 'Present',
                frase: 'She writes a new book every year.',
                icone: Icons.wb_sunny,
                corIcone: Colors.orange,
              ),

              const SizedBox(
                height: 10,
                width: 250,
                child: Divider(color: Colors.grey),
              ),

              // Card para o tempo FUTURO
              criaFlashcard(
                tempo: 'Future',
                frase: 'She will write another story soon.',
                icone: Icons.event,
                corIcone: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Função que cria um Card, baseada na função 'criaLinha' da aula
Card criaFlashcard({
  required String tempo,
  required String frase,
  required IconData icone,
  required Color corIcone,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      children: [
        // 3. ListTile para organizar ícone e texto
        ListTile(
          leading: Icon(icone, color: corIcone, size: 40),
          title: Text(tempo, style: GoogleFonts.rampartOne(fontSize: 18)),
          subtitle: Text(frase, style: GoogleFonts.quicksand(fontSize: 16)),
        ),
        // 4. Botão "Memorizado" dentro de cada card
        TextButton(
          onPressed: () {
            // Ação do botão
          },
          child: const Text('Memorizado'),
        ),
      ],
    ),
  );
}
