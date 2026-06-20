import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/routine_block.dart';
import '../core/constants/firestore_paths.dart';

class RoutineRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  RoutineRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<RoutineBlock>> watchRoutine(String uid, String routineType) {
    return _firestore
        .collection(FirestorePaths.routineBlocks(uid))
        .where('routineType', isEqualTo: routineType)
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => RoutineBlock.fromFirestore(d)).toList());
  }

  Future<String> addBlock(String uid, RoutineBlock block) async {
    final id = _uuid.v4();
    final withId = RoutineBlock(
      id: id,
      routineType: block.routineType,
      title: block.title,
      description: block.description,
      durationMinutes: block.durationMinutes,
      iconEmoji: block.iconEmoji,
      sortOrder: block.sortOrder,
    );
    await _firestore
        .doc(FirestorePaths.routineBlock(uid, id))
        .set(withId.toFirestore());
    return id;
  }

  Future<void> updateBlock(String uid, RoutineBlock block) async {
    await _firestore
        .doc(FirestorePaths.routineBlock(uid, block.id))
        .update(block.toFirestore());
  }

  Future<void> removeBlock(String uid, String blockId) async {
    await _firestore
        .doc(FirestorePaths.routineBlock(uid, blockId))
        .update({'isActive': false});
  }

  Future<void> reorderBlocks(String uid, List<RoutineBlock> blocks) async {
    final batch = _firestore.batch();
    for (int i = 0; i < blocks.length; i++) {
      batch.update(
        _firestore.doc(FirestorePaths.routineBlock(uid, blocks[i].id)),
        {'sortOrder': i},
      );
    }
    await batch.commit();
  }
}
