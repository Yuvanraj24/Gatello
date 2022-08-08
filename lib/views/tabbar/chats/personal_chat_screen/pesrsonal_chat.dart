import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/tabbar/chats/group_personal_screen/group_personal_chat.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/report_dialog.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Helpers/DateTimeHelper.dart';
import '../../../../Others/Structure.dart';
import '../../../../Others/components/ExceptionScaffold.dart';
import '../../../../Others/lottie_strings.dart';

import '../../../../core/models/pings_chat_model/pings_personal_chat_model.dart';
import '../../../../handler/LifeCycle.dart';
import 'block_dialog.dart';
import 'clear_dialog.dart';
import 'delete_dialog.dart';
import 'mute_notification.dart';

class PersonalChat extends StatefulWidget {

  String? uid;
  String? puid;
  int? state;
  PersonalChat(
      {Key? key, required this.state, required this.uid, required this.puid})
      : super(key: key);

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  int chg = 0;
  String? uid;
  String? puid;
  int? state;
  bool isSelected = false;

  String tempPuid = "";
  Future<DocumentSnapshot<Map<String, dynamic>>>? initUpdateFuture;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  var lifecycleEventHandler;
  StreamController<DocumentSnapshot<Map<String, dynamic>>> _chatRoomStreamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();
  int lastUnreadCount = 0;
  String? lastReadTimestamp;
  bool personalChatRoomDocExists = false;
  List<DocumentSnapshot<Map<String, dynamic>>> chatList = [];
  bool _isRequesting = false;
  bool _isFinish = false;
  StreamController<List<DocumentSnapshot<Map<String, dynamic>>>> _streamController = StreamController<List<DocumentSnapshot<Map<String, dynamic>>>>();
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getLastMessageSub;
  int pageLimit = 30;

