import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(home: Home(releaseType: BuildChecker.checkBuildMode()),));
}

class Home extends StatelessWidget {
  final String releaseType;
  const Home({required this.releaseType,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Release and debug handling using assert"),
        backgroundColor: Colors.teal,
      ),
      body:  Center(
        child:  Text(releaseType),
      ),
    );
  }
}
class BuildChecker {
  static String _releaseType = "";
  static const String _debugMode = "DebugMode";
  static const String _releaseMode = "ReleaseMode";

  static String checkBuildMode() {
    bool isDebugMode = false;
    assert(isDebugMode = true);
    if(isDebugMode){
      _releaseType=_debugMode;
    }
    else{
      _releaseType=BuildChecker._releaseMode;
    }
    return _releaseType;
  }
}