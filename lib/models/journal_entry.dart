import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final String? title;
  final String richContent;
  final int mood;
  final List<String> mediaUrls;
  final String? voiceNoteUrl;
  final List<String> tags;
  final int streakDayAtEntry;
  final int xpAwarded;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntry({
    required this.id,
    required this.date,
    this.title,
    required this.richContent,
    required this.mood,
    this.mediaUrls = const [],
    this.voiceNoteUrl,
    this.tags = const [],
    this.streakDayAtEntry = 0,
    this.xpAwarded = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '🔥';
      default:
        return '😐';
    }
  }

  String get moodLabel {
    switch (mood) {
      case 1:
        return 'Terrible';
      case 2:
        return 'Low';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Amazing';
      default:
        return 'Neutral';
    }
  }

  /// Returns plain text preview (first ~150 chars) from Quill delta JSON
  String get textPreview {
    try {
      if (richContent.isEmpty) return '';
      return richContent.length > 150
          ? richContent.substring(0, 150)
          : richContent;
    } catch (_) {
      return richContent.length > 150
          ? richContent.substring(0, 150)
          : richContent;
    }
  }

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      title: data['title'] as String?,
      richContent: data['richContent'] as String? ?? '',
      mood: data['mood'] as int? ?? 3,
      mediaUrls: List<String>.from(data['mediaUrls'] as List? ?? []),
      voiceNoteUrl: data['voiceNoteUrl'] as String?,
      tags: List<String>.from(data['tags'] as List? ?? []),
      streakDayAtEntry: data['streakDayAtEntry'] as int? ?? 0,
      xpAwarded: data['xpAwarded'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'date': Timestamp.fromDate(date),
        'title': title,
        'richContent': richContent,
        'mood': mood,
        'mediaUrls': mediaUrls,
        'voiceNoteUrl': voiceNoteUrl,
        'tags': tags,
        'streakDayAtEntry': streakDayAtEntry,
        'xpAwarded': xpAwarded,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  JournalEntry copyWith({
    String? title,
    String? richContent,
    int? mood,
    List<String>? mediaUrls,
    String? voiceNoteUrl,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id,
      date: date,
      title: title ?? this.title,
      richContent: richContent ?? this.richContent,
      mood: mood ?? this.mood,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
      tags: tags ?? this.tags,
      streakDayAtEntry: streakDayAtEntry,
      xpAwarded: xpAwarded,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
