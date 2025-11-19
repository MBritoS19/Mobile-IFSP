import 'package:flutter/material.dart';
import 'screens/blackjack_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack Flutter',
      theme: ThemeData(
        // Configuração para tema escuro funcionar bem
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const BlackjackScreen(),
    );
  }
}
