import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Release and debug handling using constants"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: kReleaseMode ? Text("Release Mode") : Text("Debug Mode"),
      ),
    );
  }
}
