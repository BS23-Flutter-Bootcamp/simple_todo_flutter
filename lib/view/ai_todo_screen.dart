import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/model/task.dart';
import 'package:simple_todo_flutter/view_model/ai_viewmodel.dart';
import 'package:intl/intl.dart';

class AITodoScreen extends StatelessWidget {
  const AITodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI To-Do List Generator'),
        backgroundColor: const Color(0xFF00695C),
      ),
      body: Consumer<AITodoViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: viewModel.setPrompt,
                  decoration: InputDecoration(
                    labelText:
                        'Enter your prompt (e.g., "Plan a productive day")',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF6F61)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed:
                      viewModel.isLoading ? null : viewModel.generateTasks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:
                      viewModel.isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Generate Tasks',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                ),
                const SizedBox(height: 16.0),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child:
                      viewModel.tasks.isEmpty
                          ? const Center(child: Text('No tasks generated yet'))
                          : ListView.builder(
                            itemCount: viewModel.tasks.length,
                            itemBuilder: (context, index) {
                              final task = viewModel.editedTasks[index];
                              return ListTile(
                                title: Text(task.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (task.description != null)
                                      Text(task.description!),
                                    Text(
                                      task.dueDate != null
                                          ? 'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate!)}'
                                          : 'No due date',
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed:
                                      () =>
                                          _editTask(context, viewModel, index),
                                ),
                              );
                            },
                          ),
                ),
                if (viewModel.tasks.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      viewModel.saveTasks();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00695C),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Save Tasks',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editTask(BuildContext context, AITodoViewModel viewModel, int index) {
    final task = viewModel.editedTasks[index];
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder: (context, setState) {
              DateTime? selectedDate = task.dueDate;

              return AlertDialog(
                title: const Text('Edit Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Task Title'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Task Description',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          selectedDate != null
                              ? 'Due: ${DateFormat('MMM d, yyyy').format(selectedDate)}'
                              : 'No due date',
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context:
                                  dialogContext, // Use the dialogContext (parent context)
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text('Pick Due Date'),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final updatedTask = task.copyWith(
                        title: titleController.text,
                        description:
                            descriptionController.text.isEmpty
                                ? null
                                : descriptionController.text,
                        dueDate: selectedDate,
                      );
                      viewModel.updateTask(index, updatedTask);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
    );
  }
}
