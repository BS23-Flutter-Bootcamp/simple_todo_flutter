import 'package:simple_todo_flutter/model/services/database_initializer.dart';

class TaskService {
  final DatabaseInitializer _dbInitializer = DatabaseInitializer.instance;

  Future<void> insertTask(Map<String, dynamic> taskMap) async {
    final db = await _dbInitializer.database;
    await db.insert('tasks', taskMap);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await _dbInitializer.database;
    return await db.query('tasks');
  }

  Future<void> updateTask(Map<String, dynamic> taskMap) async {
    final db = await _dbInitializer.database;
    await db.update(
      'tasks',
      taskMap,
      where: 'id = ?',
      whereArgs: [taskMap['id']],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await _dbInitializer.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await _dbInitializer.database;
    await db.close();
  }
}
