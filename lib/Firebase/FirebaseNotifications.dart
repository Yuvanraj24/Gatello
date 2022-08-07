import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> sendNotificationForCall({
  required List<String> userTokens,
  required String id,
  required bool video,
  required String phoneNumber,
  required String name,
  required String? pic,
  //0->personal call; 1->group call
  required int state,
  required String timestamp,
}) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "registration_ids": userTokens,
    "priority": "high",
    "notification": {
      "title": 'Gatello',
      "body": 'Call',
    },
    "data": {
      "type": 'call',
      "uuid": id,
      "state":state,
      "caller_id": phoneNumber,
      "caller_name": name,
      "caller_pic": pic ??
          ((state == 0)
              ? 'https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoProfile.jpg?alt=media&token=a2283e6d-222d-492f-b7f5-7c53bf7f38e4'
              : 'https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoGroupProfile.jpg?alt=media&token=e622ff31-2c33-45a5-9680-0b6e8202764f'),
      "timestamp": timestamp,
      "caller_id_type": "number",
      "has_video": video,
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=AAAAWxwfW88:APA91bGjN84f1HmsPdrbu4dA3fRcstAiugPL9Us1aqD0AwWuXuF6gBbaCuX_ot4yZI7gJMd6VRkH_YaOq_9FSl1A8MCmOC7RaSBFI2MsOWktT7TO0M9taTrgaOxhOO99QMclm573Xcf3'
  };

  final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}

Future<bool> sendNotificationForChat({
  required List<String> userTokens,
  required String name,
  required String message,
  required String? pic,
  //0->personal chat; 1->group chat
  required int state,
  required String uid,
  required String puid,
}) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "registration_ids": userTokens,
    "priority": "high",
    "notification": {
      "title": name,
      "body": message,
      "imageUrl": pic ??
          ((state == 0)
              ? 'https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoProfile.jpg?alt=media&token=a2283e6d-222d-492f-b7f5-7c53bf7f38e4'
              : 'https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoGroupProfile.jpg?alt=media&token=e622ff31-2c33-45a5-9680-0b6e8202764f')
    },
    "data": {
      "type": 'chat',
      "uid": uid,
      "puid": puid,
      "state": state,
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=AAAAWxwfW88:APA91bGjN84f1HmsPdrbu4dA3fRcstAiugPL9Us1aqD0AwWuXuF6gBbaCuX_ot4yZI7gJMd6VRkH_YaOq_9FSl1A8MCmOC7RaSBFI2MsOWktT7TO0M9taTrgaOxhOO99QMclm573Xcf3'
  };

  final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}
