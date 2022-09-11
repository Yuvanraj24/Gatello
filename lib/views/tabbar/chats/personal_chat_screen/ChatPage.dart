import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/test_chat/WallpaperPage.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../../../../Assets/GatelloIcon.dart';
import '../../../../Database/StorageManager.dart';
import '../../../../Firebase.dart';
import '../../../../Firebase/FirebaseNotifications.dart';
import '../../../../Firebase/Writes.dart';
import '../../../../Helpers/DateTimeHelper.dart';
import '../../../../Others/Structure.dart';
import '../../../../Others/components/ExceptionScaffold.dart';
import '../../../../Others/components/LottieComposition.dart';
import '../../../../Others/lottie_strings.dart';
import '../../../../Style/Colors.dart';
import '../../../../Style/Text.dart';
import '../../../../components/AlertDialogBox.dart';
import '../../../../components/AssetPageView.dart';
import '../../../../components/AudioPlayer.dart';
import '../../../../components/Document.dart';
import '../../../../components/Emoji.dart';
import '../../../../components/Gif.dart';
import '../../../../components/MarqueeWidget.dart';
import '../../../../components/RecordButton.dart';
import '../../../../components/ScaffoldDialog.dart';
import '../../../../components/SimpleDialogBox.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/TextField.dart';
import '../../../../components/contacts.dart';
import '../../../../components/flatButton.dart';
import '../../../../handler/Calls.dart';
import '../../../../handler/LifeCycle.dart';
import '../../../../handler/Location.dart';
import '../../../../main.dart';

import '../../../../utils/DynamicLinkParser.dart';
import '../../../ContactList.dart';
import 'ChatDetails.dart';

class ChatPage extends StatefulWidget {

  final String uid;

  ///* peeruid for personal chat and gid for group chat
  final String puid;

  ///*0->user,1->group
  final int state;
  const ChatPage({Key? key, required this.uid, required this.puid, required this.state}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}


class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  late AnimationController voiceRecordAnimationController;
  late AnimationController unreadMessageAnimationController;
  late Animation unreadMessageAnimation;
  late StreamSubscription<
      QuerySnapshot<Map<String, dynamic>>> getLastMessageSub;
  ValueNotifier<String> recordAudioValueNotifier = ValueNotifier<String>("");
  bool isSearching = false;
  Map<int, DocumentSnapshot<Map<String, dynamic>>> messages = {};
  int notUserMessages = 0;
  String? uid;
  bool attachmentShowing = false;
  bool emojiShowing = false;
  Map inverseDataType = dataTypeMap.inverse;
  final focusNode = FocusNode();
  final ScrollController listScrollController = ScrollController();
  bool _isRequesting = false;
  bool _isFinish = false;
  List<DocumentSnapshot<Map<String, dynamic>>> chatList = [];
  StreamController<List<DocumentSnapshot<
      Map<String, dynamic>>>> _streamController = StreamController<
      List<DocumentSnapshot<Map<String, dynamic>>>>();
  StreamController<DocumentSnapshot<
      Map<String, dynamic>>> _chatRoomStreamController = StreamController<
      DocumentSnapshot<Map<String, dynamic>>>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController searchTextEditingController = TextEditingController();
  bool canSend = false;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  int pageLimit = 30;
  bool personalChatRoomDocExists = false;
  Future<DocumentSnapshot<Map<String, dynamic>>>? initUpdateFuture;
  int lastUnreadCount = 0;
  String? lastReadTimestamp;
  var lifecycleEventHandler;

  // List<String> groupMemberIds = [];
  Map? replyMessageMap;
  String? replyUserName;
  String tempPuid = "";
  late final AudioCache _audioCache;
  List recentEmojiList = [];

  // ValueNotifier<int> totalChatCount = ValueNotifier<int>(0);

