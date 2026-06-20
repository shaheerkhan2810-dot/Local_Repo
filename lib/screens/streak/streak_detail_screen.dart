import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/streak_provider.dart';
import 'package:apexforge/screens/streak/widgets/streak_counter_ring.dart';
import 'package:apexforge/screens/streak/widgets/milestone_timeline.dart';
import 'package:apexforge/screens/streak/widgets/coping_tools_panel.dart';
import 'package:apexforge/screens/streak/widgets/urge_logger_sheet.dart';
import 'package:apexforge/screens/streak/widgets/relapse_modal.dart';
import 'package:apexforge/widgets/confirmation_dialog.dart';

class StreakDetailScreen extends ConsumerStatefulWidget {
  const StreakDetailScreen({super.key});

  @override
  ConsumerState<StreakDetailScreen> createState() =>
      _StreakDetailScreenState();
}

class _StreakDetailScreenState extends ConsumerState<StreakDetailScreen> {
  void _showUrgeLogger() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UrgeLoggerSheet(),
    );
  }

  Future<void> _showRelapseConfirm() async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Log Relapse',
      message: 'This will reset your streak. Are you sure?',
      confirmLabel: 'Continue',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const RelapseModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'STREAK',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.surfaceBright),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUrgeLogger,
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.warning_rounded),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const StreakCounterRing(),
                  const SizedBox(height: 24),
                  const MilestoneTimeline(),
                  const SizedBox(height: 24),
                  const CopingToolsPanel(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showRelapseConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'LOG RELAPSE',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
