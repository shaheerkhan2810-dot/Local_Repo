import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadFile({
    required String uid,
    required File file,
    required String folder,
    void Function(double)? onProgress,
  }) async {
    final ext = path.extension(file.path);
    final fileName = '${_uuid.v4()}$ext';
    final ref = _storage.ref('users/$uid/$folder/$fileName');

    final task = ref.putFile(file);

    if (onProgress != null) {
      task.snapshotEvents.listen((snapshot) {
        if (snapshot.totalBytes > 0) {
          onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
        }
      });
    }

    await task;
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // File may not exist — ignore
    }
  }

  Future<List<String>> listFiles(String uid, String folder) async {
    final ref = _storage.ref('users/$uid/$folder');
    final result = await ref.listAll();
    return Future.wait(result.items.map((item) => item.getDownloadURL()));
  }
}
