import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:android_path_provider/android_path_provider.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import '../Helpers/DateTimeHelper.dart';

extension InvertMap<K, V> on Map<K, V> {
  Map<V, K> get inverse => Map.fromEntries(entries.map((e) => MapEntry(e.value, e.key)));
}

const String nullPic = "https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoProfile.jpg?alt=media&token=a2283e6d-222d-492f-b7f5-7c53bf7f38e4";
const String nullGroupPic =
    "https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoGroupProfile.jpg?alt=media&token=e622ff31-2c33-45a5-9680-0b6e8202764f";

// extension RemoteMessageExt on RemoteMessage {
//   Map<String, dynamic> getContent() {
//     return jsonDecode(this.data["content"]);
//   }

//   Map<String, dynamic> payload() {
//     return getContent()["payload"];
//   }
// }

// Future<File> getImageFileFromAssets(String path) async {
//   final byteData = await rootBundle.load('$path');
//   final file = File(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes), path.split("/").last);
//   // var a =   FileReader().readAsDataUrl(blob)
//   // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//   return file;
// }

// String personalChatIdGenerator({required String uid, required String puid}) {
//   if (uid.hashCode > puid.hashCode) {
//     return uid + "-" + puid;
//   } else {
//     return puid + "-" + uid;
//   }
// }

//if we need delete use this... add deleted...
Map<int, String> dataTypeMap = {
  0: "Text", //just text
  1: "📷 Image",
  2: "📹 Video",
  3: "🔈 Audio",
  4: "📁 Document",
  5: "📜 Story",
  6: "✨ Gif", //just text
  7: "📍 Location", //just text
  8: "👤 Contact", //just text
  9: "🎤 Voice"
};

String getMessage(int index, Map data) {
  switch (index) {
    case 0:
      return data['text'];
    case 1:
      return data['image'];
    case 2:
      return data['video'];
    case 3:
      return data['audio'];
    case 4:
      return data['document'];
    case 5:
      return data['story'];
    case 6:
      return data['gif'];
    case 7:
      return data['location'];
    case 8:
      return data['contact'];
    case 9:
      return data['voice'];
    default:
      return "";
  }
}

Map replyMap({required String documentId, required int documentIndex, required String fromUid, required String type, required Map data}) {
  Map inversedDataTypeMap = dataTypeMap.inverse;
  int index = inversedDataTypeMap[type];
  String? dataString;
  dataString = getMessage(index, data);
  return {
    "documentId": documentId,
    "documentIndex": documentIndex,
    "from": fromUid,
    "type": type,
    "data": {
      "text": (index == 0) ? dataString : null,
      "image": (index == 1) ? dataString : null,
      "video": (index == 2) ? dataString : null,
      "audio": (index == 3) ? dataString : null,
      "document": (index == 4) ? dataString : null,
      "story": (index == 5) ? dataString : null,
      "gif": (index == 6) ? dataString : null,
      "location": (index == 7) ? dataString : null,
      "contact": (index == 8) ? dataString : null,
      "voice": (index == 9) ? dataString : null,
    }
  };
}

Map createCallLogMap({required List<String> members}) {
  Map result = {};
  members.forEach((member) {
    result.addAll({
      member: {
        "endTime": null,
        "isAnswered": false,
        "isCancelled": false,
        "isMissed": false,
      }
    });
  });
  return result;
}

Tuple2 namePicGenerator(int length, uid, Map<String, dynamic> members) {
  List<String?> pics = [];
  String name = "";
  for (int i = 0; i < length; i++) {
    if (uid != members.keys.elementAt(i)) {
      pics.add((members.values.elementAt(i)["pic"] != null)
          ? members.values.elementAt(i)["pic"]
          : "https://firebasestorage.googleapis.com/v0/b/gatello-5d386.appspot.com/o/default%2FnoProfile.jpg?alt=media&token=a2283e6d-222d-492f-b7f5-7c53bf7f38e4");
      if (members.length == 2) {
        name = members.values.elementAt(i)["name"];
      } else if (members.length == 3) {
        if (' & '.allMatches(name).length != 1) {
          name += members.values.elementAt(i)["name"] + " & ";
        } else {
          name += members.values.elementAt(i)["name"];
        }
      } else {
        if (' & '.allMatches(name).length != 2) {
          name += members.values.elementAt(i)["name"] + " & ";
        } else {
          name += members.values.elementAt(i)["name"] + " & Others";
        }
      }
    }
  }
  return Tuple2(pics, name);
}

Map addGroupMembersMap({required List<Map<String, dynamic>> members}) {
  Map result = {};
  for (Map<String, dynamic> member in members) {
    result.addAll({
      member["uid"]: {"isRemoved": false, "pic": member["pic"], "name": member["name"], "claim": "member", "lastRead": null, "unreadCount": 0}
    });
  }
  return result;
}

Future<Uint8List?> downloadToBytes(String url) async {
  if (url.isNotEmpty) {
    final uri = Uri.parse(url);
    final request = await http.get(uri);
    return request.bodyBytes;
    // final client = http.Client();
    // final request = http.Request('GET', uri);
    // final response = await client.send(request);
    // final stream = response.stream;
    // client.close();
    // return stream.toBytes();
  } else {
    return null;
  }
}

Map createGroupMembersMap({required String? adminPic, required String adminName, required String adminUid, required List<Map<String, dynamic>> members}) {
  Map result = {
    adminUid: {"isRemoved": false, "pic": adminPic, "name": adminName, "claim": "admin", "lastRead": null, "unreadCount": 0}
  };
  for (Map<String, dynamic> member in members) {
    result.addAll({
      member["uid"]: {"isRemoved": false, "pic": member["pic"], "name": member["name"], "claim": "member", "lastRead": null, "unreadCount": 0}
    });
  }
  print(result);
  return result;
}

