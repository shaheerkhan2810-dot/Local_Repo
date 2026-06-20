import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String iconAsset;
  final DateTime unlockedAt;
  final String category;
  final String rarity;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.unlockedAt,
    required this.category,
    required this.rarity,
  });

  String get rarityLabel {
    switch (rarity) {
      case 'legendary':
        return 'LEGENDARY';
      case 'epic':
        return 'EPIC';
      case 'rare':
        return 'RARE';
      default:
        return 'COMMON';
    }
  }

  factory BadgeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BadgeModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      iconAsset: data['iconAsset'] as String? ?? '🏆',
      unlockedAt: (data['unlockedAt'] as Timestamp).toDate(),
      category: data['category'] as String? ?? 'general',
      rarity: data['rarity'] as String? ?? 'common',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'iconAsset': iconAsset,
        'unlockedAt': Timestamp.fromDate(unlockedAt),
        'category': category,
        'rarity': rarity,
      };

  static List<BadgeModel> get allBadges => [
        BadgeModel(
          id: 'badge_7_warrior',
          title: '7 Day Warrior',
          description: 'Completed 7 consecutive days of purity.',
          iconAsset: '⚔️',
          unlockedAt: DateTime.now(),
          category: 'streak',
          rarity: 'common',
        ),
        BadgeModel(
          id: 'badge_30_iron',
          title: 'Iron Will',
          description: 'Completed 30 days. The first real test.',
          iconAsset: '🔩',
          unlockedAt: DateTime.now(),
          category: 'streak',
          rarity: 'rare',
        ),
        BadgeModel(
          id: 'badge_60_steel',
          title: 'Steel Mind',
          description: '60 days — forged in the fire of discipline.',
          iconAsset: '🛡️',
          unlockedAt: DateTime.now(),
          category: 'streak',
          rarity: 'rare',
        ),
        BadgeModel(
          id: 'badge_90_diamond',
          title: 'Diamond Mind',
          description: '90 days. You have broken the cycle.',
          iconAsset: '💎',
          unlockedAt: DateTime.now(),
          category: 'streak',
          rarity: 'epic',
        ),
        BadgeModel(
          id: 'badge_180_unbreakable',
          title: 'Unbreakable',
          description: '180 days. Half a year of total control.',
          iconAsset: '🌋',
          unlockedAt: DateTime.now(),
          category: 'streak',
          rarity: 'epic',
        ),
        BadgeModel(
          id: 'badge_365_legend',
          title: 'LEGEND',
          description: 'One full year. You are a legend.',
          iconAsset: '👑',
          unlockedAt: DateTime.now(),
          category: 'streak',
          rarity: 'legendary',
        ),
      ];
}
