import 'package:ez_call/Screens/CallScreen/Widgets/cameraSwitchButton.dart';
import 'package:ez_call/Screens/CallScreen/Widgets/muteButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:ez_call/Network/signaling.dart';

// Import Local Widgets
import 'Widgets/localView.dart';
import 'Widgets/remoteView.dart';
import 'Widgets/hangupButton.dart';
import 'Widgets/loadingScreen.dart';

class CallScreen extends StatefulWidget {
  final bool isHost;
  final String sessionID;

  CallScreen({this.isHost, this.sessionID = ""});

  @override
  _MyCallScreenState createState() => _MyCallScreenState();
}

class _MyCallScreenState extends State<CallScreen> {
  final localRenderer = new RTCVideoRenderer();
  final remoteRenderer = new RTCVideoRenderer();
  Signaling signaling;
  String id = "";

  @override
  void initState() {
    super.initState();
    initRenderers();
    initSignaling();
    setState(() => id = widget.sessionID);
  }

  @override
  deactivate() {
    super.deactivate();
    signaling.close();
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    localRenderer.dispose();
    remoteRenderer.dispose();
  }

  initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    // localRenderer.srcObject = await signaling.createStream();
  }

  initSignaling() async {
    final isHost = widget.isHost;
    final sessionID = widget.sessionID;

    signaling = Signaling(isHost: isHost, sessionID: sessionID)..init();

    signaling.onLocalStream = ((stream) {
      localRenderer.srcObject = stream;
      localRenderer.mirror = true;
    });

    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
    });

    signaling.onDisconnect = (() {
      Navigator.pop(context);
    });

    signaling.setID = ((_id) {
      if (this.mounted) {
        setState(() => id = _id);
      }
    });
  }

  // Temporary ID display
  Widget T() => Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.all(5.0),
        child: Text("ID : $id"),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        if (id == "") {
          return loading();
        }

        return Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              remoteView(context, remoteRenderer),
              localView(context, localRenderer, orientation),
              Positioned(
                top: 40.0,
                right: 20.0,
                child: T(),
              ),
              Positioned(
                bottom: 20,
                child: SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cameraSwitchButton(context, signaling),
                      hangupButton(context, signaling),
                      muteButton(context, signaling),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
