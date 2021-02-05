import 'package:flutter/material.dart';

// Import Local Widgets
import 'Widgets/createButton.dart';
import 'Widgets/joinButton.dart';
import 'Widgets/header.dart';
import 'Widgets/illustration.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            header(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                illustration(),
                createButton(context),
                joinButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }
}
