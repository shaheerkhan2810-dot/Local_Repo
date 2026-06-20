import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../core/constants/firestore_paths.dart';

class JournalRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  JournalRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<JournalEntry>> watchEntries(String uid) {
    return _firestore
        .collection(FirestorePaths.journalEntries(uid))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => JournalEntry.fromFirestore(d)).toList());
  }

  Future<List<JournalEntry>> getEntries(
    String uid, {
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    Query query = _firestore
        .collection(FirestorePaths.journalEntries(uid))
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
    return snap.docs.map((d) => JournalEntry.fromFirestore(d)).toList();
  }

  Future<JournalEntry?> getEntry(String uid, String entryId) async {
    final doc = await _firestore
        .doc(FirestorePaths.journalEntry(uid, entryId))
        .get();
    return doc.exists ? JournalEntry.fromFirestore(doc) : null;
  }

  Future<String> createEntry(String uid, JournalEntry entry) async {
    final id = _uuid.v4();
    final withId = JournalEntry(
      id: id,
      date: entry.date,
      title: entry.title,
      richContent: entry.richContent,
      mood: entry.mood,
      mediaUrls: entry.mediaUrls,
      voiceNoteUrl: entry.voiceNoteUrl,
      tags: entry.tags,
      streakDayAtEntry: entry.streakDayAtEntry,
      xpAwarded: entry.xpAwarded,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _firestore
        .doc(FirestorePaths.journalEntry(uid, id))
        .set(withId.toFirestore());
    return id;
  }

  Future<void> updateEntry(String uid, JournalEntry entry) async {
    await _firestore
        .doc(FirestorePaths.journalEntry(uid, entry.id))
        .update(entry.toFirestore());
  }

  Future<void> deleteEntry(String uid, String entryId) async {
    await _firestore
        .doc(FirestorePaths.journalEntry(uid, entryId))
        .delete();
  }

  Future<bool> hasEntryForToday(String uid) async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59);
    final snap = await _firestore
        .collection(FirestorePaths.journalEntries(uid))
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  String generateId() => _uuid.v4();
}
