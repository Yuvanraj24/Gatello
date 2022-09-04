import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Database/StorageManager.dart';
import '../../Style/Colors.dart';
import '../../Style/Text.dart';
import '../../components/RecordButton.dart';
import '../../components/SnackBar.dart';
import '../../components/TextField.dart';
import '../../main.dart';
import '../tabbar/chats/group_personal_screen/group_personal_chat.dart';

class Otherstatus extends StatefulWidget {
  const Otherstatus({Key? key}) : super(key: key);

  @override
  State<Otherstatus> createState() => _OtherstatusState();
}


class _OtherstatusState extends State<Otherstatus> with TickerProviderStateMixin {

  bool canSend = false;
  final focusNode = FocusNode();
  late AnimationController voiceRecordAnimationController;
  ValueNotifier<String> recordAudioValueNotifier = ValueNotifier<String>("");
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    voiceRecordAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool attachmentShowing = false;
    List recentEmojiList = [];
    bool emojiShowing = false;
    return Scaffold(
      body:Stack(
          children:[
            Container(height:double.infinity.h,width:double.infinity.w,decoration:BoxDecoration(
             color:Colors.black, image:DecorationImage(image:NetworkImage('https://images.unsplash.com/photo-1589419621083-1ead66c96fa7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWlja2V5JTIwbW91c2V8ZW58MHx8MHx8&w=1000&q=80'),
                )
          ),),
            Positioned(top:28.h,left:10.w,right:12.w,
              child: Row(children: [
                GestureDetector(onTap:() {
                  Navigator.pop(context);
                },
                    child: SvgPicture.asset('assets/status_assets/back_icon.svg',height:32.h,width:32.w)),
                SizedBox(width:10.w),
                Container(height:60.h,width:60.w,decoration:BoxDecoration(shape:BoxShape.circle,
                    image:DecorationImage(image: NetworkImage('https://photosfile.com/wp-content/uploads/2022/03/Exam-Time-DP-18.jpg'),
                        fit:BoxFit.fill),
                    border:Border.all(width:1.5.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                SizedBox(width:10.w),
                Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text('Deena',style:GoogleFonts.inter(fontWeight:FontWeight.w700,
                        fontSize:14.sp,color:Color.fromRGBO(255, 255, 255, 1))),
                    SizedBox(height:5.h),
                    Text('Today at 6:00am',style:GoogleFonts.inter(textStyle:TextStyle(
                        fontWeight:FontWeight.w400,fontSize:11.sp,color:Color.fromRGBO(255, 255, 255, 1)
                    )))
                  ],),Spacer(),
                PopupMenuButton(
                  icon:Icon(Icons.more_vert,color:Colors.white,size:30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  itemBuilder: (context) =>
                  [PopupMenuItem(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('Mute', style:
                            GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 1))),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children:[Text('Ping', style: GoogleFonts.inter(fontWeight: FontWeight.w400,
                                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1))),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                        children: [Text('View profile', style:
                            GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ]),
            ),
            Container(
              padding:EdgeInsets.symmetric(horizontal:20.w),
              height: 40.h,color:Colors.red,
              child:Row(children: [
                //textField for personal chat
                Flexible(
                  child: textField(
                      prefix:
                      IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onPressed: () async {
                            recentEmojiList = await getRecentEmoji();
                            if (!mounted) return;
                            setState(() {
                              if (attachmentShowing) {
                                attachmentShowing = false;
                              }
                              emojiShowing = !emojiShowing;
                              if (!emojiShowing) {
                                focusNode.requestFocus();
                              } else {
                                focusNode.unfocus();
                              }
                            });
                          },
                          icon: Icon(Icons.emoji_emotions_outlined,
                              color: Color.fromRGBO(12, 16, 29, 1))),
                      focusNode: focusNode,
                      textStyle: GoogleFonts.inter(
                          textStyle: textStyle(fontSize: 14, color: (themedata.value.index == 0) ? Color(materialBlack) : Color(white))),
                      textEditingController: textEditingController,
                      hintText: "Ping here...",
                      hintStyle: GoogleFonts.inter(
                          textStyle: textStyle(fontSize: 14, color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey))),
                      border: false,
                      onSubmitted:(v) {

                      },
                      maxLines: 5,
                      fillColor: (themedata.value.index == 0) ? Color(white) : Color(lightBlack),
                      suffixIcon: Container(
                        width: 80,
                        child: Row(
                          children: [
                            GestureDetector(
                              child:SvgPicture.asset("assets/status_assets/chat_attachment.svg"),
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

                                                    GestureDetector(
                                                      onTap: () {

                                                      },

                                                      child:
                                                      iconCreation(
                                                          "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/document_icon_container.png",
                                                          "Document"),
                                                    ),
                                                    GestureDetector(
                                                      onTap: ()  {

                                                      },

                                                      child: iconCreation(
                                                          "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/camera_icon_container.png",
                                                          "Camera"

                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: ()  {

                                                      },

                                                      child: iconCreation(
                                                          "assets/tabbar_icons/tab_view_m"
                                                              "ain/chats_image/attachment_icon"
                                                              "_container/gallery_icon_container.png",
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
                                                      onTap: ()  {

                                                      },

                                                      child: iconCreation(
                                                          "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/audio_icon_container.png",
                                                          "Audio"),
                                                    ),
                                                    GestureDetector(
                                                      onTap: ()  {

                                                      },

                                                      child: iconCreation(
                                                          "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/location_icon_container.png",
                                                          "Location"),
                                                    ),
                                                    GestureDetector(
                                                      onTap: ()  {

                                                      },

                                                      child: iconCreation(
                                                          "assets/tabbar_icons/tab_view_main/chats_image/attachment_icon_container/contact_icon_container.png",
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
                            SizedBox(width:25.w),
                            GestureDetector(
                              child:SvgPicture.asset("assets/status_assets/chat_camera.svg"),
                              onTap: () {

                              },
                            ),

                          ],
                        ),
                      )
                  ),
                ),
                SizedBox(width:16.w),
                (canSend)
                    ? GestureDetector(
                  // elevation: 0,
                    child: Container(
                      height: 45,
                      width: 45,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(accent),
                      ),
                      child: Icon(
                        Icons.send,
                        color: (themedata.value.index == 0) ? Color((canSend) ? white : grey) : Color(grey),
                      ),
                    ),

                    onTap: canSend
                        ? () async {}: null) :
                RecordButton(
                    controller: voiceRecordAnimationController,
                    valueNotifier: recordAudioValueNotifier,
                    function: () async {File file = File(recordAudioValueNotifier.value);
                    if (file.existsSync()) {int length = await file.length();
                    Uint8List bytes = await file.readAsBytes();

                    if (length < 52428800) {

                    } else {
                      final snackBar = snackbar(content: "File size is greater than 50MB");
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    }
                    }),
              ],
              ),
            ),
          ]),
    );
  }
}

class Statusdetails extends StatefulWidget {
  const Statusdetails({Key? key}) : super(key: key);

  @override
  State<Statusdetails> createState() => _StatusdetailsState();
}

class _StatusdetailsState extends State<Statusdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  GestureDetector(onTap:(){Navigator.pop(context);},
          child: Column(mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/profile_assets/back_button.svg',
                  height: 30.h, width:30.w),
            ],
          ),
        ),
        title: Text('My status', style: GoogleFonts.inter(
              textStyle: TextStyle(fontSize:18.sp, fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 0, 0, 1)))),
      ),
      body:Column(
        children: [
          ListView.builder(itemCount:3,shrinkWrap:true,
            itemBuilder: (context, index) {
            return Container(padding:EdgeInsets.symmetric(vertical:7.h),
              child: ListTile(
                leading:Container(height:70.h,width:69.w,decoration:BoxDecoration(shape:BoxShape.circle,
                    image:DecorationImage(image: NetworkImage
                      ('http://www.goodmorningimagesdownload.com/wp-content/uploads/2021/07/Cute-Whatsapp-DP-Wallpaper-Download-3-300x300.jpg'),
                        fit:BoxFit.fill),
                    border:Border.all(width:2.w,color:Color.fromRGBO(248, 206, 97, 1))),),
                title:Text('37 views',style:GoogleFonts.inter(fontWeight:FontWeight.w700,fontSize:14.sp,
                color:Color.fromRGBO(0,0,0,1))),
                subtitle:Text('Today at 6:00am',style:GoogleFonts.inter(fontWeight:FontWeight.w400,fontSize:11.sp,
                  color:Color.fromRGBO(121, 117, 117, 1))),
                trailing: PopupMenuButton(
                  child:SvgPicture.asset('assets/status_assets/statusdetails.svg'),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                          5)),
                  itemBuilder:
                      (context) =>
                  [
                    PopupMenuItem(
                      child:
                      Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [Text('Also show in Pop  status', style:
                            GoogleFonts.inter(textStyle: TextStyle(fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 1))),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child:
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('Delete', style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400, textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1))),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            );
          },),SizedBox(height:30.h),
          Text('Your status updates will disappear after 24 hours',style:GoogleFonts.inter(
              fontWeight:FontWeight.w400,fontSize:14.sp,
              color:Color.fromRGBO(121, 117, 117, 1))),
        ],
      ),
    );
  }
}
