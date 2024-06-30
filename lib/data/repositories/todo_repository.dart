import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/data/models/todo_model.dart';

class TodoRepository {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dueDate TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTodo(Todo todo) async {
    await _database.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database.query('todos');
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> updateTodo(Todo todo) async {
    await _database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    await _database.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