String roomId({required String uid, required String puid}) {
  if (uid.compareTo(puid) < 0) {
    return "$uid-$puid";
  } else if (uid.compareTo(puid) > 0) {
    return "$puid-$uid";
  } else {
    return "$uid-$uid";
  }
}

Map dataMap({required int index, required String data}) {
  return {
    "text": (index == 0) ? data : null,
    "image": (index == 1) ? data : null,
    "video": (index == 2) ? data : null,
    "audio": (index == 3) ? data : null,
    "document": (index == 4) ? data : null,
    "story": (index == 5) ? data : null,
    "gif": (index == 6) ? data : null,
    "location": (index == 7) ? data : null,
    "contact": (index == 8) ? data : null,
    "voice": (index == 9) ? data : null,
  };
}

Map shareDataMap({required int contentType, required String description, required String contentUrl, required String storyUrl}) {
  if (contentType == 0) {
    return {
      "text": description,
      "image": contentUrl,
      "video": null,
      "audio": null,
      "document": null,
      "story": storyUrl,
      "gif": null,
      "location": null,
      "contact": null,
      "voice": null,
    };
  } else {
    return {
      "text": description,
      "image": null,
      "video": contentUrl,
      "audio": null,
      "document": null,
      "story": storyUrl,
      "gif": null,
      "location": null,
      "contact": null,
      "voice": null,
    };
  }
}

Map groupWriteMessageMembersMap({required Map members}) {
  Map result = {};
  members.forEach((key, value) {
    result.addAll({
      key: {
        "isRemoved": value["isRemoved"],
        "pic": value["pic"],
        "name": value["name"],
        "claim": value["claim"],
        "lastRead": value["lastRead"],
        "unreadCount": (key == 's8b6XInslPffQEgz8sVTINsPhcx2') ? 0 : value["unreadCount"] + 1
      }
    });
  });
  return result;
}

//!poor design and dont have time to optimize it
bool groupReadReceipt({required Map members, required String timestamp, required String uid}) {
  bool isRead = false;
  members.remove(uid);
  for (var value in members.values) {
    if (value["lastRead"] == null) {
      isRead = false;
      break;
    }
    if (getDateTimeSinceEpoch(datetime: value["lastRead"]).difference(getDateTimeSinceEpoch(datetime: timestamp)).inMicroseconds > 0) {
      isRead = true;
    } else {
      isRead = false;
      break;
    }
  }
  return isRead;
}

// void downloadFile(String url) {
//   html.AnchorElement anchorElement = new html.AnchorElement(href: url);
//   anchorElement.download = url;
//   anchorElement.click();
//   anchorElement.remove();
// }

// blobToUrl(Uint8List bytes, String type) {
//   final Blob blob = Blob([bytes], type);
//   // return blob.toString();
//   var url = Url.createObjectUrl(blob);
//   // log(url);
//   return url;
// }
const kDuration = const Duration(milliseconds: 300);
const kCurve = Curves.ease;
///**********************download */
late String _localPath;
Future downloadFile(String url, String fileName, TargetPlatform platform) async {
  print('rrrrrrrr');
  final bool hasGranted = await _checkPermission(platform);
  if (hasGranted) {
    await _prepareSaveDir();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
    await FlutterDownloader.open(taskId: taskId!);
  }
}

Future<bool> _checkPermission(platform) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  if (platform == TargetPlatform.android && androidInfo.version.sdkInt! <= 28) {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

Future<void> _prepareSaveDir() async {
  _localPath = (await _findLocalPath())!;
  final savedDir = Directory(_localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
}

Future<String?> _findLocalPath() async {
  var externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}

// void downloadCallback(String id, DownloadTaskStatus status, int progress) {
//   final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
//   send.send([id, status, progress]);
// }
///**********************download */

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}

//note: missed happends in call invitation timeout and decline call :: and ended is whenever the call is ended
//* status : 0->ringer 1->answered 2->ended 3->missed
Map createCallMembersGroup({required Map<String, dynamic> groupDetailDocument, required String callerUID}) {
  Map memberMap = {};
  groupDetailDocument["members"].forEach((k, v) {
    // if (k == callerUID) {
    //   memberMap.addAll({
    //     k: {"status": 1, "pic": v["pic"], "name": v["name"]}
    //   });
    // } else {
    memberMap.addAll({
      k: {"status": 0, "pic": v["pic"], "name": v["name"]}
    });
    // }
  });
  return memberMap;
}

// Map addCallMembersGroup() {}

Map createCallMember({required Map<String, dynamic> userDetailDocument, required Map<String, dynamic> peerDetailDocument}) {
  Map memberMap = {};
  memberMap.addAll({
    userDetailDocument["uid"]: {"status": 0, "pic": userDetailDocument["pic"], "name": userDetailDocument["name"]}
  });
  memberMap.addAll({
    peerDetailDocument["uid"]: {"status": 0, "pic": peerDetailDocument["pic"], "name": peerDetailDocument["name"]}
  });
  return memberMap;
}

Map addCallMember({required Map<String, dynamic> callDocument}) {
  Map memberMap = {};
  memberMap.addAll({
    callDocument["uid"]: {"status": 0, "pic": callDocument["pic"], "name": callDocument["name"]}
  });
  return memberMap;
}

List<String> relationshipStatusList = [
  "Single",
  "In a relationship",
  "Engaged",
  "Married",
  "It's complicated",
  "In an open relationship",
  "Widowed",
  "Separated",
  "Divorced",
];
