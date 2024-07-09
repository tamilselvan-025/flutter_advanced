import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_advanced/encryption_and_decryption/directory_manager.dart';

class CryptoGraph {
  static const String _key = "+GAO/eSAJ+c/KjukxYAuaA=="; // 24 bytes
  static const String _padding = "PKCS7";
  final Key key = Key.fromUtf8(_key);

  Future<String?> encode(File file, int fileNo) async {
    try {
      List<int> imageData = file.readAsBytesSync();
      final String data = base64Encode(imageData);
      final IV initializationVector = IV.fromSecureRandom(16); // Random IV
      final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: _padding));
      String path = await _getPath(DirectoryType.images);
      myPrint("PATH : $path");
      File encryptedFile = File('$path/image$fileNo');
      Encrypted encrypted = encryptor.encrypt(
        data,
        iv: initializationVector,
      );
      var encryptedData = initializationVector.base64 + encrypted.base64; // Store IV + encrypted data
      encryptedFile.createSync(recursive: true);
      encryptedFile.writeAsStringSync(encryptedData);
      myPrint("DATA : $data");
      myPrint("ENCRYPTED DATA : $encryptedData");
      return encryptedData;
    } catch (error, stackTrace) {
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("Error in encode() : $error");
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("StackTrace in encode() : $stackTrace");
    }
    return null;
  }

  String? decode(String filePath) {
    try {
      File file = File(filePath);
      String encodedFileData = file.readAsStringSync();
      myPrint("encodedFileData : $encodedFileData");
      final IV initializationVector = IV.fromBase64(encodedFileData.substring(0, 24)); // Extract IV
      final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: _padding));
      String encryptedString = encryptor.decrypt64(encodedFileData.substring(24), iv: initializationVector); // Decrypt with IV
      myPrint("encryptedString : $encryptedString");
      return encryptedString;
    } catch (error, stackTrace) {
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("Error in decode() : $error");
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("StackTrace in decode() : $stackTrace");
    }
    return null;
  }

  Future<String> _getPath(DirectoryType directoryManagerType) async {
    switch (directoryManagerType) {
      case DirectoryType.images:
        return await DirectoryManager.getImagePath();
      case DirectoryType.videos:
        return await DirectoryManager.getVideoPath();
      case DirectoryType.documents:
        return await DirectoryManager.getDocsPath();
    }
  }
}