import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../models/main_streak.dart';
import '../models/relapse_event.dart';
import '../models/tracker_entry.dart';
import '../models/custom_tracker.dart';
import '../models/journal_entry.dart';
import '../core/utils/date_utils.dart';

class ExportService {
  ExportService._();

  static Future<void> exportAllAsCsv({
    required List<CustomTracker> trackers,
    required Map<String, List<TrackerEntry>> entriesByTracker,
  }) async {
    final dir = await getTemporaryDirectory();
    final files = <XFile>[];

    for (final tracker in trackers) {
      final entries = entriesByTracker[tracker.id] ?? [];
      if (entries.isEmpty) continue;

      final csvContent = _buildTrackerCsv(tracker, entries);
      final fileName =
          '${tracker.name.replaceAll(' ', '_')}_${DateFormat('yyyy-MM').format(DateTime.now())}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csvContent);
      files.add(XFile(file.path));
    }

    if (files.isEmpty) return;

    await Share.shareXFiles(files, subject: 'ApexForge Tracker Data');
  }

  static String _buildTrackerCsv(
      CustomTracker tracker, List<TrackerEntry> entries) {
    final buffer = StringBuffer();

    // Header
    buffer.write('Date');
    for (final field in tracker.fieldSchema) {
      buffer.write(',${field.label}');
      if (field.unit != null) buffer.write(' (${field.unit})');
    }
    buffer.write(',Notes\n');

    // Rows
    for (final entry in entries) {
      buffer.write(DateFormat('yyyy-MM-dd').format(entry.date));
      for (final field in tracker.fieldSchema) {
        final value = entry.values[field.id] ?? '';
        buffer.write(',$value');
      }
      buffer.write(',${entry.notes ?? ''}\n');
    }

    return buffer.toString();
  }

  static Future<void> exportStreakReport({
    required UserProfile profile,
    required MainStreak? streak,
    required List<RelapseEvent> relapses,
    required List<JournalEntry> recentJournals,
  }) async {
    final dir = await getTemporaryDirectory();
    final buffer = StringBuffer();

    // Header
    buffer.writeln('APEXFORGE LIFE MASTERY TRACKER — STREAK REPORT');
    buffer.writeln('Generated: ${AppDateUtils.formatDateTime(DateTime.now())}');
    buffer.writeln('Warrior: ${profile.displayName}');
    buffer.writeln('Level: ${profile.level} | Total XP: ${profile.totalXP}');
    buffer.writeln('');

    // Current streak
    if (streak != null && streak.isActive) {
      buffer.writeln('CURRENT STREAK: ${streak.currentDays} DAYS');
    } else {
      buffer.writeln('CURRENT STREAK: 0 DAYS');
    }
    buffer.writeln('LONGEST STREAK: ${profile.longestStreak} days');
    buffer.writeln('');

    // Relapse history
    buffer.writeln('RELAPSE HISTORY (${relapses.length} total):');
    for (final r in relapses) {
      buffer.writeln(
        '  • ${AppDateUtils.formatDate(r.occurredAt)} — after ${r.streakDaysBefore} days'
        '${r.triggerCategory != null ? ' [${r.triggerCategory}]' : ''}',
      );
    }
    buffer.writeln('');

    // Journal highlights
    buffer.writeln('RECENT JOURNAL ENTRIES (last ${recentJournals.length}):');
    for (final j in recentJournals) {
      buffer.writeln(
        '  ${AppDateUtils.formatDate(j.date)} ${j.moodEmoji} ${j.title ?? '(untitled)'}'
        ' — Day ${j.streakDayAtEntry}',
      );
    }

    final file = File('${dir.path}/apexforge_report.txt');
    await file.writeAsString(buffer.toString());
    await Share.shareXFiles([XFile(file.path)], subject: 'ApexForge Streak Report');
  }
}
