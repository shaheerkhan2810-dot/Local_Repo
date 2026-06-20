import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/badge_model.dart';

class BadgeGallery extends StatelessWidget {
  final List<BadgeModel> badges;

  const BadgeGallery({super.key, required this.badges});

  Color get _rarityGlow {
    return AppColors.accentGold;
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'legendary':
        return const Color(0xFFFFD700);
      case 'epic':
        return const Color(0xFF7B1FA2);
      case 'rare':
        return const Color(0xFF1565C0);
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Text('🏅', style: TextStyle(fontSize: 36)),
            SizedBox(height: 8),
            Text(
              'No badges earned yet',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textHint,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Reach streak milestones to unlock badges',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: badges.map((badge) => _BadgeChip(badge: badge)).toList(),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeChip({required this.badge});

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'legendary':
        return const Color(0xFFFFD700);
      case 'epic':
        return const Color(0xFF7B1FA2);
      case 'rare':
        return const Color(0xFF1565C0);
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _rarityColor(badge.rarity);

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(120), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(30),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              badge.iconAsset,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 6),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              badge.rarityLabel,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 9,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.iconAsset, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              badge.title,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              badge.rarityLabel,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _rarityColor(badge.rarity),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'CLOSE',
              style: TextStyle(color: AppColors.accentGold),
            ),
          ),
        ],
      ),
    );
  }
}
