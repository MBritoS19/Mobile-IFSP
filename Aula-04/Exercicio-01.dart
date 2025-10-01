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
      debugShowCheckedModeBanner:
          false, // Remove o banner de debug [cite: 64, 119]
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 1. Imagem da Internet ilustrando o verbo [cite: 975]
              const CircleAvatar(
                radius:
                    50, // Define o raio do avatar circular [cite: 216, 318, 499]
                backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1664280284972-97b2c423021b?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE1fHx8ZW58MHx8fHx8',
                ), // Exemplo de imagem para o verbo "to write"
              ),

              // Card para o tempo PASSADO
              criaFlashcard(
                tempo: 'Past',
                frase: 'She wrote a letter yesterday.',
                icone: Icons.history, // Ícone para tempo passado
                corIcone: Colors.brown,
              ),

              // 2. Linha horizontal para separar os cards [cite: 979]
              const SizedBox(
                height: 10,
                width: 250, // Largura da linha divisória [cite: 816]
                child: Divider(
                  color: Colors.grey, // Cor da linha [cite: 819]
                ),
              ),

              // Card para o tempo PRESENTE
              criaFlashcard(
                tempo: 'Present',
                frase: 'She writes a new book every year.',
                icone: Icons.wb_sunny, // Ícone para tempo presente
                corIcone: Colors.orange,
              ),

              // Linha horizontal para separar os cards [cite: 979]
              const SizedBox(
                height: 10,
                width: 250,
                child: Divider(color: Colors.grey),
              ),

              // Card para o tempo FUTURO
              criaFlashcard(
                tempo: 'Future',
                frase: 'She will write another story soon.',
                icone: Icons.event, // Ícone para tempo futuro
                corIcone: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Função que cria um Card, baseada na função 'criaLinha' da aula [cite: 713]
Card criaFlashcard({
  required String tempo,
  required String frase,
  required IconData icone,
  required Color corIcone,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ), // Margem do card [cite: 688]
    child: Column(
      children: [
        // 3. ListTile para organizar ícone e texto [cite: 689, 705]
        ListTile(
          leading: Icon(
            icone,
            color: corIcone,
            size: 40,
          ), // Ícone à esquerda [cite: 690, 844]
          title: Text(
            tempo,
            style: GoogleFonts.rampartOne(
              fontSize: 18,
            ), // Ajuste de fonte, como visto na aula [cite: 202]
          ),
          subtitle: Text(
            frase,
            style: GoogleFonts.quicksand(
              fontSize: 16,
            ), // Ajuste de fonte [cite: 203]
          ),
        ),
        // 4. Botão "Memorizado" dentro de cada card
        TextButton(
          onPressed: () {
            // Ação do botão
          },
          child: const Text(
            'Memorizado',
          ), // Botão, como no exemplo "Usar poder" [cite: 752, 907]
        ),
      ],
    ),
  );
}
