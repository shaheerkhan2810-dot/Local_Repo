import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../core/constants/firestore_paths.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  TaskRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<TaskModel>> watchTasks(String uid) {
    return _firestore
        .collection(FirestorePaths.tasks(uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => TaskModel.fromFirestore(d)).toList());
  }

  Future<List<TaskModel>> getTasks(String uid) async {
    final snap = await _firestore
        .collection(FirestorePaths.tasks(uid))
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => TaskModel.fromFirestore(d)).toList();
  }

  Future<String> createTask(String uid, TaskModel task) async {
    final id = _uuid.v4();
    final withId = TaskModel(
      id: id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isRecurring: task.isRecurring,
      recurrenceRule: task.recurrenceRule,
      priority: task.priority,
      domain: task.domain,
      tags: task.tags,
      xpReward: task.xpReward,
      createdAt: DateTime.now(),
      pomodoroEstimate: task.pomodoroEstimate,
    );
    await _firestore
        .doc(FirestorePaths.task(uid, id))
        .set(withId.toFirestore());
    return id;
  }

  Future<void> updateTask(String uid, TaskModel task) async {
    await _firestore
        .doc(FirestorePaths.task(uid, task.id))
        .update(task.toFirestore());
  }

  Future<void> toggleComplete(String uid, String taskId, bool complete) async {
    await _firestore.doc(FirestorePaths.task(uid, taskId)).update({
      'isCompleted': complete,
      'completedAt': complete
          ? Timestamp.fromDate(DateTime.now())
          : null,
    });
  }

  Future<void> incrementPomodoro(String uid, String taskId) async {
    await _firestore.doc(FirestorePaths.task(uid, taskId)).update({
      'pomodorosCompleted': FieldValue.increment(1),
    });
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _firestore.doc(FirestorePaths.task(uid, taskId)).delete();
  }

  String generateId() => _uuid.v4();
}
