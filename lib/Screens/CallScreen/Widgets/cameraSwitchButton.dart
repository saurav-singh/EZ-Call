import 'package:flutter/material.dart';

Widget cameraSwitchButton(context, signaling) {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
        signaling.switchCamera();
      },
      tooltip: 'Hangup',
      child: Icon(Icons.switch_camera),
      backgroundColor: Colors.deepPurpleAccent,
    ),
  );
}
