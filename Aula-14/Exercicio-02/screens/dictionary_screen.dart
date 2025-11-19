import 'package:flutter/material.dart';
import '../services/dictionary_service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  final DictionaryService _service = DictionaryService();

  bool _loading = false;
  String? _definition;
  String _searchedWord = "";

  Future<void> _search() async {
    // 1. Fecha teclado
    FocusScope.of(context).unfocus();

    if (_controller.text.isEmpty) return;

    setState(() {
      _loading = true;
      _definition = null; // Limpa resultado anterior
    });

    // 2. Busca definição
    String? result = await _service.getFirstDefinition(_controller.text);

    setState(() {
      _loading = false;
      _definition = result ?? "Não foi possível obter a definição.";
      _searchedWord = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Dictionary'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- CAMPO DE TEXTO DECORADO ---
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Word',
                hintText: 'Type a word in English...',
                filled: true,
                fillColor: Colors.deepPurple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.book, color: Colors.deepPurple),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.deepPurple),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 30),

            // --- ÁREA DE RESULTADO ---
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_definition != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        _searchedWord.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const Divider(height: 30, thickness: 1),
                      const Text(
                        "Definition:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _definition!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4, // Melhor leitura
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: Text(
                  "Digite uma palavra para ver o significado.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
