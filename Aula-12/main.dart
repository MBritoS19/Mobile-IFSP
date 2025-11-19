import 'package:flutter/material.dart';
import 'screens/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List SQLite',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const TodoListScreen(),
    );
  }
}
