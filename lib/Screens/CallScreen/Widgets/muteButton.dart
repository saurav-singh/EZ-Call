import 'package:flutter/material.dart';

Widget muteButton(context, signaling) {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
        // signaling.disconnect();
        Navigator.pop(context);
      },
      tooltip: 'Hangup',
      child: Icon(Icons.mic_off),
      backgroundColor: Colors.deepPurpleAccent,
    ),
  );
}
