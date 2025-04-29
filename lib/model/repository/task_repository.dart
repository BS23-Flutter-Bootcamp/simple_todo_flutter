import 'package:flutter/foundation.dart';
import 'package:simple_todo_flutter/model/repository/notification_repository.dart';
import 'package:simple_todo_flutter/model/services/firestore_service.dart';
import 'package:simple_todo_flutter/model/services/task_service.dart';
import 'package:simple_todo_flutter/model/task.dart';

class TaskRepository {
  TaskRepository(
    this._taskService,
    this._firestoreService,
    this._notificationRepository,
  );

  final TaskService _taskService;
  final FirestoreService _firestoreService;
  final NotificationRepository _notificationRepository;

  Future<void> addTask({
    required String userId,
    required String title,
    DateTime? dueDate,
    String? description,
    bool isCompleted = false,
  }) async {
    if (title.isEmpty) {
      throw Exception('Title cannot be empty');
    }
    final task = Task(
      userId: userId,
      title: title.trim(),
      dueDate: dueDate,
      description: description?.trim(),
      isCompleted: isCompleted,
      lastModified: DateTime.now(),
      syncStatus: 'pending',
    );
    final taskId = await _taskService.insertTask(task);
    final taskWithId = task.copyWith(id: taskId);
    //This is testing Schedule a notification for the task
    // await _notificationRepository.scheduleTestNotification(
    //   id: taskId,
    //   title: title,
    //   body: 'Task "${task.title}" is due in 10 secs!',
    // );
    await _notificationRepository.scheduleTaskNotifications(taskWithId);
  }

  Future<List<Task>> getTasks(String userId) async {
    return await _taskService.getTasks(userId);
  }

  Future<void> updateTask(Task task) async {
    if (task.title.isEmpty) {
      throw Exception('Title cannot be empty');
    }
    final updatedTask = task.copyWith(
      lastModified: DateTime.now(),
      syncStatus: 'pending',
    );
    await _taskService.updateTask(updatedTask);
    await _notificationRepository.cancelNotification(task.id!);
    await _notificationRepository.scheduleTaskNotifications(updatedTask);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      lastModified: DateTime.now(),
      syncStatus: 'pending',
    );
    await _taskService.updateTask(updatedTask);
    if (task.isCompleted) {
      await _notificationRepository.cancelNotification(task.id!);
    } else {
      await _notificationRepository.scheduleTaskNotifications(updatedTask);
    }
  }

  Future<void> deleteTask(int id, String userId) async {
    final tasks = await _taskService.getTasks(userId);
    final task = tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => throw 'Task not found',
    );
    final updatedTask = task.copyWith(
      syncStatus: 'deleted',
      lastModified: DateTime.now(),
    );
    await _taskService.updateTask(updatedTask);
    await _notificationRepository.cancelNotification(task.id!);
  }

  Future<void> syncTasks(String userId) async {
    try {
      final pendingTasks = await _taskService.getPendingTasks(userId);
      for (final task in pendingTasks) {
        if (task.syncStatus == 'deleted') {
          await _firestoreService.deleteTask(userId, task.id!);
        } else {
          await _firestoreService.syncTask(userId, task);
        }
        if (task.syncStatus == 'deleted') {
          await _taskService.deleteTask(task.id!);
        } else {
          await _taskService.updateTask(task.copyWith(syncStatus: 'synced'));
        }
      }
      await _syncFromFirestore(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Sync failed: $e');
      }
    }
  }

  Future<void> _syncFromFirestore(String userId) async {
    final firestoreTasks = await _firestoreService.getTasks(userId);
    final localTasks = await _taskService.getTasks(userId);

    for (final firestoreTask in firestoreTasks) {
      final localTask = localTasks.firstWhere(
        (t) => t.id == firestoreTask.id,
        orElse:
            () => Task(
              id: firestoreTask.id,
              userId: userId,
              title: '',
              isCompleted: false,
              lastModified: DateTime.now(),
              syncStatus: 'synced',
            ),
      );
      if (localTask.title.isEmpty ||
          firestoreTask.lastModified.isAfter(localTask.lastModified)) {
        await _taskService.insertTask(firestoreTask);
      } else if (localTask.lastModified.isAfter(firestoreTask.lastModified) &&
          localTask.syncStatus == 'synced') {
        await _firestoreService.syncTask(userId, localTask);
      }
    }

    await _firestoreService.setLastSyncTime(userId, DateTime.now());
  }

  Future<void> fetchFromFirestore(String userId) async {
    // await _taskService.clearTasksForUser(userId);
    await _syncFromFirestore(userId);
  }
}
