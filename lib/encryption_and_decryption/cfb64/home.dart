import 'package:file_picker/file_picker.dart';
import 'package:flutter_advanced/encryption_and_decryption/cfb64/encrypt_decrypt.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final keyBase64 = generateRandomString(32);
  final ivBase64 = generateRandomString(16);
  File? file;
  String path="/data/user/0/com.example.flutter_advance/app_flutter/encrypt.txt";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Encryption'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result=await FilePicker.platform.pickFiles();
                  if(result!=null){
                    file=File(result.files.single.path!);
                    myPrint("path : $path");
                    await encryptFile(file!.path,keyBase64,ivBase64);
                  }
                },
                child: const Text('Encrypt File'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(file!=null){
                    String data =await decryptFile(path,keyBase64, ivBase64);
                    myPrint("data is not null");
                    myPrint("-----------------------------");
                    myPrint(data);
                    setState(() {
                    });
                  }
                },
                child: const Text('Decrypt File'),
              ),
              file!=null?SizedBox(
                height: 300,
                width: 300,
                child: Text(file.toString()),
              ):const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
