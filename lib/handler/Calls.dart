import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:http/http.dart' as http;


import 'package:firebase_messaging/firebase_messaging.dart';

import '../Authentication/Authentication.dart';
import 'AppRoute.dart';
import 'NavigationService.dart';

Future showCallkitIncoming({
  ///* state 0->notification 1->direct
  required int state,
  RemoteMessage? message,
  String? id,
  String? name,
  String? phone,
  String? pic,
  int? hasVideo,
  String? timestamp,
  int? chatType,
}) async {
  var params = <String, dynamic>{
    'id': (state == 0) ? message!.data['uuid'] : id,
    'nameCaller': (state == 0) ? message!.data['caller_name'] : name,
    'appName': 'Gatello',
    'avatar': (state == 0) ? message!.data['caller_pic'] : pic,
    'handle': (state == 0) ? message!.data['caller_id'] : phone,
    'type': (state == 0)
        ? (message!.data["has_video"] == 'true')
        ? 1
        : 0
        : hasVideo,
    'duration': 30000,
    'textAccept': 'Accept',
    'textDecline': 'Decline',
    'textMissedCall': 'Missed call',
    'textCallback': 'Call back',
    'extra': <String, dynamic>{
      "channelName": (state == 0) ? message!.data['uuid'] : id,
      "caller_id": (state == 0) ? message!.data['caller_id'] : phone,
      "title": (state == 0) ? message!.data['caller_name'] : name,
      "caller_pic": (state == 0) ? message!.data['caller_pic'] : pic,
      "video": (state == 0) ? message!.data["has_video"] : hasVideo,
      "startTimestamp": (state == 0) ? message!.data["timestamp"] : timestamp,
      "chatType": (state == 0) ? message!.data["state"] : chatType
    },
    'headers': {},
    'android': <String, dynamic>{
      'isCustomNotification': true,
      'isShowLogo': true,
      'isShowCallback': true,
      'ringtonePath': 'system_ringtone_default',
      'backgroundColor': '#0955fa',
      'backgroundUrl': (state == 0) ? message!.data['caller_pic'] : pic,
      'actionColor': '#4CAF50'
    },
    'ios': <String, dynamic>{
      'iconName': 'AppIcon',
      'handleType': '',
      'supportsVideo': true,
      'maximumCallGroups': 2,
      'maximumCallsPerCallGroup': 1,
      'audioSessionMode': 'None',
      'audioSessionActive': true,
      'audioSessionPreferredSampleRate': 44100.0,
      'audioSessionPreferredIOBufferDuration': 0.005,
      'supportsDTMF': true,
      'supportsHolding': true,
      'supportsGrouping': true,
      'supportsUngrouping': true,
      'ringtonePath': 'system_ringtone_default'
    }
  };
  if (state == 0) {
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  } else {
    return params;
  }
}

//!!listener doesnt work in background
Future<void> listenerEvent() async {
  var instance = FirebaseFirestore.instance;
  var uid = getUID();
  try {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      switch (event!.name) {
        case CallEvent.ACTION_CALL_INCOMING:
        // TODO: received an incoming call
          break;
        case CallEvent.ACTION_CALL_START:
        // TODO: started an outgoing call
        // TODO: show screen calling in Flutter
          break;
        case CallEvent.ACTION_CALL_ACCEPT:
        // TODO: accepted an incoming call
        // TODO: show screen calling in Flutter
          {
            NavigationService.instance.pushNamed(AppRoute.callingPage, args: event.body);
          }
          break;
        case CallEvent.ACTION_CALL_DECLINE:
          {
            var payload = event.body as Map<String, dynamic>;
            DocumentReference<Map<String, dynamic>> calldocref = await instance.collection("call-logs").doc(payload["extra"]['startTimestamp']);
            DocumentSnapshot<Map<String, dynamic>> calldoc = await calldocref.get();
            if (calldoc.data()!["presentCount"] == 1 || calldoc.data()!["presentCount"] == 0) {
              await calldocref.update({"end-timestamp": DateTime.now().millisecondsSinceEpoch.toString()});
            }
            await calldocref.update({"members.$uid.status": 3});
          }
          break;
        case CallEvent.ACTION_CALL_ENDED:
        // TODO: ended an incoming/outgoing call
          {
            var payload = event.body as Map<String, dynamic>;
            DocumentReference<Map<String, dynamic>> calldocref = await instance.collection("call-logs").doc(payload["extra"]['startTimestamp']);
            DocumentSnapshot<Map<String, dynamic>> calldoc = await calldocref.get();
            if (calldoc.data()!["presentCount"] == 0) {
              await calldocref.update({"end-timestamp": DateTime.now().millisecondsSinceEpoch.toString()});
            }
            await calldocref.update({"members.$uid.status": 2});
          }
          break;
        case CallEvent.ACTION_CALL_TIMEOUT:
        // TODO: missed an incoming call
          {
            var payload = event.body as Map<String, dynamic>;
            DocumentReference<Map<String, dynamic>> calldocref = await instance.collection("call-logs").doc(payload["extra"]['startTimestamp']);
            DocumentSnapshot<Map<String, dynamic>> calldoc = await calldocref.get();
            if (calldoc.data()!["presentCount"] == 0) {
              await calldocref.update({"end-timestamp": DateTime.now().millisecondsSinceEpoch.toString()});
            }
            await calldocref.update({"members.$uid.status": 3});
          }
          break;
        case CallEvent.ACTION_CALL_CALLBACK:
        // TODO: only Android - click action `Call back` from missed call notification
          break;
        case CallEvent.ACTION_CALL_TOGGLE_HOLD:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_MUTE:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_DMTF:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_GROUP:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
        // TODO: only iOS
          break;
        case CallEvent.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
        // TODO: only iOS
          break;
      }
    });
  } on Exception catch (e) {
    print('CallError: ${e.toString()}');
  }
}

getCurrentCall() async {
  var calls = await activeCalls();
  final objCalls = json.decode(calls);
  if (objCalls is List) {
    if (objCalls.isNotEmpty) {
      print('DATA: $objCalls');
      return objCalls[0];
    } else {
      return null;
    }
  }
}

Future activeCalls() async {
  return await FlutterCallkitIncoming.activeCalls();
}

Future<void> endAllCalls() async {
  await FlutterCallkitIncoming.endAllCalls();
}

Future<void> startCall(params) async {
  await FlutterCallkitIncoming.startCall(params);
}

Future getDevicePushTokenVoIP() async {
  var devicePushTokenVoIP = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  print(devicePushTokenVoIP);
  return devicePushTokenVoIP;
}

Future<void> endCurrentCall() async {
  var params = await getCurrentCall();
  if (params != null) {
    await FlutterCallkitIncoming.endCall(params);
  }
}
