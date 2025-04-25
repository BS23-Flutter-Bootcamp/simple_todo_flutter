import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_todo_flutter/model/repository/task_repository.dart';
import 'package:simple_todo_flutter/model/task.dart';

class TaskViewModel extends ChangeNotifier {
  TaskViewModel(this._taskRepository) {
    _init();
  }
  final TaskRepository _taskRepository;
  List<Task> _tasks = [];
  String? _currentUserId;
  bool _isSyncing = false;
  List<Task> get tasks => _tasks;
  bool get isSyncing => _isSyncing;

  Future<void> _init() async {
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_currentUserId != null) {
      await syncTasks();
      await loadTasks();
    }
  }

  Future<void> setUser(String userId) async {
    _currentUserId = userId;
    await syncTasks();
    await loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      if (_currentUserId == null) return;
      _tasks = await _taskRepository.getTasks(_currentUserId!);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks from SQLite: $e');
      }
    }
  }

  Future<void> addTask({
    required String title,
    DateTime? dueDate,
    String? description,
    bool isCompleted = false,
  }) async {
    try {
      if (_currentUserId == null) throw 'User not logged in';
      await _taskRepository.addTask(
        userId: _currentUserId!,
        title: title,
        dueDate: dueDate,
        description: description,
        isCompleted: isCompleted,
      );
      await loadTasks();
      await syncTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding task: $e');
      }
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      await loadTasks();
      await syncTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating task: $e');
      }
      rethrow;
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      await _taskRepository.toggleTaskCompletion(task);
      await loadTasks();
      await syncTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling task completion: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      if (_currentUserId == null) throw 'User not logged in';
      await _taskRepository.deleteTask(id, _currentUserId!);
      await loadTasks();
      await syncTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting task: $e');
      }
      rethrow;
    }
  }

  Future<void> syncTasks() async {
    if (_currentUserId == null) return;
    var connectivityResult = await (Connectivity().checkConnectivity());
    print('connectivityResult: $connectivityResult');
    if (connectivityResult.contains(ConnectivityResult.none)) return;

    _isSyncing = true;
    notifyListeners();
    try {
      await _taskRepository
          .syncTasks(_currentUserId!)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw 'Task sync timed out',
          );
      await loadTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing tasks: $e');
      }
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> onUserLogin(String userId) async {
    _currentUserId = userId;
    try {
      await _taskRepository
          .fetchFromFirestore(userId)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw 'Fetching tasks from Firestore timed out',
          );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching tasks from Firestore: $e');
      }
    }
    await loadTasks();
    await syncTasks();
  }

  void onUserLogout() {
    _currentUserId = null;
    _tasks = [];
    notifyListeners();
  }
}
