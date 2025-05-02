import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/view/widgets/custom_date_picker.dart';
import '../view_model/task_viewmodel.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isCompleted = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final viewModel = Provider.of<TaskViewModel>(context, listen: false);
      try {
        await viewModel.addTask(
          title: _titleController.text,
          dueDate: _dueDate,
          description:
              _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
          isCompleted: _isCompleted,
        );
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add task: $error'),
              backgroundColor: const Color(0xFFB00020),
            ),
          );
        }
      } finally {
        if (context.mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Color(0xFFB00020),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: const Color(0xFF00695C),
      ),
      backgroundColor: const Color(0xFFECEFF1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF4DB6AC)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6E40)),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF263238)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF4DB6AC)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6E40)),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF263238)),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 16),
              CustomDatePicker(
                selectedDate: _dueDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _dueDate = newDate;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF00695C),
                    checkColor: Colors.white,
                  ),
                  const Text(
                    'Completed',
                    style: TextStyle(color: Color(0xFF4DB6AC)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF263238)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSaving ? null : () => _saveTask(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00695C),
                    ),
                    child:
                        _isSaving
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
