import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/model/task.dart';
import 'package:simple_todo_flutter/model/repository/ai_repository.dart';

class AITodoViewModel with ChangeNotifier {
  AITodoViewModel(this._repository);
  final AITodoRepository _repository;

  String _prompt = '';
  List<Task> _tasks = [];
  List<Task> _editedTasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  String get prompt => _prompt;
  List<Task> get tasks => _tasks;
  List<Task> get editedTasks => _editedTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setPrompt(String value) {
    _prompt = value;
    notifyListeners();
  }

  Future<void> generateTasks() async {
    if (_prompt.isEmpty) {
      _errorMessage = 'Please enter a prompt';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _tasks.clear();
    _editedTasks.clear();
    notifyListeners();

    try {
      final generatedTasks = await _repository.generateTasks(_prompt);
      _tasks = generatedTasks;
      _editedTasks = List.from(generatedTasks);
    } catch (e) {
      _errorMessage = 'Error generating tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateTask(int index, Task updatedTask) {
    _editedTasks[index] = updatedTask.copyWith(
      lastModified: DateTime.now(),
      syncStatus: 'pending',
    );
    notifyListeners();
  }

  void saveTasks() {
    if (_editedTasks.isEmpty) {
      _errorMessage = 'No tasks to save';
      notifyListeners();
      return;
    }
    _repository.saveTasks(_editedTasks);
    _tasks.clear();
    _editedTasks.clear();
    _prompt = '';
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
