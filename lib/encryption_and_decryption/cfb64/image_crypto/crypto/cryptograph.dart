import 'dart:typed_data';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_advanced/encryption_and_decryption/directory_manager.dart';
class CryptoGraph{
  static const String _key = "openwavecomputingservicespvtltd!";
  static const String _padding = "PKCS7";
  final IV initializationVector = IV.fromLength(16);
  final Key key = Key.fromUtf8(_key);

  Future<Uint8List?> encode(File file,int fileNo)async{
    try {
      final Uint8List data = file.readAsBytesSync();
      final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: _padding));
      String path = await _getPath(DirectoryType.images);
      myPrint("PATH : $path");
      File encryptedFile = File('$path/image$fileNo');
      Encrypted encrypted = encryptor.encryptBytes(
        data,
        iv: initializationVector,
      );
      var encryptedData=encrypted.base64;
      encryptedFile.createSync(recursive: true);
      //encryptedFile.writeAsBytesSync(encryptedData);
      myPrint("DATA : $data");
      myPrint("ENCRYPTED DATA : $encryptedData");
      return data;
    }
    catch (error, stackTrace) {
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("Error in encode() : $error");
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("StackTrace in encode() : $stackTrace");
    }
    return null;
  }
  Future<String> _getPath(DirectoryType directoryManagerType) async {
    String path = '';
    switch (directoryManagerType) {
      case DirectoryType.images:
        {
          path = await DirectoryManager.getImagePath();
        }
      case DirectoryType.videos:
        {
          path = await DirectoryManager.getVideoPath();
        }
      case DirectoryType.documents:
        {
          path = await DirectoryManager.getDocsPath();
        }
    }
    return path;
  }
}