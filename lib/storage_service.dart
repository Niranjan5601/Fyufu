import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filepath, String filename) async {
    File file = File(filepath);

    try {
      await storage.ref('test/$filename').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  // Future<String> downloadUrl(String imageName) async {
  //   String downloadURL = await storage.ref('test/$imageName').getDownloadURL();

  //   return downloadURL;
  // }

  Future<List> loadImages() async {
    List<String> files = [];

    final result = await storage.ref('MainPage/Ramesh/jfkgh').list();
    final List<firebase_storage.Reference> allFiles = result.items;

    await Future.forEach<firebase_storage.Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      files.add(fileUrl);
    });

    return files;
  }
}
