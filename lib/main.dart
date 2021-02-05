import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/Home/home.dart';

void main() async => {
      WidgetsFlutterBinding.ensureInitialized(),
      await SystemChrome.setPreferredOrientations(
          // Lock to portrait mode
          [DeviceOrientation.portraitUp]),
      runApp(MyApp())
    };

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
