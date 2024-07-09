import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_advanced/encryption_and_decryption/cfb64/image_crypto/crypto/cryptograph.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

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
  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image encoder and decoder"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  CryptoGraph cryptoGraph = CryptoGraph();
                  File? file = await _selectFromGallery();
                  if (file != null) {
                    imageData = await cryptoGraph.encode(file, 1);
                    myPrint("Image data fetched !!!");
                    setState(() {});
                  }
                },
                child: const Text("Encode"),
              ),
              imageData != null
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.memory(imageData!),
                    )
                  : const Text("Insert a image to encode"),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _selectFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return null;
    return File(returnedImage.path);
  }
}
