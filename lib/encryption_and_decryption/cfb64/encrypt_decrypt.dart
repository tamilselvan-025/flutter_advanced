// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:encrypt/encrypt.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'encryption_and_decryption/basic_encryption.dart';
//
// Future<void> encryptFile() async {
//
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['txt','xml'],
//   );
//
//   if (result != null) {
//     File file = File(result.files.single.path!);
//     myPrint("File path : ${file.path}");
//     String fileContent = await file.readAsString(encoding: utf8);
//     myPrint("File content : $fileContent");
//
//     // Define the encryption key and IV
//     final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
//     final iv = IV.fromLength(16);
//
//     // Create an encrypter object with AES in CBC mode and PKCS7 padding
//     final encryptor = Encrypter(AES(key,mode: AESMode.cbc_not_working,padding:"PKCS7"));
//     myPrint("Encryptor : $encryptor");
//
//     // Encrypt the file content
//     final encrypted = encryptor.encrypt(fileContent, iv: iv);
//     myPrint("encrypted : ${encrypted.runtimeType}");
//     myPrint("encrypted : $encrypted");
//
//     // Save the encrypted content to a new file
//     Directory directory = await getApplicationDocumentsDirectory();
//     myPrint("directory : ${directory.path}");
//     File encryptedFile = File('${directory.path}/encrypted_file.txt');
//    var data= await encryptedFile.writeAsBytes(encrypted.bytes);
//    myPrint("data :$data");
//    myPrint('File encrypted successfully. Encrypted file path: ${encryptedFile.path}');
//   }
// }
//
// Future<String?> decryptFile() async {
//   // Pick the encrypted file using file picker
//   FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//   if (result != null) {
//     File encryptedFile = File(result.files.single.path!);
//     myPrint("encryptedFile path : ${encryptedFile.path}");
//
//     // Read the encrypted file content
//     Uint8List encryptedBytes = await encryptedFile.readAsBytes();
//     myPrint("encryptedBytes : $encryptedBytes");
//     // Define the decryption key and IV (must be the same as used for encryption)
//     final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
//     final iv = IV.fromLength(16);
//
//     // Create an encrypter object with AES in CBC mode and PKCS7 padding
//     final encryptor = Encrypter(AES(key,mode: AESMode.cbc_not_working,padding: "PKCS7"));
//
//     // Decrypt the file content
//     final decrypted = encryptor.decryptBytes(Encrypted(encryptedBytes), iv: iv);
//     myPrint("decrypted : $decrypted");
//     // Convert the decrypted bytes to a string
//     String decryptedString = utf8.decode(decrypted);
//
//     myPrint('File decrypted successfully. Decrypted content: $decryptedString');
//     return decryptedString;
//   }
//   return null;
// }

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
