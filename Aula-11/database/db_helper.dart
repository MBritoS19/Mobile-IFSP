import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calculadora.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dados(
        id INTEGER PRIMARY KEY, 
        numero_atual TEXT, 
        conteudo_memoria TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE operacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        expressao TEXT, 
        resultado TEXT,
        data_hora TEXT
      )
    ''');

    await db.insert('dados', {
      'id': 1,
      'numero_atual': '0',
      'conteudo_memoria': '0',
    });
  }

  Future<void> salvarEstado(String numeroAtual, String memoria) async {
    final db = await database;
    await db.update(
      'dados',
      {'numero_atual': numeroAtual, 'conteudo_memoria': memoria},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<Map<String, dynamic>?> recuperarEstado() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dados',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<void> salvarOperacao(String expressao, String resultado) async {
    final db = await database;
    await db.insert('operacoes', {
      'expressao': expressao,
      'resultado': resultado,
      'data_hora': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> listarOperacoes() async {
    final db = await database;
    return await db.query('operacoes', orderBy: 'id DESC');
  }
}
