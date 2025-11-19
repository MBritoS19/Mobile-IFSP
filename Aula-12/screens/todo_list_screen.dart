import 'package:flutter/material.dart';
import '../database/todo_db.dart';
import '../models/task.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoDatabase _dbHelper = TodoDatabase();
  List<Task> _tasks = [];
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _refreshTaskList();
  }

  Future<void> _refreshTaskList() async {
    final data = await _dbHelper.getTasks(dateFilter: _selectedDate);
    setState(() {
      _tasks = data;
    });
  }

  String _formatDate(DateTime dt) {
    return dt.toString().split(' ')[0];
  }

  void _pickDateFilter() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = _formatDate(picked);
      });
      _refreshTaskList();
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDate = null;
    });
    _refreshTaskList();
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    String dateToSave =
        task?.date ?? _selectedDate ?? _formatDate(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            Text(
              "Data: $dateToSave",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;

              if (task == null) {
                final newTask = Task(
                  title: titleController.text,
                  isDone: false,
                  date: dateToSave,
                );
                await _dbHelper.insertTask(newTask);
              } else {
                final updatedTask = task.copyWith(title: titleController.text);
                await _dbHelper.updateTask(updatedTask);
              }

              Navigator.pop(context);
              _refreshTaskList();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await _dbHelper.updateTask(updatedTask);
    _refreshTaskList();
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _refreshTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedDate == null
              ? 'Todas as Tarefas'
              : 'Tarefas de $_selectedDate',
        ),
        actions: [
          IconButton(
            icon: Icon(
              _selectedDate == null ? Icons.filter_alt_off : Icons.filter_alt,
            ),
            onPressed: _selectedDate == null ? _pickDateFilter : _clearFilter,
            tooltip: _selectedDate == null
                ? 'Filtrar por Data'
                : 'Limpar Filtro',
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                _selectedDate == null
                    ? 'Nenhuma tarefa cadastrada.'
                    : 'Nenhuma tarefa para esta data.',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key(task.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _deleteTask(task.id!),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) => _toggleTaskStatus(task),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isDone ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(task.date),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showTaskDialog(task: task),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
