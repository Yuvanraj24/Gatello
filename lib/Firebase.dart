// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'Authentication/Authentication.dart';
// import 'Structure.dart';
//
//
// class Write {
//   FirebaseStorage instance = FirebaseStorage.instance;
//   var uid = getUID();
//   Future<TaskSnapshot> personalChat({required String roomId, required Uint8List file, required String fileName, required String contentType}) async =>
//       await instance.ref('personal-chat/$roomId/${(uid + "-" + fileName + "." + contentType.split("/").last).trim()}').putData(file, SettableMetadata(contentType: contentType));
//   Future<TaskSnapshot> groupChat({required String guid, required Uint8List file, required String fileName, required String contentType}) async =>
//       await instance.ref('group-chat/$guid/${(uid + "-" + fileName + "." + contentType.split("/").last).trim()}').putData(file, SettableMetadata(contentType: contentType));
//   Future<TaskSnapshot> userProfile({required String uid, required Uint8List file, required String fileName, required String contentType}) async =>
//       await instance.ref('user-profile/$uid/${(uid + "-" + fileName + "." + contentType.split("/").last).trim()}').putData(file, SettableMetadata(contentType: contentType));
//   Future<TaskSnapshot> groupProfile({required String guid, required Uint8List file, required String fileName, required String contentType}) async =>
//       await instance.ref('group-profile/$guid/${(uid + "-" + fileName + "." + contentType.split("/").last).trim()}').putData(file, SettableMetadata(contentType: contentType));
// }
//
// Future WriteLog(
//     {required String timestamp,
//       //*0->personal chat; 1->group chat
//       required int chatType,
//       required String callerId,
//       //audio or video
//       required int callType,
//       required String channelId,
//       String?name,
//       required DocumentSnapshot<Map<String, dynamic>> document}) async {
//   FirebaseFirestore instance = FirebaseFirestore.instance;
//   String uid = getUID();
//   DocumentSnapshot<Map<String, dynamic>>? userDocumentSnapshot;
//   if (chatType == 0) {
//     userDocumentSnapshot = await instance.collection("user-detail").doc(uid).get();
//   }
//   return await instance.collection("call-logs").doc(timestamp).set({
//     "pic": (chatType == 0) ? null : document.data()!["pic"],
//     "name": (chatType == 0) ? document.data()!["name"] : name??document.data()!["title"],
//     "presentCount": 0,
//     "callerId": callerId,
//     "channelId": channelId,
//     "chatType": chatType,
//     "start-timestamp": timestamp,
//     "end-timestamp": null,
//     "callType": callType,
//     "members": (chatType == 0)
//         ? createCallMember(userDetailDocument: userDocumentSnapshot!.data()!, peerDetailDocument: document.data()!)
//         : createCallMembersGroup(groupDetailDocument: document.data()!, callerUID: uid),
//   });
// }
//
// Future UpdateWriteLog({required String documentId, required String uid, required Map<String, dynamic> userDetailDoc}) async {
//   FirebaseFirestore instance = FirebaseFirestore.instance;
//   DocumentReference<Map<String, dynamic>> callLogDocRef = instance.collection("call-logs").doc(documentId);
//   await instance.runTransaction((transaction) async {
//     DocumentSnapshot<Map<String, dynamic>> callLogDoc = await transaction.get(callLogDocRef);
//     if (Map.from(callLogDoc.data()!["members"]).containsKey(uid) == false) {
//       await transaction.set(callLogDocRef, {"members": addCallMember(callDocument: userDetailDoc)}, SetOptions(merge: true));
//     }
//   });
//   // return await instance.collection("call-logs").doc(documentId).update({"members": addCallMember(callDocument: userDetailDoc)});
// }
