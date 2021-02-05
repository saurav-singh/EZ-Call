import 'dart:convert';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const SOCKET_EVENTS = [
  "connect",
  "disconnect",
  "CREATE",
  "JOIN",
  "INIT",
  "OFFER",
  "ANSWER",
  "SEND_CANDIDATE",
  "RECV_CANDIDATE"
];

typedef void StreamCallback(MediaStream stream);
typedef void IDCallback(String id);
typedef void DisconnectCallback();

class Signaling {
  /*
   * Attributes
   */
  bool isHost;
  String sessionID;
  IO.Socket socket;
  RTCPeerConnection peerConnection;
  List<dynamic> localCandidates = [];
  MediaStream localStream;
  MediaStream remoteStream;
  StreamCallback onLocalStream;
  StreamCallback onAddRemoteStream;
  StreamCallback onRemoveRemoteStream;
  DisconnectCallback onDisconnect;
  IDCallback setID;

  /*
   * Configuration Parameters
   */
  final Map<String, dynamic> constraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  final Map<String, dynamic> mediaConstraints = {
    "audio": true,
    "video": {"facingMode": "user"},
  };

  final Map<String, dynamic> configuration = {
    "iceServers": [
      {"urls": "stun:stun.l.google.com:19302"},
      {"urls": "stun:stun.services.mozilla.com"}
    ]
  };

  /*
   * Constructor
   */
  Signaling({this.isHost, this.sessionID});

  /*
   * Initialization Methods
   */
  void init() async {
    peerConnection = await initPeerConnection();

    // Initialize Socket Connection
    final serverAddr = "https://frand-server.herokuapp.com";
    final Map<String, dynamic> params = {
      'transports': ['websocket'],
      'autoConnect': false,
    };
    socket = IO.io(serverAddr, params)..connect();

    // Add Socket Event Handlers
    SOCKET_EVENTS.forEach((event) {
      socket.on(event, (data) => socketEventHandler(event, data));
    });
  }

  /*
   * Socket Event Handler Methods
   */
  void socketEventHandler(String event, dynamic data) async {
    // print("EVENT: $event occured!");

    if (data == "Error") {
      print("-----Error-----");
      return;
    }

    // Common Events (Ice Candidates)
    switch (event) {
      case "SEND_CANDIDATE":
        {
          localCandidates.forEach((candidateData) {
            emit("CANDIDATE", candidateData);
          });
        }
        break;

      case "RECV_CANDIDATE":
        {
          await addCandidate(data);
        }
        break;

      // Test
      case "disconnect":
        {
          print("Disconnected from the server");
        }
    }

    // Client-A Events
    if (isHost) {
      switch (event) {
        case "connect":
          {
            emit("CREATE", "");
          }
          break;

        case "CREATE":
          {
            sessionID = data;
            setID(sessionID);
          }
          break;

        case "INIT":
          {
            final offerData = await createOffer();
            emit("OFFER", offerData);
          }
          break;

        case "ANSWER":
          {
            await completeOffer(data);
            emit("COMPLETE", sessionID);
          }
      }
    }

    // Client-B Events
    else {
      switch (event) {
        case "connect":
          {
            emit("JOIN", sessionID);
          }
          break;

        case "OFFER":
          {
            final answerData = await createAnswer(data);
            emit("ANSWER", answerData);
          }
      }
    }
  }

  void emit(event, data) {
    socket.emit(event, data);
  }

  /*
   * Device Helper Functions
   */

  // todo: switches between all possible cameras? do only rear and front
  void switchCamera() {
    if (localStream != null) {
      localStream.getVideoTracks()[0].switchCamera();
    }
  }

  void muteMicrophone() {
    if (localStream != null) {
      localStream.getVideoTracks()[0].setMicrophoneMute(true);
    }
  }

  /*
   * WebRTC Methods
   */
  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    return await navigator.getUserMedia(mediaConstraints);
    // Screen Sharing feature:
    // return await navigator.getDisplayMedia(mediaConstraints);
  }

  Future<RTCPeerConnection> initPeerConnection() async {
    // Create Media Stream
    localStream = await createStream();

    // Set local media stream
    onLocalStream(localStream);

    // Create Peer Connection
    final pc = await createPeerConnection(configuration, constraints);
    pc.addStream(localStream);

    // Peer Connection Event Handlers
    pc.onIceCandidate = (data) {
      if (data == null) return;
      // Parse candidate
      final candidate = {
        'sdpMLineIndex': data.sdpMlineIndex,
        'sdpMid': data.sdpMid,
        'candidate': data.candidate,
      };
      // Create candidate data to be sent to the server
      final candidateData = {
        "sessionID": sessionID,
        "client_type": isHost ? "clientA" : "clientB",
        "candidate": candidate
      };

      localCandidates.add(candidateData);
    };

    // Peer Connection State Event Handlers
    pc.onIceConnectionState = (state) {
      print("ICE CONNECTION STATE");
      print(state);

      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateDisconnected)
        onDisconnect();
    };

    pc.onAddStream = (stream) {
      onAddRemoteStream(stream);
    };

    pc.onRemoveStream = (stream) {
      onRemoveRemoteStream(stream);
    };

    return pc;
  }

  Future<dynamic> createOffer() async {
    final description = await peerConnection.createOffer(constraints);
    peerConnection.setLocalDescription(description);

    final offerSDP = {"sdp": description.sdp, "type": description.type};
    final offerData = {"ID": sessionID, "session_data": offerSDP};

    return offerData;
  }

  Future<void> completeOffer(dynamic remoteData) async {
    final sdp = remoteData;
    final description = RTCSessionDescription(sdp["sdp"], sdp["type"]);
    await peerConnection.setRemoteDescription(description);
  }

  Future<dynamic> createAnswer(dynamic remoteData) async {
    // Retrieve Client-A offer -> Set Remote Description
    final sdp = remoteData;
    final rDescription = RTCSessionDescription(sdp["sdp"], sdp["type"]);
    await peerConnection.setRemoteDescription(rDescription);

    // Create answer -> Set LocalDescription
    final description = await peerConnection.createAnswer(constraints);
    await peerConnection.setLocalDescription(description);

    final answerSDP = {"sdp": description.sdp, "type": description.type};
    final answerData = {"ID": sessionID, "session_data": answerSDP};

    return answerData;
  }

  Future<void> addCandidate(dynamic candidateData) async {
    try {
      // todo: Clean this parsing code
      if (validCandidate(candidateData["client_type"])) {
        var p = json.encode(candidateData["candidate"]);
        int tempIndex = int.parse(p[17]);

        candidateData = candidateData["candidate"];

        // this doesn't parse correctly
        // final candidate = RTCIceCandidate(candidateData["candidate"],
        //     candidateData["sdpMid"], candidateData["sdpMlineIndex"]);

        final candidate = RTCIceCandidate(
            candidateData["candidate"], candidateData["sdpMid"], tempIndex);

        await peerConnection.addCandidate(candidate);
      }
    } catch (e) {
      print("ERROR ADDING ICE CANDIDATE:\n MSG: $e");
      return;
    }
  }

  bool validCandidate(String clientType) {
    return (isHost && clientType == "clientB") ||
        (!isHost && clientType == "clientA");
  }

  void close() {
    if (localStream != null) {
      localStream.dispose();
      localStream = null;
    }

    if (peerConnection != null) {
      peerConnection.close();
    }

    if (socket != null) {
      socket.disconnect();
    }
  }
}
