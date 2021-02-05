import 'package:flutter/material.dart';
import '../../CallScreen/callScreen.dart';

Widget createButton(context) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.all(10.0),
    child: SizedBox(
      width: 205,
      height: 55,
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CallScreen(isHost: true),
            ),
          );
        },
        child: Text(
          "CREATE",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        color: Color(0xFF6C63FF),
      ),
    ),
  );
}
