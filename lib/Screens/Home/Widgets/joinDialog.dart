import 'package:flutter/material.dart';

Widget dBox(context) {
  final callIdController = TextEditingController();

  return Container(
    height: 350,
    width: 250,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Enter Call ID",
            style: TextStyle(fontSize: 20.0),
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: callIdController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: "Enter Text Id"),
          ),
          RaisedButton(
            child: Text("JOIN"),
            onPressed: () {},
          )
        ],
      ),
    ),
  );
}
