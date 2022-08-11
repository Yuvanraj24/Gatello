import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../../Authentication/Authentication.dart';
import '../../../../../Helpers/DateTimeHelper.dart';
import '../../../../../Style/Colors.dart';
import '../../../../../Style/Text.dart';
import '../../../../../components/SimpleDialogBox.dart';
import '../../../../../main.dart';

class WallpaperPageView extends StatefulWidget {
  final List<String> imageList;
  final String roomId;
  final int type;
  const WallpaperPageView({Key? key, required this.imageList, required this.roomId, required this.type}) : super(key: key);

  @override
  State<WallpaperPageView> createState() => _WallpaperPageViewState();
}

class _WallpaperPageViewState extends State<WallpaperPageView> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  String uid = getUID();
  PreloadPageController pageController = PreloadPageController();
  int currentPage = 0;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
          elevation: 0,
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text('Preview'),
          actions: [
            IconButton(
                onPressed: () async {
                  return await simpleDialogBox(context: context, widgetList: [
                    SimpleDialogOption(
                        onPressed: () async {
                          await updateOneFirestore(widget.imageList[currentPage], 0);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'For this chat only',
                            style: GoogleFonts.poppins(
                                textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                            softWrap: true,
                          ),
                        )),
                    SimpleDialogOption(
                        onPressed: () async {
                          await updateAllFirestore(widget.imageList[currentPage]);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "For all chats",
                            style: GoogleFonts.poppins(
                                textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                            softWrap: true,
                          ),
                        )),
                  ]);
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: PreloadPageView.builder(
          controller: pageController,
          itemCount: widget.imageList.length,
          preloadPagesCount: 3,
          onPageChanged: (value) {
            if (!mounted) return;
            setState(() {
              currentPage = value;
            });
          },
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // color: Color(black),
                    image: DecorationImage(
                      image: AssetImage(
                        widget.imageList[index],
                      ),
                      fit: BoxFit.cover,
                      // colorFilter: ColorFilter.mode(Colors.black.withOpacity(.25), BlendMode.srcOver),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Chip(
                        label: Text(
                          "Today",
                          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack))),
                        ),
                        backgroundColor: Color(accent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 50, top: 20, bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? MediaQuery.of(context).size.width / 15 : 0,
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                ChatBubble(
                                  alignment: Alignment.centerLeft,
                                  elevation: 0,
                                  clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
                                  backGroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
                                  child: Text(
                                    "This is a sample text message from reciever!",
                                    softWrap: true,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        textStyle: textStyle(
                                          color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    formatTime(DateTime.now()),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        textStyle: textStyle(
                                          color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? MediaQuery.of(context).size.width / 10 : 0,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 20, top: 30, bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? MediaQuery.of(context).size.width / 10 : 0,
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                ChatBubble(
                                  alignment: Alignment.centerRight,
                                  clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
                                  backGroundColor: Color(accent),
                                  elevation: 0,
                                  child: Text(
                                    "This is a sample text message from sender!",
                                    softWrap: true,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        textStyle: textStyle(
                                          color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white),
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    formatTime(DateTime.now()),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        textStyle: textStyle(
                                          color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (sizingInformation.deviceScreenType == DeviceScreenType.desktop) ? MediaQuery.of(context).size.width / 15 : 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    });
  }

  Future updateOneFirestore(String wallpaperName, int type) async {
    if (type == 0) {
      DocumentSnapshot<Map<String, dynamic>> personalChatRoomDetails = await instance.collection("personal-chat-room-detail").doc(widget.roomId).get();
      if (personalChatRoomDetails.exists) {
        personalChatRoomDetails.reference.update({
          "members.${uid}.wallpaper": wallpaperName,
        });
      }
    } else {
      DocumentSnapshot<Map<String, dynamic>> groupChatRoomDetails = await instance.collection("group-detail").doc(widget.roomId).get();
      if (groupChatRoomDetails.exists) {
        groupChatRoomDetails.reference.update({
          "members.${uid}.wallpaper": wallpaperName,
        });
      }
    }
  }

  Future updateAllFirestore(String wallpaperName) async {
    Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetailsNotBlocked =
    instance.collection("personal-chat-room-detail").where("members.${uid}.isBlocked", isEqualTo: false).get();
    await personalChatRoomDetailsNotBlocked.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
          await instance.collection("personal-chat-room-detail").doc(element.id).update({"members.${uid}.wallpaper": wallpaperName});
        });
      }
    });
    Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetailsBlocked =
    instance.collection("personal-chat-room-detail").where("members.${uid}.isBlocked", isEqualTo: true).get();
    await personalChatRoomDetailsBlocked.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
          await instance.collection("personal-chat-room-detail").doc(element.id).update({"members.${uid}.wallpaper": wallpaperName});
        });
      }
    });
    Future<QuerySnapshot<Map<String, dynamic>>> groupDetailsRemoved = instance.collection("group-detail").where("members.${uid}.isRemoved", isEqualTo: true).get();
    await groupDetailsRemoved.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
          await instance.collection("group-detail").doc(element.id).update({"members.${uid}.wallpaper": wallpaperName});
        });
      }
    });
    Future<QuerySnapshot<Map<String, dynamic>>> groupDetailsNotRemoved = instance.collection("group-detail").where("members.${uid}.isRemoved", isEqualTo: false).get();
    await groupDetailsNotRemoved.then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
          await instance.collection("group-detail").doc(element.id).update({"members.${uid}.wallpaper": wallpaperName});
        });
      }
    });
  }
}
