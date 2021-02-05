import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';

Widget localView(context, localRenderer, orientation) {
  return Positioned(
    left: 20.0,
    top: 70.0,
    child: Container(
      width: orientation == Orientation.portrait ? 90.0 : 120.0,
      height: orientation == Orientation.portrait ? 120.0 : 90.0,
      child: RTCVideoView(localRenderer),
      decoration: BoxDecoration(color: Colors.black54),
    ),
  );
}
