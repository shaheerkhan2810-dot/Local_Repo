import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/routine_repository.dart';
import '../models/routine_block.dart';
import 'user_provider.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository();
});

final morningRoutineProvider = StreamProvider<List<RoutineBlock>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(routineRepositoryProvider).watchRoutine(uid, 'morning');
});

final nightRoutineProvider = StreamProvider<List<RoutineBlock>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(routineRepositoryProvider).watchRoutine(uid, 'night');
});

class RoutineNotifier extends StateNotifier<AsyncValue<void>> {
  final RoutineRepository _repo;
  final String uid;

  RoutineNotifier(this._repo, this.uid) : super(const AsyncValue.data(null));

  Future<void> addBlock(RoutineBlock block) async {
    await _repo.addBlock(uid, block);
  }

  Future<void> updateBlock(RoutineBlock block) async {
    await _repo.updateBlock(uid, block);
  }

  Future<void> removeBlock(String blockId) async {
    await _repo.removeBlock(uid, blockId);
  }

  Future<void> reorderBlocks(List<RoutineBlock> blocks) async {
    await _repo.reorderBlocks(uid, blocks);
  }
}

final routineNotifierProvider =
    StateNotifierProvider<RoutineNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return RoutineNotifier(ref.watch(routineRepositoryProvider), uid);
});
