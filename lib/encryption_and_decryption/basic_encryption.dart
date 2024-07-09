import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart' as material;
import 'package:encrypt/encrypt.dart';

void main() {
  material.runApp(const material.MaterialApp());
  String myKey="openwavecomputingservicespvtltd!";
  final key = Key.fromUtf8(myKey);
  final iv = IV.fromLength(16);
  myPrint("iv : ${iv.bytes}");
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

  const plainText = 'Hello, World!';
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  myPrint('Plaintext: $plainText');
  myPrint('Encrypted: ${encrypted.base64}');
  myPrint('Decrypted: $decrypted');
}
void myPrint(String string){
  _printColored(string, '30', bgColorCode: '46',bold: true,underline: true);
}

void _printColored(String text, String colorCode, {String? bgColorCode, bool bold = false, bool underline = false}) {
  String color = '\x1B[${colorCode}m';
  String bgColor = bgColorCode != null ? '\x1B[${bgColorCode}m' : '';
  String boldCode = bold ? '\x1B[1m' : '';
  String underlineCode = underline ? '\x1B[4m' : '';
  String reset = '\x1B[0m';
  cupertino.debugPrint('$boldCode$underlineCode$bgColor$color$text$reset');
}
