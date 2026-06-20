import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import '../models/user_profile.dart';
import 'auth_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);
  final uid = authState.value?.uid;
  if (uid == null) return const Stream.empty();
  return ref.watch(userRepositoryProvider).watchProfile(uid);
});

final currentUidProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.uid;
});

class UserNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserRepository _repo;
  final String uid;

  UserNotifier(this._repo, this.uid) : super(const AsyncValue.loading());

  Future<void> completeOnboarding() async {
    await _repo.completeOnboarding(uid);
  }

  Future<void> awardXP(String domain, int amount) async {
    await _repo.awardXP(uid, domain, amount);
  }

  Future<void> updateDisplayName(String name) async {
    await _repo.updateProfile(uid, {'displayName': name});
  }

  Future<void> updateAvatar(String url) async {
    await _repo.updateProfile(uid, {'avatarUrl': url});
  }

  Future<void> updateLongestStreak(int days) async {
    await _repo.updateLongestStreak(uid, days);
  }
}

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserProfile?>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return UserNotifier(ref.watch(userRepositoryProvider), uid);
});
