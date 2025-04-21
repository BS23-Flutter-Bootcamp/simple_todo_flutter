class Task {
  Task({
    this.id,
    required this.title,
    this.dueDate,
    this.description,
    this.isCompleted = false,
  });
  final int? id;
  final String title;
  final DateTime? dueDate;
  final String? description;
  final bool isCompleted;
}
