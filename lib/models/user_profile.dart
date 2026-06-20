import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/xp_calculator.dart';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final int totalXP;
  final int level;
  final Map<String, int> domains;
  final DateTime? currentStreakStart;
  final int longestStreak;
  final bool onboardingComplete;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.createdAt,
    this.totalXP = 0,
    this.level = 0,
    this.domains = const {
      'discipline': 0,
      'body': 0,
      'mind': 0,
      'wealth': 0,
    },
    this.currentStreakStart,
    this.longestStreak = 0,
    this.onboardingComplete = false,
  });

  double get levelProgress => XpCalculator.progressToNextLevel(totalXP);
  int get nextLevelXp => XpCalculator.xpForNextLevel(level);
  int get xpInCurrentLevel =>
      totalXP - AppConstants.levelThresholds[level.clamp(0, AppConstants.levelThresholds.length - 1)];

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'Warrior',
      avatarUrl: data['avatarUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalXP: data['totalXP'] as int? ?? 0,
      level: data['level'] as int? ?? 0,
      domains: Map<String, int>.from(data['domains'] as Map? ?? {}),
      currentStreakStart:
          (data['currentStreakStart'] as Timestamp?)?.toDate(),
      longestStreak: data['longestStreak'] as int? ?? 0,
      onboardingComplete: data['onboardingComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'avatarUrl': avatarUrl,
        'createdAt': Timestamp.fromDate(createdAt),
        'totalXP': totalXP,
        'level': level,
        'domains': domains,
        'currentStreakStart': currentStreakStart != null
            ? Timestamp.fromDate(currentStreakStart!)
            : null,
        'longestStreak': longestStreak,
        'onboardingComplete': onboardingComplete,
      };

  UserProfile copyWith({
    String? displayName,
    String? avatarUrl,
    int? totalXP,
    int? level,
    Map<String, int>? domains,
    DateTime? currentStreakStart,
    int? longestStreak,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      domains: domains ?? this.domains,
      currentStreakStart: currentStreakStart ?? this.currentStreakStart,
      longestStreak: longestStreak ?? this.longestStreak,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  static UserProfile empty(String uid, String email) => UserProfile(
        uid: uid,
        email: email,
        displayName: 'Warrior',
        createdAt: DateTime.now(),
      );
}
