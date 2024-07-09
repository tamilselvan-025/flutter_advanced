import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart'as encryption;
import 'package:flutter_advanced/encryption_and_decryption/basic_encryption.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Encryption Key Generator',
      home: KeyGeneratorScreen(),
    );
  }
}

class KeyGeneratorScreen extends StatefulWidget {
  @override
  _KeyGeneratorScreenState createState() => _KeyGeneratorScreenState();
}

class _KeyGeneratorScreenState extends State<KeyGeneratorScreen> {
  final storage = FlutterSecureStorage();
  String? generatedKey;

  @override
  void initState() {
    super.initState();
    _generateAndStoreKey();
  }

  Future<void> _generateAndStoreKey() async {
    final key = encryption.Key.fromSecureRandom(16); // Generate 128-bit key
    await storage.write(key: 'encryptionKey', value: key.base64);
    setState(() {
      generatedKey = key.base64;
      myPrint(generatedKey!);
    });
  }

  Future<String?> _retrieveKey() async {
    return await storage.read(key: 'encryptionKey');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encryption Key Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Generated Key:',
            ),
            if (generatedKey != null) ...[
              Text(
                generatedKey!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final retrievedKey = await _retrieveKey();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Retrieved Key'),
                    content: Text(retrievedKey ?? 'No key found'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Retrieve Key'),
            ),
          ],
        ),
      ),
    );
  }
}
