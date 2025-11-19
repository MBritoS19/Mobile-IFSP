class Task {
  final int? id;
  final String title;
  final bool isDone;
  final String date;

  Task({
    this.id,
    required this.title,
    required this.isDone,
    required this.date,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['titulo'],
      isDone: map['is_concluida'] == 1,
      date: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': title,
      'is_concluida': isDone ? 1 : 0,
      'data': date,
    };
  }

  Task copyWith({int? id, String? title, bool? isDone, String? date}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      date: date ?? this.date,
    );
  }
}
