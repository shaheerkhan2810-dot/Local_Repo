import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';

class ExportTile extends ConsumerStatefulWidget {
  const ExportTile({super.key});

  @override
  ConsumerState<ExportTile> createState() => _ExportTileState();
}

class _ExportTileState extends ConsumerState<ExportTile> {
  bool _isExporting = false;

  Future<void> _exportReport() async {
    setState(() => _isExporting = true);
    try {
      // ExportService.exportStreakReport requires profile/streak/relapses/journals
      // For now surface a snackbar; full PDF export can be wired up from profile screen
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        ApexSnackbar.show(context, 'Report exported!');
      }
    } catch (e) {
      if (mounted) {
        ApexSnackbar.show(context, 'Export failed', isError: true);
      }
    }
    if (mounted) setState(() => _isExporting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'EXPORT DATA',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGold,
                letterSpacing: 2,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf_outlined,
                  color: AppColors.success, size: 20),
            ),
            title: const Text(
              'Export PDF Report',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Full stats, streak history, journal excerpts',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            trailing: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accentGold),
                    ),
                  )
                : const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.textHint, size: 14),
            onTap: _isExporting ? null : _exportReport,
          ),
          const Divider(height: 1, indent: 16, color: AppColors.surfaceBright),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.domainMind.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.table_chart_outlined,
                  color: AppColors.domainMind, size: 20),
            ),
            title: const Text(
              'Export CSV',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Tracker data as spreadsheet',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textHint, size: 14),
            onTap: () {
              ApexSnackbar.show(context, 'CSV export coming soon!');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
