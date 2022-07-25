

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/report_dialog.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/models/pings_chat_model/pings_personal_chat_model.dart';
import '../personal_chat_screen/block_dialog.dart';
import '../personal_chat_screen/clear_dialog.dart';
import '../personal_chat_screen/mute_notification.dart';
import 'exit_group_dialog.dart';


class GroupPersonalChat extends StatefulWidget {
  const GroupPersonalChat(
      {Key? key})
      : super(key: key);

  @override
  State<GroupPersonalChat> createState() => _GroupPersonalChatState();
}

class _GroupPersonalChatState extends State<GroupPersonalChat> {
  int chg = 0;
  bool isSelected = false;
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
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Group',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Suresh, +91 98467341...',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ),
                    ],
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
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        onTap: () {},
                        child: Text(
                          "Search",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration(seconds: 0),
                                  () => showConfirmationDialog(context)
                          );
                          //

                        },
                        child: Text(
                          "Mute Notification",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration(seconds: 0),
                                  () => showConfirmationDialog1(context)
                          );
                        },
                        child: Text(
                          "Report",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration(seconds: 0),
                                  () => showConfirmationDialog2(context));
                        },
                        child: Text(
                          "Clear chats",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration(seconds: 0),
                                  () => showConfirmationDialog3(context));
                        },
                        child: Text(
                          "Exit group",
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
              : AppBar(
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
                  'assets/tabbar_icons/tab_view_main/chats_image/per_chat_ontap_icons/backward.svg',
                  width: 18.w,
                ),
                onTap: () {},
              ),
              SizedBox(width: 16),
              InkWell(
                  child: SvgPicture.asset(
                    'assets/tabbar_icons/tab_view_main/chats_image/per_chat_ontap_icons/delete.svg',
                    color: Colors.black,
                    height: 20.h,
                  ),
                  onTap: () {

                  }),

              SizedBox(width: 16),
              SvgPicture.asset(
                'assets/tabbar_icons/tab_view_main/chats_image/per_chat_ontap_icons/forward.svg',
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
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        child: Text(
                          "Share",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
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
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                    PopupMenuItem(
                        child: Text(
                          "Copy",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        )),
                  ]),
            ],
          ),

          body: Container(
            padding: EdgeInsets.only(bottom: 4.h, left: 12, right: 12),
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
                          borderRadius: BorderRadius.circular(width * 0.01),
                          boxShadow: [
                            BoxShadow(color: Color.fromARGB(0, 0, 0, 1))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            if (isSelected) {
                              mycolor = Color.fromRGBO(248, 206, 97, 0.31);
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
                            (messages[index].messageType == "receiver"
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                                constraints: BoxConstraints(
                                  minWidth: 100.w,
                                  maxWidth: 272.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  messages[index].messageType == "receiver"
                                      ? BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15))
                                      : BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                  color:
                                  (messages[index].messageType == "receiver"
                                      ? Colors.grey.shade200
                                      : Color.fromRGBO(248, 206, 97, 1)),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(messages[index].messageContent,
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1)))),
                                    Positioned(
                                      right: 1,
                                      bottom: 1,
                                      child: Text("3:30 PM",
                                          style: GoogleFonts.inter(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(
                                                  12, 16, 29, 0.6))),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    //   padding: EdgeInsets.only(top: 570.h),
                    //  color: Colors.blue,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            height: 36.h,
                            width: 291.w,
                            decoration: BoxDecoration(
                              color: HexColor('#FFFFFF'),
                              borderRadius: BorderRadius.circular(35.0),
                              boxShadow: [
                                BoxShadow(blurRadius: 0.02, color: Colors.grey)
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 4.w),
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      // color: Colors.lightGreen,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.emoji_emotions_outlined,
                                            size: 30,
                                            color: Colors.black38,
                                          ),

                                          // isDense: true,
                                          // isCollapsed: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              top: 10.h,
                                              bottom: 10.w,
                                              right: 6),
                                          hintText: 'Ping here...',
                                          hintStyle: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: HexColor('#9A9A9A'))),
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
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
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
                                                  BorderRadius.circular(15),
                                                  side: BorderSide(
                                                      color: Color.fromRGBO(
                                                          246, 207, 70, 1))),
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              margin: EdgeInsets.all(30),
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
                                primary: Color.fromRGBO(248, 206, 97, 1),
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
        return ExitGroupCustomDialog();
      },
    );
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
