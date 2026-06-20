import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/journal_repository.dart';
import '../models/journal_entry.dart';
import 'user_provider.dart';
import 'streak_provider.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

final journalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(journalRepositoryProvider).watchEntries(uid);
});

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  final JournalRepository _repo;
  final String uid;
  final Ref _ref;

  JournalNotifier(this._repo, this.uid, this._ref)
      : super(const AsyncValue.data(null));

  Future<String?> createEntry(JournalEntry entry) async {
    state = const AsyncValue.loading();
    try {
      final streakDays = _ref.read(currentStreakDaysProvider);
      final withStreak = JournalEntry(
        id: entry.id,
        date: entry.date,
        title: entry.title,
        richContent: entry.richContent,
        mood: entry.mood,
        mediaUrls: entry.mediaUrls,
        voiceNoteUrl: entry.voiceNoteUrl,
        tags: entry.tags,
        streakDayAtEntry: streakDays,
        xpAwarded: 8,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await _repo.createEntry(uid, withStreak);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _repo.updateEntry(uid, entry);
  }

  Future<void> deleteEntry(String entryId) async {
    await _repo.deleteEntry(uid, entryId);
  }
}

final journalNotifierProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return JournalNotifier(ref.watch(journalRepositoryProvider), uid, ref);
});
