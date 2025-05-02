import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_todo_flutter/model/services/ai_service.dart';
import 'package:simple_todo_flutter/model/task.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';
import 'package:intl/intl.dart';

class AITodoRepository {
  final GenerativeAIService _aiService;
  final TaskViewModel _taskViewModel;

  AITodoRepository(this._aiService, this._taskViewModel);

  Future<List<Task>> generateTasks(String prompt) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final taskDataList = await _aiService.generateTasks(prompt);
    final tasks =
        taskDataList.map((data) {
          final dueDate = DateFormat('yyyy-MM-dd').parse(data['dueDate']!);
          return Task(
            id: null,
            userId: userId,
            title: data['title']!,
            description: data['description'],
            dueDate: dueDate,
            isCompleted: false,
            lastModified: DateTime.now(),
            syncStatus: 'pending',
          );
        }).toList();
    return tasks;
  }

  void saveTasks(List<Task> tasks) {
    for (final task in tasks) {
      _taskViewModel.addTask(
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
      );
    }
  }
}
