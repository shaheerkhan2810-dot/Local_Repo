import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool isRecurring;
  final String? recurrenceRule;
  final int priority;
  final String? domain;
  final List<String> tags;
  final int xpReward;
  final DateTime createdAt;
  final int? pomodoroEstimate;
  final int pomodorosCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.isRecurring = false,
    this.recurrenceRule,
    this.priority = 2,
    this.domain,
    this.tags = const [],
    this.xpReward = 5,
    required this.createdAt,
    this.pomodoroEstimate,
    this.pomodorosCompleted = 0,
  });

  String get priorityLabel {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Medium';
    }
  }

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      isRecurring: data['isRecurring'] as bool? ?? false,
      recurrenceRule: data['recurrenceRule'] as String?,
      priority: data['priority'] as int? ?? 2,
      domain: data['domain'] as String?,
      tags: List<String>.from(data['tags'] as List? ?? []),
      xpReward: data['xpReward'] as int? ?? 5,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pomodoroEstimate: data['pomodoroEstimate'] as int?,
      pomodorosCompleted: data['pomodorosCompleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
        'isCompleted': isCompleted,
        'completedAt':
            completedAt != null ? Timestamp.fromDate(completedAt!) : null,
        'isRecurring': isRecurring,
        'recurrenceRule': recurrenceRule,
        'priority': priority,
        'domain': domain,
        'tags': tags,
        'xpReward': xpReward,
        'createdAt': Timestamp.fromDate(createdAt),
        'pomodoroEstimate': pomodoroEstimate,
        'pomodorosCompleted': pomodorosCompleted,
      };

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isRecurring,
    String? recurrenceRule,
    int? priority,
    String? domain,
    List<String>? tags,
    int? xpReward,
    int? pomodoroEstimate,
    int? pomodorosCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      priority: priority ?? this.priority,
      domain: domain ?? this.domain,
      tags: tags ?? this.tags,
      xpReward: xpReward ?? this.xpReward,
      createdAt: createdAt,
      pomodoroEstimate: pomodoroEstimate ?? this.pomodoroEstimate,
      pomodorosCompleted: pomodorosCompleted ?? this.pomodorosCompleted,
    );
  }
}
