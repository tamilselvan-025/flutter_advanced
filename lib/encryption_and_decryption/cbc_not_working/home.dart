import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_advanced/encryption_and_decryption/cbc_not_working/encrypt_decrypt.dart';

import 'package:flutter_advanced/encryption_and_decryption/directory_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? path;
  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encrypt and Decrypt using CBC"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    path = await _selectFromGallery();
                    if (path != null) {
                      CryptoCBC cryptoCBC = CryptoCBC();
                      String? data = await cryptoCBC.encode(DirectoryType.images,
                          filePath: path!,
                          newFileName: "image"
                              "1");
                      if (data == null) {
                        myPrint("ReturnedData is null");
                      } else {
                        myPrint("Data : $data");
                      }
                      setState(() {});
                    }
                  },
                  child: const Text("Select image")),
              ElevatedButton(
                  onPressed: () async {
                    String path = "/data/user/0/com.example.flutter_advance/app_flutter'/images/image1";
                    CryptoCBC cryptoCBC = CryptoCBC();
                    try {
                      dynamic value = await cryptoCBC.decrypt(path);
                      if (value is Uint8List) {
                        myPrint("Value is Uint8List");
                        myPrint("value.length : ${value.length}");
                        imageData = value;

                      }
                    } catch (e, s) {
                      debugPrint("Error in decrypt button : $e");
                      debugPrint("StackTrace in decrypt button : $s");
                    }
                  },
                  child: const Text("Decode image")),
              path != null
                  ? SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.file(File(path!)),
                    )
                  : const Text("Select a image to encrypt"),
              imageData != null
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.memory(imageData!),
                    )
                  : const Text("No decoded file selected"),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Set State"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _selectFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return null;
    return returnedImage.path;
  }
}
