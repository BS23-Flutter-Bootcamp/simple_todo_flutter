import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_flutter/model/repository/notification_repository.dart';
import 'package:simple_todo_flutter/model/repository/task_repository.dart';
import 'package:simple_todo_flutter/model/services/firestore_service.dart';
import 'package:simple_todo_flutter/model/services/task_service.dart';
import 'package:simple_todo_flutter/view/ai_todo_screen.dart';
import 'package:simple_todo_flutter/view/login_screen.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';
import 'package:simple_todo_flutter/view/add_task_screen.dart';
import 'package:simple_todo_flutter/view/edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _handleLogout() async {
    TaskViewModel(
      TaskRepository(
        TaskService(),
        FirestoreService(),
        NotificationRepository(),
      ),
    ).onUserLogout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('ToDo List', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: const Color(0xFF00695C),
        leading: Consumer<TaskViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.isSyncing
                ? const SizedBox(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
                : IconButton(
                  icon: const Icon(Icons.sync, color: Colors.white),
                  onPressed: () => viewModel.syncTasks(),
                );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AITodoScreen()),
              );
            },
            tooltip: 'Generate AI Tasks',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFECEFF1),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          final tasks = viewModel.tasks;
          return tasks.isEmpty
              ? viewModel.isSyncing
                  ? const Center(child: Text('Syncing tasks...'))
                  : const Center(child: Text('No tasks yet! Add some.'))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFF00695C),
                          width: 2,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          viewModel.toggleTaskCompletion(task);
                        },
                        activeColor: const Color(0xFF00695C),
                        checkColor: Colors.white,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 14, 102, 93),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decoration:
                              task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.description != null)
                            Text(
                              task.description!,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 10, 22, 26),
                              ),
                            ),
                          Text(
                            task.dueDate != null
                                ? 'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate!)}'
                                : 'No due date',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 21, 120, 110),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EditTaskScreen(task: task, index: index),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: const Color(0xFF00695C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
