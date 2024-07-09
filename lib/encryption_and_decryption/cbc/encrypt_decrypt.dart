import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_advanced/encryption_and_decryption/directory_manager.dart';

class CryptoCBC {
  CryptoCBC._private();

  factory CryptoCBC() {
    return CryptoCBC._private();
  }

  static const String _key = "openwavecomputingservicespvtltd!";
  static const String _padding = "PKCS7";
  final IV initializationVector = IV.fromLength(16);
  final Key key = Key.fromUtf8(_key);

  Future<String?> encode(DirectoryType DirectoryType, {required String filePath, required String newFileName}) async {
    try {
      File file = File(filePath);
      final Uint8List data = file.readAsBytesSync();
      final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: _padding));
      String path = await _getPath(DirectoryType);
      myPrint("PATH : $path");
      File encryptedFile = File('$path/$newFileName');
      Encrypted encrypted = encryptor.encryptBytes(
        data,
        iv: initializationVector,
      );
      String encryptedData = encrypted.base64;
      encryptedFile.createSync(recursive: true);
      encryptedFile.writeAsStringSync(encryptedData);
      return encryptedData;
    } catch (error, stackTrace) {
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("Error in encode() : $error");
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("StackTrace in encode() : $stackTrace");
    }
    return Future.value(null);
  }

  Future<dynamic>? decrypt(String path) {
    try {
      File file = File(path);
      DirectoryType? directoryType = _getDirectoryType(path);
      if (DirectoryType == null) {
        return null;
      }
      return _decryptData(file, directoryType!);
    } catch (error, stackTrace) {
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("Error in encode() : $error");
      cupertino.debugPrint("-------------------------------------");
      cupertino.debugPrint("StackTrace in encode() : $stackTrace");
    }
    return null;
  }

  DirectoryType? _getDirectoryType(String path) {
    if (path.contains('images')) {
      return DirectoryType.images;
    } else if (path.contains('videos')) {
      return DirectoryType.videos;
    } else if (path.contains('docs')) {
      return DirectoryType.documents;
    }
    return null;
  }

  _decryptData(File file, DirectoryType directoryType) {
    switch (directoryType) {
      case DirectoryType.images:
        {
          return _imageDecoder(file);
        }
      case DirectoryType.videos:
        {
          return _videoDecoder(file);
        }
      case DirectoryType.documents:
        {
          return _documentDecoder(file);
        }
    }
  }

  _imageDecoder(File file) async {
    final encryptor = Encrypter(AES(key, mode: AESMode.cbc, padding: _padding));
    String thumbnail="vRBEbSq8VoONdWUsH8aQeYvc8YUpXPKTHFLEWYCqLTcZxv/f6TZ2+43pUbtsQhU1EQpsQ6El3yYRDYp27cNUbEVEw23dIHjjDbJpUpqksbMUL4Vh9mlecibMz1VSRO0dHfuJSQNwrB0ZlyDprWDk8ZiC7kmvdz6mUdWzwh0Qy4jGFCUMArkF5GjJKuyyTNPypVx+0dMVftdFRQE9V/dP7bDaUBY8ZpnPP2KJPrVacWGz5MMX/nOkgbkethdeaNQt1/EK5gRfket99SonUk7law74b7ItOwycWqqD0m66blOaHt3c2jQ2Mw99E5glQsOdbSHFfHC9IB/9uWxRMxhMBRs24qlIHkhulTsy+niaPb/T4uho/D8joqKEqp3T327/YucU8Jh7bksNu49WryV8dFE7sdddjJprxtdmINq/qnzhtleAkqcSsog9eJvIGcIlcjvCIowBAch1QePaox82KIw2YufaxAaqgoufim7cidht3VlufEfz3q/CeDc0AL/CUK7Obx2Fpl6YXJNIrP3HxmZ7M9aBenk28OkkBsyfofnYvvRc2jc4xpuA3ZUY4hjvDyizRnia3OUqvWjxaA3d6kzgvy8qGqhWSbSRL4y7p9CPDe51pdcEITxxz+GZQ4Bw3BEalarItMWrx1yFM4/6Kc3tAWgbqBb1lS5I5QxDRwbE37E59iaohBk3nktUD3kGzFD1yUzHTx5wefeqN+oMC61xLCoBYgjEbzNIC0jFi4IK5ypZqrR9PBDHBzldZYtOtLEk1pPUiflPRKeK5u+qCWLjJdTo3nhCtACHJXaLDzsFwi+DPi+A6XFo8EJg9dtfR1ETu51Qu08lZDUpQ/7Ap1tAvGrOmDYvgZOu9+80wtds3Dwpqmw9H3rflnxCJk8cjmgZ5Z9UAFwf+BTViKaitboFxWJ/X2Dlxd9SpD4BuWnPGpCAmYZvCPUqwETYFp0wYEVls+mXU9AmZvSXB5gk9n64PNIP6dFd5OkMus";
   myPrint('${thumbnail.length}');
    // if (thumbnail.length % 4 > 0) {
    //   thumbnail += '=' * (4 - thumbnail .length % 4) ;// as suggested by Albert221
    // }
    String encryptedString=file.readAsStringSync();
    myPrint("encryptedString.length : ${encryptedString.length}");
   // myPrint("encryptedString : $encryptedString");
    final  encryptedBase64Data = encryptor.decryptBytes(Encrypted.fromBase64(encryptedString), iv: initializationVector);
    myPrint("encryptedData : $encryptedBase64Data");
    myPrint("encryptedData.length : ${encryptedBase64Data.length}");
    // Uint8List imageData = base64Decode(encryptedString);
    // myPrint("imageData.length : ${imageData.length}");
    // myPrint("imageData : $imageData");
    // final decrypt=encryptor.decrypt(Encrypted(_bytes),iv: initializationVector);
    // myPrint("decrypted $decrypt");
    // Uint8List imageBytes = base64Decode(decrypt);
    // myPrint("imageBytes : $imageBytes");
    Uint8List list=Uint8List.fromList(encryptedBase64Data);
    myPrint("list.length : ${list.length}");
    return list;
  }

  _videoDecoder(File file) {}

  _documentDecoder(File file) {}

  Future<String> _getPath(DirectoryType directoryType) async {
    String path = '';
    switch (directoryType) {
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
