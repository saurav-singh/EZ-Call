import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../CallScreen/callScreen.dart';
import 'package:http/http.dart' as http;

Widget joinButton(context) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.all(10.0),
    child: SizedBox(
      width: 205,
      height: 55,
      child: RaisedButton(
        onPressed: () {
          dLog(context);
        },
        child: Text(
          "JOIN",
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

Future<Null> dLog(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: dBox(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
    },
  );
}

Widget dBox(context) {
  final callIdController = TextEditingController();

  return Container(
    height: 250,
    width: 250,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            inputFormatters: [UpperCaseTextFormatter()],
            textAlign: TextAlign.center,
            controller: callIdController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: "Enter Call Id"),
          ),
          RaisedButton(
            child: Text(
              "JOIN",
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xFF6C63FF),
            onPressed: () async {
              // Check for valid ID
              const api =
                  "https://frand-server.herokuapp.com/checkID?sessionID=";

              var response = await http.get(api + callIdController.text);

              if (response.body == "INVALID") {
                // Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "INVAID ID",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.redAccent,
                    fontSize: 15.0);
              } else {
                // Navigate
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CallScreen(
                      isHost: false,
                      sessionID: callIdController.text,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

// Temp
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
