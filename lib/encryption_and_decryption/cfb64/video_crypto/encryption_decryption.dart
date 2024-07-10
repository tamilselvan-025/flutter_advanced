import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart' as cupertino;

final iv = encrypt.IV.fromLength(16);

Future<File?> encryptFile(File file, String key) async {
  final bytes = await file.readAsBytes();
  final keyBytes = encrypt.Key.fromUtf8(key.padRight(32));
 // final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));

  final encryptedBytes = encrypter.encryptBytes(bytes, iv: iv).bytes;

  final dir = await getApplicationDocumentsDirectory();
  final encryptedFile = File('${dir.path}/videos/video1.enc');
  encryptedFile.createSync(recursive: true);
  encryptedFile.writeAsBytesSync(encryptedBytes);

  return encryptedFile;
}

Future<File?> decryptFile(File file, String key) async {
  try{
    final bytes = await file.readAsBytes();
    final keyBytes = encrypt.Key.fromUtf8(key.padRight(32));

    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));

    final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(Uint8List.fromList(bytes)), iv: iv);//exception
    // from this line

    final dir = await getApplicationDocumentsDirectory();
    final decryptedFile = File('${dir.path}/videos/video2.dec.mp4');
    decryptedFile.createSync(recursive: true);
    await decryptedFile.writeAsBytes(decryptedBytes);
    return decryptedFile;
  }
  catch(error,stackTrace){
    cupertino.debugPrint("-------------------------------------");
    cupertino.debugPrint("Error in decryptFile() : $error");
    cupertino.debugPrint("-------------------------------------");
    cupertino.debugPrint("StackTrace in decryptFile() : $stackTrace");
  }
  return null;
}