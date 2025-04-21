import 'package:simple_todo_flutter/model/services/task_service.dart';
import 'package:simple_todo_flutter/model/task.dart';

class TaskRepository {
  final TaskService _taskDatabase = TaskService();

  Future<void> addTask(String title, DateTime? dueDate, String? description, bool isCompleted) async {
    if (title.isEmpty) {
      throw Exception('Title cannot be empty');
    }
    final task = Task(
      title: title.trim(),
      dueDate: dueDate,
      description: description?.trim(),
      isCompleted: isCompleted,
    );
    await _taskDatabase.insertTask(task);
  }

  Future<List<Task>> getTasks() async {
    return await _taskDatabase.getTasks();
  }

  Future<void> updateTask(Task task) async {
    if (task.title.isEmpty) {
      throw Exception('Title cannot be empty');
    }
    final updatedTask = Task(
      id: task.id,
      title: task.title.trim(),
      dueDate: task.dueDate,
      description: task.description?.trim(),
      isCompleted: task.isCompleted,
    );
    await _taskDatabase.updateTask(updatedTask);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      description: task.description,
      isCompleted: !task.isCompleted,
    );
    await _taskDatabase.updateTask(updatedTask);
  }

  Future<void> deleteTask(int id) async {
    await _taskDatabase.deleteTask(id);
  }
}