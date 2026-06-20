import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_tracker.dart';
import '../models/tracker_entry.dart';
import '../core/constants/firestore_paths.dart';
import '../core/utils/logger.dart';

class TrackerRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  TrackerRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<CustomTracker>> watchTrackers(String uid) {
    return _firestore
        .collection(FirestorePaths.trackers(uid))
        .where('isArchived', isEqualTo: false)
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => CustomTracker.fromFirestore(d)).toList());
  }

  Future<List<CustomTracker>> getTrackers(String uid) async {
    final snap = await _firestore
        .collection(FirestorePaths.trackers(uid))
        .where('isArchived', isEqualTo: false)
        .orderBy('sortOrder')
        .get();
    return snap.docs.map((d) => CustomTracker.fromFirestore(d)).toList();
  }

  Stream<CustomTracker?> watchTracker(String uid, String trackerId) {
    return _firestore
        .doc(FirestorePaths.tracker(uid, trackerId))
        .snapshots()
        .map((doc) => doc.exists ? CustomTracker.fromFirestore(doc) : null);
  }

  Future<String> createTracker(String uid, CustomTracker tracker) async {
    final id = _uuid.v4();
    final trackerWithId = CustomTracker(
      id: id,
      name: tracker.name,
      emoji: tracker.emoji,
      colorHex: tracker.colorHex,
      description: tracker.description,
      fieldSchema: tracker.fieldSchema,
      trackingFrequency: tracker.trackingFrequency,
      goal: tracker.goal,
      xpPerEntry: tracker.xpPerEntry,
      domain: tracker.domain,
      createdAt: DateTime.now(),
      sortOrder: tracker.sortOrder,
    );
    await _firestore
        .doc(FirestorePaths.tracker(uid, id))
        .set(trackerWithId.toFirestore());
    AppLogger.info('Tracker created: ${tracker.name}');
    return id;
  }

  Future<void> updateTracker(String uid, CustomTracker tracker) async {
    await _firestore
        .doc(FirestorePaths.tracker(uid, tracker.id))
        .update(tracker.toFirestore());
  }

  Future<void> archiveTracker(String uid, String trackerId) async {
    await _firestore
        .doc(FirestorePaths.tracker(uid, trackerId))
        .update({'isArchived': true});
  }

  Future<void> deleteTracker(String uid, String trackerId) async {
    await _firestore.doc(FirestorePaths.tracker(uid, trackerId)).delete();
  }

  // Entries
  Stream<List<TrackerEntry>> watchEntries(
    String uid,
    String trackerId, {
    DateTime? from,
    DateTime? to,
  }) {
    Query query = _firestore
        .collection(FirestorePaths.trackerEntries(uid, trackerId))
        .orderBy('date', descending: true);
    if (from != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    }
    if (to != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
    }
    return query.snapshots().map(
        (snap) => snap.docs.map((d) => TrackerEntry.fromFirestore(d)).toList());
  }

  Future<List<TrackerEntry>> getEntries(
    String uid,
    String trackerId, {
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    Query query = _firestore
        .collection(FirestorePaths.trackerEntries(uid, trackerId))
        .orderBy('date', descending: true);
    if (from != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    }
    if (to != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
    }
    if (limit != null) query = query.limit(limit);
    final snap = await query.get();
    return snap.docs.map((d) => TrackerEntry.fromFirestore(d)).toList();
  }

  Future<TrackerEntry?> getEntryForDate(
    String uid,
    String trackerId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final snap = await _firestore
        .collection(FirestorePaths.trackerEntries(uid, trackerId))
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return TrackerEntry.fromFirestore(snap.docs.first);
  }

  Future<String> logEntry(String uid, String trackerId, TrackerEntry entry) async {
    final id = _uuid.v4();
    await _firestore
        .doc(FirestorePaths.trackerEntry(uid, trackerId, id))
        .set(entry.toFirestore());
    AppLogger.info('Tracker entry logged for $trackerId');
    return id;
  }

  Future<void> updateEntry(
    String uid,
    String trackerId,
    TrackerEntry entry,
  ) async {
    await _firestore
        .doc(FirestorePaths.trackerEntry(uid, trackerId, entry.id))
        .update(entry.toFirestore());
  }

  Future<void> deleteEntry(
    String uid,
    String trackerId,
    String entryId,
  ) async {
    await _firestore
        .doc(FirestorePaths.trackerEntry(uid, trackerId, entryId))
        .delete();
  }

  String generateId() => _uuid.v4();
}
