import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TodoDatabase {
  static final TodoDatabase _instance = TodoDatabase._internal();
  factory TodoDatabase() => _instance;
  TodoDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_list.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        titulo TEXT, 
        is_concluida INTEGER,
        data TEXT
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tarefas', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tarefas',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Task>> getTasks({String? dateFilter}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (dateFilter != null) {
      maps = await db.query(
        'tarefas',
        where: 'data = ?',
        whereArgs: [dateFilter],
        orderBy: 'is_concluida ASC, id DESC',
      );
    } else {
      maps = await db.query('tarefas', orderBy: 'data DESC, is_concluida ASC');
    }

    return maps.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
