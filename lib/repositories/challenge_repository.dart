import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/challenge.dart';
import '../core/constants/firestore_paths.dart';
import '../core/constants/app_constants.dart';

class ChallengeRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  ChallengeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Challenge>> getBuiltInChallenges() async {
    return AppConstants.builtInChallenges
        .map((data) => Challenge.fromMap(data))
        .toList();
  }

  Stream<List<ChallengeProgress>> watchActiveChallenges(String uid) {
    return _firestore
        .collection(FirestorePaths.challenges(uid))
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ChallengeProgress.fromFirestore(d)).toList());
  }

  Stream<List<ChallengeProgress>> watchAllChallenges(String uid) {
    return _firestore
        .collection(FirestorePaths.challenges(uid))
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ChallengeProgress.fromFirestore(d)).toList());
  }

  Future<String> joinChallenge(String uid, Challenge challenge) async {
    final id = _uuid.v4();
    final progress = ChallengeProgress(
      id: id,
      challengeId: challenge.id,
      startedAt: DateTime.now(),
      currentValue: 0,
      isCompleted: false,
    );
    await _firestore
        .doc(FirestorePaths.challenge(uid, id))
        .set(progress.toFirestore());
    return id;
  }

  Future<void> updateProgress(
    String uid,
    String progressId,
    int newValue, {
    bool? isCompleted,
  }) async {
    final updates = <String, dynamic>{'currentValue': newValue};
    if (isCompleted == true) {
      updates['isCompleted'] = true;
      updates['completedAt'] = Timestamp.fromDate(DateTime.now());
    }
    await _firestore
        .doc(FirestorePaths.challenge(uid, progressId))
        .update(updates);
  }

  Future<void> abandonChallenge(String uid, String progressId) async {
    await _firestore.doc(FirestorePaths.challenge(uid, progressId)).delete();
  }
}
