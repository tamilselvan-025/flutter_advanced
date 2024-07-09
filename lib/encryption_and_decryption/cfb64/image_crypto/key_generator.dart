
import 'package:flutter/material.dart' as material;
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

const storage = FlutterSecureStorage();

Future<void> storeEncryptionKey(Key key) async {
  await storage.write(key: 'encryptionKey', value: key.base64);
}

Future<Key?> retrieveEncryptionKey() async {
  final keyBase64 = await storage.read(key: 'encryptionKey');
  if (keyBase64 != null) {
    return Key.fromBase64(keyBase64);
  }
  return null;
}

void main() async {
  material.runApp(const material.MaterialApp());
  final key = generateEncryptionKey();
  await storeEncryptionKey(key);
  final retrievedKey = await retrieveEncryptionKey();
  myPrint('Retrieved Key: ${retrievedKey?.base64}');
}

Key generateEncryptionKey() {
  final key = Key.fromSecureRandom(16); // 128-bit key
  return key;
}
