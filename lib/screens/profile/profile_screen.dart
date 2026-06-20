import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/auth_provider.dart';
import 'package:apexforge/providers/user_provider.dart';
import 'package:apexforge/screens/profile/widgets/xp_level_card.dart';
import 'package:apexforge/screens/profile/widgets/badge_gallery.dart';
import 'package:apexforge/screens/profile/widgets/notification_settings_tile.dart';
import 'package:apexforge/screens/profile/widgets/export_tile.dart';
import 'package:apexforge/widgets/apex_loading.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';
import 'package:apexforge/widgets/confirmation_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: AppColors.textSecondary),
            onPressed: () async {
              final confirmed = await showConfirmationDialog(
                context,
                title: 'Sign Out',
                message: 'Are you sure you want to sign out?',
                confirmLabel: 'Sign Out',
              );
              if (confirmed == true && context.mounted) {
                await ref.read(authNotifierProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('No profile found',
                  style: TextStyle(color: AppColors.textHint)),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // XP + Level card
              XpLevelCard(profile: profile),
              const SizedBox(height: 20),

              // Badges section
              const _SectionHeader(title: 'ACHIEVEMENTS'),
              const SizedBox(height: 10),
              const BadgeGallery(badges: []),
              const SizedBox(height: 20),

              // Notifications
              const NotificationSettingsTile(),
              const SizedBox(height: 20),

              // Export
              const ExportTile(),
              const SizedBox(height: 20),

              // Account settings
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.surfaceBright, width: 0.5),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ACCOUNT',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_forever_outlined,
                          color: AppColors.error),
                      title: const Text(
                        'Delete Account',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: AppColors.error,
                        ),
                      ),
                      subtitle: const Text(
                        'This action is irreversible',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                      onTap: () async {
                        final confirmed = await showConfirmationDialog(
                          context,
                          title: 'Delete Account',
                          message:
                              'This will permanently delete all your data. This cannot be undone.',
                          confirmLabel: 'Delete Forever',
                          isDestructive: true,
                        );
                        if (confirmed == true && context.mounted) {
                          ApexSnackbar.show(
                              context, 'Account deletion not yet implemented',
                              isError: true);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // About
              const Center(
                child: Column(
                  children: [
                    Text(
                      'APEXFORGE',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Life Mastery Tracker v1.0.0',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const ApexLoading(),
        error: (_, __) => const Center(
          child: Text('Error loading profile',
              style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Rajdhani',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.accentGold,
        letterSpacing: 2,
      ),
    );
  }
}
