class Task {
  Task({
    this.id,
    required this.userId,
    required this.title,
    this.dueDate,
    this.description,
    this.isCompleted = false,
    required this.lastModified,
    required this.syncStatus,
  });

  final int? id;
  final String userId;
  final String title;
  final DateTime? dueDate;
  final String? description;
  final bool isCompleted;
  final DateTime lastModified;
  final String syncStatus;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'lastModified': lastModified.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'] as String,
      title: map['title'] as String,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      description: map['description'] as String?,
      isCompleted: (map['isCompleted'] as int) == 1,
      lastModified: DateTime.parse(map['lastModified']),
      syncStatus: map['syncStatus'] as String,
    );
  }

  factory Task.fromFirestore(
    String docId,
    Map<String, dynamic> data,
    String userId,
  ) {
    return Task(
      id: int.parse(docId),
      userId: userId,
      title: data['title'] as String,
      dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
      description: data['description'] as String?,
      isCompleted: (data['isCompleted'] as int) == 1,
      lastModified: DateTime.parse(data['lastModified']),
      syncStatus: 'synced',
    );
  }

  Task copyWith({
    int? id,
    String? userId,
    String? title,
    DateTime? dueDate,
    String? description,
    bool? isCompleted,
    DateTime? lastModified,
    String? syncStatus,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      lastModified: lastModified ?? this.lastModified,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
