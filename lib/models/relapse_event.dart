import 'package:cloud_firestore/cloud_firestore.dart';

class RelapseEvent {
  final String id;
  final DateTime occurredAt;
  final int streakDaysBefore;
  final String? reason;
  final String? triggerCategory;
  final int mood;
  final String? notes;

  const RelapseEvent({
    required this.id,
    required this.occurredAt,
    required this.streakDaysBefore,
    this.reason,
    this.triggerCategory,
    required this.mood,
    this.notes,
  });

  factory RelapseEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RelapseEvent(
      id: doc.id,
      occurredAt: (data['occurredAt'] as Timestamp).toDate(),
      streakDaysBefore: data['streakDaysBefore'] as int? ?? 0,
      reason: data['reason'] as String?,
      triggerCategory: data['triggerCategory'] as String?,
      mood: data['mood'] as int? ?? 3,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'occurredAt': Timestamp.fromDate(occurredAt),
        'streakDaysBefore': streakDaysBefore,
        'reason': reason,
        'triggerCategory': triggerCategory,
        'mood': mood,
        'notes': notes,
      };
}
