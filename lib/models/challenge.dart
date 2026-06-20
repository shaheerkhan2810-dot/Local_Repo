import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String type;
  final int targetValue;
  final String? unit;
  final int durationDays;
  final int xpReward;
  final String? badgeId;
  final String domain;
  final bool isBuiltIn;
  final String difficulty;
  final String iconEmoji;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.unit,
    required this.durationDays,
    required this.xpReward,
    this.badgeId,
    required this.domain,
    this.isBuiltIn = false,
    required this.difficulty,
    required this.iconEmoji,
  });

  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Challenge(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      type: data['type'] as String,
      targetValue: data['targetValue'] as int,
      unit: data['unit'] as String?,
      durationDays: data['durationDays'] as int,
      xpReward: data['xpReward'] as int,
      badgeId: data['badgeId'] as String?,
      domain: data['domain'] as String,
      isBuiltIn: data['isBuiltIn'] as bool? ?? false,
      difficulty: data['difficulty'] as String? ?? 'medium',
      iconEmoji: data['iconEmoji'] as String? ?? '🎯',
    );
  }

  factory Challenge.fromMap(Map<String, dynamic> data) {
    return Challenge(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      type: data['type'] as String,
      targetValue: data['targetValue'] as int,
      unit: data['unit'] as String?,
      durationDays: data['durationDays'] as int,
      xpReward: data['xpReward'] as int,
      badgeId: data['badgeId'] as String?,
      domain: data['domain'] as String,
      isBuiltIn: data['isBuiltIn'] as bool? ?? true,
      difficulty: data['difficulty'] as String? ?? 'medium',
      iconEmoji: data['iconEmoji'] as String? ?? '🎯',
    );
  }
}

class ChallengeProgress {
  final String id;
  final String challengeId;
  final DateTime startedAt;
  final int currentValue;
  final bool isCompleted;
  final DateTime? completedAt;
  final Challenge? challenge;

  const ChallengeProgress({
    required this.id,
    required this.challengeId,
    required this.startedAt,
    required this.currentValue,
    required this.isCompleted,
    this.completedAt,
    this.challenge,
  });

  double get progressPercent {
    if (challenge == null || challenge!.targetValue == 0) return 0;
    return (currentValue / challenge!.targetValue).clamp(0.0, 1.0);
  }

  int get daysRemaining {
    if (challenge == null || isCompleted) return 0;
    final elapsed = DateTime.now().difference(startedAt).inDays;
    final remaining = challenge!.durationDays - elapsed;
    return remaining.clamp(0, challenge!.durationDays);
  }

  factory ChallengeProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChallengeProgress(
      id: doc.id,
      challengeId: data['challengeId'] as String,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      currentValue: data['currentValue'] as int? ?? 0,
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'challengeId': challengeId,
        'startedAt': Timestamp.fromDate(startedAt),
        'currentValue': currentValue,
        'isCompleted': isCompleted,
        'completedAt':
            completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      };

  ChallengeProgress copyWith({
    int? currentValue,
    bool? isCompleted,
    DateTime? completedAt,
    Challenge? challenge,
  }) {
    return ChallengeProgress(
      id: id,
      challengeId: challengeId,
      startedAt: startedAt,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      challenge: challenge ?? this.challenge,
    );
  }
}
