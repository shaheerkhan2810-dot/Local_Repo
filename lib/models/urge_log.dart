import 'package:cloud_firestore/cloud_firestore.dart';

class UrgeLog {
  final String id;
  final DateTime loggedAt;
  final int intensity;
  final String? trigger;
  final int? durationMinutes;
  final String? copingToolUsed;
  final bool overcame;

  const UrgeLog({
    required this.id,
    required this.loggedAt,
    required this.intensity,
    this.trigger,
    this.durationMinutes,
    this.copingToolUsed,
    required this.overcame,
  });

  factory UrgeLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UrgeLog(
      id: doc.id,
      loggedAt: (data['loggedAt'] as Timestamp).toDate(),
      intensity: data['intensity'] as int? ?? 5,
      trigger: data['trigger'] as String?,
      durationMinutes: data['durationMinutes'] as int?,
      copingToolUsed: data['copingToolUsed'] as String?,
      overcame: data['overcame'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'loggedAt': Timestamp.fromDate(loggedAt),
        'intensity': intensity,
        'trigger': trigger,
        'durationMinutes': durationMinutes,
        'copingToolUsed': copingToolUsed,
        'overcame': overcame,
      };
}
