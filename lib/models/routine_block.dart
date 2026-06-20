import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineBlock {
  final String id;
  final String routineType;
  final String title;
  final String? description;
  final int durationMinutes;
  final String iconEmoji;
  final int sortOrder;
  final bool isActive;
  final String? linkedTrackerId;
  final String? linkedTaskId;

  const RoutineBlock({
    required this.id,
    required this.routineType,
    required this.title,
    this.description,
    required this.durationMinutes,
    required this.iconEmoji,
    required this.sortOrder,
    this.isActive = true,
    this.linkedTrackerId,
    this.linkedTaskId,
  });

  bool get isMorning => routineType == 'morning';
  bool get isNight => routineType == 'night';

  factory RoutineBlock.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoutineBlock(
      id: doc.id,
      routineType: data['routineType'] as String? ?? 'morning',
      title: data['title'] as String,
      description: data['description'] as String?,
      durationMinutes: data['durationMinutes'] as int? ?? 10,
      iconEmoji: data['iconEmoji'] as String? ?? '⏱️',
      sortOrder: data['sortOrder'] as int? ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      linkedTrackerId: data['linkedTrackerId'] as String?,
      linkedTaskId: data['linkedTaskId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'routineType': routineType,
        'title': title,
        'description': description,
        'durationMinutes': durationMinutes,
        'iconEmoji': iconEmoji,
        'sortOrder': sortOrder,
        'isActive': isActive,
        'linkedTrackerId': linkedTrackerId,
        'linkedTaskId': linkedTaskId,
      };

  RoutineBlock copyWith({
    String? title,
    String? description,
    int? durationMinutes,
    String? iconEmoji,
    int? sortOrder,
    bool? isActive,
  }) {
    return RoutineBlock(
      id: id,
      routineType: routineType,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      linkedTrackerId: linkedTrackerId,
      linkedTaskId: linkedTaskId,
    );
  }
}
