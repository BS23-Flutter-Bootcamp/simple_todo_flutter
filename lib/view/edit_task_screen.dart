import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_flutter/view_model/task_viewmodel.dart';
import 'package:simple_todo_flutter/model/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final int index;

  const EditTaskScreen({super.key, required this.task, required this.index});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime? _dueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    _dueDate = widget.task.dueDate;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00695C), // Deep Teal
              onPrimary: Colors.white,
              surface: Color(0xFFECEFF1), // Soft Slate Gray
              onSurface: Color(0xFF263238), // Charcoal
            ),
            dialogBackgroundColor: const Color(0xFFECEFF1), // Soft Slate Gray
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<TaskViewModel>(context, listen: false);
      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        dueDate: _dueDate,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        isCompleted: _isCompleted,
      );
      viewModel.updateTask(updatedTask).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: $error'),
            backgroundColor: const Color(0xFFB00020), // Error Red
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Color(0xFFB00020), // Error Red
        ),
      );
    }
  }

  void _deleteTask(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.deleteTask(widget.task.id!).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task: $error'),
          backgroundColor: const Color(0xFFB00020), // Error Red
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: const Color(0xFF00695C), // Deep Teal
      ),
      backgroundColor: const Color(0xFFECEFF1), // Soft Slate Gray
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF4DB6AC)), // Muted Teal
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6E40)), // Coral Glow
                  ),
                ),
                style: const TextStyle(color: Color(0xFF263238)), // Charcoal
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDueDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date (optional)',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Color(0xFF4DB6AC)), // Muted Teal
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF6E40)), // Coral Glow
                    ),
                  ),
                  child: Text(
                    _dueDate != null
                        ? DateFormat('MMM d, yyyy').format(_dueDate!)
                        : 'Select a date',
                    style: const TextStyle(color: Color(0xFF263238)), // Charcoal
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color(0xFF4DB6AC)), // Muted Teal
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6E40)), // Coral Glow
                  ),
                ),
                style: const TextStyle(color: Color(0xFF263238)), // Charcoal
                maxLines: 3,
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
                    activeColor: const Color(0xFF00695C), // Deep Teal
                    checkColor: Colors.white,
                  ),
                  const Text(
                    'Completed',
                    style: TextStyle(color: Color(0xFF4DB6AC)), // Muted Teal
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _deleteTask(context),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Color(0xFFB00020)), // Error Red
                    ),
                  ),
                  const SizedBox(width: 8),
                
                  ElevatedButton(
                    onPressed: () => _saveTask(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00695C), // Deep Teal
                    ),
                    child: const Text('Save',style: TextStyle(color: Colors.white),),
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