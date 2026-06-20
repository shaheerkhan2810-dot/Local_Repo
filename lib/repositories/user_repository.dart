import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../core/constants/firestore_paths.dart';
import '../core/utils/logger.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<UserProfile?> watchProfile(String uid) {
    return _firestore
        .doc(FirestorePaths.user(uid))
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.doc(FirestorePaths.user(uid)).get();
    return doc.exists ? UserProfile.fromFirestore(doc) : null;
  }

  Future<void> createProfile(UserProfile profile) async {
    await _firestore
        .doc(FirestorePaths.user(profile.uid))
        .set(profile.toFirestore());
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    await _firestore.doc(FirestorePaths.user(uid)).update(updates);
  }

  Future<void> awardXP(String uid, String domain, int amount) async {
    await _firestore.runTransaction((tx) async {
      final ref = _firestore.doc(FirestorePaths.user(uid));
      final snapshot = await tx.get(ref);
      if (!snapshot.exists) return;

      final profile = UserProfile.fromFirestore(snapshot);
      final newDomains = Map<String, int>.from(profile.domains);
      newDomains[domain] = (newDomains[domain] ?? 0) + amount;
      final newTotal = profile.totalXP + amount;

      tx.update(ref, {
        'totalXP': newTotal,
        'domains': newDomains,
        'level': _computeLevel(newTotal),
      });
    });
  }

  int _computeLevel(int xp) {
    const thresholds = [
      0, 100, 250, 500, 900, 1500, 2500, 4000, 6000, 9000,
      13000, 18000, 25000, 34000, 45000, 60000, 78000, 100000,
    ];
    int level = 0;
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (xp >= thresholds[i]) {
        level = i;
        break;
      }
    }
    return level;
  }

  Future<void> completeOnboarding(String uid) async {
    await _firestore.doc(FirestorePaths.user(uid)).update({
      'onboardingComplete': true,
    });
  }

  Future<void> updateLongestStreak(String uid, int days) async {
    await _firestore.doc(FirestorePaths.user(uid)).update({
      'longestStreak': days,
    });
    AppLogger.info('Updated longest streak for $uid: $days');
  }

  Future<void> deleteUserData(String uid) async {
    await _firestore.doc(FirestorePaths.user(uid)).delete();
  }
}
