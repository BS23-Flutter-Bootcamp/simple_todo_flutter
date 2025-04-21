import 'package:simple_todo_flutter/model/task.dart';
import 'package:simple_todo_flutter/model/services/database_initializer.dart';

class TaskService {
  final DatabaseInitializer _dbInitializer = DatabaseInitializer.instance;

  Future<void> insertTask(Task task) async {
    final db = await _dbInitializer.database;
    await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await _dbInitializer.database;
    final maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<void> updateTask(Task task) async {
    final db = await _dbInitializer.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await _dbInitializer.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await _dbInitializer.database;
    await db.close();
  }
}