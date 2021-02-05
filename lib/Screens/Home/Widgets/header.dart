import 'package:flutter/material.dart';

Widget header() {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: 70.0),
    child: Column(
      children: [
        Image(
          image: AssetImage('assets/logo.png'),
          height: 75,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Video Calling ",
                style: TextStyle(fontSize: 14, color: Color(0xDD909090)),
              ),
              TextSpan(
                text: "Simplified",
                style: TextStyle(fontSize: 14, color: Color(0xDD6C63FF)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
