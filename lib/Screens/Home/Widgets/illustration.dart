import 'package:flutter/material.dart';

Widget illustration() {
  return Container(
    height: 250,
    width: 350,
    margin: EdgeInsets.only(bottom: 30.0),
    child: Image(
      image: AssetImage('assets/illustration.png'),
    ),
  );
}
