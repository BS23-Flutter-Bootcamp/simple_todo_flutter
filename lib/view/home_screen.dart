import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/view/add_task_screen.dart';
import 'package:simple_todo_flutter/view/edit_task_screen.dart';

class TempTask {
  final String title;
  final String? description;
  final bool isCompleted;

  TempTask({required this.title, this.description, this.isCompleted = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<TempTask> _tasks = [
    TempTask(title: 'Buy groceries', description: 'Milk, eggs, bread'),
    TempTask(title: 'Drink water',description: '2 litters of water', isCompleted: true),
    TempTask(title: 'Finish Flutter app', description: 'Complete sprint'),
  ];

  void _addTask(Map<String, dynamic> taskData) {
    setState(() {
      _tasks.add(
        TempTask(
          title: taskData['title'],
          description: taskData['description'],
          isCompleted: taskData['isCompleted'],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ToDo List')),
        backgroundColor: const Color(0xFF00695C),
      ),
      backgroundColor: const Color(0xFFECEFF1),
      body:
          _tasks.isEmpty
              ? const Center(child: Text('No tasks yet! Add some.'))
              : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Color(0xFF00695C),
                        width: 2,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: null,
                      activeColor: const Color(0xFFFF6E40),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        color:
                            task.isCompleted
                                ? const Color(0xFF4DB6AC)
                                : const Color(0xFF263238),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                    ),
                    subtitle:
                        task.description != null
                            ? Text(
                              task.description!,
                              style: TextStyle(color: Color(0xFF4DB6AC)),
                            )
                            : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditTaskScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()
            ),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        backgroundColor: const Color(0xFF00695C),
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
