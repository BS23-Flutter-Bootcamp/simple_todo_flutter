import 'package:flutter/foundation.dart';
import 'package:simple_todo_flutter/model/repository/task_repository.dart';
import 'package:simple_todo_flutter/model/task.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    try {
      _tasks = await _taskRepository.getTasks();
      notifyListeners();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> addTask(String title, DateTime? dueDate, String? description, bool isCompleted) async {
    try {
      await _taskRepository.addTask(title, dueDate, description, isCompleted);
      await loadTasks();
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      await loadTasks();
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      await _taskRepository.toggleTaskCompletion(task);
      await loadTasks();
    } catch (e) {
      print('Error toggling task completion: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _taskRepository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}