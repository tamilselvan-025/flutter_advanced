import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';

import 'encrypt_decrypt.dart';


void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  final keyBase64 = generateRandomString(32);
  final ivBase64 = generateRandomString(16);
  String path = "/data/user/0/com.example.flutter_advance/app_flutter/encrypt.txt";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents Encryption and Decryption"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  file = await _pickFile();
                  if (file != null) {
                    await encryptFile(file!.path, keyBase64, ivBase64);
                    setState(() {});
                  }
                },
                child: const Text("Encode"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String decryptedString = await decryptFile(path, keyBase64, ivBase64);
                  myPrint("decryptedString : $decryptedString");

                },
                child: const Text("Decode"),
              ),
              file != null ? const Text("File is not null") : const Text("File is  null"),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
      allowMultiple: false, // Ensures only one file can be picked
    );
    if (result == null) return null;
    return File(result.files.single.path!);
  }
}