  List<int> _selectedItems = [];
  var mycolor = Colors.transparent;
  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "Hello, Yuvan",
        messageType: "receiver",
        selected: true),
    ChatMessage(
        messageContent: "Hw r u ?", messageType: "receiver", selected: true),
    ChatMessage(
        messageContent: "Hey Aishu, I am fine. w abt u?",
        messageType: "sender",
        selected: true),
    ChatMessage(
        messageContent: "yeah fine.", messageType: "receiver", selected: true),
    ChatMessage(
        messageContent: "im in office chat u later ?",
        messageType: "sender",
        selected: true),
    ChatMessage(messageContent: ".", messageType: "sender", selected: true),
  ];

  File? image;

  Future pickimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final temporaryImage = File(image.path);
      setState(() {
        this.image = temporaryImage;
      });
    } on PlatformException catch (e) {
      print('unable to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
              if (chatRoomSnapshot.hasData && chatRoomSnapshot.connectionState == ConnectionState.active) {
                if (widget.state == 0) {
                  return StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                      return SafeArea(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/per_chat_icons/chat_background_image.png'),
                                  fit: BoxFit.cover)),
                          child: Scaffold(
                            //  resizeToAvoidBottomInset: true,
                            backgroundColor: Colors.transparent,
                            appBar: chg == 0
                                ? AppBar(
                              leading: Padding(
                                // padding: EdgeInsets.only(left: 18.w, bottom: 19.h, top: 24.h
                                //     // right: 18.w
                                //     ),
                                padding: EdgeInsets.only(left: 13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/per_chat_icons/back_icon.png',
                                        ),
                                        width: 16.w,
                                      ),
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => Group_Info()));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              centerTitle: false,
                              titleSpacing: -5.5.w,
                              title: Padding(
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 7.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 35.h,
                                      width: 35.w,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        // image: DecorationImage(
                                        //     image: AssetImage(
                                        //         'assets/per_chat_icons/dp_image.png'),
                                        //     fit: BoxFit.cover)
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: [
                                          Text(
                                            emptyChatRoomDetails.data!
                                                .data()!["name"],
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black)),
                                          ),
                                          SizedBox(height: 3.h),

                                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                              stream: instance.collection("user-detail").doc(widget.puid).snapshots(),
                                              builder: (context, peerSnapshot) {
                                                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                  stream: instance.collection("user-detail").doc(widget.uid).snapshots(),
                                                  builder: (context, userSnapshot) {
                                                    if (userSnapshot.connectionState == ConnectionState.active &&
                                                        peerSnapshot.connectionState == ConnectionState.active) {
                                                      return Container(
                                                        child: Text(
                                                          (userSnapshot.data!.data()!["onlineStatus"] == true && peerSnapshot.data!.data()!["onlineStatus"] == true)
                                                              ? (peerSnapshot.data!.data()!["status"] == "online")
                                                              ? "Online"
                                                              : (userSnapshot.data!.data()!["lastseenStatus"] == true &&
                                                              peerSnapshot.data!.data()!["lastseenStatus"] == true)
                                                              ? "Last seen ${getDateTimeInChat(datetime: getDateTimeSinceEpoch(datetime: peerSnapshot.data!.data()!["status"]))} at ${formatTime(getDateTimeSinceEpoch(datetime: peerSnapshot.data!.data()!["status"]))}"
                                                              : "Tap here for user info"
                                                              : "Tap here for user info",
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
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
                                  ],
                                ),
                              ),
                              actionsIconTheme: IconThemeData(color: Colors.black),
                              actions: [
                                //   Image.asset('assets/per_chat_icons/call_icon.png'),
                                //   Image.asset("assets/tabbar_icons/chats_image/video_call_icon.svg"),
                                InkWell(
                                  child: SvgPicture.asset(
                                    'assets/per_chat_icons/call_icon.svg',
                                    height: 18.h,
                                  ),
                                  onTap: () {
                                    showConfirmationDialog(context);
                                  },
                                ),
                                SizedBox(
                                  width: 18.w,
                                ),
                                SvgPicture.asset(
                                  'assets/per_chat_icons/video icon.svg',
                                  height: 22.h,
                                ),
                                //  SizedBox(width: 16),
                                //    Icon(Icons.video_call),
                                //Image.asset('assets/per_chat_icons/video.png'),

                                PopupMenuButton(
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(
                                          onTap: () {},
                                          child: Text(
                                            "View Profile",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {},
                                          child: Text(
                                            "Search",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(Duration(seconds: 0),
                                                    () =>
                                                    showConfirmationDialog(context)
                                            );
                                            //

                                          },
                                          child: Text(
                                            "Mute Notification",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(Duration(seconds: 0),
                                                    () =>
                                                    showConfirmationDialog1(context)
                                            );
                                          },
                                          child: Text(
                                            "Report",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(Duration(seconds: 0),
                                                    () =>
                                                    showConfirmationDialog2(
                                                        context));
                                          },
                                          child: Text(
                                            "Clear chats",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(Duration(seconds: 0),
                                                    () =>
                                                    showConfirmationDialog3(
                                                        context));
                                          },
                                          child: Text(
                                            "Block",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                    Color.fromRGBO(255, 0, 0, 1))),
                                          ))
                                    ]),
                              ],
                            )
                                :
                            AppBar(
                              leading: Padding(
                                padding: EdgeInsets.only(
                                  left: 18.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/per_chat_icons/back_icon.png',
                                        ),
                                        width: 16.w,
                                      ),
                                      onTap: () {
                                        // Navigator.push(
                                        // context,
                                        // MaterialPageRoute(
                                        //     builder: (context) => Group_Info()));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actionsIconTheme: IconThemeData(color: Colors.black),
                              actions: [
                                // Icon(Icons.account_box),
                                InkWell(
                                  child: SvgPicture.asset(
                                    'assets/tabbar_icons/tab_v'
                                        'iew_main/chats_image/per_chat_o'
                                        'ntap_icons/backward.svg',
                                    width: 18.w,
                                  ),
                                  onTap: () {},
                                ),
                                SizedBox(width: 16),
                                InkWell(
                                    child: SvgPicture.asset(
                                      'assets/tabbar_icons/tab_view_main/chats_ima'
                                          'ge/per_chat_ontap_icons/delete.svg',
                                      color: Colors.black,
                                      height: 20.h,
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          });
                                    }),

                                SizedBox(width: 16),
                                SvgPicture.asset(
                                  'assets/tabbar_icons/tab_view_main/cha'
                                      'ts_image/per_chat_ontap_icons/forward.svg',
                                  width: 18.w,
                                ),
                                PopupMenuButton(
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(
                                          child: Text(
                                            "Info",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          child: Text(
                                            "Share",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {

                                          },
                                          child: Text(
                                            "Report",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                      PopupMenuItem(
                                          child: Text(
                                            "Copy",
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))),
                                          )),
                                    ]),
                              ],
                            ),

                            body: Container(
                              padding: EdgeInsets.only(
                                  bottom: 4.h, left: 12, right: 12),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 24.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(

                                          //color: Colors.black.withOpacity(0.2)
                                            color: HexColor('#FCFCFC'),
                                            // border: Border.all(color:HexColor('#CACACA'),
                                            // width: 0.2)
                                            borderRadius: BorderRadius.circular(
                                                width * 0.01),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(0, 0, 0, 1))
                                            ]),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              '20 Dec 2021',
                                              style: TextStyle(
                                                  fontSize: width * 0.031,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    itemCount: messages.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: GestureDetector(
                                          onLongPress: () {
                                            setState(() {
                                              if (isSelected) {
                                                mycolor = Color.fromRGBO(
                                                    248, 206, 97, 0.31);
                                                isSelected = false;
                                                chg = 1;
                                              } else {
                                                mycolor = Colors.transparent;
                                                isSelected = true;
                                                chg = 0;
                                              }
                                            });
                                          },
                                          child: Container(
                                            //  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                                            color: mycolor,
                                            child: Align(
                                              alignment:
                                              (messages[index].messageType ==
                                                  "receiver"
                                                  ? Alignment.topLeft
                                                  : Alignment.topRight),
                                              child: Container(
                                                  constraints: BoxConstraints(
                                                    minWidth: 100.w,
                                                    maxWidth: 272.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    messages[index].messageType ==
                                                        "receiver"
                                                        ? BorderRadius.only(
                                                        topLeft: Radius.circular(
                                                            15),
                                                        topRight: Radius.circular(
                                                            15),
                                                        bottomRight: Radius
                                                            .circular(15))
                                                        : BorderRadius.only(
                                                        topLeft: Radius.circular(
                                                            15),
                                                        topRight: Radius.circular(
                                                            15),
                                                        bottomLeft: Radius.circular(
                                                            15)),
                                                    color:
                                                    (messages[index].messageType ==
                                                        "receiver"
                                                        ? Colors.grey.shade200
                                                        : Color.fromRGBO(
                                                        248, 206, 97, 1)),
                                                  ),
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(messages[index]
                                                          .messageContent,
                                                          style: GoogleFonts.inter(
                                                              textStyle: TextStyle(
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      0, 0, 0,
                                                                      1)))),
                                                      Positioned(
                                                        right: 1,
                                                        bottom: 1,
                                                        child: Text("3:30 PM",
                                                            style: GoogleFonts
                                                                .inter(
                                                                fontSize: 10.sp,
                                                                fontWeight: FontWeight
                                                                    .w400,
                                                                color: Color
                                                                    .fromRGBO(
                                                                    12, 16, 29,
                                                                    0.6))),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Column(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          //   padding: EdgeInsets.only(top: 570.h),
                                          //  color: Colors.blue,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  height: 36.h,
                                                  width: 291.w,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#FFFFFF'),
                                                    borderRadius: BorderRadius
                                                        .circular(35.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 0.02,
                                                          color: Colors.grey)
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 4.w),
                                                      Expanded(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .only(right: 5),
                                                            // color: Colors.lightGreen,
                                                            child: TextField(
                                                              decoration: InputDecoration(
                                                                prefixIcon: Icon(
                                                                  Icons
                                                                      .emoji_emotions_outlined,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black38,
                                                                ),

                                                                // isDense: true,
                                                                // isCollapsed: true,
                                                                border: InputBorder
                                                                    .none,
                                                                contentPadding: EdgeInsets
                                                                    .only(
                                                                    top: 10.h,
                                                                    bottom: 10.w,
                                                                    right: 6),
                                                                hintText: 'Ping here...',
                                                                hintStyle: GoogleFonts
                                                                    .inter(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                        color: HexColor(
                                                                            '#9A9A9A'))),
                                                              ),
                                                            ),
                                                          )),
                                                      InkWell(
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/per_chat_icons/attach_file_icon.png'),
                                                          height: 30.h,
                                                        ),
                                                        onTap: () {
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
                                                                              iconCreation(
                                                                                  "assets/tabbar_icons/chats_image/attachment_icon_container/document_icon_container.png",
                                                                                  "Document"),
                                                                              iconCreation(
                                                                                  "assets/tabbar_icons/chats_image/attachment_icon_container/camera_icon_container.png",
                                                                                  "Camera"),
                                                                              iconCreation(
                                                                                  "assets/tabbar_icons/chats_image/attachment_icon_container/gallery_icon_container.png",
                                                                                  "Gallery")
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceEvenly,
                                                                            children: [
                                                                              iconCreation(
                                                                                  "assets/tabbar_icons/chats_image/attachment_icon_container/audio_icon_container.png",
                                                                                  "Audio"),
                                                                              iconCreation(
                                                                                  "assets/tabbar_icons/chats_image/attachment_icon_container/location_icon_container.png",
                                                                                  "Location"),
                                                                              iconCreation(
                                                                                  "assets/tabbar_icons/chats_image/attachment_icon_container/contact_icon_container.png",
                                                                                  "Contact")
                                                                            ],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                      ),
                                                      SizedBox(width: 7.w),
                                                      InkWell(
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/per_chat_icons/camera.png'),
                                                          height: 30.h,
                                                        ),
                                                        onTap: () {
                                                          pickimage();
                                                        },
                                                      ),
                                                      //   SizedBox(width: 12.w),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              // Container(
                                              //     decoration: BoxDecoration(
                                              //         color: Color.fromRGBO(248, 206, 97, 1),
                                              //         shape: BoxShape.circle),
                                              //     height: 30.h,
                                              //     width: 30.w,
                                              //     child: SvgPicture.asset(
                                              //       'assets/per_chat_icons/mic_icon.svg',
                                              //       height: 10,
                                              //       width: 10,

                                              //       ///  fit: BoxFit.cover,
                                              //       //  ,width: 20.w,
                                              //     )
                                              //     // Image(
                                              //     //   image:
                                              //     //    SvgPicture.asset(
                                              //     //     'assets/per_chat_icons/mic_icon.svg',
                                              //     //   ),
                                              //     //  width: 40,
                                              //     //  height: 50,
                                              //     // ),
                                              //     ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(37.w, 37.h),
                                                      primary: Color.fromRGBO(
                                                          248, 206, 97, 1),
                                                      shape: CircleBorder()),
                                                  onPressed: () {},
                                                  child: SvgPicture.asset(
                                                    'assets/per_chat_icons/mic_icon.svg',
                                                    height: 18.h,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }else{
                  return Container();
                }
              }
              else {
                return Container();
              }
          }
        );
      }
      else {
        return exceptionScaffold(context: context, lottieString: loadingLottie, subtitle: "Loading Chats");
      }
      }
    );
  }
  showConfirmationDialog(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog();
      },
    );
  }
  showConfirmationDialog1(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ReportCustomDialog();
      },
    );
  }
  showConfirmationDialog2(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ClearCustomDialog();
      },
    );
  }
  showConfirmationDialog3(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlockCustomDialog();
      },
    );
  }

  initialiser() async {
    log("initState");
    if (widget.state == 0) {
      if (tempPuid != widget.puid!) {
        initUpdateFuture = (widget.state == 0) ? instance.collection("user-detail").doc(widget.puid!).get() : instance.collection("group-detail").doc(widget.puid!).get();
        lifecycleHandler();
        userChatRoomDocExists();
        initUserMessageUpdate();
        getUserLastMessage();
        tempPuid = widget.puid!;
      }
    } else {
      if (tempPuid != widget.puid!) {
        initUpdateFuture = (widget.state == 0) ? instance.collection("user-detail").doc(widget.puid!).get() : instance.collection("group-detail").doc(widget.puid!).get();
        lifecycleHandler();
        groupDetailDoc();
        initGroupMessageUpdate();
        getGroupLastMessage();
        tempPuid = widget.puid!;
      }
    }
  }
  Future lifecycleHandler() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String? uid =sharedPrefs.getString("userid");
    await instance.collection("user-detail").doc(uid).update({
      // "status": DateTime.now().millisecondsSinceEpoch.toString(),
      "chattingWith": widget.puid!,
    });
    if (uid != null && WidgetsBinding.instance != null) {
      lifecycleEventHandler = LifecycleEventHandler(detachedCallBack: () async {
        try {
          await instance.collection("user-detail").doc(uid).update({
            // "status": DateTime.now().millisecondsSinceEpoch.toString(),
            "chattingWith": null,
          });
        } catch (e) {
          log(e.toString());
        }
      }, resumeCallBack: () async {
        try {
          await instance.collection("user-detail").doc(uid).update({
            // "status": DateTime.now().millisecondsSinceEpoch.toString(),
            "chattingWith": widget.puid!,
          });
        } catch (e) {
          log(e.toString());
        }
      });
      WidgetsBinding.instance!.addObserver(lifecycleEventHandler);
    }
  }
  userChatRoomDocExists() {
    String roomid = roomId(uid: widget.uid!, puid: widget.puid!);
    instance.collection("personal-chat-room-detail").doc(roomid).snapshots().listen((snapshot) {
      if (snapshot.exists && _chatRoomStreamController.isClosed == false) {
        _chatRoomStreamController.add(snapshot);
        if (snapshot.exists && lastUnreadCount == 0 && lastReadTimestamp == null && personalChatRoomDocExists == false) {
          lastUnreadCount = snapshot.data()!["members"]["${widget.uid!}"]["unreadCount"] ?? 0;
          lastReadTimestamp = snapshot.data()!["members"]["${widget.uid!}"]["lastRead"];
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
    if (tempPuid != widget.puid!) {
      chatList.clear();
      _isRequesting = false;
      _isFinish = false;
    }
    String roomid = roomId(uid: widget.uid!, puid: widget.puid!);
    DocumentSnapshot<Map<String, dynamic>> userDetailsDoc = await instance.collection("user-detail").doc(widget.uid!).get();
    DocumentSnapshot<Map<String, dynamic>> peerDetailsDoc = await instance.collection("user-detail").doc(widget.puid!).get();
    await instance.collection("user-detail").doc(widget.uid!).update({
      "chattingWith": widget.puid!,
    });
    await readUserMessages();
    // await readUserMessages().whenComplete(() {
    //   // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    //   return getUserLastMessage();
    // });
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    if (personalChatRoomDocExists) {
      if (userDetailsDoc.data()!["readRecieptStatus"] == true && peerDetailsDoc.data()!["readRecieptStatus"] == true) {
        instance.collection("personal-chat-room-detail").doc(roomid).update({"members.${widget.uid!}.lastRead": timestamp, "members.${widget.uid!}.unreadCount": 0});
      } else {
        instance.collection("personal-chat-room-detail").doc(roomid).update({"members.${widget.uid!}.unreadCount": 0});
      }
      //!this is poor design.. should use visibility detected and update the message read timestamp.
      if (lastUnreadCount != 0 && lastReadTimestamp != null && userDetailsDoc.data()!["readRecieptStatus"] == true && peerDetailsDoc.data()!["readRecieptStatus"] == true) {
        Future<QuerySnapshot<Map<String, dynamic>>> missedMessages =
        instance.collection("personal-chat").doc(roomid).collection("messages").where("timestamp", isGreaterThanOrEqualTo: lastReadTimestamp).get();
        await missedMessages.then((value) {
          value.docs.forEach((element) {
            if (element.data()["from"] == widget.puid!) {
              element.reference.update({
                "read": {"uid": "${widget.uid!}", "timestamp": timestamp},
              });
            }
          });
        });
      }
    }
  }
  getUserLastMessage() {
    String roomid = roomId(uid: widget.uid!, puid: widget.puid!);
    getLastMessageSub = instance.collection("personal-chat").doc(roomid).collection("messages").orderBy("timestamp", descending: true).limit(1).snapshots().listen((event) async {
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
          DocumentSnapshot<Map<String, dynamic>> userDetailsDoc = await instance.collection("user-detail").doc(widget.uid!).get();
          DocumentSnapshot<Map<String, dynamic>> peerDetailsDoc = await instance.collection("user-detail").doc(widget.puid!).get();
          DocumentSnapshot<Map<String, dynamic>> personalRoomDoc = await instance.collection("personal-chat-room-detail").doc(roomid).get();
          // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          print(DateTime.now().compareTo(getDateTimeSinceEpoch(datetime: event.docs.first.data()["timestamp"])));
          if ((DateTime.now().compareTo(getDateTimeSinceEpoch(datetime: event.docs.first.data()["timestamp"])) == 1) &&
              ((userDetailsDoc.data()!["readRecieptStatus"] == true && peerDetailsDoc.data()!["readRecieptStatus"] == true)
                  ? getDateTimeSinceEpoch(datetime: event.docs.first.data()["timestamp"]).compareTo(getDateTimeSinceEpoch(datetime: lastReadTimestamp!)) >= 0
                  : personalRoomDoc.data()!["members"][widget.uid!]["unreadCount"] != 0)) {
            if (event.docs.first.data()["from"] == widget.uid!) {

            } else {

            }
          }
          if (personalRoomDoc.data()!["members"][widget.uid!]["unreadCount"] != 0) {
            WriteBatch writeBatch = instance.batch();
            if (event.docs[0].data()["from"] == widget.puid! && userDetailsDoc.data()!["readRecieptStatus"] == true && peerDetailsDoc.data()!["readRecieptStatus"] == true) {
              writeBatch.update(instance.collection("personal-chat").doc(roomid).collection("messages").doc(event.docs[0].id), {
                "read": {"uid": "${widget.uid!}", "timestamp": timestamp},
              });
            }
            if (userDetailsDoc.data()!["readRecieptStatus"] == true && peerDetailsDoc.data()!["readRecieptStatus"] == true) {
              writeBatch
                  .update(instance.collection("personal-chat-room-detail").doc(roomid), {"members.${widget.uid!}.lastRead": timestamp, "members.${widget.uid!}.unreadCount": 0});
            } else {
              writeBatch.update(instance.collection("personal-chat-room-detail").doc(roomid), {"members.${widget.uid!}.unreadCount": 0});
            }
            writeBatch.commit();
          }

          // if (getDateTimeSinceEpoch(datetime: lastReadTimestamp!).difference(getDateTimeSinceEpoch(datetime: event.docs.first.data()!["timestamp"])).inMicroseconds >= 0 &&
          //     event.docs.first.data()!["from"] == widget.uid!) {
          //   await _audioCache.play('sendTone.mp3');
          // } else {
          //   await _audioCache.play('recieveTone.mp3');
          // }
        }
      }
    });
  }
  groupDetailDoc() {
    instance.collection("group-detail").doc(widget.puid).snapshots().listen((snapshot) {
      if (snapshot.exists && _chatRoomStreamController.isClosed == false) {
        _chatRoomStreamController.add(snapshot);
        // if (groupMemberIds.length != snapshot.data()!["members"].length) {
        //   snapshot.data()!["members"].forEach((String key, value) {
        //     groupMemberIds.add(key);
        //   });
        // }
        if (snapshot.exists && lastUnreadCount == 0 && lastReadTimestamp == null) {
          lastUnreadCount = snapshot.data()!["members.${widget.uid!}.unreadCount"] ?? 0;
          lastReadTimestamp = snapshot.data()!["members.${widget.uid!}.lastRead"];
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
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      instance.collection("group-detail").doc(widget.puid).update({
        "members.${widget.uid}.lastRead": timeStamp,
        "members.${widget.uid}.unreadCount": 0,
      });
      if (lastUnreadCount != 0 && lastReadTimestamp != null) {
        Future<QuerySnapshot<Map<String, dynamic>>> missedMessages =
        instance.collection("group-chat").doc(widget.puid).collection("messages").where("timestamp", isGreaterThanOrEqualTo: lastReadTimestamp).get();
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

  getGroupLastMessage() {
    getLastMessageSub = instance.collection("group-chat").doc(widget.puid).collection("messages").orderBy("timestamp", descending: true).limit(1).snapshots().listen((event) async {
      if (event.docs.isNotEmpty) {
        if (chatList.isEmpty || chatList.first.id != event.docs.first.id) {
          chatList.insert(0, event.docs.first);
          if (!_streamController.isClosed) {
            _streamController.add(chatList);
          }

          // listScrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          DocumentSnapshot<Map<String, dynamic>> groupDetailDoc = await instance.collection("group-detail").doc(widget.puid).get();

          if ((DateTime.now().compareTo(getDateTimeSinceEpoch(datetime: event.docs.first.data()["timestamp"])) == 1) &&
              getDateTimeSinceEpoch(datetime: event.docs.first.data()["timestamp"]).compareTo(getDateTimeSinceEpoch(datetime: lastReadTimestamp!)) >= 0) {
            if (event.docs.first.data()["from"] == widget.uid) {

            } else {

            }
          }

          if (groupDetailDoc.data()!["members"][widget.uid]["unreadCount"] != 0) {
            WriteBatch writeBatch = instance.batch();
            if (event.docs.first.data()["from"] != widget.uid) {
              writeBatch.set(
                  instance.collection("group-chat").doc(widget.puid).collection("messages").doc(event.docs.first.id),
                  {
                    "read": FieldValue.arrayUnion([
                      {"uid": widget.uid, "timestamp": timestamp}
                    ])
                  },
                  SetOptions(merge: true));
            }
            writeBatch.update(instance.collection("group-detail").doc(widget.puid), {
              "members.${widget.uid}.lastRead": timestamp,
              "members.${widget.uid}.unreadCount": 0,
            });
            writeBatch.commit();
          }
        }
      }
    });
  }

  Future readUserMessages() async {
    // if (tempPuid != widget.puid) {
    //   if (_streamController != null && _streamController.hasListener) {
    //     _streamController.close();
    //   }
    // }
    String roomid = roomId(uid: widget.uid!, puid: widget.puid!);
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      _isRequesting = true;
      if (chatList.isEmpty) {
        querySnapshot = await instance.collection("personal-chat").doc(roomid).collection("messages").orderBy("timestamp", descending: true).limit(pageLimit).get();
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

  Future readGroupMessages() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      _isRequesting = true;
      if (chatList.isEmpty) {
        querySnapshot = await instance.collection("group-chat").doc(widget.puid).collection("messages").orderBy("timestamp", descending: true).limit(pageLimit).get();
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
  flusher() async {
    await instance.collection("user-detail").doc(uid).update({
      // "status": DateTime.now().millisecondsSinceEpoch.toString(),
      "chattingWith": null,
    });
    if (lifecycleEventHandler != null) {
      WidgetsBinding.instance!.removeObserver(lifecycleEventHandler);
    }
    await _chatRoomStreamController.close();
    _chatRoomStreamController = StreamController<DocumentSnapshot<Map<String, dynamic>>>();
    await _streamController.close();
    _streamController = StreamController<List<DocumentSnapshot<Map<String, dynamic>>>>();
    getLastMessageSub.cancel();
  }
}


Widget iconCreation(String iconContainer, String text) {
  return Column(
    children: [

      Image(
        image: AssetImage(iconContainer),
        width: 52.w,
        height: 47.h,
      ),
      SizedBox(height: 9.h),
      Text(text,
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400))),
    ],
  );
}