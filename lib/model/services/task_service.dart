import 'package:simple_todo_flutter/model/services/database_initializer.dart';
import 'package:simple_todo_flutter/model/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskService {
  final DatabaseInitializer _dbInitializer = DatabaseInitializer.instance;

  Future<int> insertTask(Task task) async {
    final db = await _dbInitializer.database;
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks(String userId) async {
    final db = await _dbInitializer.database;
    final maps = await db.query(
      'tasks',
      where: 'userId = ? AND syncStatus != ?',
      whereArgs: [userId, 'deleted'],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getPendingTasks(String userId) async {
    final db = await _dbInitializer.database;
    final maps = await db.query(
      'tasks',
      where: 'userId = ? AND (syncStatus = ? OR syncStatus = ?)',
      whereArgs: [userId, 'pending', 'deleted'],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
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
    await db.update(
      'tasks',
      {'syncStatus': 'deleted'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTasksForUser(String userId) async {
    final db = await _dbInitializer.database;
    await db.delete('tasks', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> close() async {
    final db = await _dbInitializer.database;
    await db.close();
  }
}
