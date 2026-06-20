import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/challenge_repository.dart';
import '../models/challenge.dart';
import 'user_provider.dart';

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository();
});

final builtInChallengesProvider = FutureProvider<List<Challenge>>((ref) {
  return ref.watch(challengeRepositoryProvider).getBuiltInChallenges();
});

final activeChallengesProvider =
    StreamProvider<List<ChallengeProgress>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(challengeRepositoryProvider).watchActiveChallenges(uid);
});

final allChallengesProvider =
    StreamProvider<List<ChallengeProgress>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(challengeRepositoryProvider).watchAllChallenges(uid);
});

class ChallengeNotifier extends StateNotifier<AsyncValue<void>> {
  final ChallengeRepository _repo;
  final String uid;

  ChallengeNotifier(this._repo, this.uid) : super(const AsyncValue.data(null));

  Future<void> joinChallenge(Challenge challenge) async {
    state = const AsyncValue.loading();
    try {
      await _repo.joinChallenge(uid, challenge);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProgress(String progressId, int newValue,
      {bool? isCompleted}) async {
    await _repo.updateProgress(uid, progressId, newValue,
        isCompleted: isCompleted);
  }

  Future<void> abandonChallenge(String progressId) async {
    await _repo.abandonChallenge(uid, progressId);
  }
}

final challengeNotifierProvider =
    StateNotifierProvider<ChallengeNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return ChallengeNotifier(ref.watch(challengeRepositoryProvider), uid);
});
