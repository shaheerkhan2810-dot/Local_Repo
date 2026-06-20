import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/widgets/apex_card.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(
      emoji: '🚨',
      label: 'Log Urge',
      subtitle: 'Track & overcome',
      color: Color(0xFFC62828),
      route: '/streak',
    ),
    _QuickAction(
      emoji: '✅',
      label: 'Add Task',
      subtitle: 'Get things done',
      color: AppColors.primaryGreenBright,
      route: '/tasks',
    ),
    _QuickAction(
      emoji: '📊',
      label: 'Log Entry',
      subtitle: 'Update tracker',
      color: AppColors.info,
      route: '/trackers',
    ),
    _QuickAction(
      emoji: '✍️',
      label: 'Write Journal',
      subtitle: 'Reflect & grow',
      color: Color(0xFF7B1FA2),
      route: '/journal/new',
    ),
    _QuickAction(
      emoji: '⏱️',
      label: 'Pomodoro',
      subtitle: 'Focus session',
      color: Color(0xFFE65100),
      route: '/tasks',
    ),
    _QuickAction(
      emoji: '📈',
      label: 'Analytics',
      subtitle: 'Track progress',
      color: Color(0xFF00695C),
      route: '/analytics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: _actions.map((action) {
        return ApexCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          onTap: () => context.push(action.route),
          child: Row(
            children: [
              Text(action.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.label,
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      action.subtitle,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final String emoji;
  final String label;
  final String subtitle;
  final Color color;
  final String route;

  const _QuickAction({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}
