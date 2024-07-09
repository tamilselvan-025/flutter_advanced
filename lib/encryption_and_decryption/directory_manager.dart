import 'dart:io';

import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:path_provider/path_provider.dart';

enum DirectoryType { images, videos, documents }

class DirectoryManager {
  Future<void> createFolderInAppDocDir(String folderName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String newFolderPath = '${appDocDir.path}/$folderName';
    Directory newDirectory = Directory(newFolderPath);
    if (await newDirectory.exists()) {
      myPrint('Folder already exists');
    } else {
      await newDirectory.create();
      myPrint('Folder created: $newFolderPath');
    }
  }

 static Future<String> getImagePath() async {
    String imageFolderPath = '${await getApplicationDocumentsDirectory()}/images';
    // Directory newDirectory = Directory(imageFolderPath);
    // if (await newDirectory.exists()) {
    //   myPrint('Folder already exists');
    // } else {
    //   await newDirectory.create();
    //   myPrint('Folder created: $imageFolderPath');
    // }
    return Future.value(imageFolderPath.substring(12));

  }

 static Future<String> getVideoPath() async {
    String videoFolderPath = '${await getApplicationDocumentsDirectory()}/videos';
    Directory newDirectory = Directory(videoFolderPath);
    if (await newDirectory.exists()) {
      myPrint('Folder already exists');
    } else {
      await newDirectory.create();
      myPrint('Folder created: $videoFolderPath');
    }
    return Future.value(videoFolderPath);
  }

 static Future<String> getDocsPath() async {
    String docsFolderPath = '${await getApplicationDocumentsDirectory()}/docs';
    Directory newDirectory = Directory(docsFolderPath);
    if (await newDirectory.exists()) {
      myPrint('Folder already exists');
    } else {
      await newDirectory.create();
      myPrint('Folder created: $docsFolderPath');
    }
    return Future.value(docsFolderPath);
  }
}
