import 'package:cloud_firestore/cloud_firestore.dart';

class TrackerEntry {
  final String id;
  final String trackerId;
  final DateTime date;
  final Map<String, dynamic> values;
  final String? notes;
  final List<String> mediaUrls;
  final DateTime loggedAt;
  final int xpAwarded;

  const TrackerEntry({
    required this.id,
    required this.trackerId,
    required this.date,
    required this.values,
    this.notes,
    this.mediaUrls = const [],
    required this.loggedAt,
    this.xpAwarded = 0,
  });

  factory TrackerEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrackerEntry(
      id: doc.id,
      trackerId: data['trackerId'] as String? ?? '',
      date: (data['date'] as Timestamp).toDate(),
      values: Map<String, dynamic>.from(data['values'] as Map? ?? {}),
      notes: data['notes'] as String?,
      mediaUrls: List<String>.from(data['mediaUrls'] as List? ?? []),
      loggedAt: (data['loggedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      xpAwarded: data['xpAwarded'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'trackerId': trackerId,
        'date': Timestamp.fromDate(date),
        'values': values,
        'notes': notes,
        'mediaUrls': mediaUrls,
        'loggedAt': Timestamp.fromDate(loggedAt),
        'xpAwarded': xpAwarded,
      };
}
