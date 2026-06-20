import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../repositories/tracker_repository.dart';
import '../models/custom_tracker.dart';
import '../models/tracker_entry.dart';
import 'user_provider.dart';

final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return TrackerRepository();
});

final trackerListProvider = StreamProvider<List<CustomTracker>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(trackerRepositoryProvider).watchTrackers(uid);
});

final trackerDetailProvider =
    StreamProvider.family<CustomTracker?, String>((ref, trackerId) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(trackerRepositoryProvider).watchTracker(uid, trackerId);
});

final trackerEntriesProvider =
    StreamProvider.family<List<TrackerEntry>, String>((ref, trackerId) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  final from = DateTime.now().subtract(const Duration(days: 30));
  return ref
      .watch(trackerRepositoryProvider)
      .watchEntries(uid, trackerId, from: from);
});

class TrackerNotifier extends StateNotifier<AsyncValue<void>> {
  final TrackerRepository _repo;
  final String uid;

  TrackerNotifier(this._repo, this.uid) : super(const AsyncValue.data(null));

  Future<String?> createTracker(CustomTracker tracker) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.createTracker(uid, tracker);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateTracker(CustomTracker tracker) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateTracker(uid, tracker);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> archiveTracker(String trackerId) async {
    await _repo.archiveTracker(uid, trackerId);
  }
}

final trackerNotifierProvider =
    StateNotifierProvider<TrackerNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return TrackerNotifier(ref.watch(trackerRepositoryProvider), uid);
});

class TrackerEntryNotifier extends StateNotifier<AsyncValue<void>> {
  final TrackerRepository _repo;
  final String uid;
  final _uuid = const Uuid();

  TrackerEntryNotifier(this._repo, this.uid)
      : super(const AsyncValue.data(null));

  Future<String?> logEntry(String trackerId, TrackerEntry entry) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.logEntry(uid, trackerId, entry);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateEntry(String trackerId, TrackerEntry entry) async {
    await _repo.updateEntry(uid, trackerId, entry);
  }

  Future<void> deleteEntry(String trackerId, String entryId) async {
    await _repo.deleteEntry(uid, trackerId, entryId);
  }
}

final trackerEntryNotifierProvider =
    StateNotifierProvider<TrackerEntryNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return TrackerEntryNotifier(ref.watch(trackerRepositoryProvider), uid);
});
