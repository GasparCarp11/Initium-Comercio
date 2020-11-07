import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';

class FirebaseStorageAPI {
  final StorageReference _storageReference = FirebaseStorage.instance.ref();

  Future<StorageUploadTask> uploadPhoto(String path, File image) async {
    StorageUploadTask storageUploadTask =
        _storageReference.child(path).putFile(image);
    return storageUploadTask;
  }
}
