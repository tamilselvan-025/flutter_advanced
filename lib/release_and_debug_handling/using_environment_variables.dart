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
    const bool isDebugMode = bool.fromEnvironment('dart.vm.product', defaultValue: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Release and debug handling using Environment variable"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: isDebugMode ? Text("Release Mode") : Text("Debug Mode"),
      ),
    );
  }
}
