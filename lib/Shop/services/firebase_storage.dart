import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI {
  final StorageReference _storageReference = FirebaseStorage.instance.ref();

  Future<StorageUploadTask> uploadPhoto(String path, File image) async {
    StorageUploadTask storageUploadTask =
        _storageReference.child(path).putFile(image);
    return storageUploadTask;
  }
}
