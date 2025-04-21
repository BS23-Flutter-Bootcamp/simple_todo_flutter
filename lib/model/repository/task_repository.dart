import 'package:simple_todo_flutter/model/services/task_service.dart';
import 'package:simple_todo_flutter/model/task.dart';

class TaskRepository {
  final TaskService _taskService = TaskService();

  Future<void> addTask({
    required String title,
    DateTime? dueDate,
    String? description,
    bool isCompleted = false,
  }) async {
    if (title.isEmpty) {
      throw Exception('Title cannot be empty');
    }
    final task = Task(
      title: title.trim(),
      dueDate: dueDate,
      description: description?.trim(),
      isCompleted: isCompleted,
    );
    await _taskService.insertTask(TaskMapper.toMap(task));
  }

  Future<List<Task>> getTasks() async {
    final maps = await _taskService.getTasks();
    return maps.map((map) => TaskMapper.fromMap(map)).toList();
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
    await _taskService.updateTask(TaskMapper.toMap(updatedTask));
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      description: task.description,
      isCompleted: !task.isCompleted,
    );
    await _taskService.updateTask(TaskMapper.toMap(updatedTask));
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
  }
}

class TaskMapper {
  static Map<String, dynamic> toMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'dueDate': task.dueDate?.toIso8601String(),
      'description': task.description,
      'isCompleted': task.isCompleted ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
