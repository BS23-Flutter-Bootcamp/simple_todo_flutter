import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';
import 'package:simple_todo_flutter/view/add_task_screen.dart';
import 'package:simple_todo_flutter/view/edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ToDo List')),
        backgroundColor: const Color(0xFF00695C),
      ),
      backgroundColor: const Color(0xFFECEFF1),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          final tasks = viewModel.tasks;
          return tasks.isEmpty
              ? const Center(child: Text('No tasks yet! Add some.'))
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
                          color: const Color(0xFF263238),
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
                              style: const TextStyle(color: Color(0xFF4DB6AC)),
                            ),
                          Text(
                            task.dueDate != null
                                ? 'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate!)}'
                                : 'No due date',
                            style: const TextStyle(color: Color(0xFF4DB6AC)),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
