import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/main_streak.dart';
import '../models/relapse_event.dart';
import '../models/urge_log.dart';
import '../core/constants/firestore_paths.dart';
import '../core/utils/logger.dart';

class StreakRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  StreakRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<MainStreak?> watchStreak(String uid) {
    return _firestore
        .doc(FirestorePaths.mainStreakDoc(uid))
        .snapshots()
        .map((doc) => doc.exists ? MainStreak.fromFirestore(doc) : null);
  }

  Future<MainStreak?> getStreak(String uid) async {
    final doc = await _firestore.doc(FirestorePaths.mainStreakDoc(uid)).get();
    return doc.exists ? MainStreak.fromFirestore(doc) : null;
  }

  Future<void> startStreak(String uid) async {
    final streak = MainStreak.fresh();
    await _firestore
        .doc(FirestorePaths.mainStreakDoc(uid))
        .set(streak.toFirestore());
    AppLogger.info('Streak started for $uid');
  }

  Future<void> logRelapse(String uid, RelapseEvent relapse) async {
    final batch = _firestore.batch();

    // Save relapse event
    final relapseRef = _firestore
        .collection(FirestorePaths.relapses(uid))
        .doc(relapse.id);
    batch.set(relapseRef, relapse.toFirestore());

    // Reset streak
    final streakRef = _firestore.doc(FirestorePaths.mainStreakDoc(uid));
    final newStreak = MainStreak.fresh();
    batch.set(streakRef, newStreak.toFirestore());

    await batch.commit();
    AppLogger.info('Relapse logged for $uid, streak reset');
  }

  Stream<List<RelapseEvent>> watchRelapses(String uid) {
    return _firestore
        .collection(FirestorePaths.relapses(uid))
        .orderBy('occurredAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => RelapseEvent.fromFirestore(d)).toList());
  }

  Future<List<RelapseEvent>> getRelapses(
      String uid, {
      DateTime? from,
      DateTime? to,
    }) async {
    Query query = _firestore
        .collection(FirestorePaths.relapses(uid))
        .orderBy('occurredAt', descending: true);
    if (from != null) {
      query = query.where('occurredAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    }
    if (to != null) {
      query = query.where('occurredAt', isLessThanOrEqualTo: Timestamp.fromDate(to));
    }
    final snap = await query.get();
    return snap.docs.map((d) => RelapseEvent.fromFirestore(d)).toList();
  }

  Future<void> logUrge(String uid, UrgeLog urgeLog) async {
    await _firestore
        .collection(FirestorePaths.urgeLogs(uid))
        .doc(urgeLog.id)
        .set(urgeLog.toFirestore());
    AppLogger.info('Urge logged for $uid: intensity ${urgeLog.intensity}');
  }

  Stream<List<UrgeLog>> watchUrgeLogs(String uid, {int limitDays = 30}) {
    final from = DateTime.now().subtract(Duration(days: limitDays));
    return _firestore
        .collection(FirestorePaths.urgeLogs(uid))
        .where('loggedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('loggedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => UrgeLog.fromFirestore(d)).toList());
  }

  Future<List<UrgeLog>> getUrgeLogs(String uid, {int limitDays = 30}) async {
    final from = DateTime.now().subtract(Duration(days: limitDays));
    final snap = await _firestore
        .collection(FirestorePaths.urgeLogs(uid))
        .where('loggedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('loggedAt', descending: true)
        .get();
    return snap.docs.map((d) => UrgeLog.fromFirestore(d)).toList();
  }

  String generateId() => _uuid.v4();
}
