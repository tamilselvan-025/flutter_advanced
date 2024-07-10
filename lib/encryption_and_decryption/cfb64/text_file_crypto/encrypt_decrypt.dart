import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:path_provider/path_provider.dart';

// Generate a random 256-bit key and 128-bit IV (Initialization Vector)
String generateRandomString(int length) {
  final random = encrypt.SecureRandom(length);
  return base64Url.encode(random.bytes);
}

// Encrypts text using AES with CFB-64 mode
Future<String> encryptText(String plainText, String keyBase64, String ivBase64) async {
  final aesKey = encrypt.Key.fromBase64(keyBase64);
  final aesIV = encrypt.IV.fromBase64(ivBase64);
  final encrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cfb64));

  final encrypted = encrypter.encrypt(plainText, iv: aesIV);
  myPrint("Encrypted.base64 : ${encrypted.base64}");
  return encrypted.base64;
}

// Decrypts text using AES with CFB-64 mode
Future<String> decryptText(String encryptedBase64, String keyBase64, String ivBase64) async {
  final aesKey = encrypt.Key.fromBase64(keyBase64);
  final aesIV = encrypt.IV.fromBase64(ivBase64);
  final encrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cfb64));

  final decrypted = encrypter.decrypt64(encryptedBase64, iv: aesIV);
  myPrint("decrypted : $decrypted");
  return decrypted;
}

// Read text from a file
Future<String> readFile(String path) async {
  try {
    final file = File(path);
    String readedFile= await file.readAsString();
    myPrint("readedFile : $readedFile");
    return readedFile;
  } catch (e) {
    debugPrint("ERROR in readFile() : $e");
    return e.toString();
  }
}

// Write text to a file
Future<void> writeFile(String path, String content) async {
  final file = File(path);
  await file.writeAsString(content);
}

Future<void> encryptFile(String inputPath, String keyBase64, String ivBase64) async {
  final plainText = await readFile(inputPath);

  final encryptedText = await encryptText(plainText, keyBase64, ivBase64);
  Directory directory = await getApplicationDocumentsDirectory();
  String path = '${directory.path}/encrypt.txt';
  myPrint("path :$path");
  await writeFile(path, encryptedText);
  myPrint("Encrypt file completed");
}

Future<String> decryptFile(String inputPath, String keyBase64, String ivBase64) async {
  debugPrint("inputPath : $inputPath");
  final encryptedText = await readFile(inputPath);
  final decryptedText = await decryptText(encryptedText, keyBase64, ivBase64);
  return decryptedText;
}
