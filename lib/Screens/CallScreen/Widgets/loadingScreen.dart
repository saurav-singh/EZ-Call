import 'package:flutter/material.dart';

Widget loading() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.all(10.0)),
          Text("Hold on a moment..."),
        ],
      ),
    ),
  );
}
