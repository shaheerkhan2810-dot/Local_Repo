import 'package:cloud_firestore/cloud_firestore.dart';
import 'tracker_field_schema.dart';

class CustomTracker {
  final String id;
  final String name;
  final String emoji;
  final String colorHex;
  final String? description;
  final List<TrackerFieldSchema> fieldSchema;
  final String trackingFrequency;
  final String? goal;
  final int xpPerEntry;
  final String domain;
  final DateTime createdAt;
  final bool isArchived;
  final int sortOrder;

  const CustomTracker({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorHex,
    this.description,
    required this.fieldSchema,
    this.trackingFrequency = 'daily',
    this.goal,
    this.xpPerEntry = 5,
    required this.domain,
    required this.createdAt,
    this.isArchived = false,
    this.sortOrder = 0,
  });

  factory CustomTracker.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final schemaList = (data['fieldSchema'] as List?)
            ?.map((e) => TrackerFieldSchema.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];
    return CustomTracker(
      id: doc.id,
      name: data['name'] as String,
      emoji: data['emoji'] as String? ?? '📊',
      colorHex: data['colorHex'] as String? ?? '#1B5E20',
      description: data['description'] as String?,
      fieldSchema: schemaList,
      trackingFrequency: data['trackingFrequency'] as String? ?? 'daily',
      goal: data['goal'] as String?,
      xpPerEntry: data['xpPerEntry'] as int? ?? 5,
      domain: data['domain'] as String? ?? 'discipline',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isArchived: data['isArchived'] as bool? ?? false,
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'emoji': emoji,
        'colorHex': colorHex,
        'description': description,
        'fieldSchema': fieldSchema.map((f) => f.toMap()).toList(),
        'trackingFrequency': trackingFrequency,
        'goal': goal,
        'xpPerEntry': xpPerEntry,
        'domain': domain,
        'createdAt': Timestamp.fromDate(createdAt),
        'isArchived': isArchived,
        'sortOrder': sortOrder,
      };

  CustomTracker copyWith({
    String? name,
    String? emoji,
    String? colorHex,
    String? description,
    List<TrackerFieldSchema>? fieldSchema,
    String? trackingFrequency,
    String? goal,
    int? xpPerEntry,
    String? domain,
    bool? isArchived,
    int? sortOrder,
  }) {
    return CustomTracker(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorHex: colorHex ?? this.colorHex,
      description: description ?? this.description,
      fieldSchema: fieldSchema ?? this.fieldSchema,
      trackingFrequency: trackingFrequency ?? this.trackingFrequency,
      goal: goal ?? this.goal,
      xpPerEntry: xpPerEntry ?? this.xpPerEntry,
      domain: domain ?? this.domain,
      createdAt: createdAt,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
