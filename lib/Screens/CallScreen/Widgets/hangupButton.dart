import 'package:flutter/material.dart';

Widget hangupButton(context, signaling) {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
        // signaling.disconnect();
        Navigator.pop(context);
      },
      tooltip: 'Hangup',
      child: Icon(Icons.call_end),
      backgroundColor: Colors.pink,
    ),
  );
}
