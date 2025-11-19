import 'package:flutter/material.dart';
import 'screens/city_weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca Clima Cidade',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const CityWeatherScreen(),
    );
  }
}
