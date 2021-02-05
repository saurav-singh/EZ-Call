import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';

Widget remoteView(context, remoteRenderer) {
  return Positioned(
    left: 0.0,
    right: 0.0,
    top: 0.0,
    bottom: 0.0,
    child: Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: RTCVideoView(remoteRenderer),
      decoration: BoxDecoration(color: Colors.black54),
    ),
  );
}