  Future<void> _getUID() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid");
  }

  final ImagePicker _picker = ImagePicker();

  // Future<DocumentSnapshot<Map<String, dynamic>>>? emptyFuture;
  Future<FilePickerResult?> files() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        // withData: true,
      );

  Future<FilePickerResult?> image() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg'],

        // withData: true,
        // allowedExtensions: ['jpg'],
      );

  Future<FilePickerResult?> video() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        // withData: true,
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mpeg4'],
      );

  Future<FilePickerResult?> audio() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        // withData: true,
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

  // Future lifecycleHandler() async {
  //   String? uid = "s8b6XInslPffQEgz8sVTINsPhcx2";
  //   await instance.collection("user-detail").doc(uid).update({
  //     // "status": DateTime.now().millisecondsSinceEpoch.toString(),
  //     "chattingWith": widget.puid,
  //   });
  //   if (uid != null && WidgetsBinding.instance != null) {
  //     lifecycleEventHandler = LifecycleEventHandler(detachedCallBack: () async {
  //       try {
  //         await instance.collection("user-detail").doc(uid).update({
  //           // "status": DateTime.now().millisecondsSinceEpoch.toString(),
  //           "chattingWith": null,
  //         });
  //       } catch (e) {
  //         log(e.toString());
  //       }
  //     }, resumeCallBack: () async {
  //       try {
  //         await instance.collection("user-detail").doc(uid).update({
  //           // "status": DateTime.now().millisecondsSinceEpoch.toString(),
  //           "chattingWith": widget.puid,
  //         });
  //       } catch (e) {
  //         log(e.toString());
  //       }
  //     });
  //     WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  //   }
  // }

  //*<- user chat stuff starts here ->*//
  userChatRoomDocExists() {
    String roomid = roomId(uid: widget.uid, puid: widget.puid);
    instance.collection("personal-chat-room-detail").doc(roomid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && _chatRoomStreamController.isClosed == false) {
        _chatRoomStreamController.add(snapshot);
        if (snapshot.exists && lastUnreadCount == 0 &&
            lastReadTimestamp == null && personalChatRoomDocExists == false) {
          lastUnreadCount =
              snapshot.data()!["members"]["${widget.uid}"]["unreadCount"] ?? 0;
          lastReadTimestamp =
          snapshot.data()!["members"]["${widget.uid}"]["lastRead"];
          personalChatRoomDocExists = true;
        }
      } else {
        // _chatRoomStreamController.done;
        lastUnreadCount = 0;
        lastReadTimestamp = null;
        personalChatRoomDocExists = false;
      }
    });
  }

  Future initUserMessageUpdate() async {
    if (tempPuid != widget.puid) {
      chatList.clear();
      _isRequesting = false;
      _isFinish = false;
    }
    String roomid = roomId(uid: widget.uid, puid: widget.puid);
    DocumentSnapshot<Map<String, dynamic>> userDetailsDoc = await instance
        .collection("user-detail").doc(widget.uid).get();
    DocumentSnapshot<Map<String, dynamic>> peerDetailsDoc = await instance
        .collection("user-detail").doc(widget.puid).get();
    await instance.collection("user-detail").doc(widget.uid).update({
      "chattingWith": widget.puid,
    });
    await readUserMessages();
    // await readUserMessages().whenComplete(() {
    //   // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    //   return getUserLastMessage();
    // });
    String timestamp = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    if (personalChatRoomDocExists) {
      if (userDetailsDoc.data()!["readRecieptStatus"] == true &&
          peerDetailsDoc.data()!["readRecieptStatus"] == true) {
        instance.collection("personal-chat-room-detail").doc(roomid).update({
          "members.${widget.uid}.lastRead": timestamp,
          "members.${widget.uid}.unreadCount": 0
        });
      } else {
        instance.collection("personal-chat-room-detail").doc(roomid).update(
            {"members.${widget.uid}.unreadCount": 0});
      }
      //!this is poor design.. should use visibility detected and update the message read timestamp.
      if (lastUnreadCount != 0 && lastReadTimestamp != null &&
          userDetailsDoc.data()!["readRecieptStatus"] == true &&
          peerDetailsDoc.data()!["readRecieptStatus"] == true) {
        Future<QuerySnapshot<Map<String, dynamic>>> missedMessages =
        instance.collection("personal-chat").doc(roomid)
            .collection("messages")
            .where("timestamp", isGreaterThanOrEqualTo: lastReadTimestamp)
            .get();
        await missedMessages.then((value) {
          value.docs.forEach((element) {
            if (element.data()["from"] == widget.puid) {
              element.reference.update({
                "read": {"uid": "${widget.uid}", "timestamp": timestamp},
              });
            }
          });
        });
      }
    }
  }

  //!better to find a way to paginate in stream. this optimized the last read of messages and can update a particular message feature

  Future readUserMessages() async {
    // if (tempPuid != widget.puid) {
    //   if (_streamController != null && _streamController.hasListener) {
    //     _streamController.close();
    //   }
    // }
    String roomid = roomId(uid: widget.uid, puid: widget.puid);
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      _isRequesting = true;
      if (chatList.isEmpty) {
        querySnapshot =
        await instance.collection("personal-chat").doc(roomid).collection(
            "messages").orderBy("timestamp", descending: true)
            .limit(pageLimit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("personal-chat")
            .doc(roomid)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .startAfterDocument(chatList.last)
            .limit(pageLimit)
            .get();
      }
      if (querySnapshot != null) {
        // chatList = List.from(querySnapshot.docs.reversed)..addAll(chatList);
        chatList.addAll(querySnapshot.docs);
        if (!_streamController.isClosed) {
          _streamController.add(chatList);
        }
        if (querySnapshot.docs.length < pageLimit) {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }

  getUserLastMessage() {
    String roomid = roomId(uid: widget.uid, puid: widget.puid);
    getLastMessageSub =
        instance.collection("personal-chat").doc(roomid).collection("messages")
            .orderBy("timestamp", descending: true).limit(1).snapshots()
            .listen((event) async {
          if (event.docs.isNotEmpty) {
            if (chatList.isEmpty || chatList.first.id != event.docs.first.id) {
              chatList.insert(0, event.docs.first);
              if (chatList.length >= 1 && personalChatRoomDocExists == false) {
                personalChatRoomDocExists = true;
              }
              // _streamController.add(chatList);

              if (!_streamController.isClosed) {
                _streamController.add(chatList);
              }
              DocumentSnapshot<
                  Map<String, dynamic>> userDetailsDoc = await instance
                  .collection("user-detail").doc(widget.uid).get();
              DocumentSnapshot<
                  Map<String, dynamic>> peerDetailsDoc = await instance
                  .collection("user-detail").doc(widget.puid).get();
              DocumentSnapshot<
                  Map<String, dynamic>> personalRoomDoc = await instance
                  .collection("personal-chat-room-detail").doc(roomid).get();
              // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
              String timestamp = DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString();
              print(DateTime.now().compareTo(getDateTimeSinceEpoch(
                  datetime: event.docs.first.data()["timestamp"])));
              if ((DateTime.now().compareTo(getDateTimeSinceEpoch(
                  datetime: event.docs.first.data()["timestamp"])) == 1) &&
                  ((userDetailsDoc.data()!["readRecieptStatus"] == true &&
                      peerDetailsDoc.data()!["readRecieptStatus"] == true)
                      ? getDateTimeSinceEpoch(
                      datetime: event.docs.first.data()["timestamp"]).compareTo(
                      getDateTimeSinceEpoch(datetime: lastReadTimestamp!)) >= 0
                      : personalRoomDoc.data()!["members"][widget
                      .uid]["unreadCount"] != 0)) {
                if (event.docs.first.data()["from"] == widget.uid) {
                  await _audioCache.play('sendTone.mp3');
                } else {
                  await _audioCache.play('recieveTone.mp3');
                }
              }
              if (personalRoomDoc.data()!["members"][widget
                  .uid]["unreadCount"] != 0) {
                WriteBatch writeBatch = instance.batch();
                if (event.docs[0].data()["from"] == widget.puid &&
                    userDetailsDoc.data()!["readRecieptStatus"] == true &&
                    peerDetailsDoc.data()!["readRecieptStatus"] == true) {
                  writeBatch.update(
                      instance.collection("personal-chat").doc(roomid)
                          .collection("messages")
                          .doc(event.docs[0].id), {
                    "read": {"uid": "${widget.uid}", "timestamp": timestamp},
                  });
                }
                if (userDetailsDoc.data()!["readRecieptStatus"] == true &&
                    peerDetailsDoc.data()!["readRecieptStatus"] == true) {
                  writeBatch
                      .update(
                      instance.collection("personal-chat-room-detail").doc(
                          roomid), {
                    "members.${widget.uid}.lastRead": timestamp,
                    "members.${widget.uid}.unreadCount": 0
                  });
                } else {
                  writeBatch.update(
                      instance.collection("personal-chat-room-detail").doc(
                          roomid), {"members.${widget.uid}.unreadCount": 0});
                }
                writeBatch.commit();
              }

              // if (getDateTimeSinceEpoch(datetime: lastReadTimestamp!).difference(getDateTimeSinceEpoch(datetime: event.docs.first.data()!["timestamp"])).inMicroseconds >= 0 &&
              //     event.docs.first.data()!["from"] == widget.uid) {
              //   await _audioCache.play('sendTone.mp3');
              // } else {
              //   await _audioCache.play('recieveTone.mp3');
              // }
            }
          }
        });
  }
  Future writeUserMessage({
    required int type,
    String? message,
    Uint8List? file,
    String? contentType,
    Map? replyMap,
    // required String? peerChattingWith,
    required String peerName,
    required String? peerPic,
  })
  async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot? taskSnapshot;
    String? url;
    String roomid = roomId(uid: widget.uid, puid: widget.puid);
    if (file != null && type != 0 && contentType != null) {
      taskSnapshot = await Write().personalChat(roomId: roomid, file: file, fileName: timestamp, contentType: contentType);
      url = await taskSnapshot.ref.getDownloadURL();
      log(url);
    } else if ((type == 6 || type == 7 || type == 8) && message != null) {
      url = message;
    }
    WriteBatch writeBatch = instance.batch();
    try {
      if (personalChatRoomDocExists) {
        writeBatch.set(instance.collection("personal-chat").doc(roomid).collection("messages").doc(timestamp), {
          "from": widget.uid,
          "to": widget.puid,
          "timestamp": timestamp,
          "forwardCount": 0,
          "type": dataTypeMap[type],
          "data": dataMap(index: type, data: (type == 0) ? message! : url!),
          "contentType": (type == 1 || type == 2 || type == 3 || type == 4) ? contentType : null,
          "read": {"uid": widget.puid, "timestamp": null},
          "reply": (replyMap != null) ? replyMap : null,
          "delete": {"everyone": false, "personal": null}
        });
        writeBatch.update(instance.collection("personal-chat-room-detail").doc(roomid), {
          "timestamp": timestamp,
          "messageBy": "${widget.uid}",
          "lastMessage": (type == 0) ? message! : dataTypeMap[type],
          "members.${widget.puid}.unreadCount": FieldValue.increment(1),
          "delete": false
        });
        writeBatch.commit();
        DocumentSnapshot<Map<String, dynamic>> peerDocSnap = await instance.collection("user-detail").doc(widget.puid).get();
        DocumentSnapshot<Map<String, dynamic>> userDocSnap = await instance.collection("user-detail").doc(uid).get();
        if (peerDocSnap.data()!["chattingWith"] != uid && peerDocSnap["token"] != null) {
          return await sendNotificationForChat(
              userTokens: [peerDocSnap["token"]],
              name: userDocSnap["name"],
              message: (type == 0) ? message! : dataTypeMap[type]!,
              pic: userDocSnap["pic"],
              state: widget.state,
              uid: uid.toString(),
              puid: widget.puid);
        }
      } else {
        Future<DocumentSnapshot<Map<String, dynamic>>> userDetail = instance.collection("user-detail").doc(widget.uid).get();
        await userDetail.then((value) async {
          if (value.exists && value.data() != null) {
            writeBatch.set(instance.collection("personal-chat-room-detail").doc(roomid), {
              "roomId": roomid,
              "timestamp": timestamp,
              "lastMessage": (type == 0) ? message! : dataTypeMap[type],
              "messageBy": "${widget.uid}",
              "delete": false,
              "members": {
                "${widget.uid}": {
                  "isBlocked": false,
                  "peeruid": "${widget.puid}",
                  "pic": value.data()!["pic"],
                  "name": value.data()!["name"],
                  "lastRead": null,
                  "unreadCount": 0,
                },
                "${widget.puid}": {
                  "isBlocked": false,
                  "peeruid": "${widget.uid}",
                  "pic": peerPic,
                  "name": peerName,
                  "lastRead": null,
                  "unreadCount": 0,
                },
              }
              // "${widget.uid}-peeruid": "${widget.puid}",
              // "${widget.uid}-peername": peerName,
              // "${widget.uid}-name": value.data()!["name"],
              // "${widget.uid}-pic": (value.data()!["pic"] != null) ? value.data()!["pic"].last : null,
              // "${widget.uid}-lastRead": null,
              // "${widget.uid}-blocked": false,
              // "${widget.uid}-unreadCount": 0,
              // "${widget.puid}-peeruid": "${widget.uid}",
              // "${widget.puid}-peername": value.data()!["name"],
              // "${widget.puid}-name": peerName,
              // "${widget.puid}-pic": peerPic,
              // "${widget.puid}-lastRead": null,
              // "${widget.puid}-blocked": false,
              // "${widget.puid}-unreadCount": 1
            });
            // writeBatch.set(
            //     instance.collection("user-detail").doc(widget.uid),
            //     {
            //       "userList": FieldValue.arrayUnion([widget.puid])
            //     },
            //     SetOptions(merge: true));
            // writeBatch.set(
            //     instance.collection("user-detail").doc(widget.puid),
            //     {
            //       "userList": FieldValue.arrayUnion([widget.uid])
            //     },
            //     SetOptions(merge: true));
            // writeBatch.set(
            //     instance.collection("personal-user-list").doc(widget.uid),
            //     {
            //       "userList": FieldValue.arrayUnion([widget.puid])
            //     },
            //     SetOptions(merge: true));
            // writeBatch.set(
            //     instance.collection("personal-user-list").doc(widget.puid),
            //     {
            //       "userList": FieldValue.arrayUnion([widget.uid])
            //     },
            //     SetOptions(merge: true));
            writeBatch.set(instance.collection("personal-chat").doc(roomid).collection("messages").doc(timestamp.toString()), {
              "from": widget.uid,
              "to": widget.puid,
              "timestamp": timestamp,
              "forwardCount": 0,
              "type": dataTypeMap[type],
              "data": dataMap(index: type, data: (type == 0) ? message! : url!),
              "contentType": (type == 1 || type == 2 || type == 3 || type == 4) ? contentType : null,
              "read": {"uid": widget.puid, "timestamp": null},
              "reply": (replyMap != null) ? replyMap : null,
              "delete": {"everyone": false, "personal": null}
            });
            writeBatch.commit();
            DocumentSnapshot<Map<String, dynamic>> peerDocSnap = await instance.collection("user-detail").doc(widget.puid).get();
            DocumentSnapshot<Map<String, dynamic>> userDocSnap = await instance.collection("user-detail").doc(uid).get();
            if (peerDocSnap.data()!["chattingWith"] != uid && peerDocSnap["token"] != null) {
              return await sendNotificationForChat(
                  userTokens: [peerDocSnap["token"]],
                  name: userDocSnap["name"],
                  message: (type == 0) ? message! : dataTypeMap[type]!,
                  pic: userDocSnap["pic"],
                  state: widget.state,
                  uid: uid.toString(),
                  puid: widget.puid);
            }
          } else {
            throw FirebaseException(plugin: "cloud-firestore", code: "no-user-exists",
                message: "This user document doesnt exists. Aborting transaction!.");
          }
        });
      }
    } on FirebaseException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  // Future writeUserMessage({
  //   required int type,
  //   String? message,
  //   Uint8List? file,
  //   String? contentType,
  //   Map? replyMap,
  //   // required String? peerChattingWith,
  //   required String peerName,
  //   required String? peerPic,
  // }) async {
  //   String timestamp = DateTime
  //       .now()
  //       .millisecondsSinceEpoch
  //       .toString();
  //   TaskSnapshot? taskSnapshot;
  //   String? url;
  //   String roomid = roomId(uid: widget.uid, puid: widget.puid);
  //   if (file != null && type != 0 && contentType != null) {
  //     taskSnapshot = await Write().personalChat(roomId: roomid,
  //         file: file,
  //         fileName: timestamp,
  //         contentType: contentType);
  //     url = await taskSnapshot.ref.getDownloadURL();
  //     log(url);
  //   } else if ((type == 6 || type == 7 || type == 8) && message != null) {
  //     url = message;
  //   }
  //   WriteBatch writeBatch = instance.batch();
  //   try {
  //     if (personalChatRoomDocExists) {
  //       writeBatch.set(
  //           instance.collection("personal-chat").doc(roomid).collection(
  //               "messages").doc(timestamp), {
  //         "from": widget.uid,
  //         "to": widget.puid,
  //         "timestamp": timestamp,
  //         "forwardCount": 0,
  //         "type": dataTypeMap[type],
  //         "data": dataMap(index: type, data: (type == 0) ? message! : url!),
  //         "contentType": (type == 1 || type == 2 || type == 3 || type == 4)
  //             ? contentType
  //             : null,
  //         "read": {"uid": widget.puid, "timestamp": null},
  //         "reply": (replyMap != null) ? replyMap : null,
  //         "delete": {"everyone": false, "personal": false}
  //       });
  //       writeBatch.update(
  //           instance.collection("personal-chat-room-detail").doc(roomid), {
  //         "timestamp": timestamp,
  //         "messageBy": "${widget.uid}",
  //         "lastMessage": (type == 0) ? message! : dataTypeMap[type],
  //         "members.${widget.puid}.unreadCount": FieldValue.increment(1),
  //         "delete": false
  //       });
  //       writeBatch.commit();
  //       DocumentSnapshot<Map<String, dynamic>> peerDocSnap = await instance
  //           .collection("user-detail").doc(widget.puid).get();
  //       DocumentSnapshot<Map<String, dynamic>> userDocSnap = await instance
  //           .collection("user-detail").doc(uid).get();
  //       if (peerDocSnap.data()!["chattingWith"] != uid &&
  //           peerDocSnap["token"] != null) {
  //         return await sendNotificationForChat(
  //             userTokens: [peerDocSnap["token"]],
  //             name: userDocSnap["name"],
  //             message: (type == 0) ? message! : dataTypeMap[type]!,
  //             pic: userDocSnap["pic"],
  //             state: widget.state,
  //             uid: uid.toString(),
  //             puid: widget.puid);
  //       }
  //     } else {
  //       Future<DocumentSnapshot<Map<String, dynamic>>> userDetail = instance
  //           .collection("user-detail").doc(widget.uid).get();
  //       await userDetail.then((value) async {
  //         if (value.exists && value.data() != null) {
  //           writeBatch.set(
  //               instance.collection("personal-chat-room-detail").doc(roomid), {
  //             "roomId": roomid,
  //             "timestamp": timestamp,
  //             "lastMessage": (type == 0) ? message! : dataTypeMap[type],
  //             "messageBy": "${widget.uid}",
  //             "delete": false,
  //             "members": {
  //               "${widget.uid}": {
  //                 "isBlocked": false,
  //                 "peeruid": "${widget.puid}",
  //                 "pic": value.data()!["pic"],
  //                 "name": value.data()!["name"],
  //                 "lastRead": null,
  //                 "unreadCount": 0,
  //               },
  //               "${widget.puid}": {
  //                 "isBlocked": false,
  //                 "peeruid": "${widget.uid}",
  //                 "pic": peerPic,
  //                 "name": peerName,
  //                 "lastRead": null,
  //                 "unreadCount": 0,
  //               },
  //             },
  //             "${widget.uid}-peeruid": "${widget.puid}",
  //             "${widget.uid}-peername": peerName,
  //             "${widget.uid}-name": value.data()!["name"],
  //             "${widget.uid}-pic": (value.data()!["pic"] != null) ? value
  //                 .data()!["pic"].last : null,
  //             "${widget.uid}-lastRead": null,
  //             "${widget.uid}-blocked": false,
  //             "${widget.uid}-unreadCount": 0,
  //             "${widget.puid}-peeruid": "${widget.uid}",
  //             "${widget.puid}-peername": value.data()!["name"],
  //             "${widget.puid}-name": peerName,
  //             "${widget.puid}-pic": peerPic,
  //             "${widget.puid}-lastRead": null,
  //             "${widget.puid}-blocked": false,
  //             "${widget.puid}-unreadCount": 1
  //           });
  //           writeBatch.set(
  //               instance.collection("user-detail").doc(widget.uid),
  //               {
  //                 "userList": FieldValue.arrayUnion([widget.puid])
  //               },
  //               SetOptions(merge: true));
  //           writeBatch.set(
  //               instance.collection("user-detail").doc(widget.puid),
  //               {
  //                 "userList": FieldValue.arrayUnion([widget.uid])
  //               },
  //               SetOptions(merge: true));
  //           writeBatch.set(
  //               instance.collection("personal-user-list").doc(widget.uid),
  //               {
  //                 "userList": FieldValue.arrayUnion([widget.puid])
  //               },
  //               SetOptions(merge: true));
  //           writeBatch.set(
  //               instance.collection("personal-user-list").doc(widget.puid),
  //               {
  //                 "userList": FieldValue.arrayUnion([widget.uid])
  //               },
  //               SetOptions(merge: true));
  //           writeBatch.set(
  //               instance.collection("personal-chat").doc(roomid).collection(
  //                   "messages").doc(timestamp.toString()), {
  //             "from": widget.uid,
  //             "to": widget.puid,
  //             "timestamp": timestamp,
  //             "forwardCount": 0,
  //             "type": dataTypeMap[type],
  //             "data": dataMap(index: type, data: (type == 0) ? message! : url!),
  //             "contentType": (type == 1 || type == 2 || type == 3 || type == 4)
  //                 ? contentType
  //                 : null,
  //             "read": {"uid": widget.puid, "timestamp": null},
  //             "reply": (replyMap != null) ? replyMap : null,
  //             "delete": {"everyone": false, "personal": false}
  //           });
  //           writeBatch.commit();
  //           DocumentSnapshot<Map<String, dynamic>> peerDocSnap = await instance
  //               .collection("user-detail").doc(widget.puid).get();
  //           DocumentSnapshot<Map<String, dynamic>> userDocSnap = await instance
  //               .collection("user-detail").doc(uid).get();
  //           if (peerDocSnap.data()!["chattingWith"] != uid &&
  //               peerDocSnap["token"] != null) {
  //             return await sendNotificationForChat(
  //                 userTokens: [peerDocSnap["token"]],
  //                 name: userDocSnap["name"],
  //                 message: (type == 0) ? message! : dataTypeMap[type]!,
  //                 pic: userDocSnap["pic"],
  //                 state: widget.state,
  //                 uid: uid.toString(),
  //                 puid: widget.puid);
  //           }
  //         } else {
  //           throw FirebaseException(plugin: "cloud-firestore",
  //               code: "no-user-exists",
  //               message: "This user document doesnt exists. Aborting transaction!.");
  //         }
  //       });
  //     }
  //   } on FirebaseException catch (e) {
  //     log(e.toString());
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  //*<- user chat stuff ends here ->*//

  //*<- group chat stuff starts here ->*//

  groupDetailDoc() {
    instance.collection("group-detail").doc(widget.puid).snapshots().listen((
        snapshot) {
      if (snapshot.exists && _chatRoomStreamController.isClosed == false) {
        _chatRoomStreamController.add(snapshot);
        // if (groupMemberIds.length != snapshot.data()!["members"].length) {
        //   snapshot.data()!["members"].forEach((String key, value) {
        //     groupMemberIds.add(key);
        //   });
        // }
        if (snapshot.exists && lastUnreadCount == 0 &&
            lastReadTimestamp == null) {
          lastUnreadCount =
              snapshot.data()!["members.${widget.uid}.unreadCount"] ?? 0;
          lastReadTimestamp =
          snapshot.data()!["members.${widget.uid}.lastRead"];
        }
      } else {
        lastUnreadCount = 0;
        lastReadTimestamp = null;
      }
    });
  }

  Future initGroupMessageUpdate() async {
    if (tempPuid != widget.puid) {
      chatList.clear();
      _isRequesting = false;
      _isFinish = false;
    }
    await instance.collection("user-detail").doc(widget.uid).update({
      "chattingWith": widget.puid,
    });
    await readGroupMessages();
    // await readGroupMessages().whenComplete(() {
    //   // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    //   return getGroupLastMessage();
    // });
    String timeStamp = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    try {
      instance.collection("group-detail").doc(widget.puid).update({
        "members.${widget.uid}.lastRead": timeStamp,
        "members.${widget.uid}.unreadCount": 0,
      });
      if (lastUnreadCount != 0 && lastReadTimestamp != null) {
        Future<QuerySnapshot<Map<String, dynamic>>> missedMessages =
        instance.collection("group-chat").doc(widget.puid).collection(
            "messages").where(
            "timestamp", isGreaterThanOrEqualTo: lastReadTimestamp).get();
        await missedMessages.then((value) {
          value.docs.forEach((element) {
            if (element.data()["from"] != widget.uid) {
              element.reference.set({
                "read": FieldValue.arrayUnion([
                  {"uid": widget.uid, "timestamp": timeStamp}
                ]),
              }, SetOptions(merge: true));
            }
          });
        });
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future readGroupMessages() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      _isRequesting = true;
      if (chatList.isEmpty) {
        querySnapshot =
        await instance.collection("group-chat").doc(widget.puid).collection(
            "messages").orderBy("timestamp", descending: true)
            .limit(pageLimit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("group-chat")
            .doc(widget.puid)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .startAfterDocument(chatList.last)
            .limit(pageLimit)
            .get();
      }
      if (querySnapshot != null) {
        // chatList = List.from(querySnapshot.docs.reversed)..addAll(chatList);
        chatList.addAll(querySnapshot.docs);
        if (!_streamController.isClosed) {
          _streamController.add(chatList);
        }
        if (querySnapshot.docs.length < pageLimit) {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }

  getGroupLastMessage() {
    getLastMessageSub =
        instance.collection("group-chat").doc(widget.puid).collection(
            "messages").orderBy("timestamp", descending: true)
            .limit(1)
            .snapshots()
            .listen((event) async {
          if (event.docs.isNotEmpty) {
            if (chatList.isEmpty || chatList.first.id != event.docs.first.id) {
              chatList.insert(0, event.docs.first);
              if (!_streamController.isClosed) {
                _streamController.add(chatList);
              }

              // listScrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              String timestamp = DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString();
              DocumentSnapshot<
                  Map<String, dynamic>> groupDetailDoc = await instance
                  .collection("group-detail").doc(widget.puid).get();

              if ((DateTime.now().compareTo(getDateTimeSinceEpoch(
                  datetime: event.docs.first.data()["timestamp"])) == 1) &&
                  getDateTimeSinceEpoch(
                      datetime: event.docs.first.data()["timestamp"]).compareTo(
                      getDateTimeSinceEpoch(datetime: lastReadTimestamp!)) >=
                      0) {
                if (event.docs.first.data()["from"] == widget.uid) {
                  await _audioCache.play('sendTone.mp3');
                } else {
                  await _audioCache.play('recieveTone.mp3');
                }
              }

              if (groupDetailDoc.data()!["members"][widget
                  .uid]["unreadCount"] != 0) {
                WriteBatch writeBatch = instance.batch();
                if (event.docs.first.data()["from"] != widget.uid) {
                  writeBatch.set(
                      instance.collection("group-chat")
                          .doc(widget.puid)
                          .collection("messages")
                          .doc(event.docs.first.id),
                      {
                        "read": FieldValue.arrayUnion([
                          {"uid": widget.uid, "timestamp": timestamp}
                        ])
                      },
                      SetOptions(merge: true));
                }
                writeBatch.update(
                    instance.collection("group-detail").doc(widget.puid), {
                  "members.${widget.uid}.lastRead": timestamp,
                  "members.${widget.uid}.unreadCount": 0,
                });
                writeBatch.commit();
              }
            }
          }
        });
  }

  Future writeGroupMessage({
    required int type,
    String? message,
    Uint8List? file,
    String? contentType,
    Map? replyMap,
    required String groupName,
    required String? groupPic,
    required Map members,
  }) async {
    String timestamp = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    TaskSnapshot? taskSnapshot;
    String? url;
    if (file != null && type != 0 && contentType != null) {
      taskSnapshot = await Write().groupChat(guid: widget.puid,
          file: file,
          fileName: timestamp,
          contentType: contentType);
      url = await taskSnapshot.ref.getDownloadURL();
    } else if ((type == 6 || type == 7 || type == 8) && message != null) {
      url = message;
    }
    WriteBatch writeBatch = instance.batch();
    try {
      writeBatch.set(
          instance.collection("group-chat").doc(widget.puid).collection(
              "messages").doc(timestamp), {
        "from": widget.uid,
        "timestamp": timestamp,
        "type": dataTypeMap[type],
        "data": dataMap(index: type, data: (type == 0) ? message! : url!),
        "forwardCount": 0,
        "contentType": (type == 1 || type == 2 || type == 3 || type == 4)
            ? contentType
            : null,
        "read": null,
        "reply": (replyMap != null) ? replyMap : null,
        "delete": {"everyone": false, "personal": false}
      });
      writeBatch.set(
          instance.collection("group-detail").doc(widget.puid),
          {
            "timestamp": timestamp,
            "messageBy": "${widget.uid}",
            "lastMessage": (type == 0) ? message! : dataTypeMap[type],
            "delete": false,
            "members": groupWriteMessageMembersMap(members: members),
          },
          SetOptions(merge: true));
      writeBatch.commit();
      DocumentSnapshot<Map<String, dynamic>> userDocSnap = await instance
          .collection("user-detail").doc(uid).get();
      List<String> userToken = [];
      members.forEach((key, value) async {
        DocumentSnapshot<Map<String, dynamic>> peerDocSnap = await instance
            .collection("user-detail").doc(key).get();
        if (peerDocSnap.data()!["chattingWith"] != widget.puid) {
          userToken.add(peerDocSnap.data()!["uid"]);
        }
      });
      await sendNotificationForChat(
          userTokens: userToken,
          name: groupName,
          message: userDocSnap["name"] + ": " + (type == 0)
              ? message!
              : dataTypeMap[type]!,
          pic: groupPic,
          state: widget.state,
          uid: uid.toString(),
          puid: widget.puid);
    } catch (e) {
      log(e.toString());
    }
  }

  //*<- group chat stuff ends here ->*//

  // userChatInit() {
  //   initUpdateFuture = initUserMessageUpdate();
  // }

  // groupChatInit() {
  //   initUpdateFuture = initGroupMessageUpdate();
  // }
  initialiser() async {
    _getUID();
    log("initState");
    if (widget.state == 0) {
      if (tempPuid != widget.puid) {
        initUpdateFuture =
        (widget.state == 0) ? instance.collection("user-detail").doc(
            widget.puid).get() : instance.collection("group-detail").doc(
            widget.puid).get();
        // lifecycleHandler();
        userChatRoomDocExists();
        initUserMessageUpdate();
        getUserLastMessage();
        tempPuid = widget.puid;
      }
    } else {
      if (tempPuid != widget.puid) {
        initUpdateFuture =
        (widget.state == 0) ? instance.collection("user-detail").doc(
            widget.puid).get() : instance.collection("group-detail").doc(
            widget.puid).get();

        //    lifecycleHandler();
        groupDetailDoc();
        initGroupMessageUpdate();
        getGroupLastMessage();
        tempPuid = widget.puid;
      }
    }
    textEditingController.addListener(() {
      if (textEditingController.text.trim() == "") {
        if (canSend) {
          if (!mounted) return;
          setState(() {
            canSend = false;
          });
        }
      } else {
        if (!canSend) {
          if (!mounted) return;
          setState(() {
            canSend = true;
          });
        }
      }
    });
  }

  flusher() async {
    await instance.collection("user-detail").doc(uid).update({
      // "status": DateTime.now().millisecondsSinceEpoch.toString(),
      "chattingWith": null,
    });
    if (lifecycleEventHandler != null) {
      WidgetsBinding.instance!.removeObserver(lifecycleEventHandler);
    }
    await _chatRoomStreamController.close();
    _chatRoomStreamController =
        StreamController<DocumentSnapshot<Map<String, dynamic>>>();
    await _streamController.close();
    _streamController =
        StreamController<List<DocumentSnapshot<Map<String, dynamic>>>>();
    getLastMessageSub.cancel();
    textEditingController.clear();
    await _audioCache.clearAll();
  }

  @override
  void initState() {
    _getUID();
    voiceRecordAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    unreadMessageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    unreadMessageAnimation = ColorTween(
        begin: Color(accent).withOpacity(0.2), end: Color(transparent))
        .animate(unreadMessageAnimationController)
      ..addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    unreadMessageAnimationController.forward();
    unreadMessageAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        setState(() {
          lastUnreadCount = 0;
        });
      }
    });
    // document.onContextMenu.listen((event) => event.preventDefault());
    initialiser();
    _audioCache = AudioCache(
      prefix: 'assets/audio/',
      fixedPlayer: AudioPlayer()
        ..setReleaseMode(ReleaseMode.STOP),
    );
    super.initState();
  }

  @override
  void dispose() {
    voiceRecordAnimationController.dispose();
    unreadMessageAnimationController.dispose();
    flusher();
    textEditingController.dispose();
    listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tempPuid != widget.puid) {
      flusher();
      initialiser();
    }
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: initUpdateFuture!,
        builder: (context, emptyChatRoomDetails) {
          if (emptyChatRoomDetails.connectionState == ConnectionState.done) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _chatRoomStreamController.stream,
                builder: (context, chatRoomSnapshot) {
                  if (chatRoomSnapshot.hasData &&
                      chatRoomSnapshot.connectionState ==
                          ConnectionState.active) {
                    if (widget.state == 0) {
                      // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      //     stream: instance.collection("user-detail").doc(widget.puid).snapshots(),
                      //     builder: (context, userDetailSnapshot) {
                      //       if (userDetailSnapshot.hasData) {
                      return StreamBuilder<
                          List<DocumentSnapshot<Map<String, dynamic>>>>(
                          stream: _streamController.stream,
                          builder: (context, snapshot) {

                            return ResponsiveBuilder(
                                builder: (context, sizingInformation) {

                                  // if (sizingInformation.screenSize == DeviceScreenType.desktop) {
                                  //   Navigator.maybePop(context);
                                  // }
                                  return Scaffold(


                                    // this appbar is for personal

                                    appBar: AppBar(

                                      centerTitle: false,
                                      automaticallyImplyLeading: false,
                                      backgroundColor: (themedata.value.index ==
                                          0)
                                          ? Color.fromRGBO(248, 206, 97, 1)
                                          : Colors.red,
                                      elevation: 0,
                                      leading: (sizingInformation
                                          .deviceScreenType !=
                                          DeviceScreenType.desktop)

                                          ? GestureDetector(
                                        // splashColor: Colors.transparent,
                                        // highlightColor: Colors.transparent,
                                        // hoverColor: Colors.transparent,
                                          onTap: (messages.isNotEmpty)
                                              ? () {
                                            if (!mounted) return;
                                            setState(() {
                                              messages.clear();
                                              notUserMessages = 0;
                                            });
                                          }
                                              : (isSearching)
                                              ? () {
                                            if (!mounted) return;
                                            setState(() {
                                              isSearching = false;
                                              searchTextEditingController
                                                  .clear();
                                            });
                                          }
                                              : () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/pops_asset/back_button.svg',
                                                height: 30.h,
                                                width: 30.w,),
                                            ],
                                          )
                                      )
                                          : null,
                                      actionsIconTheme: IconThemeData(
                                          color: Color.fromRGBO(0, 0, 0, 1)),
                                      actions: (isSearching)
                                          ? null
                                          : (messages.isEmpty)
                                          ? [

                                        //this is a voice-call for appbar
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            onTap: ()  {

                                            },

                                            child: SvgPicture.asset(
                                              'assets/tabbar_icons/tab_view_main/call.svg',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: GestureDetector(
                                            child: SvgPicture.asset(
                                                'assets/tabbar_icons/tab_view_main/video.svg'),
                                            onTap: () {

                                            },

                                          ),
                                        ),


                                        PopupMenuButton(

                                            onSelected: (value) async {
                                              switch (value) {
                                                case 1:
                                                  {
                                                    if (sizingInformation
                                                        .deviceScreenType ==
                                                        DeviceScreenType
                                                            .desktop) {
                                                      //ModifiedByAkash
                                                      return await scaffoldAlertDialogBox(
                                                          context: context,
                                                          page: ChatDetails(
                                                            sizingInformation: sizingInformation,
                                                            uid: widget.uid,
                                                            puid: widget.puid,
                                                            state: 0,
                                                          ));
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                ChatDetails(
                                                                  sizingInformation: sizingInformation,
                                                                  uid: widget
                                                                      .uid,
                                                                  puid: widget
                                                                      .puid,
                                                                  state: 0,
                                                                )),
                                                      );
                                                    }
                                                  }
                                                  break;
                                                case 2:
                                                  {
                                                    if (!mounted) return;
                                                    setState(() {
                                                      isSearching = true;
                                                    });
                                                  }
                                                  break;
                                                case 3:
                                                  {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                WallpaperPageView(
                                                                  roomId: chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["roomId"],
                                                                  type: 0,
                                                                  imageList: [
                                                                    "assets/images/deer.jpg",
                                                                    "assets/images/hand.jpg",
                                                                    "assets/chatLightBg.jpg",
                                                                    "assets/chatDarkBg.jpg"
                                                                  ],
                                                                )));
                                                  }
                                                  break;
                                                case 4:
                                                  {
                                                    //TODOBlock
                                                    await instance.collection(
                                                        "personal-chat-room-detail")
                                                        .doc(
                                                        chatRoomSnapshot.data!
                                                            .data()!["roomId"])
                                                        .update({
                                                      "members.${chatRoomSnapshot
                                                          .data!
                                                          .data()!["members"]["${widget
                                                          .uid}"]["peeruid"]}.isBlocked": (chatRoomSnapshot
                                                          .data!
                                                          .data()!["members"][chatRoomSnapshot
                                                          .data!
                                                          .data()!["members"]["${widget
                                                          .uid}"]["peeruid"]]["isBlocked"] ==
                                                          true)
                                                          ? false
                                                          : true
                                                    });
                                                  }
                                                  break;
                                                default:
                                              }
                                            },
                                            itemBuilder: (context) =>
                                            [
                                              PopupMenuItem(
                                                child: Text("View Contact"),
                                                value: 1,
                                              ),
                                              PopupMenuItem(
                                                child: Text("Search"),
                                                value: 2,
                                              ),
                                              PopupMenuItem(
                                                child: Text("Wallpaper"),
                                                value: 3,
                                              ),
                                              PopupMenuItem(
                                                child: Text(
                                                    ((chatRoomSnapshot.data!
                                                        .data()!["members"]["${widget
                                                        .uid}"]["isBlocked"] ==
                                                        true ||
                                                        chatRoomSnapshot.data!
                                                            .data()!["members"][chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"]["${widget
                                                            .uid}"]["peeruid"]]
                                                        ["isBlocked"] ==
                                                            true))
                                                        ? "Unblock"
                                                        : "Block"),
                                                value: 4,
                                              ),
                                            ])
                                      ]
                                          : [
                                        (messages.length == 1)
                                            ? IconButton(
                                            onPressed: () async {
                                              replyUserName = (widget.uid !=
                                                  messages.entries.first.value
                                                      .data()!["from"])
                                                  ? chatRoomSnapshot.data!
                                                  .data()!["members"]["${widget
                                                  .puid}"]["name"]
                                                  : "You";
                                              if (!mounted) return;
                                              setState(() {
                                                replyMessageMap = replyMap(
                                                    documentId: messages.entries
                                                        .first.value.id,
                                                    documentIndex: (snapshot
                                                        .data!.length + 1) -
                                                        messages.entries.first
                                                            .key,
                                                    fromUid: messages.entries
                                                        .first.value
                                                        .data()!["from"],
                                                    type: messages.entries.first
                                                        .value.data()!["type"],
                                                    data: messages.entries.first
                                                        .value.data()!["data"]);
                                              });
                                              focusNode.requestFocus();
                                              if (!mounted) return;
                                              setState(() {
                                                messages.clear();
                                                notUserMessages = 0;
                                              });
                                            },
                                            icon: Icon(Entypo.reply))
                                            : Container(),
                                        (notUserMessages == 0)
                                            ? IconButton(
                                            onPressed: () async {
                                              await alertDialogBox(
                                                  context: context,
                                                  title: "Delete ${messages
                                                      .length} messages?",
                                                  subtitle: "",
                                                  bodyWidget: IntrinsicWidth(
                                                    child: IntrinsicHeight(
                                                      child: Column(children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: GoogleFonts
                                                                    .inter(
                                                                    textStyle:
                                                                    textStyle(
                                                                        fontSize: 12,
                                                                        color: (themedata
                                                                            .value
                                                                            .index ==
                                                                            0)
                                                                            ? Color(
                                                                            black)
                                                                            : Color(
                                                                            white))),
                                                              )),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: TextButton(
                                                              onPressed: () async {
                                                                String roomid = roomId(
                                                                    uid: widget
                                                                        .uid,
                                                                    puid: widget
                                                                        .puid);
                                                                messages
                                                                    .forEach((
                                                                    key,
                                                                    value) async {
                                                                  await instance
                                                                      .collection(
                                                                      "personal-chat")
                                                                      .doc(
                                                                      roomid)
                                                                      .collection(
                                                                      "messages")
                                                                      .doc(value
                                                                      .data()!["timestamp"])
                                                                      .update({
                                                                    "delete.personal": true,
                                                                  });
                                                                  if (chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["timestamp"] ==
                                                                      value
                                                                          .data()!["timestamp"]) {
                                                                    await instance
                                                                        .collection(
                                                                        "personal-chat-room-detail")
                                                                        .doc(
                                                                        roomid)
                                                                        .update(
                                                                        {
                                                                          "delete": true,
                                                                        });
                                                                  }
                                                                  DocumentSnapshot<
                                                                      Map<
                                                                          String,
                                                                          dynamic>> updatedMessage = await instance
                                                                      .collection(
                                                                      "personal-chat")
                                                                      .doc(
                                                                      roomid)
                                                                      .collection(
                                                                      "messages")
                                                                      .doc(value
                                                                      .data()!["timestamp"])
                                                                      .get();
                                                                  // DocumentSnapshot<Map<String, dynamic>> message =
                                                                  //     chatList[chatList.indexWhere((element) => element.id == value.id)];

                                                                  // chatList[chatList.indexWhere((element) => element.id == value.id)] =
                                                                  //     message.data()!["delete"].update("everyone", (value) => true);
                                                                  chatList[chatList
                                                                      .indexWhere((
                                                                      element) =>
                                                                  element.id ==
                                                                      value
                                                                          .id)] =
                                                                      updatedMessage;
                                                                  _streamController
                                                                      .add(
                                                                      chatList);
                                                                });
                                                                // if(!mounted)return;
                                                                // setState((){});

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Delete for me",
                                                                style: GoogleFonts
                                                                    .inter(
                                                                    textStyle:
                                                                    textStyle(
                                                                        fontSize: 12,
                                                                        color: (themedata
                                                                            .value
                                                                            .index ==
                                                                            0)
                                                                            ? Color(
                                                                            black)
                                                                            : Color(
                                                                            white))),
                                                              )),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: TextButton(
                                                              onPressed: () async {
                                                                String roomid = roomId(
                                                                    uid: widget
                                                                        .uid,
                                                                    puid: widget
                                                                        .puid);
                                                                messages
                                                                    .forEach((
                                                                    key,
                                                                    value) async {
                                                                  await instance
                                                                      .collection(
                                                                      "personal-chat")
                                                                      .doc(
                                                                      roomid)
                                                                      .collection(
                                                                      "messages")
                                                                      .doc(value
                                                                      .data()!["timestamp"])
                                                                      .update({
                                                                    "delete.everyone": true,
                                                                  });
                                                                  if (chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["timestamp"] ==
                                                                      value
                                                                          .data()!["timestamp"]) {
                                                                    await instance
                                                                        .collection(
                                                                        "personal-chat-room-detail")
                                                                        .doc(
                                                                        roomid)
                                                                        .update(
                                                                        {
                                                                          "delete": true,
                                                                        });
                                                                  }
                                                                  DocumentSnapshot<
                                                                      Map<
                                                                          String,
                                                                          dynamic>> updatedMessage = await instance
                                                                      .collection(
                                                                      "personal-chat")
                                                                      .doc(
                                                                      roomid)
                                                                      .collection(
                                                                      "messages")
                                                                      .doc(value
                                                                      .data()!["timestamp"])
                                                                      .get();
                                                                  // DocumentSnapshot<Map<String, dynamic>> message =
                                                                  //     chatList[chatList.indexWhere((element) => element.id == value.id)];

                                                                  // chatList[chatList.indexWhere((element) => element.id == value.id)] =
                                                                  //     message.data()!["delete"].update("everyone", (value) => true);
                                                                  chatList[chatList
                                                                      .indexWhere((
                                                                      element) =>
                                                                  element.id ==
                                                                      value
                                                                          .id)] =
                                                                      updatedMessage;
                                                                  _streamController
                                                                      .add(
                                                                      chatList);
                                                                });
                                                                // if(!mounted)return;
                                                                // setState((){});

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Delete for Everyone",
                                                                style: GoogleFonts
                                                                    .inter(
                                                                    textStyle:
                                                                    textStyle(
                                                                        fontSize: 12,
                                                                        color: (themedata
                                                                            .value
                                                                            .index ==
                                                                            0)
                                                                            ? Color(
                                                                            black)
                                                                            : Color(
                                                                            white))),
                                                              )),
                                                        ),
                                                      ]),
                                                    ),
                                                  ));
                                              if (!mounted) return;
                                              setState(() {
                                                messages.clear();
                                                notUserMessages = 0;
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                            : Container(),
                                        IconButton(
                                            onPressed: () async {
                                              if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                                return await scaffoldAlertDialogBox(
                                                    context: context,
                                                    page: PingsChatView(
                                                      state: 1,
                                                      messages: messages, uid: uid.toString(),
                                                    )).whenComplete(() {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    messages.clear();
                                                    notUserMessages = 0;
                                                  });
                                                });
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => PingsChatView(
                                                          state: 1,
                                                          messages: messages, uid: uid.toString(),
                                                        ))).whenComplete(() {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    messages.clear();
                                                    notUserMessages = 0;
                                                  });
                                                });
                                              }
                                              // if (!mounted) return;
                                              // setState(() {
                                              //   messages.clear();
                                              //   notUserMessages = 0;
                                              // });
                                            },
                                            icon: Icon(Entypo.forward)),
                                      ],
                                      title: (isSearching)
                                          ? searchTextBox()
                                          : GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          if (sizingInformation
                                              .deviceScreenType ==
                                              DeviceScreenType.desktop) {
                                            return await scaffoldAlertDialogBox(
                                                context: context,
                                                page: ChatDetails(
                                                  sizingInformation: sizingInformation,
                                                  uid: widget.uid,
                                                  puid: widget.puid,
                                                  state: 0,
                                                ));
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatDetails(
                                                        sizingInformation: sizingInformation,
                                                        uid: widget.uid,
                                                        puid: widget.puid,
                                                        state: 0,
                                                      )),
                                            );
                                          }
                                        },
                                        child: (messages.isEmpty)
                                            ? Row(
                                          children: [
                                            Container(

                                                width: 35,
                                                height: 35,
                                                child: ClipOval(
                                                  // peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                                  // peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                  child: (chatRoomSnapshot.data!
                                                      .data()!["members"]["${widget
                                                      .puid}"]["pic"] != null)
                                                  // ? Image.network(
                                                  //     chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                  //     fit: BoxFit.cover,
                                                  //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                  //       if (loadingProgress == null) return child;
                                                  //       return Center(
                                                  //         child: CircularProgressIndicator(
                                                  //           value: loadingProgress.expectedTotalBytes != null
                                                  //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  //               : null,
                                                  //         ),
                                                  //       );
                                                  //     },
                                                  //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                                  //   )
                                                      ? CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    fadeInDuration: const Duration(
                                                        milliseconds: 400),
                                                    progressIndicatorBuilder: (
                                                        context, url,
                                                        downloadProgress) =>
                                                        Center(
                                                          child: Container(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                          ),
                                                        ),
                                                    imageUrl: chatRoomSnapshot
                                                        .data!
                                                        .data()!["members"]["${widget
                                                        .puid}"]["pic"],
                                                    errorWidget: (context, url,
                                                        error) => Image.asset(
                                                        "assets/noProfile.jpg",
                                                        fit: BoxFit.cover),
                                                  )
                                                      : Image.asset(
                                                      "assets/noProfile.jpg",
                                                      fit: BoxFit.cover),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  new Text((widget.state == 0)
                                                      ? emptyChatRoomDetails
                                                      .data!.data()!["name"]
                                                      :
                                                  emptyChatRoomDetails.data!
                                                      .data()!["title"],
                                                      style: GoogleFonts.inter(
                                                          textStyle: textStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight
                                                                  .w500,
                                                              color: Colors
                                                                  .black))),
                                                  StreamBuilder<
                                                      DocumentSnapshot<Map<
                                                          String,
                                                          dynamic>>>(
                                                      stream: instance
                                                          .collection(
                                                          "user-detail")
                                                          .doc(widget.puid)
                                                          .snapshots(),
                                                      builder: (context,
                                                          peerSnapshot) {
                                                        return StreamBuilder<
                                                            DocumentSnapshot<
                                                                Map<
                                                                    String,
                                                                    dynamic>>>(
                                                          stream: instance
                                                              .collection(
                                                              "user-detail")
                                                              .doc(widget.uid)
                                                              .snapshots(),
                                                          builder: (context,
                                                              userSnapshot) {
                                                            if (userSnapshot
                                                                .connectionState ==
                                                                ConnectionState
                                                                    .active &&
                                                                peerSnapshot
                                                                    .connectionState ==
                                                                    ConnectionState
                                                                        .active) {
                                                              return MarqueeWidget(
                                                                direction: Axis
                                                                    .horizontal,
                                                                child: Text(
                                                                  (userSnapshot
                                                                      .data!
                                                                      .data()!["onlineStatus"] ==
                                                                      true &&
                                                                      peerSnapshot
                                                                          .data!
                                                                          .data()!["onlineStatus"] ==
                                                                          true)
                                                                      ? (peerSnapshot
                                                                      .data!
                                                                      .data()!["status"] ==
                                                                      "online")
                                                                      ? "Online"
                                                                      : (userSnapshot
                                                                      .data!
                                                                      .data()!["lastseenStatus"] ==
                                                                      false &&
                                                                      peerSnapshot
                                                                          .data!
                                                                          .data()!["lastseenStatus"] ==
                                                                          false)
                                                                      ? "Last seen ${getDateTimeInChat(
                                                                      datetime:
                                                                      getDateTimeSinceEpoch(
                                                                          datetime: peerSnapshot
                                                                              .data!
                                                                              .
                                                                          data()!["status"]))} at ${formatTime(
                                                                      getDateTimeSinceEpoch
                                                                        (datetime: peerSnapshot
                                                                          .data!
                                                                          .data()!["status"]))}"
                                                                      : "Tap here for user info"
                                                                      : "Tap here for user info",
                                                                  style: GoogleFonts
                                                                      .inter(
                                                                      textStyle: textStyle(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color: Color
                                                                              .fromRGBO
                                                                            (0,
                                                                              0,
                                                                              0,
                                                                              1))),
                                                                ),
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
                                                          },
                                                        );
                                                      })
                                                ],
                                              ),
                                            )
                                            // Flexible(
                                            //   child: Column(
                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                            //     children: [
                                            //       Text((widget.state == 0) ? emptyChatRoomDetails.data!.data()!["name"]
                                            //           : emptyChatRoomDetails.data!.data()!["title"],
                                            //           style: GoogleFonts.inter(textStyle: textStyle(fontSize: 16,
                                            //               color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.w500))),
                                            //       StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                            //           stream: instance.collection("user-detail").doc(widget.puid).snapshots(),
                                            //           builder: (context, peerSnapshot) {
                                            //             return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                            //               stream: instance.collection("user-detail").doc(widget.uid).snapshots(),
                                            //               builder: (context, userSnapshot) {
                                            //                 if (userSnapshot.connectionState == ConnectionState.active &&
                                            //                     peerSnapshot.connectionState == ConnectionState.active) {
                                            //
                                            //                   return Text(
                                            //
                                            //                     (userSnapshot.data!.data()!["onlineStatus"] == true &&
                                            //                         peerSnapshot.data!.data()!["onlineStatus"] == true)
                                            //                         ? (peerSnapshot.data!.data()!["status"] == "online")
                                            //                         ? "Online"
                                            //                         : (userSnapshot.data!.data()!["lastseenStatus"] == true &&
                                            //                         peerSnapshot.data!.data()!["lastseenStatus"] == true)
                                            //                         ? "Last seen ${getDateTimeInChat(datetime:
                                            //                     getDateTimeSinceEpoch(datetime: peerSnapshot.data!.data()!["status"]))}"
                                            //                         " at ${formatTime(getDateTimeSinceEpoch(
                                            //                         datetime: peerSnapshot.data!.data()!["status"]))}"
                                            //                         : "Tap here for user info"
                                            //                         : "Tap here for user info",
                                            //                     style: GoogleFonts.inter(
                                            //                         textStyle: textStyle(fontSize: 12, fontWeight: FontWeight.w500,
                                            //                             color: Color.fromRGBO(0, 0, 0, 1))),
                                            //                   );
                                            //                 } else {
                                            //                   return Container();
                                            //                 }
                                            //               },
                                            //             );
                                            //           })
                                            //     ],
                                            //   ),
                                            // )
                                          ],
                                        )
                                            : Text(messages.length.toString() +
                                            " Selected"),
                                      ),
                                    ),
                                    body: Container(
                                      decoration: BoxDecoration(
                                        // color: Color(black),
                                        image: DecorationImage(
                                          image: (Map.from(
                                              chatRoomSnapshot.data!
                                                  .data()!['members']["${widget
                                                  .uid}"]).containsKey(
                                              "wallpaper") == true)
                                              ? (chatRoomSnapshot.data!
                                              .data()!['members']["${widget
                                              .uid}"]["wallpaper"] != null)
                                              ? AssetImage(
                                              chatRoomSnapshot.data!
                                                  .data()!['members']["${widget
                                                  .uid}"]["wallpaper"])
                                              : AssetImage(
                                              (themedata.value.index == 0)
                                                  ? "assets/chatLightBg.jpg"
                                                  : "assets/chatDarkBg.jpg")
                                              : AssetImage(
                                              (themedata.value.index == 0)
                                                  ? "assets/chatLightBg.jpg"
                                                  : "assets/chatDarkBg.jpg"),
                                          fit: BoxFit.cover,
                                          // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: NotificationListener<
                                                ScrollNotification>(
                                                onNotification: (
                                                    ScrollNotification scrollInfo) {
                                                  if (scrollInfo.metrics
                                                      .maxScrollExtent ==
                                                      scrollInfo.metrics
                                                          .pixels) {
                                                    readUserMessages();
                                                  }
                                                  return true;
                                                },
                                                child:
                                                //  StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                                                //     stream: _streamController.stream,
                                                //     builder: (context, snapshot) {
                                                (!snapshot.hasData)
                                                    ? Center(
                                                  child: Text("No messages"),
                                                )
                                                    :

                                                // return Container(
                                                //   width: MediaQuery.of(context).size.width,
                                                //   child: ListView.builder(
                                                //     reverse: true,
                                                //     padding: EdgeInsets.all(10.0),
                                                //     itemBuilder: (context, index) => buildItem(index: index, document: snapshot.data![index], chatRoomSnapshot: chatRoomSnapshot.data!),
                                                //     itemCount: snapshot.data!.length,
                                                //     controller: listScrollController,
                                                //   ),
                                                // );
                                                Container(

                                                  child: GroupedListView(
                                                      sort: false,
                                                      elements: snapshot.data!,
                                                      // groupBy: (DocumentSnapshot<Map<String, dynamic>> element) =>
                                                      //     getDateTimeInChat(datetime: getDateTimeSinceEpoch(datetime: element["timestamp"])),
                                                      groupBy: (
                                                          DocumentSnapshot<Map<
                                                              String,
                                                              dynamic>> element) =>
                                                          DateFormat(
                                                              'yyyy-MM-dd')
                                                              .format(
                                                            tz.TZDateTime.from(
                                                                getDateTimeSinceEpoch(
                                                                    datetime: element["timestamp"]),
                                                                tz.local),
                                                          ),
                                                      reverse: true,
                                                      // padding: EdgeInsets.all(10.0),
                                                      groupHeaderBuilder: (
                                                          DocumentSnapshot<Map<
                                                              String,
                                                              dynamic>> element) =>
                                                          buildGroupHeaderItem(
                                                              element),
                                                      indexedItemBuilder: (
                                                          context,
                                                          DocumentSnapshot<Map<
                                                              String,
                                                              dynamic>> element,
                                                          index) =>
                                                      (sizingInformation
                                                          .deviceScreenType ==
                                                          DeviceScreenType
                                                              .desktop)
                                                          ? GestureDetector(
                                                          behavior: HitTestBehavior
                                                              .opaque,
                                                          child: buildItem(
                                                            document: element,
                                                            chatRoomSnapshot: chatRoomSnapshot
                                                                .data!,
                                                            sizingInformation: sizingInformation,
                                                            // userDetailSnapshot: userDetailSnapshot.data!,
                                                            index: index,
                                                            replyIndex: (snapshot
                                                                .data!.length +
                                                                1) - index,
                                                          ))
                                                          : SwipeTo(
                                                          onRightSwipe: (element
                                                              .data()!["delete"]["everyone"] ==
                                                              true)
                                                              ? null
                                                              : () {
                                                            replyUserName =
                                                            (widget.uid !=
                                                                element
                                                                    .data()!["from"])
                                                                ? chatRoomSnapshot
                                                                .data!
                                                                .data()!["members"]["${widget
                                                                .puid}"]["name"]
                                                                : "You";
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              replyMessageMap =
                                                                  replyMap(
                                                                      documentId: element
                                                                          .id,
                                                                      documentIndex: (snapshot
                                                                          .data!
                                                                          .length +
                                                                          1) -
                                                                          index,
                                                                      fromUid: element
                                                                          .data()!["from"],
                                                                      type: element
                                                                          .data()!["type"],
                                                                      data: element
                                                                          .data()!["data"]);
                                                            });
                                                            focusNode
                                                                .requestFocus();
                                                          },
                                                          child: GestureDetector(
                                                              behavior: HitTestBehavior
                                                                  .opaque,
                                                              onLongPress: (element
                                                                  .data()!["delete"]["everyone"] ==
                                                                  true)
                                                                  ? null
                                                                  : () {
                                                                if (messages
                                                                    .isEmpty ==
                                                                    true) {
                                                                  // if (!mounted) return;
                                                                  // setState(() {
                                                                  // messages.add(element);
                                                                  messages[index] =
                                                                      element;
                                                                  // });
                                                                  if (element
                                                                      .data()!["from"] !=
                                                                      widget
                                                                          .uid) {
                                                                    notUserMessages +=
                                                                    1;
                                                                  }

                                                                  // if (!mounted) return;
                                                                  // setState(() {
                                                                  //   appbarVisible = false;
                                                                  // });
                                                                }
                                                                if (!mounted)
                                                                  return;
                                                                setState(() {
                                                                  if (isSearching) {
                                                                    isSearching =
                                                                    false;
                                                                    searchTextEditingController
                                                                        .clear();
                                                                  }
                                                                });
                                                                log(
                                                                    notUserMessages
                                                                        .toString());
                                                                log(messages
                                                                    .length
                                                                    .toString());
                                                              },
                                                              onTap: () {
                                                                if (messages
                                                                    .isNotEmpty) {
                                                                  if (messages
                                                                      .values
                                                                      .contains(
                                                                      element)) {
                                                                    // if (!mounted) return;
                                                                    // setState(() {
                                                                    messages
                                                                        .remove(
                                                                        messages
                                                                            .inverse[element]);
                                                                    // });
                                                                    if (element
                                                                        .data()!["from"] !=
                                                                        widget
                                                                            .uid) {
                                                                      notUserMessages -=
                                                                      1;
                                                                    }
                                                                  } else {
                                                                    // if (!mounted) return;
                                                                    // setState(() {
                                                                    // messages.add(element);
                                                                    if (element
                                                                        .data()!["delete"]["everyone"] ==
                                                                        false) {
                                                                      messages[index] =
                                                                          element;
                                                                    }
                                                                    // });
                                                                    if (element
                                                                        .data()!["from"] !=
                                                                        widget
                                                                            .uid) {
                                                                      notUserMessages +=
                                                                      1;
                                                                    }
                                                                  }
                                                                  // if (messages.isEmpty) {
                                                                  //   if (!mounted) return;
                                                                  //   setState(() {
                                                                  //     appbarVisible = true;
                                                                  //   });
                                                                  // }
                                                                }
                                                                if (!mounted)
                                                                  return;
                                                                setState(() {});
                                                                log(
                                                                    notUserMessages
                                                                        .toString());
                                                                log(messages
                                                                    .length
                                                                    .toString());
                                                              },
                                                              child: Container(

                                                                color: (index <=
                                                                    lastUnreadCount &&
                                                                    lastUnreadCount !=
                                                                        0)
                                                                    ? unreadMessageAnimation
                                                                    .value
                                                                    : (messages
                                                                    .values
                                                                    .contains(
                                                                    element))
                                                                    ? Color(
                                                                    accent)
                                                                    .withOpacity(
                                                                    0.2)
                                                                    : Color(
                                                                    transparent),
                                                                child: buildItem(
                                                                    sizingInformation: sizingInformation,
                                                                    document: element,
                                                                    // sizingInformation: sizingInformation,
                                                                    chatRoomSnapshot: chatRoomSnapshot
                                                                        .data!,
                                                                    // userDetailSnapshot: userDetailSnapshot.data!,
                                                                    index: index,
                                                                    replyIndex: (snapshot
                                                                        .data!
                                                                        .length +
                                                                        1) -
                                                                        index),
                                                              ))),
                                                      controller: listScrollController,
                                                      useStickyGroupSeparators: true,
                                                      floatingHeader: true,
                                                      order: GroupedListOrder
                                                          .DESC),
                                                )
                                              // }
                                              // }),
                                            ),
                                          ),
                                          Container(

                                            // height: 66,
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (replyMessageMap != null)
                                                    ? Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 20,
                                                      bottom: 8),
                                                  child: Container(

                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        Expanded(
                                                          child: Container(

                                                            padding: EdgeInsets
                                                                .all(8),
                                                            decoration: BoxDecoration(

                                                              color: (themedata
                                                                  .value
                                                                  .index == 0)
                                                                  ? Color(
                                                                  dividerGrey)
                                                                  .withOpacity(
                                                                  .1)
                                                                  : Color(
                                                                  lightBlack)
                                                                  .withOpacity(
                                                                  .1),
                                                              borderRadius: BorderRadius
                                                                  .all(
                                                                Radius.circular(
                                                                    12.0),
                                                              ),
                                                            ),
                                                            child: IntrinsicHeight(
                                                              child: Row(
                                                                children: [
                                                                  Container(

                                                                    color: Color(
                                                                        yellow),
                                                                    width: 4,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Flexible(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                          replyUserName!,
                                                                          style: GoogleFonts
                                                                              .inter(
                                                                            textStyle: textStyle(
                                                                                fontSize: 14,
                                                                                color: Color(
                                                                                    yellow)),
                                                                          ),
                                                                          maxLines: 1,
                                                                          softWrap: true,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 8),
                                                                        Text(
                                                                          (inverseDataType[replyMessageMap!["type"]] ==
                                                                              0)
                                                                              ? replyMessageMap!["data"]["text"]
                                                                              : replyMessageMap!["type"],
                                                                          style: GoogleFonts
                                                                              .inter(
                                                                              textStyle: textStyle(
                                                                                  fontSize: 14)),
                                                                          maxLines: 2,
                                                                          softWrap: true,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .all(8.0),
                                                          child: GestureDetector(
                                                            child: Icon(
                                                                Icons.close,
                                                                size: 30),
                                                            onTap: () {
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                replyMessageMap =
                                                                null;
                                                              });
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                    : Container(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10,
                                                      top: 10),
                                                  child: ((chatRoomSnapshot
                                                      .data!
                                                      .data()!["members"]["${widget
                                                      .uid}"]["isBlocked"] ==
                                                      true ||
                                                      chatRoomSnapshot.data!
                                                          .data()!["members"][chatRoomSnapshot
                                                          .data!
                                                          .data()!["members"]["${widget
                                                          .uid}"]["peeruid"]]
                                                      ["isBlocked"] ==
                                                          true))
                                                      ? Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 5,
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 10),
                                                    child: Text(
                                                        (chatRoomSnapshot.data!
                                                            .data()!["members"]["${widget
                                                            .uid}"]["isBlocked"] ==
                                                            true)
                                                            ? "You are blocked by ${chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"][chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"]["${widget
                                                            .uid}"]["peeruid"]]["name"]}. You cant send text unless you are unblocked by your peer!"
                                                            : "You have blocked ${chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"][chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"]["${widget
                                                            .uid}"]["peeruid"]]["name"]}. You cant send text unless you unblock your peer!",
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: GoogleFonts
                                                            .inter(
                                                            textStyle: textStyle(
                                                                fontSize: 14,
                                                                color: (themedata
                                                                    .value
                                                                    .index == 0)
                                                                    ? Color(
                                                                    materialBlack)
                                                                    : Color(
                                                                    white)))),
                                                  )
                                                      : Column(
                                                    children: [
                                                      Row(
                                                        children: [

                                                          //textField for personal chat
                                                          Flexible(
                                                            child: textField(

                                                                prefix:
                                                                IconButton(
                                                                    splashColor: Colors
                                                                        .transparent,
                                                                    highlightColor: Colors
                                                                        .transparent,
                                                                    hoverColor: Colors
                                                                        .transparent,
                                                                    onPressed: () async {
                                                                      recentEmojiList =
                                                                      await getRecentEmoji();
                                                                      if (!mounted)
                                                                        return;
                                                                      setState(() {
                                                                        if (attachmentShowing) {
                                                                          attachmentShowing =
                                                                          false;
                                                                        }
                                                                        emojiShowing =
                                                                        !emojiShowing;
                                                                        if (!emojiShowing) {
                                                                          focusNode
                                                                              .requestFocus();
                                                                        } else {
                                                                          focusNode
                                                                              .unfocus();
                                                                        }
                                                                      });
                                                                    },
                                                                    icon: Icon(
                                                                        Icons
                                                                            .emoji_emotions_outlined,
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            12,
                                                                            16,
                                                                            29,
                                                                            1))),


                                                                // IconButton(
                                                                //     splashColor: Colors.transparent,
                                                                //     highlightColor: Colors.transparent,
                                                                //     hoverColor: Colors.transparent,
                                                                //     onPressed: () {
                                                                //       if (!mounted) return;
                                                                //       setState(() {
                                                                //         if (emojiShowing) {
                                                                //           emojiShowing = false;
                                                                //         }
                                                                //         attachmentShowing = !attachmentShowing;
                                                                //       });
                                                                //     },
                                                                //     icon: Icon(Icons.attach_file)),
                                                                focusNode: focusNode,
                                                                textStyle: GoogleFonts
                                                                    .inter(
                                                                    textStyle: textStyle(
                                                                        fontSize: 14,
                                                                        color: (themedata
                                                                            .value
                                                                            .index ==
                                                                            0)
                                                                            ? Color(
                                                                            materialBlack)
                                                                            : Color(
                                                                            white))),
                                                                textEditingController: textEditingController,
                                                                hintText: "Ping here...",
                                                                hintStyle: GoogleFonts
                                                                    .inter(
                                                                    textStyle: textStyle(
                                                                        fontSize: 14,
                                                                        color: (themedata
                                                                            .value
                                                                            .index ==
                                                                            0)
                                                                            ? Color(
                                                                            grey)
                                                                            : Color(
                                                                            lightGrey))),
                                                                border: false,
                                                                onSubmitted: (canSend)
                                                                    ? (
                                                                    value) async {
                                                                  if (textEditingController
                                                                      .text
                                                                      .trim() !=
                                                                      "") {
                                                                    await writeUserMessage(
                                                                        type: 0,
                                                                        peerPic: (chatRoomSnapshot
                                                                            .data!
                                                                            .data()!["members"]["${widget
                                                                            .puid}"]["pic"] !=
                                                                            null)
                                                                            ? chatRoomSnapshot
                                                                            .data!
                                                                            .data()!["members"]["${widget
                                                                            .puid}"]["pic"]
                                                                            : null,
                                                                        peerName: chatRoomSnapshot
                                                                            .data!
                                                                            .data()!["members"]["${widget
                                                                            .puid}"]["name"],
                                                                        // peerChattingWith: userDetailSnapshot.data!.data()!["chattingWith"],
                                                                        replyMap: replyMessageMap,
                                                                        message: textEditingController
                                                                            .text);
                                                                    if (replyMessageMap !=
                                                                        null &&
                                                                        replyUserName !=
                                                                            null) {
                                                                      if (!mounted)
                                                                        return;
                                                                      setState(() {
                                                                        replyMessageMap =
                                                                        null;
                                                                        replyUserName =
                                                                        null;
                                                                      });
                                                                    }
                                                                    if (emojiShowing) {
                                                                      if (!mounted)
                                                                        return;
                                                                      setState(() {
                                                                        emojiShowing =
                                                                        false;
                                                                      });
                                                                    }
                                                                    textEditingController
                                                                        .clear();
                                                                  }
                                                                }
                                                                    : null,
                                                                maxLines: 5,
                                                                fillColor: (themedata
                                                                    .value
                                                                    .index == 0)
                                                                    ? Color(
                                                                    white)
                                                                    : Color(
                                                                    lightBlack),
                                                                suffixIcon: Container(

                                                                  width: 80,

                                                                  child: Row(
                                                                    children: [
                                                                      InkWell(
                                                                        child: Image(
                                                                          image: AssetImage(
                                                                              'assets/per_chat_icons/attach_file_icon.png'
                                                                          ),
                                                                          height: 30
                                                                              .h,
                                                                        ),
                                                                        onTap: () {
                                                                          //
                                                                          // if (!mounted) return;
                                                                          // setState(() {
                                                                          //   if (emojiShowing) {
                                                                          //     emojiShowing = false;
                                                                          //   }
                                                                          //   attachmentShowing = !attachmentShowing;
                                                                          // });
                                                                          showModalBottomSheet(
                                                                              backgroundColor: Colors
                                                                                  .transparent,
                                                                              context: context,
                                                                              builder: (
                                                                                  BuildContext context) {
                                                                                return Container(
                                                                                  height: 250,
                                                                                  width: MediaQuery
                                                                                      .of(context)
                                                                                      .size
                                                                                      .width -
                                                                                      20,
                                                                                  child: Card(
                                                                                    shape: RoundedRectangleBorder(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                            15),
                                                                                        side: BorderSide(
                                                                                            color: Color
                                                                                                .fromRGBO(
                                                                                                246,
                                                                                                207,
                                                                                                70,
                                                                                                1))),
                                                                                    color: Color
                                                                                        .fromRGBO(
                                                                                        255, 255,
                                                                                        255, 1),
                                                                                    margin: EdgeInsets
                                                                                        .all(30),
                                                                                    child: Column(
                                                                                        mainAxisAlignment:
                                                                                        MainAxisAlignment
                                                                                            .spaceEvenly,
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment:
                                                                                            MainAxisAlignment
                                                                                                .spaceEvenly,
                                                                                            children: [

                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  if (!mounted) return;
                                                                                                  setState(() {
                                                                                                    attachmentShowing = false;
                                                                                                  });
                                                                                                  // Navigator.pop(context);
                                                                                                  return await files().then((value) async {

                                                                                                    if (value!.files.isNotEmpty) {
                                                                                                      for (var file in value.files) {
                                                                                                        if (file.size < 52428800 && file.bytes != null) {
                                                                                                          if (widget.state == 0) {

                                                                                                            await writeUserMessage(
                                                                                                              type: 4,
                                                                                                              // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                                                              peerName:
                                                                                                              chatRoomSnapshot.data!.data()!["members"]
                                                                                                              ["${widget.puid}"]["name"],
                                                                                                              peerPic:
                                                                                                              chatRoomSnapshot.data!.data()!["members"]
                                                                                                              ["${widget.puid}"]["pic"],
                                                                                                              replyMap: replyMessageMap,
                                                                                                              file: file.bytes,
                                                                                                              contentType: lookupMimeType(file.path!)!,
                                                                                                            );

                                                                                                            if (replyMessageMap != null &&
                                                                                                                replyUserName != null) {
                                                                                                              if (!mounted) return;
                                                                                                              setState(() {
                                                                                                                replyMessageMap = null;
                                                                                                                replyUserName = null;
                                                                                                              });
                                                                                                            }
                                                                                                          } else {
                                                                                                            await writeGroupMessage(
                                                                                                              type: 4,
                                                                                                              members:
                                                                                                              chatRoomSnapshot.data!.data()!["members"],
                                                                                                              file: file.bytes,
                                                                                                              contentType: lookupMimeType(file.path!),
                                                                                                              groupName:
                                                                                                              chatRoomSnapshot.data!.data()!["title"],
                                                                                                              groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                                                                                              replyMap: replyMessageMap,
                                                                                                            );
                                                                                                            if (replyMessageMap != null &&
                                                                                                                replyUserName != null) {
                                                                                                              if (!mounted) return;
                                                                                                              setState(() {
                                                                                                                replyMessageMap = null;
                                                                                                                replyUserName = null;
                                                                                                              });
                                                                                                            }
                                                                                                          }
                                                                                                        } else {

                                                                                                          final snackBar = snackbar(
                                                                                                              content: "File size is greater than 50MB");
                                                                                                          ScaffoldMessenger.of(context)
                                                                                                              .showSnackBar(snackBar);
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  });
                                                                                                },

                                                                                                child: iconCreation(
                                                                                                    "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/doc_image.svg", "Document"),
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  if (!mounted) return;
                                                                                                  setState(() {
                                                                                                    attachmentShowing = false;
                                                                                                  });
                                                                                                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

                                                                                                  // Navigator.pop(context);
                                                                                                  // return await image().then((value) async {
                                                                                                  if (photo != null) {
                                                                                                    int size = await photo.length();
                                                                                                    Uint8List bytes = await photo.readAsBytes();
                                                                                                    // for (var file in value.files) {
                                                                                                    if (size < 52428800 && bytes != null) {
                                                                                                      if (widget.state == 0) {
                                                                                                        await writeUserMessage(
                                                                                                          type: 1,
                                                                                                          // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                                                          peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                                                                                          peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                                                                          replyMap: replyMessageMap,
                                                                                                          file: bytes,
                                                                                                          contentType: "image/" + photo.path.split(".").last,
                                                                                                        );
                                                                                                        if (replyMessageMap != null && replyUserName != null) {
                                                                                                          if (!mounted) return;
                                                                                                          setState(() {
                                                                                                            replyMessageMap = null;
                                                                                                            replyUserName = null;
                                                                                                          });
                                                                                                        }
                                                                                                      } else {
                                                                                                        await writeGroupMessage(
                                                                                                            type: 1,
                                                                                                            members: chatRoomSnapshot.data!.data()!["members"],
                                                                                                            file: bytes,
                                                                                                            replyMap: replyMessageMap,
                                                                                                            contentType: "image/" + photo.path.split(".").last,
                                                                                                            groupName: chatRoomSnapshot.data!.data()!["title"],
                                                                                                            groupPic: chatRoomSnapshot.data!.data()!["pic"]);
                                                                                                        if (replyMessageMap != null && replyUserName != null) {
                                                                                                          if (!mounted) return;
                                                                                                          setState(() {
                                                                                                            replyMessageMap = null;
                                                                                                            replyUserName = null;
                                                                                                          });
                                                                                                        }
                                                                                                      }
                                                                                                    } else {
                                                                                                      final snackBar = snackbar(content: "File size is greater than 50MB");
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                                    }
                                                                                                    // }
                                                                                                  }
                                                                                                  // });
                                                                                                },

                                                                                                child: iconCreation(
                                                                                                    "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/camera_image.svg",
                                                                                                    "Camera"

                                                                                                ),
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  Navigator.pop(context);
                                                                                                  if (!mounted) return;
                                                                                                  setState(() {
                                                                                                    attachmentShowing = false;
                                                                                                  });
                                                                                                  // Navigator.pop(context);

                                                                                                  return await video().then((value) async {
                                                                                                    if (value!.files.isNotEmpty) {
                                                                                                      Navigator.push(
                                                                                                          context,
                                                                                                          MaterialPageRoute(
                                                                                                              builder: (context) => AssetPageView(
                                                                                                                fileList: value.files,
                                                                                                                onPressed: () async {
                                                                                                                  Navigator.pop(context);
                                                                                                                  for (var file in value.files) {
                                                                                                                    if (file.size < 52428800 &&
                                                                                                                        file.bytes != null) {
                                                                                                                      if (widget.state == 0) {
                                                                                                                        await writeUserMessage(
                                                                                                                          type: 2,
                                                                                                                          // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                                                                          peerName: chatRoomSnapshot
                                                                                                                              .data!
                                                                                                                              .data()![
                                                                                                                          "members"][
                                                                                                                          "${widget.puid}"]
                                                                                                                          ["name"],
                                                                                                                          peerPic: chatRoomSnapshot
                                                                                                                              .data!
                                                                                                                              .data()![
                                                                                                                          "members"][
                                                                                                                          "${widget.puid}"]
                                                                                                                          ["pic"],
                                                                                                                          replyMap:
                                                                                                                          replyMessageMap,
                                                                                                                          file: file.bytes,
                                                                                                                          contentType: "video/" +
                                                                                                                              file.extension!,
                                                                                                                        );
                                                                                                                        if (replyMessageMap !=
                                                                                                                            null &&
                                                                                                                            replyUserName !=
                                                                                                                                null) {
                                                                                                                          if (!mounted) return;
                                                                                                                          setState(() {
                                                                                                                            replyMessageMap =
                                                                                                                            null;
                                                                                                                            replyUserName = null;
                                                                                                                          });
                                                                                                                        }
                                                                                                                      } else {
                                                                                                                        await writeGroupMessage(
                                                                                                                            type: 2,
                                                                                                                            members:
                                                                                                                            chatRoomSnapshot
                                                                                                                                .data!
                                                                                                                                .data()![
                                                                                                                            "members"],
                                                                                                                            file: file.bytes,
                                                                                                                            replyMap:
                                                                                                                            replyMessageMap,
                                                                                                                            contentType: "video/" +
                                                                                                                                file.extension!,
                                                                                                                            groupName:
                                                                                                                            chatRoomSnapshot
                                                                                                                                .data!
                                                                                                                                .data()![
                                                                                                                            "title"],
                                                                                                                            groupPic:
                                                                                                                            chatRoomSnapshot
                                                                                                                                .data!
                                                                                                                                .data()![
                                                                                                                            "pic"]);
                                                                                                                        if (replyMessageMap !=
                                                                                                                            null &&
                                                                                                                            replyUserName !=
                                                                                                                                null) {
                                                                                                                          if (!mounted) return;
                                                                                                                          setState(() {
                                                                                                                            replyMessageMap =
                                                                                                                            null;
                                                                                                                            replyUserName = null;
                                                                                                                          });
                                                                                                                        }
                                                                                                                      }
                                                                                                                    } else {
                                                                                                                      final snackBar = snackbar(
                                                                                                                          content:
                                                                                                                          "File size is greater than 50MB");
                                                                                                                      ScaffoldMessenger.of(
                                                                                                                          context)
                                                                                                                          .showSnackBar(snackBar);
                                                                                                                    }
                                                                                                                  }
                                                                                                                },
                                                                                                              )));
                                                                                                    }
                                                                                                  });
                                                                                                },

                                                                                                child: iconCreation(
                                                                                                    "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/gallery_image.svg",
                                                                                                    "Gallery"),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment:
                                                                                            MainAxisAlignment
                                                                                                .spaceEvenly,
                                                                                            children: [
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  if (!mounted) return;
                                                                                                  setState(() {
                                                                                                    attachmentShowing = false;
                                                                                                  });
                                                                                                  // Navigator.pop(context);
                                                                                                  return await audio().then((value) async {
                                                                                                    if (value!.files.isNotEmpty) {
                                                                                                      for (var file in value.files) {
                                                                                                        if (file.size < 52428800 && file.bytes != null) {
                                                                                                          if (widget.state == 0) {

                                                                                                            await writeUserMessage(
                                                                                                              type: 3,
                                                                                                              // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                                                              peerName:
                                                                                                              chatRoomSnapshot.data!.data()!["members"]
                                                                                                              ["${widget.puid}"]["name"],
                                                                                                              peerPic:
                                                                                                              chatRoomSnapshot.data!.data()!["members"]
                                                                                                              ["${widget.puid}"]["pic"],
                                                                                                              replyMap: replyMessageMap,
                                                                                                              file: file.bytes,
                                                                                                              contentType: "audio" + file.extension.toString(),
                                                                                                            );
                                                                                                            print('Success');
                                                                                                            if (replyMessageMap != null &&
                                                                                                                replyUserName != null) {
                                                                                                              if (!mounted) return;
                                                                                                              setState(() {
                                                                                                                replyMessageMap = null;
                                                                                                                replyUserName = null;
                                                                                                              });
                                                                                                            }
                                                                                                          } else {
                                                                                                            await writeGroupMessage(
                                                                                                                type: 3,
                                                                                                                members:
                                                                                                                chatRoomSnapshot.data!.data()!["members"],
                                                                                                                file: file.bytes,
                                                                                                                replyMap: replyMessageMap,
                                                                                                                contentType: "audio/" + file.extension!,
                                                                                                                groupName:
                                                                                                                chatRoomSnapshot.data!.data()!["title"],
                                                                                                                groupPic:
                                                                                                                chatRoomSnapshot.data!.data()!["pic"]);
                                                                                                            if (replyMessageMap != null &&
                                                                                                                replyUserName != null) {
                                                                                                              if (!mounted) return;
                                                                                                              setState(() {
                                                                                                                replyMessageMap = null;
                                                                                                                replyUserName = null;
                                                                                                              });
                                                                                                            }
                                                                                                          }
                                                                                                        } else {
                                                                                                          final snackBar = snackbar(
                                                                                                              content: "File size is greater than 50MB");
                                                                                                          ScaffoldMessenger.of(context)
                                                                                                              .showSnackBar(snackBar);
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  });
                                                                                                },

                                                                                                child: iconCreation(
                                                                                                    "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/audio_image.svg",
                                                                                                    "Audio"),
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  if (!mounted) return;
                                                                                                  setState(() {
                                                                                                    attachmentShowing = false;
                                                                                                  });

                                                                                                  // // Navigator.pop(context);
                                                                                                  return await getUserLocation().then((value) async {
                                                                                                    if (value.item1 != null) {
                                                                                                      return await hereReverseGeocode(value.item1).then((response) async {
                                                                                                        Map<String, dynamic> body = jsonDecode(response.body);
                                                                                                        if (widget.state == 0) {
                                                                                                          await writeUserMessage(
                                                                                                            type: 7,
                                                                                                            // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                                                            peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                                                                                            peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                                                                            replyMap: replyMessageMap,
                                                                                                            message: "https://www.google.com/maps/search/?api=1&query=${value.item1.latitude},${value.item1.longitude}" +
                                                                                                                "\n" +
                                                                                                                body["Response"]['View'][0]["Result"][0]['Location']['Address']['Label'],
                                                                                                          );
                                                                                                          if (replyMessageMap != null && replyUserName != null) {
                                                                                                            if (!mounted) return;
                                                                                                            setState(() {
                                                                                                              replyMessageMap = null;
                                                                                                              replyUserName = null;
                                                                                                            });
                                                                                                          }
                                                                                                        } else {
                                                                                                          await writeGroupMessage(
                                                                                                            type: 7,
                                                                                                            members: chatRoomSnapshot.data!.data()!["members"],
                                                                                                            message: "https://www.google.com/maps/search/?api=1&query=${value.item1.latitude},${value.item1.longitude}" +
                                                                                                                "\n" +
                                                                                                                body["Response"]['View'][0]["Result"][0]['Location']['Address']['Label'],
                                                                                                            groupName: chatRoomSnapshot.data!.data()!["title"],
                                                                                                            groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                                                                                            replyMap: replyMessageMap,
                                                                                                          );
                                                                                                          if (replyMessageMap != null && replyUserName != null) {
                                                                                                            if (!mounted) return;
                                                                                                            setState(() {
                                                                                                              replyMessageMap = null;
                                                                                                              replyUserName = null;
                                                                                                            });
                                                                                                          }
                                                                                                        }
                                                                                                      });
                                                                                                    } else {
                                                                                                      final snackBar = snackbar(content: "Please enable location services");
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                                    }
                                                                                                  });
                                                                                                },

                                                                                                child: iconCreation(
                                                                                                    "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/location_img.svg",
                                                                                                    "Location"),
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  if (!mounted) return;
                                                                                                  setState(() {
                                                                                                    attachmentShowing = false;
                                                                                                  });

                                                                                                  // // Navigator.pop(context);
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactList(state: 1))).then((value) async {
                                                                                                    if (value != null) {
                                                                                                      for (var i in value) {
                                                                                                        if (widget.state == 0) {
                                                                                                          await writeUserMessage(
                                                                                                            type: 8,
                                                                                                            // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                                                            peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                                                                                            peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                                                                            replyMap: replyMessageMap,
                                                                                                            message: i.displayName + "\n" + i.phones[0],
                                                                                                          );
                                                                                                          if (replyMessageMap != null && replyUserName != null) {
                                                                                                            if (!mounted) return;
                                                                                                            setState(() {
                                                                                                              replyMessageMap = null;
                                                                                                              replyUserName = null;
                                                                                                            });
                                                                                                          }
                                                                                                        }
                                                                                                        else {
                                                                                                          await writeGroupMessage(
                                                                                                            type: 8,
                                                                                                            members: chatRoomSnapshot.data!.data()!["members"],
                                                                                                            message: i.displayName + "\n" + i.phones[0],
                                                                                                            groupName: chatRoomSnapshot.data!.data()!["title"],
                                                                                                            groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                                                                                            replyMap: replyMessageMap,
                                                                                                          );
                                                                                                          if (replyMessageMap != null && replyUserName != null) {
                                                                                                            if (!mounted) return;
                                                                                                            setState(() {
                                                                                                              replyMessageMap = null;
                                                                                                              replyUserName = null;
                                                                                                            });
                                                                                                          }
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                  });
                                                                                                },
                                                                                                child: iconCreation(
                                                                                                    "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/contact_img.svg",
                                                                                                    "Contact"),
                                                                                              )
                                                                                            ],
                                                                                          )
                                                                                        ]),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        },
                                                                      ),

                                                                      InkWell(
                                                                        child: Image(
                                                                          image: AssetImage(

                                                                              'assets/per_chat_icons/camera.png'
                                                                          ),
                                                                          height: 30
                                                                              .h,
                                                                        ),
                                                                        onTap: () {

                                                                        },
                                                                      ),

                                                                    ],
                                                                  ),
                                                                )
                                                            ),
                                                          ),


                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(left: 8.0,
                                                                right: 8.0),
                                                            // padding: EdgeInsets.zero,
                                                            child: (canSend)
                                                                ? GestureDetector(
                                                              // elevation: 0,
                                                                child: Container(
                                                                  height: 45,
                                                                  width: 45,
                                                                  clipBehavior: Clip
                                                                      .hardEdge,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        accent),
                                                                  ),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.send,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // padding: EdgeInsets.all(20),
                                                                // shape: CircleBorder(),
                                                                // color: Color(accent),
                                                                onTap: canSend
                                                                    ? () async {
                                                                  if (textEditingController
                                                                      .text
                                                                      .trim() !=
                                                                      "") {
                                                                    await writeUserMessage(
                                                                        type: 0,
                                                                        peerPic: (chatRoomSnapshot
                                                                            .data!
                                                                            .data()!["members"]["${widget
                                                                            .puid}"]["pic"] !=
                                                                            null)
                                                                            ? chatRoomSnapshot
                                                                            .data!
                                                                            .data()!["members"]["${widget
                                                                            .puid}"]["pic"]
                                                                            : null,
                                                                        peerName: chatRoomSnapshot
                                                                            .data!
                                                                            .data()!["members"]["${widget
                                                                            .puid}"]["name"],
                                                                        // peerChattingWith: userDetailSnapshot.data!.data()!["chattingWith"],
                                                                        replyMap: replyMessageMap,
                                                                        message: textEditingController
                                                                            .text);
                                                                    if (replyMessageMap !=
                                                                        null &&
                                                                        replyUserName !=
                                                                            null) {
                                                                      if (!mounted)
                                                                        return;
                                                                      setState(() {
                                                                        replyMessageMap =
                                                                        null;
                                                                        replyUserName =
                                                                        null;
                                                                      });
                                                                    }
                                                                    if (emojiShowing) {
                                                                      if (!mounted)
                                                                        return;
                                                                      setState(() {
                                                                        emojiShowing =
                                                                        false;
                                                                      });
                                                                    }
                                                                    textEditingController
                                                                        .clear();
                                                                  }
                                                                }
                                                                    : null)
                                                                : RecordButton(
                                                                controller: voiceRecordAnimationController,
                                                                valueNotifier: recordAudioValueNotifier,
                                                                function: () async {
                                                                  File file = File(
                                                                      recordAudioValueNotifier
                                                                          .value);
                                                                  if (file
                                                                      .existsSync()) {
                                                                    int length = await file
                                                                        .length();
                                                                    Uint8List bytes = await file
                                                                        .readAsBytes();

                                                                    if (length <
                                                                        52428800) {
                                                                      if (widget
                                                                          .state ==
                                                                          0) {
                                                                        await writeUserMessage(
                                                                          type: 9,
                                                                          // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                          peerName: chatRoomSnapshot
                                                                              .data!
                                                                              .data()!["members"]["${widget
                                                                              .puid}"]["name"],
                                                                          peerPic: chatRoomSnapshot
                                                                              .data!
                                                                              .data()!["members"]["${widget
                                                                              .puid}"]["pic"],
                                                                          replyMap: replyMessageMap,
                                                                          file: bytes,
                                                                          contentType: "audio/" +
                                                                              file
                                                                                  .path
                                                                                  .split(
                                                                                  ".")
                                                                                  .last,
                                                                        );
                                                                        if (replyMessageMap !=
                                                                            null &&
                                                                            replyUserName !=
                                                                                null) {
                                                                          if (!mounted)
                                                                            return;
                                                                          setState(() {
                                                                            replyMessageMap =
                                                                            null;
                                                                            replyUserName =
                                                                            null;
                                                                          });
                                                                        }
                                                                      } else {
                                                                        await writeGroupMessage(
                                                                            type: 9,
                                                                            members: chatRoomSnapshot
                                                                                .data!
                                                                                .data()!["members"],
                                                                            file: bytes,
                                                                            replyMap: replyMessageMap,
                                                                            contentType: "audio/" +
                                                                                file
                                                                                    .path
                                                                                    .split(
                                                                                    ".")
                                                                                    .last,
                                                                            groupName: chatRoomSnapshot
                                                                                .data!
                                                                                .data()!["title"],
                                                                            groupPic: chatRoomSnapshot
                                                                                .data!
                                                                                .data()!["pic"]);
                                                                        if (replyMessageMap !=
                                                                            null &&
                                                                            replyUserName !=
                                                                                null) {
                                                                          if (!mounted)
                                                                            return;
                                                                          setState(() {
                                                                            replyMessageMap =
                                                                            null;
                                                                            replyUserName =
                                                                            null;
                                                                          });
                                                                        }
                                                                      }
                                                                    } else {
                                                                      final snackBar = snackbar(
                                                                          content: "File size is greater than 50MB");
                                                                      ScaffoldMessenger
                                                                          .of(
                                                                          context)
                                                                          .showSnackBar(
                                                                          snackBar);
                                                                    }
                                                                  }
                                                                }),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Offstage(offstage: !emojiShowing,
                                              child: emojiOffstage()),
                                          // Offstage(offstage: !attachmentShowing,
                                          //     child: attachmentOffstage(
                                          //         chatRoomSnapshot: chatRoomSnapshot)),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          });
                    }
                    //   } else {
                    //     return Container();
                    //   }

                    // })
                    else if (widget.state == 1) {
                      if (chatRoomSnapshot.data!.data()!["members"]["${widget
                          .uid}"]["claim"] != "removed") {
                        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //     // stream: instance.collection("user-detail").where("uid", whereIn: groupMemberIds).snapshots(),
                        //     // stream: instance.collection("user-detail").where("uid", whereIn: groupMemberIds).snapshots(),

                        //     builder: (context, userDetailSnapshot) {
                        //       if (userDetailSnapshot.hasData) {
                        //         return
                        return StreamBuilder<List<DocumentSnapshot<Map<
                            String,
                            dynamic>>>>(
                            stream: _streamController.stream,
                            builder: (context, snapshot) {
                              return ResponsiveBuilder(builder: (context,
                                  sizingInformation) {

                                return Scaffold(
                                  appBar: AppBar(
                                    centerTitle: false,
                                    automaticallyImplyLeading: false,
                                    backgroundColor: (themedata.value.index ==
                                        0)
                                        ? Color.fromRGBO(248, 206, 97, 1)
                                        : Colors.red,
                                    elevation: 0,
                                    leading: (sizingInformation
                                        .deviceScreenType !=
                                        DeviceScreenType.desktop)
                                        ? GestureDetector(
                                      // splashColor: Colors.transparent,
                                      // highlightColor: Colors.transparent,
                                      // hoverColor: Colors.transparent,
                                        onTap: (messages.isNotEmpty)
                                            ? () {
                                          if (!mounted) return;
                                          setState(() {
                                            messages.clear();
                                            notUserMessages = 0;
                                          });
                                        }
                                            : (isSearching)
                                            ? () {
                                          if (!mounted) return;
                                          setState(() {
                                            isSearching = false;
                                            searchTextEditingController.clear();
                                          });
                                        }
                                            : () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/pops_asset/back_button.svg',
                                              height: 30.h,
                                              width: 30.w,),
                                          ],
                                        )
                                    )
                                        : null,
                                    actionsIconTheme: IconThemeData(
                                        color: Color.fromRGBO(0, 0, 0, 1)),
                                    actions: (isSearching)
                                        ? null
                                        : (messages.isEmpty)
                                        ? [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          onTap: ()  {

                                          },
                                          child: SvgPicture.asset(
                                            'assets/tabbar_icons/tab_view_main/call.svg',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: GestureDetector(
                                          child: SvgPicture.asset(
                                              'assets/tabbar_icons/tab_view_main/video.svg'),
                                          onTap: () {

                                          },

                                        ),
                                      ),
                                      PopupMenuButton(
                                          onSelected: (value) async {
                                            switch (value) {
                                              case 1:
                                                {
                                                  if (sizingInformation
                                                      .deviceScreenType ==
                                                      DeviceScreenType
                                                          .desktop) {
                                                    return await scaffoldAlertDialogBox(
                                                        context: context,
                                                        page: ChatDetails(
                                                          sizingInformation: sizingInformation,
                                                          uid: widget.uid,
                                                          puid: widget.puid,
                                                          state: 1,
                                                        ));
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatDetails(
                                                                sizingInformation: sizingInformation,
                                                                uid: widget.uid,
                                                                puid: widget
                                                                    .puid,
                                                                state: 1,
                                                              )),
                                                    );
                                                  }
                                                }
                                                break;
                                              case 2:
                                                {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isSearching = true;
                                                  });
                                                }
                                                break;
                                              case 3:
                                                {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WallpaperPageView(
                                                                roomId: chatRoomSnapshot
                                                                    .data!
                                                                    .data()!["gid"],
                                                                type: 1,
                                                                imageList: [
                                                                  "assets/images/deer.jpg",
                                                                  "assets/images/hand.jpg",
                                                                  "assets/chatLightBg.jpg",
                                                                  "assets/chatDarkBg.jpg"
                                                                ],
                                                              )));
                                                }
                                                break;
                                              case 4:
                                                {
                                                  //TODOBlock
                                                  if (chatRoomSnapshot.data!
                                                      .data()!["members"]["${widget
                                                      .uid}"]["claim"] ==
                                                      "member") {
                                                    await instance.collection(
                                                        "group-detail")
                                                        .doc(
                                                        chatRoomSnapshot.data!
                                                            .data()!["gid"])
                                                        .update({
                                                      "members.$uid.isRemoved": true,
                                                      "members.$uid.claim": "removed",
                                                      "members.$uid.unreadCount": 0,
                                                      "members.$uid.lastRead": null,
                                                    })
                                                        .whenComplete(() {
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                      route.isFirst);
                                                    });
                                                  } else {
                                                    final snackBar = snackbar(
                                                        content: "Only members can exit the group!");
                                                    ScaffoldMessenger.of(
                                                        context).showSnackBar(
                                                        snackBar);
                                                  }
                                                }
                                                break;
                                              default:
                                            }
                                          },
                                          itemBuilder: (context) =>
                                          [
                                            PopupMenuItem(
                                              child: Text("Group Info"),
                                              value: 1,
                                            ),
                                            PopupMenuItem(
                                              child: Text("Search"),
                                              value: 2,
                                            ),
                                            PopupMenuItem(
                                              child: Text("Wallpaper"),
                                              value: 3,
                                            ),
                                            PopupMenuItem(
                                              child: Text("Exit Group"),
                                              value: 4,
                                            ),
                                          ])
                                    ]
                                        : [
                                      (messages.length == 1)
                                          ? IconButton(
                                          onPressed: () async {
                                            replyUserName = (widget.uid !=
                                                messages.entries.first.value
                                                    .data()!["from"])
                                                ? chatRoomSnapshot.data!
                                                .data()!["members"]["${widget
                                                .puid}"]["name"]
                                                : "You";
                                            if (!mounted) return;
                                            setState(() {
                                              replyMessageMap = replyMap(
                                                  documentId: messages.entries
                                                      .first.value.id,
                                                  documentIndex: (snapshot.data!
                                                      .length + 1) -
                                                      messages.entries.first
                                                          .key,
                                                  fromUid: messages.entries
                                                      .first.value
                                                      .data()!["from"],
                                                  type: messages.entries.first
                                                      .value.data()!["type"],
                                                  data: messages.entries.first
                                                      .value.data()!["data"]);
                                            });
                                            focusNode.requestFocus();
                                            if (!mounted) return;
                                            setState(() {
                                              messages.clear();
                                              notUserMessages = 0;
                                            });
                                          },
                                          icon: Icon(Entypo.reply))
                                          : Container(),
                                      (notUserMessages == 0)
                                          ? IconButton(
                                          onPressed: () async {
                                            await alertDialogBox(
                                                context: context,
                                                title: "Delete ${messages
                                                    .length} messages?",
                                                subtitle: "",
                                                bodyWidget: IntrinsicWidth(
                                                  child: IntrinsicHeight(
                                                    child: Column(children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: GoogleFonts
                                                                  .inter(
                                                                  textStyle:
                                                                  textStyle(
                                                                      fontSize: 12,
                                                                      color: (themedata
                                                                          .value
                                                                          .index ==
                                                                          0)
                                                                          ? Color(
                                                                          black)
                                                                          : Color(
                                                                          white))),
                                                            )),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: TextButton(
                                                            onPressed: () async {
                                                              messages.forEach((
                                                                  key,
                                                                  value) async {
                                                                await instance
                                                                    .collection(
                                                                    "group-chat")
                                                                    .doc(
                                                                    widget.puid)
                                                                    .collection(
                                                                    "messages")
                                                                    .doc(value
                                                                    .data()!["timestamp"])
                                                                    .update({
                                                                  "delete.everyone": true,
                                                                });
                                                                if (chatRoomSnapshot
                                                                    .data!
                                                                    .data()!["timestamp"] ==
                                                                    value
                                                                        .data()!["timestamp"]) {
                                                                  await instance
                                                                      .collection(
                                                                      "group-detail")
                                                                      .doc(
                                                                      widget
                                                                          .puid)
                                                                      .update({
                                                                    "delete": true,
                                                                  });
                                                                }
                                                                DocumentSnapshot<
                                                                    Map<
                                                                        String,
                                                                        dynamic>> updatedMessage = await instance
                                                                    .collection(
                                                                    "group-chat")
                                                                    .doc(
                                                                    widget.puid)
                                                                    .collection(
                                                                    "messages")
                                                                    .doc(value
                                                                    .data()!["timestamp"])
                                                                    .get();
                                                                DocumentSnapshot<
                                                                    Map<
                                                                        String,
                                                                        dynamic>> message =
                                                                chatList[chatList
                                                                    .indexWhere((
                                                                    element) =>
                                                                element.id ==
                                                                    value.id)];
                                                                chatList[chatList
                                                                    .indexWhere((
                                                                    element) =>
                                                                element.id ==
                                                                    value.id)] =
                                                                    message
                                                                        .data()!["delete"]
                                                                        .update(
                                                                        "everyone", (
                                                                        value) => true);
                                                                chatList[chatList
                                                                    .indexWhere((
                                                                    element) =>
                                                                element.id ==
                                                                    value.id)] =
                                                                    updatedMessage;
                                                                _streamController
                                                                    .add(
                                                                    chatList);
                                                              });
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                messages
                                                                    .clear();
                                                                notUserMessages =
                                                                0;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Delete for Everyone",
                                                              style: GoogleFonts
                                                                  .inter(
                                                                  textStyle:
                                                                  textStyle(
                                                                      fontSize: 12,
                                                                      color: (themedata
                                                                          .value
                                                                          .index ==
                                                                          0)
                                                                          ? Color(
                                                                          black)
                                                                          : Color(
                                                                          white))),
                                                            )),
                                                      ),
                                                    ]),
                                                  ),
                                                ));
                                          },
                                          icon: Icon(Icons.delete))
                                          : Container(),
                                      IconButton(
                                          onPressed: () async {
                                            if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                              return await scaffoldAlertDialogBox(
                                                  context: context,
                                                  page: PingsChatView(
                                                    state: 1,
                                                    messages: messages, uid: uid.toString(),
                                                  )).whenComplete(() {
                                                if (!mounted) return;
                                                setState(() {
                                                  messages.clear();
                                                  notUserMessages = 0;
                                                });
                                              });
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => PingsChatView(
                                                        state: 1,
                                                        messages: messages, uid: uid.toString(),
                                                      ))).whenComplete(() {
                                                if (!mounted) return;
                                                setState(() {
                                                  messages.clear();
                                                  notUserMessages = 0;
                                                });
                                              });
                                            }
                                            // if (!mounted) return;
                                            // setState(() {
                                            //   messages.clear();
                                            //   notUserMessages = 0;
                                            // });
                                          },
                                          icon: Icon(Entypo.forward)),
                                    ],
                                    title: (isSearching)
                                        ? searchTextBox()
                                        : GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        if (sizingInformation
                                            .deviceScreenType ==
                                            DeviceScreenType.desktop) {
                                          return await scaffoldAlertDialogBox(
                                              context: context,
                                              page: ChatDetails(
                                                sizingInformation: sizingInformation,
                                                uid: widget.uid,
                                                puid: widget.puid,
                                                state: 1,
                                              ));
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetails(
                                                      sizingInformation: sizingInformation,
                                                      uid: widget.uid,
                                                      puid: widget.puid,
                                                      state: 1,
                                                    )),
                                          );
                                        }
                                      },
                                      child: (messages.isEmpty)
                                          ? Row(
                                        children: [
                                          Container(
                                              width: 35,
                                              height: 35,
                                              child: ClipOval(
                                                child: (chatRoomSnapshot.data!
                                                    .data()!["pic"] != null)
                                                // ? Image.network(
                                                //     chatRoomSnapshot.data!.data()!["pic"],
                                                //     fit: BoxFit.cover,
                                                //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                //       if (loadingProgress == null) return child;
                                                //       return Center(
                                                //         child: CircularProgressIndicator(
                                                //           value: loadingProgress.expectedTotalBytes != null
                                                //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                //               : null,
                                                //         ),
                                                //       );
                                                //     },
                                                //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noGroupProfile.jpg", fit: BoxFit.cover),
                                                //   )
                                                    ? CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  fadeInDuration: const Duration(
                                                      milliseconds: 400),
                                                  progressIndicatorBuilder: (
                                                      context, url,
                                                      downloadProgress) =>
                                                      Center(
                                                        child: Container(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          child: CircularProgressIndicator(
                                                              value: downloadProgress
                                                                  .progress),
                                                        ),
                                                      ),
                                                  imageUrl: chatRoomSnapshot
                                                      .data!.data()!["pic"],
                                                  errorWidget: (context, url,
                                                      error) => Image.asset(
                                                      "assets/noProfile.jpg",
                                                      fit: BoxFit.cover),
                                                )
                                                    : Image.asset(
                                                    "assets/noProfile.jpg",
                                                    fit: BoxFit.cover),
                                              )

                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                new Text(chatRoomSnapshot.data!
                                                    .data()!["title"],
                                                    style: GoogleFonts.inter(
                                                        textStyle: textStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            color: Colors
                                                                .black))),
                                                MarqueeWidget(
                                                  direction: Axis.horizontal,
                                                  child: Text(
                                                      "Tap here for group info",
                                                      style: GoogleFonts.inter(
                                                          textStyle: textStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight
                                                                  .w500,
                                                              color: Color(
                                                                  grey)))),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                          : Text(messages.length.toString() +
                                          " Selected"),
                                    ),
                                  ),
                                  body: Container(
                                    decoration: BoxDecoration(
                                      // color: Color(black),
                                      image: DecorationImage(
                                        image: (Map.from(chatRoomSnapshot.data!
                                            .data()!['members']["${widget
                                            .uid}"]).containsKey("wallpaper") ==
                                            true)
                                            ? (chatRoomSnapshot.data!
                                            .data()!['members']["${widget
                                            .uid}"]["wallpaper"] != null)
                                            ? AssetImage(chatRoomSnapshot.data!
                                            .data()!['members']["${widget
                                            .uid}"]["wallpaper"])
                                            : AssetImage(
                                            (themedata.value.index == 0)
                                                ? "assets/chatLightBg.jpg"
                                                : "assets/chatDarkBg.jpg")
                                            : AssetImage(
                                            (themedata.value.index == 0)
                                                ? "assets/chatLightBg.jpg"
                                                : "assets/chatDarkBg.jpg"),
                                        fit: BoxFit.cover,
                                        // colorFilter: (themedata.value.index == 0)
                                        //     ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.lighten)
                                        //     : ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: NotificationListener<
                                              ScrollNotification>(
                                              onNotification: (
                                                  ScrollNotification scrollInfo) {
                                                if (scrollInfo.metrics
                                                    .maxScrollExtent ==
                                                    scrollInfo.metrics.pixels) {
                                                  readGroupMessages();
                                                }
                                                return true;
                                              },
                                              child: (!snapshot.hasData)
                                                  ? Center(
                                                child: Text("No messages"),
                                              )
                                                  :
                                              // } else {
                                              // return Container(
                                              //   width: MediaQuery.of(context).size.width,
                                              //   child: ListView.builder(
                                              //     reverse: true,
                                              //     padding: EdgeInsets.all(10.0),
                                              //     itemBuilder: (context, index) => buildItem(index, snapshot.data![index]),
                                              //     itemCount: snapshot.data!.length,
                                              //     controller: listScrollController,
                                              //   ),
                                              // );
                                              Container(
                                                child: GroupedListView(
                                                  elements: snapshot.data!,
                                                  groupBy: (DocumentSnapshot<
                                                      Map<String,
                                                          dynamic>> element) =>
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                        tz.TZDateTime.from(
                                                            getDateTimeSinceEpoch(
                                                                datetime: element["timestamp"]),
                                                            tz.local),
                                                      ),
                                                  sort: false,
                                                  reverse: true,
                                                  // padding: EdgeInsets.all(10.0),
                                                  groupHeaderBuilder: (
                                                      DocumentSnapshot<Map<
                                                          String,
                                                          dynamic>> element) =>
                                                      buildGroupHeaderItem(
                                                          element),
                                                  indexedItemBuilder: (context,
                                                      DocumentSnapshot<Map<
                                                          String,
                                                          dynamic>> element,
                                                      index) =>
                                                  (sizingInformation
                                                      .deviceScreenType ==
                                                      DeviceScreenType.desktop)
                                                      ? GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      child: buildItem(
                                                        document: element,
                                                        chatRoomSnapshot: chatRoomSnapshot
                                                            .data!,
                                                        sizingInformation: sizingInformation,
                                                        // userDetailsSnapshot: userDetailSnapshot.data!,
                                                        // sizingInformation: sizingInformation,
                                                        index: index,
                                                        replyIndex: (snapshot
                                                            .data!.length + 1) -
                                                            index,
                                                      ))
                                                      : SwipeTo(
                                                      onRightSwipe: (element
                                                          .data()!["delete"]["everyone"] ==
                                                          true)
                                                          ? null
                                                          : () {
                                                        chatRoomSnapshot.data!
                                                            .data()!["members"]
                                                            .forEach((k, v) {
                                                          if (widget.uid ==
                                                              element
                                                                  .data()!["from"]) {
                                                            replyUserName =
                                                            "You";
                                                          } else if (k ==
                                                              element
                                                                  .data()!["from"]) {
                                                            replyUserName =
                                                            v["name"];
                                                          }
                                                        });
                                                        if (!mounted) return;
                                                        setState(() {
                                                          replyMessageMap =
                                                              replyMap(
                                                                  documentId: element
                                                                      .id,
                                                                  documentIndex: (snapshot
                                                                      .data!
                                                                      .length +
                                                                      1) -
                                                                      index,
                                                                  fromUid: element
                                                                      .data()!["from"],
                                                                  type: element
                                                                      .data()!["type"],
                                                                  data: element
                                                                      .data()!["data"]);
                                                        });
                                                        focusNode
                                                            .requestFocus();
                                                      },
                                                      child: GestureDetector(
                                                        behavior: HitTestBehavior
                                                            .opaque,
                                                        onLongPress: (element
                                                            .data()!["delete"]["everyone"] ==
                                                            true)
                                                            ? null
                                                            : () {
                                                          if (messages
                                                              .isEmpty ==
                                                              true) {
                                                            // if (!mounted) return;
                                                            // setState(() {
                                                            // messages.add(element);
                                                            messages[index] =
                                                                element;
                                                            // });
                                                            if (element
                                                                .data()!["from"] !=
                                                                widget.uid) {
                                                              notUserMessages +=
                                                              1;
                                                            }

                                                            // if (!mounted) return;
                                                            // setState(() {
                                                            //   appbarVisible = false;
                                                            // });
                                                          }
                                                          if (!mounted) return;
                                                          setState(() {
                                                            if (isSearching) {
                                                              isSearching =
                                                              false;
                                                              searchTextEditingController
                                                                  .clear();
                                                            }
                                                          });
                                                          log(notUserMessages
                                                              .toString());
                                                        },
                                                        onTap: () {
                                                          if (messages
                                                              .isNotEmpty) {
                                                            if (messages.values
                                                                .contains(
                                                                element)) {
                                                              // if (!mounted) return;
                                                              // setState(() {
                                                              messages.remove(
                                                                  messages
                                                                      .inverse[element]);
                                                              // });
                                                              if (element
                                                                  .data()!["from"] !=
                                                                  widget.uid) {
                                                                notUserMessages -=
                                                                1;
                                                              }
                                                            } else {
                                                              // if (!mounted) return;
                                                              // setState(() {
                                                              // messages.add(element);
                                                              if (element
                                                                  .data()!["delete"]["everyone"] ==
                                                                  false) {
                                                                messages[index] =
                                                                    element;
                                                              }
                                                              // });
                                                              if (element
                                                                  .data()!["from"] !=
                                                                  widget.uid) {
                                                                notUserMessages +=
                                                                1;
                                                              }
                                                            }
                                                            // if (messages.isEmpty) {
                                                            //   if (!mounted) return;
                                                            //   setState(() {
                                                            //     appbarVisible = true;
                                                            //   });
                                                            // }
                                                          }
                                                          if (!mounted) return;
                                                          setState(() {});
                                                          log(notUserMessages
                                                              .toString());
                                                        },
                                                        child: Container(
                                                          color: (index <=
                                                              lastUnreadCount &&
                                                              lastUnreadCount !=
                                                                  0)
                                                              ? unreadMessageAnimation
                                                              .value
                                                              : (messages.values
                                                              .contains(
                                                              element))
                                                              ? Color(accent)
                                                              .withOpacity(0.2)
                                                              : Color(
                                                              transparent),
                                                          child: buildItem(
                                                              document: element,
                                                              chatRoomSnapshot: chatRoomSnapshot
                                                                  .data!,
                                                              sizingInformation: sizingInformation,
                                                              // userDetailsSnapshot: userDetailSnapshot.data!,
                                                              // sizingInformation: sizingInformation,
                                                              index: index,
                                                              replyIndex: (snapshot
                                                                  .data!
                                                                  .length + 1) -
                                                                  index),
                                                        ),
                                                      )),
                                                  controller: listScrollController,
                                                  useStickyGroupSeparators: true,
                                                  floatingHeader: true,
                                                  order: GroupedListOrder.DESC,
                                                ),
                                              )
                                            // }
                                            // }),
                                          ),
                                        ),

                                        Container(
                                          // height: 66,
                                          color: Colors.transparent,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (replyMessageMap != null)
                                                  ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 20,
                                                    bottom: 8),
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .all(8),
                                                          decoration: BoxDecoration(
                                                            color: (themedata
                                                                .value.index ==
                                                                0)
                                                                ? Color(
                                                                dividerGrey)
                                                                .withOpacity(.1)
                                                                : Color(
                                                                lightBlack)
                                                                .withOpacity(
                                                                .1),
                                                            borderRadius: BorderRadius
                                                                .all(
                                                              Radius.circular(
                                                                  12.0),
                                                            ),
                                                          ),
                                                          child: IntrinsicHeight(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  color: Color(
                                                                      yellow),
                                                                  width: 4,
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Flexible(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                          replyUserName!,
                                                                          style: GoogleFonts
                                                                              .inter(
                                                                            textStyle: textStyle(
                                                                                fontSize: 14,
                                                                                color: Color(
                                                                                    yellow)),
                                                                          ),
                                                                          maxLines: 1,
                                                                          softWrap: true,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 8),
                                                                        Text(
                                                                          (dataTypeMap
                                                                              .inverse[replyMessageMap!["type"]] ==
                                                                              0)
                                                                              ? replyMessageMap!["data"]["text"]
                                                                              : replyMessageMap!["type"],
                                                                          style: GoogleFonts
                                                                              .inter(
                                                                              textStyle: textStyle(
                                                                                  fontSize: 14)),
                                                                          maxLines: 2,
                                                                          softWrap: true,
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .all(8.0),
                                                        child: GestureDetector(
                                                          child: Icon(
                                                              Icons.close,
                                                              size: 30),
                                                          onTap: () {
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              replyMessageMap =
                                                              null;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                                  : Container(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10,
                                                    top: 10),
                                                child: Row(
                                                  children: [


                                                    Flexible(
                                                      child: textField(
                                                        prefix:IconButton(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            onPressed: () async {
                                                              recentEmojiList =
                                                              await getRecentEmoji();
                                                              if (!mounted) return;
                                                              setState(() {
                                                                if (attachmentShowing) {
                                                                  attachmentShowing =
                                                                  false;
                                                                }
                                                                emojiShowing =
                                                                !emojiShowing;
                                                                if (!emojiShowing) {
                                                                  focusNode
                                                                      .requestFocus();
                                                                } else {
                                                                  focusNode
                                                                      .unfocus();
                                                                }
                                                              });
                                                            },
                                                            icon: Icon(
                                                                Icons
                                                                    .emoji_emotions_outlined,
                                                                color: Color
                                                                    .fromRGBO(
                                                                    12,
                                                                    16,
                                                                    29,
                                                                    1))),
                                                        suffixIcon: Container(

                                                          width: 80,

                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      'assets/per_chat_icons/attach_file_icon.png'
                                                                  ),
                                                                  height: 30
                                                                      .h,
                                                                ),
                                                                onTap: () {
                                                                  if (!mounted) return;
                                                                  setState(() {
                                                                    if (emojiShowing) {
                                                                      emojiShowing = false;
                                                                    }
                                                                    attachmentShowing = !attachmentShowing;
                                                                  });
                                                                  // showModalBottomSheet(
                                                                  //     backgroundColor: Colors
                                                                  //         .transparent,
                                                                  //     context: context,
                                                                  //     builder: (
                                                                  //         BuildContext context) {
                                                                  //       return Container(
                                                                  //         height: 250,
                                                                  //         width: MediaQuery
                                                                  //             .of(context)
                                                                  //             .size
                                                                  //             .width -
                                                                  //             20,
                                                                  //         child: Card(
                                                                  //           shape: RoundedRectangleBorder(
                                                                  //               borderRadius:
                                                                  //               BorderRadius
                                                                  //                   .circular(
                                                                  //                   15),
                                                                  //               side: BorderSide(
                                                                  //                   color: Color
                                                                  //                       .fromRGBO(
                                                                  //                       246,
                                                                  //                       207,
                                                                  //                       70,
                                                                  //                       1))),
                                                                  //           color: Color
                                                                  //               .fromRGBO(
                                                                  //               255, 255,
                                                                  //               255, 1),
                                                                  //           margin: EdgeInsets
                                                                  //               .all(30),
                                                                  //           child: Column(
                                                                  //               mainAxisAlignment:
                                                                  //               MainAxisAlignment
                                                                  //                   .spaceEvenly,
                                                                  //               children: [
                                                                  //                 Row(
                                                                  //                   mainAxisAlignment:
                                                                  //                   MainAxisAlignment
                                                                  //                       .spaceEvenly,
                                                                  //                   children: [
                                                                  //
                                                                  //                     GestureDetector(
                                                                  //                       onTap: () async {
                                                                  //                         if (!mounted) return;
                                                                  //                         setState(() {
                                                                  //                           attachmentShowing = false;
                                                                  //                         });
                                                                  //                         // Navigator.pop(context);
                                                                  //                         return await files().then((value) async {
                                                                  //
                                                                  //                           if (value!.files.isNotEmpty) {
                                                                  //                             for (var file in value.files) {
                                                                  //                               if (file.size < 52428800 && file.bytes != null) {
                                                                  //                                 if (widget.state == 0) {
                                                                  //
                                                                  //                                   await writeUserMessage(
                                                                  //                                     type: 4,
                                                                  //                                     // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  //                                     peerName:
                                                                  //                                     chatRoomSnapshot.data!.data()!["members"]
                                                                  //                                     ["${widget.puid}"]["name"],
                                                                  //                                     peerPic:
                                                                  //                                     chatRoomSnapshot.data!.data()!["members"]
                                                                  //                                     ["${widget.puid}"]["pic"],
                                                                  //                                     replyMap: replyMessageMap,
                                                                  //                                     file: file.bytes,
                                                                  //                                     contentType: lookupMimeType(file.path!)!,
                                                                  //                                   );
                                                                  //
                                                                  //                                   if (replyMessageMap != null &&
                                                                  //                                       replyUserName != null) {
                                                                  //                                     if (!mounted) return;
                                                                  //                                     setState(() {
                                                                  //                                       replyMessageMap = null;
                                                                  //                                       replyUserName = null;
                                                                  //                                     });
                                                                  //                                   }
                                                                  //                                 } else {
                                                                  //                                   await writeGroupMessage(
                                                                  //                                     type: 4,
                                                                  //                                     members:
                                                                  //                                     chatRoomSnapshot.data!.data()!["members"],
                                                                  //                                     file: file.bytes,
                                                                  //                                     contentType: lookupMimeType(file.path!),
                                                                  //                                     groupName:
                                                                  //                                     chatRoomSnapshot.data!.data()!["title"],
                                                                  //                                     groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                                                  //                                     replyMap: replyMessageMap,
                                                                  //                                   );
                                                                  //                                   if (replyMessageMap != null &&
                                                                  //                                       replyUserName != null) {
                                                                  //                                     if (!mounted) return;
                                                                  //                                     setState(() {
                                                                  //                                       replyMessageMap = null;
                                                                  //                                       replyUserName = null;
                                                                  //                                     });
                                                                  //                                   }
                                                                  //                                 }
                                                                  //                               } else {
                                                                  //
                                                                  //                                 final snackBar = snackbar(
                                                                  //                                     content: "File size is greater than 50MB");
                                                                  //                                 ScaffoldMessenger.of(context)
                                                                  //                                     .showSnackBar(snackBar);
                                                                  //                               }
                                                                  //                             }
                                                                  //                           }
                                                                  //                         });
                                                                  //                       },
                                                                  //
                                                                  //                       child: iconCreation(
                                                                  //                           "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/doc_image.svg", "Document"),
                                                                  //                     ),
                                                                  //                     GestureDetector(
                                                                  //                       onTap: () async {
                                                                  //                         if (!mounted) return;
                                                                  //                         setState(() {
                                                                  //                           attachmentShowing = false;
                                                                  //                         });
                                                                  //                         final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                                                  //
                                                                  //                         // Navigator.pop(context);
                                                                  //                         // return await image().then((value) async {
                                                                  //                         if (photo != null) {
                                                                  //                           int size = await photo.length();
                                                                  //                           Uint8List bytes = await photo.readAsBytes();
                                                                  //                           // for (var file in value.files) {
                                                                  //                           if (size < 52428800 && bytes != null) {
                                                                  //                             if (widget.state == 0) {
                                                                  //                               await writeUserMessage(
                                                                  //                                 type: 1,
                                                                  //                                 // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  //                                 peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                                                  //                                 peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                                  //                                 replyMap: replyMessageMap,
                                                                  //                                 file: bytes,
                                                                  //                                 contentType: "image/" + photo.path.split(".").last,
                                                                  //                               );
                                                                  //                               if (replyMessageMap != null && replyUserName != null) {
                                                                  //                                 if (!mounted) return;
                                                                  //                                 setState(() {
                                                                  //                                   replyMessageMap = null;
                                                                  //                                   replyUserName = null;
                                                                  //                                 });
                                                                  //                               }
                                                                  //                             } else {
                                                                  //                               await writeGroupMessage(
                                                                  //                                   type: 1,
                                                                  //                                   members: chatRoomSnapshot.data!.data()!["members"],
                                                                  //                                   file: bytes,
                                                                  //                                   replyMap: replyMessageMap,
                                                                  //                                   contentType: "image/" + photo.path.split(".").last,
                                                                  //                                   groupName: chatRoomSnapshot.data!.data()!["title"],
                                                                  //                                   groupPic: chatRoomSnapshot.data!.data()!["pic"]);
                                                                  //                               if (replyMessageMap != null && replyUserName != null) {
                                                                  //                                 if (!mounted) return;
                                                                  //                                 setState(() {
                                                                  //                                   replyMessageMap = null;
                                                                  //                                   replyUserName = null;
                                                                  //                                 });
                                                                  //                               }
                                                                  //                             }
                                                                  //                           } else {
                                                                  //                             final snackBar = snackbar(content: "File size is greater than 50MB");
                                                                  //                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  //                           }
                                                                  //                           // }
                                                                  //                         }
                                                                  //                         // });
                                                                  //                       },
                                                                  //
                                                                  //                       child: iconCreation(
                                                                  //                           "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/camera_image.svg",
                                                                  //                           "Camera"
                                                                  //
                                                                  //                       ),
                                                                  //                     ),
                                                                  //                     GestureDetector(
                                                                  //                       onTap: () async {
                                                                  //                         Navigator.pop(context);
                                                                  //                         if (!mounted) return;
                                                                  //                         setState(() {
                                                                  //                           attachmentShowing = false;
                                                                  //                         });
                                                                  //                         // Navigator.pop(context);
                                                                  //
                                                                  //                         return await video().then((value) async {
                                                                  //                           if (value!.files.isNotEmpty) {
                                                                  //                             Navigator.push(
                                                                  //                                 context,
                                                                  //                                 MaterialPageRoute(
                                                                  //                                     builder: (context) => AssetPageView(
                                                                  //                                       fileList: value.files,
                                                                  //                                       onPressed: () async {
                                                                  //                                         Navigator.pop(context);
                                                                  //                                         for (var file in value.files) {
                                                                  //                                           if (file.size < 52428800 &&
                                                                  //                                               file.bytes != null) {
                                                                  //                                             if (widget.state == 0) {
                                                                  //                                               await writeUserMessage(
                                                                  //                                                 type: 2,
                                                                  //                                                 // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  //                                                 peerName: chatRoomSnapshot
                                                                  //                                                     .data!
                                                                  //                                                     .data()![
                                                                  //                                                 "members"][
                                                                  //                                                 "${widget.puid}"]
                                                                  //                                                 ["name"],
                                                                  //                                                 peerPic: chatRoomSnapshot
                                                                  //                                                     .data!
                                                                  //                                                     .data()![
                                                                  //                                                 "members"][
                                                                  //                                                 "${widget.puid}"]
                                                                  //                                                 ["pic"],
                                                                  //                                                 replyMap:
                                                                  //                                                 replyMessageMap,
                                                                  //                                                 file: file.bytes,
                                                                  //                                                 contentType: "video/" +
                                                                  //                                                     file.extension!,
                                                                  //                                               );
                                                                  //                                               if (replyMessageMap !=
                                                                  //                                                   null &&
                                                                  //                                                   replyUserName !=
                                                                  //                                                       null) {
                                                                  //                                                 if (!mounted) return;
                                                                  //                                                 setState(() {
                                                                  //                                                   replyMessageMap =
                                                                  //                                                   null;
                                                                  //                                                   replyUserName = null;
                                                                  //                                                 });
                                                                  //                                               }
                                                                  //                                             } else {
                                                                  //                                               await writeGroupMessage(
                                                                  //                                                   type: 2,
                                                                  //                                                   members:
                                                                  //                                                   chatRoomSnapshot
                                                                  //                                                       .data!
                                                                  //                                                       .data()![
                                                                  //                                                   "members"],
                                                                  //                                                   file: file.bytes,
                                                                  //                                                   replyMap:
                                                                  //                                                   replyMessageMap,
                                                                  //                                                   contentType: "video/" +
                                                                  //                                                       file.extension!,
                                                                  //                                                   groupName:
                                                                  //                                                   chatRoomSnapshot
                                                                  //                                                       .data!
                                                                  //                                                       .data()![
                                                                  //                                                   "title"],
                                                                  //                                                   groupPic:
                                                                  //                                                   chatRoomSnapshot
                                                                  //                                                       .data!
                                                                  //                                                       .data()![
                                                                  //                                                   "pic"]);
                                                                  //                                               if (replyMessageMap !=
                                                                  //                                                   null &&
                                                                  //                                                   replyUserName !=
                                                                  //                                                       null) {
                                                                  //                                                 if (!mounted) return;
                                                                  //                                                 setState(() {
                                                                  //                                                   replyMessageMap =
                                                                  //                                                   null;
                                                                  //                                                   replyUserName = null;
                                                                  //                                                 });
                                                                  //                                               }
                                                                  //                                             }
                                                                  //                                           } else {
                                                                  //                                             final snackBar = snackbar(
                                                                  //                                                 content:
                                                                  //                                                 "File size is greater than 50MB");
                                                                  //                                             ScaffoldMessenger.of(
                                                                  //                                                 context)
                                                                  //                                                 .showSnackBar(snackBar);
                                                                  //                                           }
                                                                  //                                         }
                                                                  //                                       },
                                                                  //                                     )));
                                                                  //                           }
                                                                  //                         });
                                                                  //                       },
                                                                  //
                                                                  //                       child: iconCreation(
                                                                  //                           "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/gallery_image.svg",
                                                                  //                           "Gallery"),
                                                                  //                     )
                                                                  //                   ],
                                                                  //                 ),
                                                                  //                 Row(
                                                                  //                   mainAxisAlignment:
                                                                  //                   MainAxisAlignment
                                                                  //                       .spaceEvenly,
                                                                  //                   children: [
                                                                  //                     GestureDetector(
                                                                  //                       onTap: () async {
                                                                  //                         if (!mounted) return;
                                                                  //                         setState(() {
                                                                  //                           attachmentShowing = false;
                                                                  //                         });
                                                                  //                         // Navigator.pop(context);
                                                                  //                         return await audio().then((value) async {
                                                                  //                           if (value!.files.isNotEmpty) {
                                                                  //                             for (var file in value.files) {
                                                                  //                               if (file.size < 52428800 && file.bytes != null) {
                                                                  //                                 if (widget.state == 0) {
                                                                  //
                                                                  //                                   await writeUserMessage(
                                                                  //                                     type: 3,
                                                                  //                                     // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  //                                     peerName:
                                                                  //                                     chatRoomSnapshot.data!.data()!["members"]
                                                                  //                                     ["${widget.puid}"]["name"],
                                                                  //                                     peerPic:
                                                                  //                                     chatRoomSnapshot.data!.data()!["members"]
                                                                  //                                     ["${widget.puid}"]["pic"],
                                                                  //                                     replyMap: replyMessageMap,
                                                                  //                                     file: file.bytes,
                                                                  //                                     contentType: "audio" + file.extension.toString(),
                                                                  //                                   );
                                                                  //                                   print('Success');
                                                                  //                                   if (replyMessageMap != null &&
                                                                  //                                       replyUserName != null) {
                                                                  //                                     if (!mounted) return;
                                                                  //                                     setState(() {
                                                                  //                                       replyMessageMap = null;
                                                                  //                                       replyUserName = null;
                                                                  //                                     });
                                                                  //                                   }
                                                                  //                                 } else {
                                                                  //                                   await writeGroupMessage(
                                                                  //                                       type: 3,
                                                                  //                                       members:
                                                                  //                                       chatRoomSnapshot.data!.data()!["members"],
                                                                  //                                       file: file.bytes,
                                                                  //                                       replyMap: replyMessageMap,
                                                                  //                                       contentType: "audio/" + file.extension!,
                                                                  //                                       groupName:
                                                                  //                                       chatRoomSnapshot.data!.data()!["title"],
                                                                  //                                       groupPic:
                                                                  //                                       chatRoomSnapshot.data!.data()!["pic"]);
                                                                  //                                   if (replyMessageMap != null &&
                                                                  //                                       replyUserName != null) {
                                                                  //                                     if (!mounted) return;
                                                                  //                                     setState(() {
                                                                  //                                       replyMessageMap = null;
                                                                  //                                       replyUserName = null;
                                                                  //                                     });
                                                                  //                                   }
                                                                  //                                 }
                                                                  //                               } else {
                                                                  //                                 final snackBar = snackbar(
                                                                  //                                     content: "File size is greater than 50MB");
                                                                  //                                 ScaffoldMessenger.of(context)
                                                                  //                                     .showSnackBar(snackBar);
                                                                  //                               }
                                                                  //                             }
                                                                  //                           }
                                                                  //                         });
                                                                  //                       },
                                                                  //
                                                                  //                       child: iconCreation(
                                                                  //                           "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/audio_image.svg",
                                                                  //                           "Audio"),
                                                                  //                     ),
                                                                  //                     GestureDetector(
                                                                  //                       onTap: () async {
                                                                  //                         if (!mounted) return;
                                                                  //                         setState(() {
                                                                  //                           attachmentShowing = false;
                                                                  //                         });
                                                                  //
                                                                  //                         // // Navigator.pop(context);
                                                                  //                         return await getUserLocation().then((value) async {
                                                                  //                           if (value.item1 != null) {
                                                                  //                             return await hereReverseGeocode(value.item1).then((response) async {
                                                                  //                               Map<String, dynamic> body = jsonDecode(response.body);
                                                                  //                               if (widget.state == 0) {
                                                                  //                                 await writeUserMessage(
                                                                  //                                   type: 7,
                                                                  //                                   // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  //                                   peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                                                  //                                   peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                                                  //                                   replyMap: replyMessageMap,
                                                                  //                                   message: "https://www.google.com/maps/search/?api=1&query=${value.item1.latitude},${value.item1.longitude}" +
                                                                  //                                       "\n" +
                                                                  //                                       body["Response"]['View'][0]["Result"][0]['Location']['Address']['Label'],
                                                                  //                                 );
                                                                  //                                 if (replyMessageMap != null && replyUserName != null) {
                                                                  //                                   if (!mounted) return;
                                                                  //                                   setState(() {
                                                                  //                                     replyMessageMap = null;
                                                                  //                                     replyUserName = null;
                                                                  //                                   });
                                                                  //                                 }
                                                                  //                               } else {
                                                                  //                                 await writeGroupMessage(
                                                                  //                                   type: 7,
                                                                  //                                   members: chatRoomSnapshot.data!.data()!["members"],
                                                                  //                                   message: "https://www.google.com/maps/search/?api=1&query=${value.item1.latitude},${value.item1.longitude}" +
                                                                  //                                       "\n" +
                                                                  //                                       body["Response"]['View'][0]["Result"][0]['Location']['Address']['Label'],
                                                                  //                                   groupName: chatRoomSnapshot.data!.data()!["title"],
                                                                  //                                   groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                                                  //                                   replyMap: replyMessageMap,
                                                                  //                                 );
                                                                  //                                 if (replyMessageMap != null && replyUserName != null) {
                                                                  //                                   if (!mounted) return;
                                                                  //                                   setState(() {
                                                                  //                                     replyMessageMap = null;
                                                                  //                                     replyUserName = null;
                                                                  //                                   });
                                                                  //                                 }
                                                                  //                               }
                                                                  //                             });
                                                                  //                           } else {
                                                                  //                             final snackBar = snackbar(content: "Please enable location services");
                                                                  //                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  //                           }
                                                                  //                         });
                                                                  //                       },
                                                                  //
                                                                  //                       child: iconCreation(
                                                                  //                           "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/location_img.svg",
                                                                  //                           "Location"),
                                                                  //                     ),
                                                                  //                     GestureDetector(
                                                                  //                       onTap: () async {
                                                                  //
                                                                  //                         // if (!mounted) return;
                                                                  //                         // setState(() {
                                                                  //                         //   attachmentShowing = false;
                                                                  //                         // });
                                                                  //
                                                                  //                         // // Navigator.pop(context);
                                                                  //                         Navigator.push(
                                                                  //                             context,
                                                                  //                             MaterialPageRoute(
                                                                  //                                 builder: (context) => ContactList(state: 1)))
                                                                  //                             .then((value) async {
                                                                  //
                                                                  //                           if (value != null) {
                                                                  //
                                                                  //                             for (var i in value) {
                                                                  //
                                                                  //                               if (widget.state == 0) {
                                                                  //
                                                                  //                                 await writeUserMessage(
                                                                  //                                   type: 8,
                                                                  //                                   // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  //                                   peerName: chatRoomSnapshot.data!
                                                                  //                                       .data()!["members"]["${widget.puid}"]["name"],
                                                                  //                                   peerPic: chatRoomSnapshot.data!.data()!["members"]
                                                                  //                                   ["${widget.puid}"]["pic"],
                                                                  //                                   replyMap: replyMessageMap,
                                                                  //                                   message: i.displayName + "\n" + i.phones[0],
                                                                  //                                 );
                                                                  //
                                                                  //                                 if (replyMessageMap != null &&
                                                                  //                                     replyUserName != null) {
                                                                  //
                                                                  //                                   if (!mounted) return;
                                                                  //                                   setState(() {
                                                                  //
                                                                  //                                     replyMessageMap = null;
                                                                  //                                     replyUserName = null;
                                                                  //                                   });
                                                                  //                                 }
                                                                  //                               } else {
                                                                  //
                                                                  //                                 await writeGroupMessage(
                                                                  //                                   type: 8,
                                                                  //                                   members:
                                                                  //                                   chatRoomSnapshot.data!.data()!["members"],
                                                                  //                                   message: i.displayName + "\n" + i.phones[0],
                                                                  //                                   groupName:
                                                                  //                                   chatRoomSnapshot.data!.data()!["title"],
                                                                  //                                   groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                                                  //                                   replyMap: replyMessageMap,
                                                                  //                                 );
                                                                  //                                 if (replyMessageMap != null &&
                                                                  //                                     replyUserName != null) {
                                                                  //                                   if (!mounted) return;
                                                                  //                                   setState(() {
                                                                  //                                     replyMessageMap = null;
                                                                  //                                     replyUserName = null;
                                                                  //                                   });
                                                                  //                                 }
                                                                  //                               }
                                                                  //                             }
                                                                  //                           }
                                                                  //                         });
                                                                  //                       },
                                                                  //
                                                                  //                       child: iconCreation(
                                                                  //                           "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/contact_img.svg",
                                                                  //                           "Contact"),
                                                                  //                     )
                                                                  //                   ],
                                                                  //                 )
                                                                  //               ]),
                                                                  //         ),
                                                                  //       );
                                                                  //     });
                                                                },
                                                              ),

                                                              InkWell(
                                                                child: Image(
                                                                  image: AssetImage(

                                                                      'assets/per_chat_icons/camera.png'
                                                                  ),
                                                                  height: 30
                                                                      .h,
                                                                ),
                                                                onTap: () {

                                                                },
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        textStyle: GoogleFonts
                                                            .inter(
                                                            textStyle: textStyle(
                                                                fontSize: 14,
                                                                color: (themedata
                                                                    .value
                                                                    .index == 0)
                                                                    ? Color(
                                                                    materialBlack)
                                                                    : Color(
                                                                    white))),
                                                        textEditingController: textEditingController,
                                                        hintText: "Ping here...",

                                                        hintStyle: GoogleFonts
                                                            .inter(
                                                            textStyle: textStyle(
                                                                fontSize: 14,
                                                                color: (themedata
                                                                    .value
                                                                    .index == 0)
                                                                    ? Color(
                                                                    grey)
                                                                    : Color(
                                                                    lightGrey))),
                                                        border: false,
                                                        maxLines: 5,
                                                        onSubmitted: (canSend)
                                                            ? (value) async {
                                                          if (textEditingController
                                                              .text.trim() !=
                                                              "") {
                                                            await writeGroupMessage(
                                                                type: 0,
                                                                members: chatRoomSnapshot
                                                                    .data!
                                                                    .data()!["members"],
                                                                message: textEditingController
                                                                    .text,
                                                                replyMap: replyMessageMap,
                                                                groupName: chatRoomSnapshot
                                                                    .data!
                                                                    .data()!["title"],
                                                                groupPic: chatRoomSnapshot
                                                                    .data!
                                                                    .data()!["pic"]);
                                                            if (replyMessageMap !=
                                                                null &&
                                                                replyUserName !=
                                                                    null) {
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                replyMessageMap =
                                                                null;
                                                                replyUserName =
                                                                null;
                                                              });
                                                            }
                                                            if (emojiShowing) {
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                emojiShowing =
                                                                false;
                                                              });
                                                            }
                                                            textEditingController
                                                                .clear();
                                                          }
                                                        }
                                                            : null,
                                                        fillColor: (themedata
                                                            .value.index == 0)
                                                            ? Color(white)
                                                            : Color(lightBlack),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(left: 8.0,
                                                          right: 8.0),
                                                      child: (canSend)
                                                          ? GestureDetector(
                                                        // elevation: 0,
                                                        // child: Icon(
                                                        //   DeejosIcon.send_outline,
                                                        //   color: (themedata.value.index == 0) ? Color((canSend) ? white : grey) : Color(grey),
                                                        // ),
                                                        // padding: EdgeInsets.all(20),
                                                        // shape: CircleBorder(),
                                                        // color: Color(accent),
                                                          child: Container(
                                                            height: 45,
                                                            width: 45,
                                                            clipBehavior: Clip
                                                                .hardEdge,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                  accent),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.send,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: canSend
                                                              ? () async {
                                                            if (textEditingController
                                                                .text.trim() !=
                                                                "") {
                                                              await writeGroupMessage(
                                                                  type: 0,
                                                                  members: chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["members"],
                                                                  message: textEditingController
                                                                      .text,
                                                                  replyMap: replyMessageMap,
                                                                  groupName: chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["title"],
                                                                  groupPic: chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["pic"]);
                                                              if (replyMessageMap !=
                                                                  null &&
                                                                  replyUserName !=
                                                                      null) {
                                                                if (!mounted)
                                                                  return;
                                                                setState(() {
                                                                  replyMessageMap =
                                                                  null;
                                                                  replyUserName =
                                                                  null;
                                                                });
                                                              }
                                                              if (emojiShowing) {
                                                                if (!mounted)
                                                                  return;
                                                                setState(() {
                                                                  emojiShowing =
                                                                  false;
                                                                });
                                                              }
                                                              textEditingController
                                                                  .clear();
                                                            }
                                                          }
                                                              : null)
                                                          : RecordButton(
                                                          controller: voiceRecordAnimationController,
                                                          valueNotifier: recordAudioValueNotifier,
                                                          function: () async {
                                                            File file = File(
                                                                recordAudioValueNotifier
                                                                    .value);
                                                            if (file
                                                                .existsSync()) {
                                                              int length = await file
                                                                  .length();
                                                              Uint8List bytes = await file
                                                                  .readAsBytes();

                                                              if (length <
                                                                  52428800) {
                                                                if (widget
                                                                    .state ==
                                                                    0) {
                                                                  await writeUserMessage(
                                                                    type: 9,
                                                                    // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                    peerName: chatRoomSnapshot
                                                                        .data!
                                                                        .data()!["members"]["${widget
                                                                        .puid}"]["name"],
                                                                    peerPic: chatRoomSnapshot
                                                                        .data!
                                                                        .data()!["members"]["${widget
                                                                        .puid}"]["pic"],
                                                                    replyMap: replyMessageMap,
                                                                    file: bytes,
                                                                    contentType: "audio/" +
                                                                        file
                                                                            .path
                                                                            .split(
                                                                            ".")
                                                                            .last,
                                                                  );
                                                                  if (replyMessageMap !=
                                                                      null &&
                                                                      replyUserName !=
                                                                          null) {
                                                                    if (!mounted)
                                                                      return;
                                                                    setState(() {
                                                                      replyMessageMap =
                                                                      null;
                                                                      replyUserName =
                                                                      null;
                                                                    });
                                                                  }
                                                                } else {
                                                                  await writeGroupMessage(
                                                                      type: 9,
                                                                      members: chatRoomSnapshot
                                                                          .data!
                                                                          .data()!["members"],
                                                                      file: bytes,
                                                                      replyMap: replyMessageMap,
                                                                      contentType: "audio/" +
                                                                          file
                                                                              .path
                                                                              .split(
                                                                              ".")
                                                                              .last,
                                                                      groupName: chatRoomSnapshot
                                                                          .data!
                                                                          .data()!["title"],
                                                                      groupPic: chatRoomSnapshot
                                                                          .data!
                                                                          .data()!["pic"]);
                                                                  if (replyMessageMap !=
                                                                      null &&
                                                                      replyUserName !=
                                                                          null) {
                                                                    if (!mounted)
                                                                      return;
                                                                    setState(() {
                                                                      replyMessageMap =
                                                                      null;
                                                                      replyUserName =
                                                                      null;
                                                                    });
                                                                  }
                                                                }
                                                              } else {
                                                                final snackBar = snackbar(
                                                                    content: "File size is greater than 50MB");
                                                                ScaffoldMessenger
                                                                    .of(context)
                                                                    .showSnackBar(
                                                                    snackBar);
                                                              }
                                                            }
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Offstage(offstage: !emojiShowing,
                                            child: emojiOffstage()),
                                        // Offstage(offstage: !attachmentShowing,
                                        //     child: attachmentOffstage(
                                        //         chatRoomSnapshot: chatRoomSnapshot)),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      } else {
                        return Container(
                            color: (themedata.value.index == 0) ? Color(
                                lightGrey) : Color(materialBlack),
                            child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      lottieAnimation(notFoundLottie),
                                      Text(
                                          "You have been removed from the group",
                                          style: GoogleFonts.inter(
                                              textStyle:
                                              textStyle(fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: (themedata.value
                                                      .index != 0) ? Color(
                                                      lightGrey) : Color(
                                                      materialBlack)))),
                                      flatButton(
                                          backgroundColor: Color(accent),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Go Back"))
                                    ],
                                  ),
                                )));
                      }
                    } else {
                      return Container();
                    }
                  } else {
                    return ResponsiveBuilder(
                        builder: (context, sizingInformation) {
                          // if (sizingInformation.screenSize == DeviceScreenType.desktop) {
                          //   Navigator.maybePop(context);
                          // }
                          return Scaffold(
                            appBar: AppBar(
                              centerTitle: false,
                              automaticallyImplyLeading: false,
                              backgroundColor: (themedata.value.index == 0)
                                  ? Color(lightGrey)
                                  : Color(materialBlack),
                              elevation: 0,
                              leading: (sizingInformation.deviceScreenType !=
                                  DeviceScreenType.desktop)
                                  ? IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                icon: Icon(Icons.arrow_back),
                              )
                                  : null,
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onPressed: () async {
                                        DocumentSnapshot<Map<String,
                                            dynamic>> peerUserDetailSnapshot = await instance
                                            .collection("user-detail").doc(
                                            widget.puid).get();
                                        DocumentSnapshot<Map<String,
                                            dynamic>> userDetailSnapshot = await instance
                                            .collection("user-detail")
                                            .doc(uid)
                                            .get();
                                        if (peerUserDetailSnapshot
                                            .data()!["callStatus"] == false) {
                                          if (peerUserDetailSnapshot
                                              .data()!["token"] != null) {
                                            String timestamp = DateTime
                                                .now()
                                                .millisecondsSinceEpoch
                                                .toString();
                                            await sendNotificationForCall(
                                                userTokens: [
                                                  peerUserDetailSnapshot
                                                      .data()!["token"]
                                                ],
                                                id: userDetailSnapshot
                                                    .data()!["uid"],
                                                video: true,
                                                timestamp: timestamp,
                                                state: 0,
                                                pic: userDetailSnapshot
                                                    .data()!["pic"],
                                                phoneNumber: userDetailSnapshot
                                                    .data()!["phone"],
                                                name: userDetailSnapshot
                                                    .data()!["name"]);
                                            WriteLog(
                                                timestamp: timestamp,
                                                chatType: 0,
                                                callerId: userDetailSnapshot
                                                    .data()!["phone"],
                                                callType: 2,
                                                channelId: userDetailSnapshot
                                                    .data()!["uid"],
                                                document: peerUserDetailSnapshot);
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => OutgoingPage(
                                            //           profilePics: [peerUserDetailSnapshot.data()!["pic"]],
                                            //           name: peerUserDetailSnapshot.data()!["name"],
                                            //           phone: peerUserDetailSnapshot.data()!["phone"],
                                            //           timestamp: timestamp,
                                            //         )));
                                            //---------------------------------------------------------------------
                                          } else {
                                            toast("User has logged out!");
                                          }
                                        } else {
                                          toast("user is busy right now");
                                        }
                                      },
                                      icon: Icon(
                                        DeejosIcon.video_camera,
                                        size: 17,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onPressed: () async {
                                        DocumentSnapshot<Map<String,
                                            dynamic>> peerUserDetailSnapshot = await instance
                                            .collection("user-detail").doc(
                                            widget.puid).get();
                                        DocumentSnapshot<Map<String,
                                            dynamic>> userDetailSnapshot = await instance
                                            .collection("user-detail")
                                            .doc(uid)
                                            .get();
                                        if (peerUserDetailSnapshot
                                            .data()!["callStatus"] == false) {
                                          if (peerUserDetailSnapshot
                                              .data()!["token"] != null) {
                                            String timestamp = DateTime
                                                .now()
                                                .millisecondsSinceEpoch
                                                .toString();
                                            await sendNotificationForCall(
                                                userTokens: [
                                                  peerUserDetailSnapshot
                                                      .data()!["token"]
                                                ],
                                                id: userDetailSnapshot
                                                    .data()!["uid"],
                                                video: false,
                                                state: 0,
                                                pic: userDetailSnapshot
                                                    .data()!["pic"],
                                                timestamp: timestamp,
                                                phoneNumber: userDetailSnapshot
                                                    .data()!["phone"],
                                                name: userDetailSnapshot
                                                    .data()!["name"]);
                                            WriteLog(
                                                timestamp: timestamp,
                                                chatType: 0,
                                                callerId: userDetailSnapshot
                                                    .data()!["phone"],
                                                callType: 3,
                                                channelId: userDetailSnapshot
                                                    .data()!["uid"],
                                                document: peerUserDetailSnapshot);

                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => OutgoingPage(
                                            //           profilePics: [peerUserDetailSnapshot.data()!["pic"]],
                                            //           name: peerUserDetailSnapshot.data()!["name"],
                                            //           phone: peerUserDetailSnapshot.data()!["phone"],
                                            //           timestamp: timestamp,
                                            //         )));
                                            //------------------------------------------------------------
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => CallPage(
                                            //             channelName: userDetailSnapshot.data()!["uid"],
                                            //             startTimestamp: timestamp,
                                            //             video: false,
                                            //             title: userDetailSnapshot.data()!["name"])));
                                          } else {
                                            toast("User has logged out!");
                                          }
                                        } else {
                                          toast("user is busy right now");
                                        }
                                      },
                                      icon: Icon(
                                        DeejosIcon.call,
                                        size: 20,
                                      )),
                                ),
                                PopupMenuButton(
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 1:
                                          {
                                            if (sizingInformation
                                                .deviceScreenType ==
                                                DeviceScreenType.desktop) {
                                              return await scaffoldAlertDialogBox(
                                                  context: context,
                                                  page: ChatDetails(
                                                    sizingInformation: sizingInformation,
                                                    uid: widget.uid,
                                                    puid: widget.puid,
                                                    state: 0,
                                                  ));
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDetails(
                                                          sizingInformation: sizingInformation,
                                                          uid: widget.uid,
                                                          puid: widget.puid,
                                                          state: 0,
                                                        )),
                                              );
                                            }
                                          }
                                          break;

                                        default:
                                      }
                                    },
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(
                                        child: Text("View Contact"),
                                        value: 1,
                                      ),
                                    ])
                              ],
                              title: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (sizingInformation.deviceScreenType ==
                                      DeviceScreenType.desktop) {
                                    return await scaffoldAlertDialogBox(
                                        context: context,
                                        page: ChatDetails(
                                          sizingInformation: sizingInformation,
                                          uid: widget.uid,
                                          puid: widget.puid,
                                          state: 0,
                                        ));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetails(
                                                sizingInformation: sizingInformation,
                                                uid: widget.uid,
                                                puid: widget.puid,
                                                state: 0,
                                              )),
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        width: 35,
                                        height: 35,
                                        child: ClipOval(
                                          // peerName: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["name"],
                                          // peerPic: chatRoomSnapshot.data!.data()!["members"]["${widget.puid}"]["pic"],
                                          child: (emptyChatRoomDetails.data!
                                              .data()!["pic"] != null)
                                          // ? Image.network(
                                          //     emptyChatRoomDetails.data!.data()!["pic"],
                                          //     fit: BoxFit.cover,
                                          //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          //       if (loadingProgress == null) return child;
                                          //       return Center(
                                          //         child: CircularProgressIndicator(
                                          //           value: loadingProgress.expectedTotalBytes != null
                                          //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          //               : null,
                                          //         ),
                                          //       );
                                          //     },
                                          //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                          //   )
                                              ? CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            fadeInDuration: const Duration(
                                                milliseconds: 400),
                                            progressIndicatorBuilder: (context,
                                                url, downloadProgress) =>
                                                Center(
                                                  child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                                  ),
                                                ),
                                            imageUrl: emptyChatRoomDetails.data!
                                                .data()!["pic"],
                                            errorWidget: (context, url,
                                                error) => Image.asset(
                                                "assets/noProfile.jpg",
                                                fit: BoxFit.cover),
                                          )
                                              : Image.asset(
                                              "assets/noProfile.jpg",
                                              fit: BoxFit.cover),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          new Text((widget.state == 0)
                                              ? emptyChatRoomDetails.data!
                                              .data()!["name"]
                                              : emptyChatRoomDetails.data!
                                              .data()!["title"],
                                              style: GoogleFonts.inter(
                                                  textStyle: textStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .w500))),
                                          StreamBuilder<DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                              stream: instance.collection(
                                                  "user-detail").doc(
                                                  widget.puid).snapshots(),
                                              builder: (context, peerSnapshot) {
                                                return StreamBuilder<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>(
                                                  stream: instance.collection(
                                                      "user-detail").doc(
                                                      widget.uid).snapshots(),
                                                  builder: (context,
                                                      userSnapshot) {
                                                    if (userSnapshot
                                                        .connectionState ==
                                                        ConnectionState.active
                                                        && peerSnapshot
                                                            .connectionState ==
                                                            ConnectionState
                                                                .active) {
                                                      return MarqueeWidget(
                                                        direction: Axis
                                                            .horizontal,
                                                        child: Text(
                                                          (userSnapshot.data!
                                                              .data()!["onlineStatus"] ==
                                                              true &&
                                                              peerSnapshot.data!
                                                                  .data()!["onlineStatus"] ==
                                                                  true)
                                                              ? (peerSnapshot
                                                              .data!
                                                              .data()!["status"] ==
                                                              "online")
                                                              ? "Online"
                                                              : (userSnapshot
                                                              .data!
                                                              .data()!["lastseenStatus"] ==
                                                              true &&
                                                              peerSnapshot.data!
                                                                  .data()!["lastseenStatus"] ==
                                                                  true)
                                                              ? "Last seen ${getDateTimeInChat(
                                                              datetime: getDateTimeSinceEpoch(
                                                                  datetime: peerSnapshot
                                                                      .data!
                                                                      .data()!["status"]))} at ${formatTime(
                                                              getDateTimeSinceEpoch(
                                                                  datetime: peerSnapshot
                                                                      .data!
                                                                      .data()!["status"]))}"
                                                              : "Tap here for user info"
                                                              : "Tap here for user info",
                                                          style: GoogleFonts
                                                              .inter(
                                                              textStyle: textStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  color: Color(
                                                                      grey))),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          new Text((widget.state == 0)
                                              ? emptyChatRoomDetails.data!
                                              .data()!["name"]
                                              : emptyChatRoomDetails.data!
                                              .data()!["title"],
                                              style: GoogleFonts.inter(
                                                  textStyle: textStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .w500))),
                                          StreamBuilder<DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                              stream: instance.collection(
                                                  "user-detail").doc(
                                                  widget.puid).snapshots(),
                                              builder: (context, peerSnapshot) {
                                                return StreamBuilder<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>(
                                                  stream: instance.collection(
                                                      "user-detail").doc(
                                                      widget.uid).snapshots(),
                                                  builder: (context,
                                                      userSnapshot) {
                                                    if (userSnapshot
                                                        .connectionState ==
                                                        ConnectionState
                                                            .active &&
                                                        peerSnapshot
                                                            .connectionState ==
                                                            ConnectionState
                                                                .active) {
                                                      return MarqueeWidget(
                                                        direction: Axis
                                                            .horizontal,
                                                        child: Text(
                                                          (userSnapshot.data!
                                                              .data()!["onlineStatus"] ==
                                                              true &&
                                                              peerSnapshot.data!
                                                                  .data()!["onlineStatus"] ==
                                                                  true)
                                                              ? (peerSnapshot
                                                              .data!
                                                              .data()!["status"] ==
                                                              "online")
                                                              ? "Online"
                                                              : (userSnapshot
                                                              .data!
                                                              .data()!["lastseenStatus"] ==
                                                              true &&
                                                              peerSnapshot.data!
                                                                  .data()!["lastseenStatus"] ==
                                                                  true)
                                                              ? "Last seen ${getDateTimeInChat(
                                                              datetime: getDateTimeSinceEpoch(
                                                                  datetime: peerSnapshot
                                                                      .data!
                                                                      .data()!["status"]))} at ${formatTime(
                                                              getDateTimeSinceEpoch(
                                                                  datetime: peerSnapshot
                                                                      .data!
                                                                      .data()!["status"]))}"
                                                              : "Tap here for user info"
                                                              : "Tap here for user info",
                                                          style: GoogleFonts
                                                              .inter(
                                                              textStyle: textStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  color: Color(
                                                                      grey))),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                );
                                              })
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            body: Container(
                              decoration: BoxDecoration(
                                // color: Color(black),
                                image: DecorationImage(
                                  image:
                                  // (chatRoomSnapshot.data!.data()!['members']["${widget.uid}"].contains("wallpaper") == true)
                                  //     ? (chatRoomSnapshot.data!.data()!['members']["${widget.uid}"]["wallpaper"] != null)
                                  //         ? AssetImage(chatRoomSnapshot.data!.data()!['members']["${widget.uid}"]["wallpaper"])
                                  //         : AssetImage((themedata.value.index == 0) ? "assets/chatLightBg.jpg" : "assets/chatDarkBg.jpg")
                                  //     :
                                  AssetImage((themedata.value.index == 0)
                                      ? "assets/chatLightBg.jpg"
                                      : "assets/chatDarkBg.jpg"),
                                  fit: BoxFit.cover,
                                  // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: NotificationListener<
                                        ScrollNotification>(
                                        onNotification: (
                                            ScrollNotification scrollInfo) {
                                          // if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
                                          //   // readUserMessages();
                                          // }
                                          return true;
                                        },
                                        child: Center(
                                          child: Text("No messages"),
                                        )),
                                  ),
                                  Container(
                                    // height: 66,
                                    color: (themedata.value.index == 0) ? Color(
                                        lightGrey) : Color(materialBlack),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10,
                                              left: 10,
                                              right: 10,
                                              top: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: textField(
                                                      prefix: IconButton(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          onPressed: () async {
                                                            recentEmojiList =
                                                            await getRecentEmoji();
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              if (attachmentShowing) {
                                                                attachmentShowing =
                                                                false;
                                                              }
                                                              emojiShowing =
                                                              !emojiShowing;
                                                              if (!emojiShowing) {
                                                                focusNode
                                                                    .requestFocus();
                                                              } else {
                                                                focusNode
                                                                    .unfocus();
                                                              }
                                                            });
                                                          },
                                                          icon: Icon(
                                                              Icons.book)),
                                                      focusNode: focusNode,
                                                      textStyle: GoogleFonts
                                                          .inter(
                                                          textStyle: textStyle(
                                                              fontSize: 14,
                                                              color: (themedata
                                                                  .value
                                                                  .index == 0)
                                                                  ? Color(
                                                                  materialBlack)
                                                                  : Color(
                                                                  white))),
                                                      textEditingController: textEditingController,
                                                      hintText: "Type a Message",
                                                      hintStyle:
                                                      GoogleFonts.inter(
                                                          textStyle: textStyle(
                                                              fontSize: 14,
                                                              color: (themedata
                                                                  .value
                                                                  .index == 0)
                                                                  ? Color(grey)
                                                                  : Color(
                                                                  lightGrey))),
                                                      border: false,
                                                      onSubmitted: (canSend)
                                                          ? (value) async {
                                                        if (textEditingController
                                                            .text.trim() !=
                                                            "") {
                                                          await writeUserMessage(
                                                              type: 0,
                                                              peerPic: (emptyChatRoomDetails
                                                                  .data!
                                                                  .data()!["pic"] !=
                                                                  null)
                                                                  ? emptyChatRoomDetails
                                                                  .data!
                                                                  .data()!["pic"]
                                                                  : null,
                                                              peerName:
                                                              (widget.state ==
                                                                  0)
                                                                  ? emptyChatRoomDetails
                                                                  .data!
                                                                  .data()!["name"]
                                                                  : emptyChatRoomDetails
                                                                  .data!
                                                                  .data()!["title"],
                                                              // peerChattingWith: userDetailSnapshot.data!.data()!["chattingWith"],
                                                              replyMap: replyMessageMap,
                                                              message: textEditingController
                                                                  .text);
                                                          if (replyMessageMap !=
                                                              null &&
                                                              replyUserName !=
                                                                  null) {
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              replyMessageMap =
                                                              null;
                                                              replyUserName =
                                                              null;
                                                            });
                                                          }
                                                          if (emojiShowing) {
                                                            if (!mounted)
                                                              return;
                                                            setState(() {
                                                              emojiShowing =
                                                              false;
                                                            });
                                                          }
                                                          textEditingController
                                                              .clear();
                                                        }
                                                      }
                                                          : null,
                                                      maxLines: 5,
                                                      fillColor: (themedata
                                                          .value.index == 0)
                                                          ? Color(white)
                                                          : Color(lightBlack),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 8.0, right: 8.0),
                                                    child: (canSend)
                                                        ? GestureDetector(
                                                      // elevation: 0,
                                                      // child: Icon(
                                                      //   DeejosIcon.send_outline,
                                                      //   color: (themedata.value.index == 0) ? Color((canSend) ? white : grey) : Color(grey),
                                                      // ),
                                                      // padding: EdgeInsets.all(20),
                                                      // shape: CircleBorder(),
                                                      // color: Color(accent),
                                                        child: Container(
                                                          height: 65,
                                                          width: 65,
                                                          clipBehavior: Clip
                                                              .hardEdge,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            color: Color(
                                                                accent),
                                                          ),
                                                          child: Icon(
                                                            DeejosIcon
                                                                .send_outline,
                                                            color: (themedata
                                                                .value.index ==
                                                                0)
                                                                ? Color(
                                                                (canSend)
                                                                    ? white
                                                                    : grey)
                                                                : Color(grey),
                                                          ),
                                                        ),
                                                        onTap: canSend
                                                            ? () async {
                                                          if (textEditingController
                                                              .text.trim() !=
                                                              "") {
                                                            await writeUserMessage(
                                                                type: 0,
                                                                peerPic:
                                                                (emptyChatRoomDetails
                                                                    .data!
                                                                    .data()!["pic"] !=
                                                                    null)
                                                                    ? emptyChatRoomDetails
                                                                    .data!
                                                                    .data()!["pic"]
                                                                    : null,
                                                                peerName: (widget
                                                                    .state == 0)
                                                                    ? emptyChatRoomDetails
                                                                    .data!
                                                                    .data()!["name"]
                                                                    : emptyChatRoomDetails
                                                                    .data!
                                                                    .data()!["title"],
                                                                // peerChattingWith: userDetailSnapshot.data!.data()!["chattingWith"],
                                                                replyMap: replyMessageMap,
                                                                message: textEditingController
                                                                    .text);
                                                            if (replyMessageMap !=
                                                                null &&
                                                                replyUserName !=
                                                                    null) {
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                replyMessageMap =
                                                                null;
                                                                replyUserName =
                                                                null;
                                                              });
                                                            }
                                                            if (emojiShowing) {
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                emojiShowing =
                                                                false;
                                                              });
                                                            }
                                                            textEditingController
                                                                .clear();
                                                          }
                                                        }
                                                            : null)
                                                        : RecordButton(
                                                        controller: voiceRecordAnimationController,
                                                        valueNotifier: recordAudioValueNotifier,
                                                        function: () async {
                                                          File file = File(
                                                              recordAudioValueNotifier
                                                                  .value);
                                                          if (file
                                                              .existsSync()) {
                                                            int length = await file
                                                                .length();
                                                            Uint8List bytes = await file
                                                                .readAsBytes();

                                                            if (length <
                                                                52428800) {
                                                              if (widget
                                                                  .state == 0) {
                                                                await writeUserMessage(
                                                                  type: 9,
                                                                  // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                                  peerName: chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["members"]["${widget
                                                                      .puid}"]["name"],
                                                                  peerPic: chatRoomSnapshot
                                                                      .data!
                                                                      .data()!["members"]["${widget
                                                                      .puid}"]["pic"],
                                                                  replyMap: replyMessageMap,
                                                                  file: bytes,
                                                                  contentType: "audio/" +
                                                                      file.path
                                                                          .split(
                                                                          ".")
                                                                          .last,
                                                                );
                                                                if (replyMessageMap !=
                                                                    null &&
                                                                    replyUserName !=
                                                                        null) {
                                                                  if (!mounted)
                                                                    return;
                                                                  setState(() {
                                                                    replyMessageMap =
                                                                    null;
                                                                    replyUserName =
                                                                    null;
                                                                  });
                                                                }
                                                              } else {
                                                                await writeGroupMessage(
                                                                    type: 9,
                                                                    members: chatRoomSnapshot
                                                                        .data!
                                                                        .data()!["members"],
                                                                    file: bytes,
                                                                    replyMap: replyMessageMap,
                                                                    contentType: "audio/" +
                                                                        file
                                                                            .path
                                                                            .split(
                                                                            ".")
                                                                            .last,
                                                                    groupName: chatRoomSnapshot
                                                                        .data!
                                                                        .data()!["title"],
                                                                    groupPic: chatRoomSnapshot
                                                                        .data!
                                                                        .data()!["pic"]);
                                                                if (replyMessageMap !=
                                                                    null &&
                                                                    replyUserName !=
                                                                        null) {
                                                                  if (!mounted)
                                                                    return;
                                                                  setState(() {
                                                                    replyMessageMap =
                                                                    null;
                                                                    replyUserName =
                                                                    null;
                                                                  });
                                                                }
                                                              }
                                                            } else {
                                                              final snackBar = snackbar(
                                                                  content: "File size is greater than 50MB");
                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                            }
                                                          }
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Offstage(offstage: !emojiShowing,
                                      child: emojiOffstage()),
                                  // Offstage(offstage: !attachmentShowing, child: attachmentOffstage(chatRoomSnapshot: chatRoomSnapshot)),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                });
          } else {
            return exceptionScaffold(context: context,
                lottieString: loadingLottie,
                subtitle: "Loading Chats");
          }
        });
  }

  Widget buildGroupHeaderItem(DocumentSnapshot<Map<String, dynamic>> document) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Chip(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
          color: Colors.transparent,
        ),
        label: Text(getDateTimeInChat(
            datetime: getDateTimeSinceEpoch(datetime: document["timestamp"])),
            style: GoogleFonts.inter(textStyle: textStyle(fontSize: 12,
                color: (themedata.value.index == 0) ? Colors.black : Color(
                    materialBlack)))),
        backgroundColor: Color.fromRGBO(252, 252, 252, 1),
      ),
    );
  }

  Widget buildItem({
    required SizingInformation sizingInformation,
    required int index,
    required int replyIndex,
    //message
    required DocumentSnapshot<Map<String, dynamic>> document,
    //user room detail or group detail
    required DocumentSnapshot<Map<String, dynamic>> chatRoomSnapshot,
    // required SizingInformation sizingInformation,
    //for p2p user detail
    // DocumentSnapshot<Map<String, dynamic>>? userDetailSnapshot,
    //for group
    // QuerySnapshot<Map<String, dynamic>>? userDetailsSnapshot,
  }) {
//!this is poor design as it affects scalablity
//!! should replace it with read..(also bad which reads the array again if someone changes thier profile) or something effiecient
    // DocumentSnapshot<Map<String, dynamic>>? replyDocumentSnapshot;
    // DocumentSnapshot<Map<String, dynamic>>? DocumentSnapshot;
    String userName = "";
    String replyUserName = "";
    bool isRead = false;
    if (widget.state == 1) {
      if (chatRoomSnapshot.data()!["members"] != null &&
          chatRoomSnapshot.data()!["timestamp"] != null) {
        isRead = groupReadReceipt(members: chatRoomSnapshot.data()!["members"],
            timestamp: chatRoomSnapshot.data()!["timestamp"],
            uid: uid.toString());
      }
      chatRoomSnapshot.data()!["members"].forEach((k, v) {
        if (k == document.data()!["from"]) {
          //userName = v["name"];
        } else if (document.data()!["reply"] != null &&
            (k == document.data()!["reply"]["from"])) {
          //replyUserName = v["name"];
        }
      });
    }
    return Container(
        child: (document["from"] == widget.uid)
        //*if it is sent by me


            ? Padding(
          padding: const EdgeInsets.only(
              left: 50, right: 20, top: 8, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) ? MediaQuery
                    .of(context)
                    .size
                    .width / 10 : 0,
              ),

              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Listener(
                      onPointerDown: (event) async {
                        return await onPointerDown(
                          event: event,
                          replyIndex: replyIndex,
                          document: document,
                          chatRoomSnapshot: chatRoomSnapshot,
                        );
                      },
                      child: ChatBubble(
                        padding: EdgeInsets.only(left: 11.w,right: 11.w,top:10.h,bottom:7.h),
                        alignment: Alignment.centerRight,
                        clipper: ChatBubbleClipper5(type: BubbleType.sendBubble,radius: 18,secondRadius: 0),
                        backGroundColor: Color.fromRGBO(248, 206, 97, 1),
                        elevation: 0,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (document["forwardCount"] == 0)
                                ? SizedBox()
                                : Row(
                              mainAxisSize:MainAxisSize.min,
                              children: [
                                Icon(
                                  Entypo.forward,
                                  color: Color(grey),
                                  size:20,
                                ),
                                Text(
                                  (document["forwardCount"] <= 5) ? " forwarded" : " forwarded many times",
                                  style: GoogleFonts.inter(
                                    textStyle: textStyle(fontSize: 10, color: Color(grey)),
                                  ),
                                ),
                              ],
                            ),
                            (document["reply"] != null)
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (themedata.value.index == 0) ? Color(lightBlack).withOpacity(.1) :
                                    Color(lightBlack).withOpacity(.1),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          color: Color(yellow),
                                          width: 4,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              (document["reply"]["from"] != widget.uid)
                                                  ? (widget.state == 0)
                                                  ? (chatRoomSnapshot.data()!["members"]["${widget.puid}"]["name"])
                                                  : replyUserName
                                                  : "You",
                                              style: GoogleFonts.inter(
                                                textStyle: textStyle(fontSize: 14, color: Color(yellow)),
                                              ),
                                              maxLines: 1,
                                              softWrap: true,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              (inverseDataType[document.data()!["reply"]["type"]] == 0)
                                                  ? document.data()!["reply"]["data"]["text"]
                                                  : document.data()!["reply"]["type"],
                                              style: GoogleFonts.inter(
                                                textStyle: textStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              maxLines: 2,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                messageBuilder(document: document, chatRoomSnapshot: chatRoomSnapshot)
                              ],
                            )
                                : messageBuilder(document: document, chatRoomSnapshot: chatRoomSnapshot),
                            Container(
                              alignment: Alignment.bottomRight,
                              width:100,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatTime(getDateTimeSinceEpoch(datetime: document["timestamp"])),
                                      style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          textStyle: textStyle(
                                            color: (themedata.value.index == 0)
                                                ? Color.fromRGBO(
                                                12, 16, 29, 0.6)
                                                : Color.fromRGBO(
                                                12, 16, 29, 0.6),
                                          )),
                                    ),
                                    SizedBox(width: 5.w),
                                    (widget.state == 0)
                                        ? (chatRoomSnapshot.data()!["members"]["${widget.puid}"]["lastRead"] != null)
                                        ? (getDateTimeSinceEpoch(datetime: chatRoomSnapshot.data()!["members"]["${widget.puid}"]["lastRead"])
                                        .difference(getDateTimeSinceEpoch(datetime: document["timestamp"]))
                                        .inMicroseconds >
                                        0)
                                        ? Icon(
                                      Icons.done_all,
                                      size: 15,
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    )
                                        : Icon(
                                      Icons.done_all,
                                      size: 15,
                                      color: (themedata.value.index == 0) ? Colors.white : Colors.black,
                                    )
                                        : Icon(
                                      Icons.done_all,
                                      size: 15,
                                      color: (themedata.value.index == 0) ? Colors.brown : Colors.pink,
                                    )
                                        : (isRead)
                                        ? Icon(
                                      Icons.done_all,
                                      size: 15,
                                      color:  Colors.black,
                                    )
                                        : Icon(
                                      Icons.done_all,
                                      size: 15,
                                      color: (themedata.value.index == 0) ? Colors.white: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) ? MediaQuery
                    .of(context)
                    .size
                    .width / 15 : 0,
              ),
            ],
          ),
        )

            : Padding(
          padding: const EdgeInsets.only(
              left: 10, right: 50, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) ? MediaQuery
                    .of(context)
                    .size
                    .width / 15 : 0,
              ),
              Flexible(
                child: Column(
                  children: [
                    Listener(
                      onPointerDown: (event) async {
                        return await onPointerDown(event: event,
                            replyIndex: replyIndex,
                            document: document,
                            chatRoomSnapshot: chatRoomSnapshot);
                      },
                      // Receiver Message Box------------
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: 100,
                            maxWidth: MediaQuery
                                .of(context)
                                .size
                                .width
                        ),
                        child: InkWell(
                          onTap: (){print('Lotus:${chatRoomSnapshot.data()!["members"]["${widget.puid}"]["name"]}');},
                          child: Card(
                            elevation: 0,
                            color: Color.fromRGBO(252, 252, 252, 1),

                            shape: OutlineInputBorder(borderSide: BorderSide(
                                width: 1.w, color: Color.fromRGBO(0, 0, 0, 0.2)),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        15),
                                    topRight: Radius.circular(
                                        15),
                                    bottomRight: Radius
                                        .circular(15))
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                              children: [
                                (document["forwardCount"] == 0)
                                    ? SizedBox()
                                    : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Entypo.forward,
                                      color: Color(grey),
                                      size: 10,
                                    ),
                                    Text(
                                      (document["forwardCount"] <= 5)
                                          ? " forwarded"
                                          : " forwarded many times",
                                      style: GoogleFonts.inter(
                                        textStyle: textStyle(
                                            fontSize: 10.sp, color: Color(grey)),
                                      ),
                                    ),
                                  ],
                                ),
                                // (widget.state == 0)
                                //     ? messageBuilder(document)
                                //     :
                                (document["reply"] != null)
                                    ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (widget.state == 0) ? (chatRoomSnapshot.data()!["members"]["${widget.puid}"]["name"]) : userName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: GoogleFonts.inter(textStyle: textStyle(fontSize: 16, color: Color(accent))),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              color: Color(yellow),
                                              width: 4,
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(

                                                  (document["reply"]["from"] !=
                                                      widget.uid)
                                                      ? (widget.state == 0)
                                                      ? (chatRoomSnapshot
                                                      .data()!["members"]["${widget
                                                      .puid}"]["name"])
                                                      : replyUserName
                                                      : "You",
                                                  style: GoogleFonts.inter(
                                                    textStyle: textStyle(
                                                        fontSize: 12.sp,
                                                        color: Color(accent)),
                                                  ),
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  (inverseDataType[document
                                                      .data()!["reply"]["type"]] ==
                                                      0)
                                                      ? document
                                                      .data()!["reply"]["data"]["text"]
                                                      : document
                                                      .data()!["reply"]["type"],
                                                  style: GoogleFonts.inter(
                                                    textStyle: textStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  maxLines: 2,
                                                  softWrap: true,
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: messageBuilder(document: document,
                                            chatRoomSnapshot: chatRoomSnapshot))
                                  ],
                                )
                                    : Stack(

                                  children: [
                                    Text(
                                      (widget.state == 0) ? (chatRoomSnapshot.data()!["members"]["${widget.puid}"]["name"]) : userName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: GoogleFonts.inter(textStyle: textStyle(fontSize: 16, color: Color(accent))),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 5,
                                            right: 60,
                                            bottom: 20,
                                            left: 10),
                                        child: messageBuilder(document: document,
                                            chatRoomSnapshot: chatRoomSnapshot)),
                                    Positioned(
                                      bottom: 5,
                                      right: 10,
                                      child: Text(
                                        formatTime(getDateTimeSinceEpoch(
                                            datetime: document["timestamp"])),
                                        style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            textStyle: textStyle(
                                              color: (themedata.value.index == 0)
                                                  ? Color.fromRGBO(
                                                  12, 16, 29, 0.6)
                                                  : Color.fromRGBO(
                                                  12, 16, 29, 0.6),
                                            )),
                                      ),
                                    )

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                width: (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) ? MediaQuery
                    .of(context)
                    .size
                    .width / 10 : 0,
              ),
            ],
          ),
        ));
  }

  Widget messageBuilder({required DocumentSnapshot<Map<String, dynamic>> document,
    required DocumentSnapshot<Map<String, dynamic>> chatRoomSnapshot}) {
    switch (inverseDataType[document.data()!["type"]]) {
      case 0:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
        // : Text(
        //     document.data()!["data"]["text"],
        //     softWrap: true,
        //     style: GoogleFonts.poppins(
        //         fontSize: 14,
        //         textStyle: textStyle(
        //           color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
        //         )),
        //   );
            : SubstringHighlight(
          text: document.data()!["data"]["text"],
          term: searchTextEditingController.text,
          textStyle: GoogleFonts.poppins(
              fontSize: 14,
              textStyle: textStyle(
                color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
              )),
          textStyleHighlight: TextStyle(
            // highlight style
            backgroundColor: Colors.white,
          ),
        );
      case 1:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssetPageView(
                            stringList: [document.data()!["data"]["image"]],
                            showIndex: false,
                          )));
                },
                // child: Image.network(
                //   document.data()!["data"]["image"],
                //   fit: BoxFit.cover,
                //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Center(
                //       child: CircularProgressIndicator(
                //         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                //       ),
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                // ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 400),
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                  ),
                  imageUrl: document.data()!["data"]["image"],
                  errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                ))
          // child: ImageViewer(imageUrl: document.data()!["data"]["image"]),
        );
      case 2:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AssetPageView(
                      stringList: [document.data()!["data"]["video"]],
                      showIndex: false,
                    )));
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
            color: Color(black),
            child: Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Color(white),
                  size: 50,
                )),
          ),
        );
      case 3:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : PlayAudio(url: document.data()!["data"]["audio"], type: 0);
      case 4:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : DocumentDownloader(url: document.data()!["data"]["document"]);
      case 5:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : GestureDetector(
          onTap: () {
            // log(Uri.decodeFull(document.data()!["data"]["story"]).toString());
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return PostDetails(postId: Uri.decodeFull(document.data()!["data"]["story"]).toString().split("post_id=").last);
            // }));
          },
          child: Column(
            children: [
              (document.data()!["data"]["image"] != null)
                  ? CachedNetworkImage(
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 400),
                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(value: downloadProgress.progress),
                  ),
                ),
                imageUrl: document.data()!["data"]["image"],
                errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
              )
                  : (document.data()!["data"]["video"] != null)
                  ? Container(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 4,
                color: Color(black),
                child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Color(white),
                      size: 50,
                    )),
              )
                  : Container(),
              (document.data()!["data"]["text"] != null)
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  document.data()!["data"]["text"],
                  softWrap: true,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      textStyle: textStyle(
                        color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
                      )),
                ),
              )
                  : Container(),
              // GestureDetector(
              //   onTap: () async {
              //     DocumentSnapshot<Map<String, dynamic>> userDoc = await instance.collection("user-detail").doc(document.data()!["from"]).get();
              //     await DynamicLinkHandler().shareLink(
              //         userDoc.data()!["name"],
              //         document.data()!["data"]["text"],
              //         Uri.decodeFull(document.data()!["data"]["story"]).toString().split("&link=").last,
              //         (document.data()!["data"]["image"] != null)
              //             ? document.data()!["data"]["image"]
              //             : ((document.data()!["data"]["video"] != null))
              //                 ? document.data()!["data"]["video"]
              //                 : "");
              //   },
              //   onLongPress: () {
              //     Clipboard.setData(ClipboardData(text: Uri.decodeFull(document.data()!["data"]["story"]).toString()));
              //     final snackBar = snackbar(content: "Copied to clipboard");
              //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       Uri.decodeFull(document.data()!["data"]["story"]).toString(),
              //       softWrap: true,
              //       style: GoogleFonts.poppins(
              //           fontSize: 14,
              //           textStyle: textStyle(
              //             color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
              //           )),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      case 6:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssetPageView(
                            stringList: [document.data()!["data"]["image"]],
                            showIndex: false,
                          )));
                },
                // child: Image.network(
                //   document.data()!["data"]["image"],
                //   fit: BoxFit.cover,
                //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Center(
                //       child: CircularProgressIndicator(
                //         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                //       ),
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                // ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 400),
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                  ),
                  imageUrl: document.data()!["data"]["gif"],
                  errorWidget: (context, url, error) => Image.asset("assets/errorImage.jpg", fit: BoxFit.cover),
                ))
          // child: ImageViewer(imageUrl: document.data()!["data"]["image"]),
        );
      case 7:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : GestureDetector(
          onTap: () async {
            String uri = document.data()!["data"]["location"].split("\n").first;
            if (await canLaunch(uri)) {
              await launch(uri);
            } else {
              throw 'Could not launch $uri';
            }
          },
          child: Text(
            "📍 Location \n\n" + document.data()!["data"]["location"].split("\n").last,
            softWrap: true,
            style: GoogleFonts.poppins(
                fontSize: 14,
                textStyle: textStyle(
                  color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
                )),
          ),
        );
      case 8:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : GestureDetector(
          onTap: () async {
            await saveContactInPhone(
                state: 0, context: context, name: document.data()!["data"]["contact"].split("\n").first, phone: document.data()!["data"]["contact"].split("\n").last);
          },
          child: Text(
            "👤 " + document.data()!["data"]["contact"].split("\n").first + "\n" + document.data()!["data"]["contact"].split("\n").last,
            softWrap: true,
            style: GoogleFonts.poppins(
                fontSize: 14,
                textStyle: textStyle(
                  color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
                )),
          ),
        );
      case 9:
        return (document.data()!["delete"]["everyone"] == true)
            ? Text((document.data()!["from"] == widget.uid) ? "∅ You have deleted this message" : "∅ This message have been deleted")
            : PlayAudio(
            url: document.data()!["data"]["voice"],
            type: 1,
            state: (document["from"] == widget.uid) ? 0 : 1,
            profilePic: chatRoomSnapshot.data()!["members"][document.data()!["from"]]["pic"]);
      default:
        return Container();
    }
  }


  Widget emojiOffstage() {
    return Container(
      height: 300,
      child: Material(
        child: DefaultTabController(
          length: emojiArray.length + 1,

          child: Column(
            children: [
              TabBar(
                  indicatorColor: Color.fromRGBO(248, 206, 97, 1),
                  // isScrollable: true,
                  tabs: List.generate(

                    emojiArray.length + 1,
                        (tabindex) =>
                        Tab(text: (tabindex == 0 ? "🕐" : emojiArray[tabindex -
                            1][0])),

                  )),
              Flexible(
                child: TabBarView(
                  children: List.generate(emojiArray.length + 1, (tabbarindex) {
                    return SingleChildScrollView(
                      child: Wrap(
                          children: List.generate(
                            tabbarindex == 0
                                ? recentEmojiList.length
                                : emojiArray[tabbarindex - 1].length,
                                (index) {
                              return GestureDetector(
                                  onTap: () async {
                                    textEditingController
                                      ..text +=
                                    (tabbarindex == 0) ? recentEmojiList[index]
                                        .toString() : emojiArray[tabbarindex -
                                        1][index].toString()
                                      ..selection = TextSelection.fromPosition(
                                          TextPosition(
                                              offset: textEditingController.text
                                                  .length));
                                    if (tabbarindex != 0) {
                                      await setRecentEmoji(
                                          emojiArray[tabbarindex - 1][index]
                                              .toString());
                                      recentEmojiList = await getRecentEmoji();
                                      if (!mounted) return;
                                      setState(() {});
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((tabbarindex == 0)
                                        ? recentEmojiList[index]
                                        : emojiArray[tabbarindex - 1][index],
                                        style: TextStyle(fontSize: 30)),
                                  ));
                            },
                          )),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchTextBox() {
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: textField(
            fillColor: (themedata.value.index == 0) ? Color(white) : Color(
                lightBlack),
            border: false,
            hintText: "Search",
            hintStyle: GoogleFonts.inter(textStyle: textStyle(fontSize: 14,
                color: (themedata.value.index == 0) ? Color(grey) : Color(
                    lightGrey))),
            textStyle: GoogleFonts.inter(textStyle: textStyle(fontSize: 14,
                color: (themedata.value.index == 0)
                    ? Color(materialBlack)
                    : Color(white))),
            textEditingController: searchTextEditingController));
  }

  Future<void> onPointerDown({
    required PointerDownEvent event,
    required int replyIndex,
    required DocumentSnapshot<Map<String, dynamic>> document,
    required DocumentSnapshot<Map<String, dynamic>> chatRoomSnapshot,

    // DocumentSnapshot<Map<String, dynamic>>? userDetailSnapshot,
    // QuerySnapshot<Map<String, dynamic>>? userDetailsSnapshot,
  }) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay = Overlay.of(context)!.context
          .findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,
          items: [
            PopupMenuItem(child: Text('Reply'), value: 1),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          {
            if (widget.state == 0) {
              if (widget.uid == document.data()!["from"]) {
                replyUserName =
                chatRoomSnapshot.data()!["members"]["${widget.puid}"]["name"];
              } else {
                replyUserName = "You";
              }
            } else {
              chatRoomSnapshot.data()!["members"].forEach((k, v) {
                if (widget.uid == document.data()!["from"]) {
                  replyUserName = "You";
                } else if (k == document.data()!["from"]) {
                  replyUserName = v["name"];
                }
              });
            }
            if (!mounted) return;
            setState(() {
              replyMessageMap =
                  replyMap(documentId: document.id,
                      documentIndex: replyIndex,
                      fromUid: document.data()!["from"],
                      type: document.data()!["type"],
                      data: document.data()!["data"]);
            });
            focusNode.requestFocus();
          }
          break;
        default:
      }
    }
  }

  Widget iconCreation(String iconContainer, String text) {
    return Column(
      children: [


        SvgPicture.asset(iconContainer, width: 52.w,
          height: 47.h,),
        SizedBox(height: 9.h),
        Text(text,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400))),
      ],
    );
    // showModalBottomSheet(
    //     backgroundColor: Colors
    //         .transparent,
    //     context: context,
    //     builder: (
    //         BuildContext context) {
    //       return Container(
    //         height: 250,
    //         width: MediaQuery
    //             .of(context)
    //             .size
    //             .width -
    //             20,
    //         child: Card(
    //           shape: RoundedRectangleBorder(
    //               borderRadius:
    //               BorderRadius
    //                   .circular(
    //                   15),
    //               side: BorderSide(
    //                   color: Color
    //                       .fromRGBO(
    //                       246,
    //                       207,
    //                       70,
    //                       1))),
    //           color: Color
    //               .fromRGBO(
    //               255, 255,
    //               255, 1),
    //           margin: EdgeInsets
    //               .all(30),
    //           child: Column(
    //               mainAxisAlignment:
    //               MainAxisAlignment
    //                   .spaceEvenly,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment:
    //                   MainAxisAlignment
    //                       .spaceEvenly,
    //                   children: [
    //                     iconCreation(
    //                         "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/document_icon_container.png",
    //                         "Document"),
    //                     iconCreation(
    //                         "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/camera_icon_container.png",
    //                         "Camera"),
    //                     iconCreation(
    //                         "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/gallery_icon_container.png",
    //                         "Gallery")
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment:
    //                   MainAxisAlignment
    //                       .spaceEvenly,
    //                   children: [
    //                     iconCreation(
    //                         "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/audio_icon_container.png",
    //                         "Audio"),
    //                     iconCreation(
    //                         "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/location_icon_container.png",
    //                         "Location"),
    //                     iconCreation(
    //                         "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/contact_icon_container.png",
    //                         "Contact")
    //                   ],
    //                 )
    //               ]),
    //         ),
    //       );
    //     });
  }
  Widget attachmentOffstage({
    required AsyncSnapshot<
        DocumentSnapshot<Map<String, dynamic>>> chatRoomSnapshot,
    // DocumentSnapshot<Map<String, dynamic>>? userDetailSnapshot,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runAlignment: WrapAlignment.spaceAround,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [

            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    return await simpleDialogBox(context: context, widgetList: [
                      SimpleDialogOption(
                          onPressed: () async {
                            Navigator.pop(context);
                            if (!mounted) return;
                            setState(() {
                              attachmentShowing = false;
                            });
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.camera);

                            // Navigator.pop(context);
                            // return await image().then((value) async {
                            if (photo != null) {
                              int size = await photo.length();
                              Uint8List bytes = await photo.readAsBytes();
                              // for (var file in value.files) {
                              if (size < 52428800 && bytes != null) {
                                if (widget.state == 0) {
                                  await writeUserMessage(
                                    type: 1,
                                    // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                    peerName: chatRoomSnapshot.data!
                                        .data()!["members"]["${widget
                                        .puid}"]["name"],
                                    peerPic: chatRoomSnapshot.data!
                                        .data()!["members"]["${widget
                                        .puid}"]["pic"],
                                    replyMap: replyMessageMap,
                                    file: bytes,
                                    contentType: "image/" + photo.path
                                        .split(".")
                                        .last,
                                  );
                                  if (replyMessageMap != null &&
                                      replyUserName != null) {
                                    if (!mounted) return;
                                    setState(() {
                                      replyMessageMap = null;
                                      replyUserName = null;
                                    });
                                  }
                                } else {
                                  await writeGroupMessage(
                                      type: 1,
                                      members: chatRoomSnapshot.data!
                                          .data()!["members"],
                                      file: bytes,
                                      replyMap: replyMessageMap,
                                      contentType: "image/" + photo.path
                                          .split(".")
                                          .last,
                                      groupName: chatRoomSnapshot.data!
                                          .data()!["title"],
                                      groupPic: chatRoomSnapshot.data!
                                          .data()!["pic"]);
                                  if (replyMessageMap != null &&
                                      replyUserName != null) {
                                    if (!mounted) return;
                                    setState(() {
                                      replyMessageMap = null;
                                      replyUserName = null;
                                    });
                                  }
                                }
                              } else {
                                final snackBar = snackbar(
                                    content: "File size is greater than 50MB");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              }
                              // }
                            }
                          },
                          child: Center(
                            child: Text(
                              "Camera",
                              style: GoogleFonts.poppins(
                                  textStyle: textStyle(fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: (themedata.value.index == 0)
                                          ? Color(black)
                                          : Color(white))),
                              softWrap: true,
                            ),
                          )),
                      SimpleDialogOption(
                          onPressed: () async {
                            Navigator.pop(context);
                            if (!mounted) return;
                            setState(() {
                              attachmentShowing = false;
                            });
                            // Navigator.pop(context);

                            return await image().then((value) async {
                              if (value!.files.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AssetPageView(
                                            fileList: value.files,
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              for (var file in value.files) {
                                                if (file.size < 52428800 &&
                                                    file.bytes != null) {
                                                  if (widget.state == 0) {
                                                    await writeUserMessage(
                                                      type: 1,
                                                      // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                      peerName: chatRoomSnapshot
                                                          .data!
                                                          .data()!["members"]["${widget
                                                          .puid}"]["name"],
                                                      peerPic: chatRoomSnapshot
                                                          .data!
                                                          .data()!["members"]["${widget
                                                          .puid}"]["pic"],
                                                      replyMap: replyMessageMap,
                                                      file: file.bytes,
                                                      contentType: "image/" +
                                                          file.extension!,
                                                    );
                                                    if (replyMessageMap !=
                                                        null &&
                                                        replyUserName != null) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        replyMessageMap = null;
                                                        replyUserName = null;
                                                      });
                                                    }
                                                  } else {
                                                    await writeGroupMessage(
                                                        type: 1,
                                                        members: chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"],
                                                        file: file.bytes,
                                                        replyMap: replyMessageMap,
                                                        contentType: "image/" +
                                                            file.extension!,
                                                        groupName: chatRoomSnapshot
                                                            .data!
                                                            .data()!["title"],
                                                        groupPic: chatRoomSnapshot
                                                            .data!
                                                            .data()!["pic"]);
                                                    if (replyMessageMap !=
                                                        null &&
                                                        replyUserName != null) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        replyMessageMap = null;
                                                        replyUserName = null;
                                                      });
                                                    }
                                                  }
                                                } else {
                                                  final snackBar = snackbar(
                                                      content: "File size is greater than 50MB");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              }
                                            },
                                          ),
                                    ));
                              }
                            });
                          },
                          child: Center(
                            child: Text(
                              "Gallery",
                              style: GoogleFonts.poppins(
                                  textStyle: textStyle(fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: (themedata.value.index == 0)
                                          ? Color(black)
                                          : Color(white))),
                              softWrap: true,
                            ),
                          )),
                    ]);
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.photo_gallery,
                        size: 30,
                      ),
                      Text("Photo")
                    ],
                  )),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    return await simpleDialogBox(context: context, widgetList: [
                      SimpleDialogOption(
                          onPressed: () async {
                            Navigator.pop(context);
                            if (!mounted) return;
                            setState(() {
                              attachmentShowing = false;
                            });
                            final XFile? video = await _picker.pickVideo(
                                source: ImageSource.camera);
                            // Navigator.pop(context);
                            // return await image().then((value) async {
                            if (video != null) {
                              int size = await video.length();
                              Uint8List bytes = await video.readAsBytes();
                              // for (var file in value.files) {
                              if (size < 52428800 && bytes != null) {
                                if (widget.state == 0) {
                                  await writeUserMessage(
                                    type: 2,
                                    // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                    peerName: chatRoomSnapshot.data!
                                        .data()!["members"]["${widget
                                        .puid}"]["name"],
                                    peerPic: chatRoomSnapshot.data!
                                        .data()!["members"]["${widget
                                        .puid}"]["pic"],
                                    replyMap: replyMessageMap,
                                    file: bytes,
                                    contentType: "video/" + video.path
                                        .split(".")
                                        .last,
                                  );
                                  if (replyMessageMap != null &&
                                      replyUserName != null) {
                                    if (!mounted) return;
                                    setState(() {
                                      replyMessageMap = null;
                                      replyUserName = null;
                                    });
                                  }
                                } else {
                                  await writeGroupMessage(
                                      type: 2,
                                      members: chatRoomSnapshot.data!
                                          .data()!["members"],
                                      file: bytes,
                                      replyMap: replyMessageMap,
                                      contentType: "video/" + video.path
                                          .split(".")
                                          .last,
                                      groupName: chatRoomSnapshot.data!
                                          .data()!["title"],
                                      groupPic: chatRoomSnapshot.data!
                                          .data()!["pic"]);
                                  if (replyMessageMap != null &&
                                      replyUserName != null) {
                                    if (!mounted) return;
                                    setState(() {
                                      replyMessageMap = null;
                                      replyUserName = null;
                                    });
                                  }
                                }
                              } else {
                                final snackBar = snackbar(
                                    content: "File size is greater than 50MB");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              }
                              // }
                            }
                            // });
                          },
                          child: Center(
                            child: Text(
                              "Camera",
                              style: GoogleFonts.poppins(
                                  textStyle: textStyle(fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: (themedata.value.index == 0)
                                          ? Color(black)
                                          : Color(white))),
                              softWrap: true,
                            ),
                          )),
                      SimpleDialogOption(
                          onPressed: () async {
                            Navigator.pop(context);
                            if (!mounted) return;
                            setState(() {
                              attachmentShowing = false;
                            });
                            // Navigator.pop(context);

                            return await video().then((value) async {
                              if (value!.files.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AssetPageView(
                                              fileList: value.files,
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                for (var file in value.files) {
                                                  if (file.size < 52428800 &&
                                                      file.bytes != null) {
                                                    if (widget.state == 0) {
                                                      await writeUserMessage(
                                                        type: 2,
                                                        // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                                        peerName: chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"]["${widget
                                                            .puid}"]["name"],
                                                        peerPic: chatRoomSnapshot
                                                            .data!
                                                            .data()!["members"]["${widget
                                                            .puid}"]["pic"],
                                                        replyMap: replyMessageMap,
                                                        file: file.bytes,
                                                        contentType: "video/" +
                                                            file.extension!,
                                                      );
                                                      if (replyMessageMap !=
                                                          null &&
                                                          replyUserName !=
                                                              null) {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          replyMessageMap =
                                                          null;
                                                          replyUserName = null;
                                                        });
                                                      }
                                                    } else {
                                                      await writeGroupMessage(
                                                          type: 2,
                                                          members: chatRoomSnapshot
                                                              .data!
                                                              .data()!["members"],
                                                          file: file.bytes,
                                                          replyMap: replyMessageMap,
                                                          contentType: "video/" +
                                                              file.extension!,
                                                          groupName: chatRoomSnapshot
                                                              .data!
                                                              .data()!["title"],
                                                          groupPic: chatRoomSnapshot
                                                              .data!
                                                              .data()!["pic"]);
                                                      if (replyMessageMap !=
                                                          null &&
                                                          replyUserName !=
                                                              null) {
                                                        if (!mounted) return;
                                                        setState(() {
                                                          replyMessageMap =
                                                          null;
                                                          replyUserName = null;
                                                        });
                                                      }
                                                    }
                                                  } else {
                                                    final snackBar = snackbar(
                                                        content: "File size is greater than 50MB");
                                                    ScaffoldMessenger.of(
                                                        context).showSnackBar(
                                                        snackBar);
                                                  }
                                                }
                                              },
                                            )));
                              }
                            });
                          },
                          child: Center(
                            child: Text(
                              "Gallery",
                              style: GoogleFonts.poppins(
                                  textStyle: textStyle(fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: (themedata.value.index == 0)
                                          ? Color(black)
                                          : Color(white))),
                              softWrap: true,
                            ),
                          )),
                    ]);
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.video_gallery,
                        size: 30,
                      ),
                      Text("Video")
                    ],
                  )),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    if (!mounted) return;
                    setState(() {
                      attachmentShowing = false;
                    });
                    // Navigator.pop(context);
                    return await audio().then((value) async {
                      if (value!.files.isNotEmpty) {

                        for (var file in value.files) {

                          if (file.size < 52428800 && file.bytes != null) {


                            if (widget.state == 0) {

                              await writeUserMessage(
                                type: 3,
                                // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                peerName: chatRoomSnapshot.data!
                                    .data()!["members"]["${widget
                                    .puid}"]["name"],
                                peerPic: chatRoomSnapshot.data!
                                    .data()!["members"]["${widget
                                    .puid}"]["pic"],
                                replyMap: replyMessageMap,
                                file: file.bytes,
                                contentType: "audio/" + file.extension!,
                              );

                              if (replyMessageMap != null &&
                                  replyUserName != null) {

                                if (!mounted) return;
                                setState(() {
                                  replyMessageMap = null;
                                  replyUserName = null;
                                });
                              }
                            } else {

                              await writeGroupMessage(
                                  type: 3,
                                  members: chatRoomSnapshot.data!
                                      .data()!["members"],
                                  file: file.bytes,
                                  replyMap: replyMessageMap,
                                  contentType:"audio/" + file.extension!,
                                  groupName: chatRoomSnapshot.data!
                                      .data()!["title"],
                                  groupPic: chatRoomSnapshot.data!
                                      .data()!["pic"]);
                              if (replyMessageMap != null &&
                                  replyUserName != null) {
                                if (!mounted) return;
                                setState(() {
                                  replyMessageMap = null;
                                  replyUserName = null;
                                });
                              }
                            }
                          } else {
                            final snackBar = snackbar(
                                content: "File size is greater than 50MB");
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                          }
                        }
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.music_folder,
                        size: 30,
                      ),
                      Text("Audio")
                    ],
                  )),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    if (!mounted) return;
                    setState(() {
                      attachmentShowing = false;
                    });
                    // Navigator.pop(context);
                    return await files().then((value) async {
                      if (value!.files.isNotEmpty) {
                        for (var file in value.files) {
                          if (file.size < 52428800 && file.bytes != null) {
                            if (widget.state == 0) {
                              await writeUserMessage(
                                type: 4,
                                // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                                peerName: chatRoomSnapshot.data!
                                    .data()!["members"]["${widget
                                    .puid}"]["name"],
                                peerPic: chatRoomSnapshot.data!
                                    .data()!["members"]["${widget
                                    .puid}"]["pic"],
                                replyMap: replyMessageMap,
                                file: file.bytes,
                                contentType: lookupMimeType(file.path!)!,
                              );
                              if (replyMessageMap != null &&
                                  replyUserName != null) {
                                if (!mounted) return;
                                setState(() {
                                  replyMessageMap = null;
                                  replyUserName = null;
                                });
                              }
                            } else {
                              await writeGroupMessage(
                                type: 4,
                                members: chatRoomSnapshot.data!
                                    .data()!["members"],
                                file: file.bytes,
                                contentType: lookupMimeType(file.path!),
                                groupName: chatRoomSnapshot.data!
                                    .data()!["title"],
                                groupPic: chatRoomSnapshot.data!.data()!["pic"],
                                replyMap: replyMessageMap,
                              );
                              if (replyMessageMap != null &&
                                  replyUserName != null) {
                                if (!mounted) return;
                                setState(() {
                                  replyMessageMap = null;
                                  replyUserName = null;
                                });
                              }
                            }
                          } else {
                            final snackBar = snackbar(
                                content: "File size is greater than 50MB");
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                          }
                        }
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.file,
                        size: 30,
                      ),
                      Text("File")
                    ],
                  )),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    if (!mounted) return;
                    setState(() {
                      attachmentShowing = false;
                    });
                    // Navigator.pop(context);

                    return await gif(context: context).then((value) async {
                      if (value != null && value.images.original!.url != null) {
                        if (widget.state == 0) {
                          await writeUserMessage(
                            type: 6,
                            // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                            peerName: chatRoomSnapshot.data!
                                .data()!["members"]["${widget.puid}"]["name"],
                            peerPic: chatRoomSnapshot.data!
                                .data()!["members"]["${widget.puid}"]["pic"],
                            replyMap: replyMessageMap,
                            message: value.images.original!.url,
                          );
                          if (replyMessageMap != null &&
                              replyUserName != null) {
                            if (!mounted) return;
                            setState(() {
                              replyMessageMap = null;
                              replyUserName = null;
                            });
                          }
                        } else {
                          await writeGroupMessage(
                            type: 6,
                            members: chatRoomSnapshot.data!.data()!["members"],
                            message: value.images.original!.url,
                            groupName: chatRoomSnapshot.data!.data()!["title"],
                            groupPic: chatRoomSnapshot.data!.data()!["pic"],
                            replyMap: replyMessageMap,
                          );
                          if (replyMessageMap != null &&
                              replyUserName != null) {
                            if (!mounted) return;
                            setState(() {
                              replyMessageMap = null;
                              replyUserName = null;
                            });
                          }
                        }
                      } else {
                        final snackBar = snackbar(
                            content: "Unexpected error in gif!. try again!");
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.gif,
                        size: 30,
                      ),
                      Text("Gif")
                    ],
                  )),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    if (!mounted) return;
                    setState(() {
                      attachmentShowing = false;
                    });

                    // // Navigator.pop(context);
                    return await getUserLocation().then((value) async {
                      if (value.item1 != null) {
                        return await hereReverseGeocode(value.item1).then((
                            response) async {
                          Map<String, dynamic> body = jsonDecode(response.body);
                          if (widget.state == 0) {
                            await writeUserMessage(
                              type: 7,
                              // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                              peerName: chatRoomSnapshot.data!
                                  .data()!["members"]["${widget.puid}"]["name"],
                              peerPic: chatRoomSnapshot.data!
                                  .data()!["members"]["${widget.puid}"]["pic"],
                              replyMap: replyMessageMap,
                              message: "https://www.google.com/maps/search/?api=1&query=${value
                                  .item1.latitude},${value.item1.longitude}" +
                                  "\n" +
                                  body["Response"]['View'][0]["Result"][0]['Location']['Address']['Label'],
                            );
                            if (replyMessageMap != null &&
                                replyUserName != null) {
                              if (!mounted) return;
                              setState(() {
                                replyMessageMap = null;
                                replyUserName = null;
                              });
                            }
                          } else {
                            await writeGroupMessage(
                              type: 7,
                              members: chatRoomSnapshot.data!
                                  .data()!["members"],
                              message: "https://www.google.com/maps/search/?api=1&query=${value
                                  .item1.latitude},${value.item1.longitude}" +
                                  "\n" +
                                  body["Response"]['View'][0]["Result"][0]['Location']['Address']['Label'],
                              groupName: chatRoomSnapshot.data!
                                  .data()!["title"],
                              groupPic: chatRoomSnapshot.data!.data()!["pic"],
                              replyMap: replyMessageMap,
                            );
                            if (replyMessageMap != null &&
                                replyUserName != null) {
                              if (!mounted) return;
                              setState(() {
                                replyMessageMap = null;
                                replyUserName = null;
                              });
                            }
                          }
                        });
                      } else {
                        final snackBar = snackbar(
                            content: "Please enable location services");
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.placeholder,
                        size: 30,
                      ),
                      Text("Location")
                    ],
                  )),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () async {
                    if (!mounted) return;
                    setState(() {
                      attachmentShowing = false;
                    });

                    // // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ContactList(state: 1))).then((
                        value) async {
                      if (value != null) {
                        for (var i in value) {
                          if (widget.state == 0) {
                            await writeUserMessage(
                              type: 8,
                              // peerChattingWith: userDetailSnapshot!.data()!["chattingWith"],
                              peerName: chatRoomSnapshot.data!
                                  .data()!["members"]["${widget.puid}"]["name"],
                              peerPic: chatRoomSnapshot.data!
                                  .data()!["members"]["${widget.puid}"]["pic"],
                              replyMap: replyMessageMap,
                              message: i.displayName + "\n" + i.phones[0],
                            );
                            if (replyMessageMap != null &&
                                replyUserName != null) {
                              if (!mounted) return;
                              setState(() {
                                replyMessageMap = null;
                                replyUserName = null;
                              });
                            }
                          } else {
                            await writeGroupMessage(
                              type: 8,
                              members: chatRoomSnapshot.data!
                                  .data()!["members"],
                              message: i.displayName + "\n" + i.phones[0],
                              groupName: chatRoomSnapshot.data!
                                  .data()!["title"],
                              groupPic: chatRoomSnapshot.data!.data()!["pic"],
                              replyMap: replyMessageMap,
                            );
                            if (replyMessageMap != null &&
                                replyUserName != null) {
                              if (!mounted) return;
                              setState(() {
                                replyMessageMap = null;
                                replyUserName = null;
                              });
                            }
                          }
                        }
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        DeejosIcon.contact_book,
                        size: 30,
                      ),
                      Text("Contact")
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

}