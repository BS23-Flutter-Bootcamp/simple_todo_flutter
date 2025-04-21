class Task {
  final int? id;
  final String title;
  final DateTime? dueDate;
  final String? description;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.dueDate,
    this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}