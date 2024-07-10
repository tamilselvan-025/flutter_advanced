import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced/encryption_and_decryption/cfb64/video_crypto/video_screen.dart';
import 'encryption_decryption.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FileEncryptionDemo(),
    );
  }
}

class FileEncryptionDemo extends StatefulWidget {
  const FileEncryptionDemo({super.key});

  @override
  State<FileEncryptionDemo> createState() => _FileEncryptionDemoState();
}

class _FileEncryptionDemoState extends State<FileEncryptionDemo> {
  String? _filePath;
  File? _encryptedFile;
  File? _decryptedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mov', 'mkv'],
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _encryptFile() async {
    if (_filePath != null) {
      final file = File(_filePath!);
      final encryptedFile = await encryptFile(file, 'your-32-character-long-key');
      setState(() {
        _encryptedFile = encryptedFile;
      });
    }
  }

  Future<void> _decryptFile() async {
    if (_encryptedFile != null) {
      final decryptedFile = await decryptFile(_encryptedFile!, 'your-32-character-long-key');
      setState(() {
        _decryptedFile = decryptedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Encryption Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick Video File'),
            ),
            const SizedBox(height: 20),
            _filePath != null ? Text('Selected file: $_filePath') : const Text('No file selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encryptFile,
              child: const Text('Encrypt File'),
            ),
            const SizedBox(height: 20),
            _encryptedFile != null ? Text('Encrypted file: ${_encryptedFile!.path}') : const Text('No file encrypted'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decryptFile,
              child: const Text('Decrypt File'),
            ),
            const SizedBox(height: 20),
            _decryptedFile != null
                ? Column(
                    children: [
                      Text('Decrypted file: ${_decryptedFile!.path}'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoApp(filePath: _decryptedFile!.path),
                              ),
                            );
                          },
                          child: const Text("Click here to watch video"))
                    ],
                  )
                : const Text('No file decrypted'),
          ],
        ),
      ),
    );
  }
}
