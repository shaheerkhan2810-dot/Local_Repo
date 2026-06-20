import 'package:cloud_firestore/cloud_firestore.dart';

class MainStreak {
  final String id;
  final DateTime startDate;
  final bool isActive;
  final DateTime lastUpdated;

  const MainStreak({
    required this.id,
    required this.startDate,
    required this.isActive,
    required this.lastUpdated,
  });

  /// Always computed live — never stored — to avoid stale data.
  int get currentDays {
    if (!isActive) return 0;
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(start).inDays;
  }

  factory MainStreak.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MainStreak(
      id: doc.id,
      startDate: (data['startDate'] as Timestamp).toDate(),
      isActive: data['isActive'] as bool? ?? true,
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'startDate': Timestamp.fromDate(startDate),
        'isActive': isActive,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

  MainStreak copyWith({
    DateTime? startDate,
    bool? isActive,
  }) {
    return MainStreak(
      id: id,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
      lastUpdated: DateTime.now(),
    );
  }

  static MainStreak fresh() => MainStreak(
        id: 'current',
        startDate: DateTime.now(),
        isActive: true,
        lastUpdated: DateTime.now(),
      );
}
