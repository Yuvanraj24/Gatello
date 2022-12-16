import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/ChatPage.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../Authentication/Authentication.dart';
import '../../../../Firebase.dart';
import '../../../../Firebase/Writes.dart';
import '../../../../Helpers/DateTimeHelper.dart';
import '../../../../Helpers/GetContactHelper.dart';
import '../../../../Others/components/LottieComposition.dart';
import '../../../../Others/lottie_strings.dart';
import '../../../../Style/Colors.dart';
import '../../../../Style/Text.dart';
import '../../../../components/AssetPageView.dart';
import '../../../../components/ScaffoldDialog.dart';
import '../../../../components/SimpleDialogBox.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/flatButton.dart';
import '../../../../main.dart';
import '../../tabbar_view.dart';
import 'ChatDetailsUpdate.dart';

class ChatDetails extends StatefulWidget {
  ///* peeruid for personal chat and gid for group chat
  final String puid;
  final String uid;
  final SizingInformation sizingInformation;

  ///*0->user,1->group
  final int state;
  const ChatDetails({Key? key, required this.uid, required this.sizingInformation, required this.puid, required this.state}) : super(key: key);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  Future<FilePickerResult?> gallery() async => await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg'],
  );
  var top = 0.0;

  FirebaseFirestore instance = FirebaseFirestore.instance;

  Future changeClaim({
    required int type,
    required String uid,
  }) async {
    DocumentReference<Map<String, dynamic>> groupDetailDocRef = instance.collection("group-detail").doc(widget.puid);
    switch (type) {
      case 0:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "admin") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.claim": "admin",
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the admin of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
          // await instance.collection("group-detail").doc(widget.puid).update({
          //   "members.$uid.claim": "admin",
          // });
        }
        break;

      case 1:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "admin") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.claim": "member",
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the admin of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
          // await instance.collection("group-detail").doc(widget.puid).update({
          //   "members.$uid.claim": "member",
          // });
        }
        break;
      case 2:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "admin") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.isRemoved": true,
                  "members.$uid.claim": "removed",
                  "members.$uid.unreadCount": 0,
                  "members.$uid.lastRead": null,
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the admin of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
        }
        break;
      case 3:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "member") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.isRemoved": true,
                  "members.$uid.claim": "removed",
                  "members.$uid.unreadCount": 0,
                  "members.$uid.lastRead": null,
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the member of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
        }
        break;
      default:
        {
          print("error");
        }
        break;
    }
  }
  var peerName;
  var fPhone;
  @override
  void initState() {
    instance.collection("user-detail").doc(widget.puid).get().then((doc) {
      fPhone = doc.data()!['phone'];
      print("fPhone ${fPhone}");
      getContactName(fPhone).then((value) {print("peer b4 print");
      peerName = value.toString();
      print("peer after print");
      }).then((value) {
        print("value is : ${peerName}");
      });
    });

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: (widget.state == 0) ? instance.collection("user-detail").doc(widget.puid).snapshots() : instance.collection("group-detail").doc(widget.puid).snapshots(),
        builder: (context, chatDetailSnapshot) {
          if (chatDetailSnapshot.hasData && chatDetailSnapshot.connectionState == ConnectionState.active) {
            return ResponsiveBuilder(builder: (context, sizingInformation) {
              return Scaffold(
                  appBar: AppBar(centerTitle: false,
                    automaticallyImplyLeading: false,
                    backgroundColor:Color.fromRGBO(248, 206, 97, 1),
                    elevation: 0,
                    actions:  [
                      SizedBox(width:22.w),
                      (widget.state == 0)?SizedBox():
                      PopupMenuButton(
                          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(7)),
                          icon:Icon(Icons.more_vert_rounded,color:Colors.black),
                          iconSize:26,
                          itemBuilder: (context) =>
                          [
                            PopupMenuItem(
                              child: Text("Report group",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                  fontSize:13.sp,color:Color.fromRGBO(255, 0, 0, 1)))),

                              value: 1,
                            ),
                            PopupMenuItem(
                                onTap:()async{
                                  await changeClaim(type: 3, uid: widget.uid);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                value: 1,
                                child:Text("Exit group",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                    fontSize:13.sp,color:Color.fromRGBO(255, 0, 0, 1)))))
                          ])
                    ],
                    leading: GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/pops_asset/back_button.svg',height:35.h,
                              width:35.w,),
                          ],
                        )),
                    title: Text((widget.state == 0) ? "Personal Info" : "Group Info",
                        style: GoogleFonts.inter(fontSize:16.sp,fontWeight:FontWeight.w500,color:
                        (themedata.value.index == 0) ? Color(black) : Color(white))),
                  ),
                  body: ((widget.state == 0) ? true : chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] != "removed")
                      ? SingleChildScrollView(
                    child: Container(padding:EdgeInsets.fromLTRB(12.w,22.h,12.w,0.h),
                      child: Column(crossAxisAlignment:CrossAxisAlignment.center,
                        children: [Stack(
                            children: [
                              (chatDetailSnapshot.data!.data()!["pic"] != null)?
                              CachedNetworkImage(
                                imageUrl: chatDetailSnapshot.data!.data()!["pic"],
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 80.0.w,
                                  height: 80.0.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ):
                              SvgPicture.asset((widget.state == 0) ? "assets/invite_friends/profilepicture.svg" : "assets/invite_friends/profilepicture.svg", fit: BoxFit.cover,
                                height:80.h,
                                width: 80.w,
                              ),
                              (widget.state == 0)?SizedBox():Positioned(right:0.w,top:1.h,
                                child: Container(
                                  height: 28.h,
                                  width: 28.w,
                                  child: GestureDetector(
                                    onTap: () async {
                                      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

                                      return await gallery().then((value) async {
                                        if (value != null && value.files.first.size<52428800) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AssetPageView(
                                                    fileList: value.files,
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(
                                                          guid: widget.puid,
                                                          file: value.files.first.bytes!,
                                                          fileName: timestamp,
                                                          contentType: "image/" + value.files.first.extension!);
                                                      String url = await taskSnapshot.ref.getDownloadURL();

                                                      await instance
                                                          .collection("group-detail")
                                                          .doc(widget.puid)
                                                          .set({"pic": url, "updatedAt": DateTime.now().millisecondsSinceEpoch.toString()}, SetOptions(merge: true));
                                                    },
                                                  )));
                                        } else {
                                          final snackBar = snackbar(content: "File size is greater than 50MB");
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/profile_assets/edittoolblack.svg',
                                            height: 15,
                                            width: 15),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(248, 206, 97, 1),
                                      border: Border.all(color: Color.fromRGBO(255, 255, 255, 1),width: 1),
                                      shape: BoxShape.circle),
                                ),
                              ),
                            ]
                        ),
                          SizedBox(height:11.h),
                          Row(mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Text((widget.state == 0) ? (peerName == null)?fPhone:peerName : chatDetailSnapshot.data!.data()!["title"],
                                  textAlign: TextAlign.center, style: GoogleFonts.inter(textStyle: textStyle(fontSize:20.sp,
                                      fontWeight:FontWeight.w700))),
                              SizedBox(width:4.w),
                              (widget.state == 1 && chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                  ?  Container(
                                height: 20.h,
                                width: 20.w,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                      return await scaffoldAlertDialogBox(
                                          context: context,page: ChatDetailsUpdate(
                                          state: 0, text: chatDetailSnapshot.data!.data()!["title"], guid: chatDetailSnapshot.data!.data()!["gid"]));
                                    } else {
                                      Navigator.push(context,MaterialPageRoute(
                                          builder: (context) => ChatDetailsUpdate(
                                              state: 0, text: chatDetailSnapshot.data!.data()!["title"], guid: chatDetailSnapshot.data!.data()!["gid"])));
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/profile_assets/edittoolblack.svg',
                                          height: 12.h,
                                          width: 12.w),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                        248, 206, 97, 1),
                                    border: Border.all(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 1),
                                        width: 1),
                                    shape: BoxShape.circle),
                              )
                                  : SizedBox(height:0)
                            ],
                          ),
                          SizedBox(height:20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     // Image(
                              //     //   image: AssetImage(
                              //     //     'assets/group_info/calls.png',
                              //     //   ),
                              //     //   width: 42.w,
                              //     // ),
                              //     SvgPicture.asset(
                              //         'assets/group_info/calls icon.svg'),
                              //
                              //     SizedBox(height: 11.h),
                              //     Text(
                              //       'Call',
                              //       style: GoogleFonts.inter(
                              //           textStyle: TextStyle(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.w700,
                              //               color: Colors.black)),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(width: 42.w),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     SvgPicture.asset(
                              //         'assets/group_info/video image.svg'),
                              //     SizedBox(height: 11.h),
                              //     Text(
                              //       'Video',
                              //       style: GoogleFonts.inter(
                              //           textStyle: TextStyle(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.w700,
                              //               color: Colors.black)),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(width: 42.w),
                              GestureDetector(onTap:() async {
                                if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                  return await scaffoldAlertDialogBox(
                                      context: context,
                                      page: SearchPage(
                                        sizingInformation: sizingInformation,
                                        gid: widget.puid,
                                        state: 5,
                                        participants: chatDetailSnapshot.data!.data()!["members"].keys.toList(),
                                      ));
                                } else {
                                  List<String> participantIds = [];
                                  chatDetailSnapshot.data!.data()!["members"].forEach((key, value) {
                                    if (value["isRemoved"] == false) {
                                      participantIds.add(key);
                                    }
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchPage(sizingInformation: sizingInformation, gid: widget.puid, state: 5, participants: participantIds)));
                                }
                              },
                                child: (widget.state==1)?Column(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/group_info/add_participants.svg'),
                                    SizedBox(height: 11.h),
                                    Text('Add',
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ):SizedBox(),
                              )
                            ],
                          ),
                          SizedBox(height:18.h),
                          Divider(),
                          SizedBox(height:11.h),
                          (widget.state == 0) ?
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: instance.collection("group-detail").where("members.${widget.uid}.isRemoved", isEqualTo: false).where("members.${widget.puid}.isRemoved", isEqualTo: false).snapshots(),
                              // stream: instance.collection("group-detail").where("gid", whereIn: ids).snapshots(),
                              builder: (context, groupDetailSnapshot) {
                                if (groupDetailSnapshot.hasData && groupDetailSnapshot.connectionState == ConnectionState.active) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${groupDetailSnapshot.data!.docs.length} Group in Common",
                                          style: GoogleFonts.inter(textStyle:TextStyle(fontSize: 16.sp,
                                              fontWeight: FontWeight.w600))),
                                      SizedBox(height:24.h),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: groupDetailSnapshot.data!.docs.length,
                                        itemBuilder: (context, index) => buildItem(
                                            index: index,
                                            description: groupDetailSnapshot.data!.docs[index]["members"].length.toString(),
                                            pic: (groupDetailSnapshot.data!.docs[index]["pic"] != null) ? groupDetailSnapshot.data!.docs[index]["pic"] : null,
                                            chatDetailSnapshot: chatDetailSnapshot,
                                            name: groupDetailSnapshot.data!.docs[index]["title"],
                                            id: groupDetailSnapshot.data!.docs[index]["gid"]),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container(
                                      child: Center(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [lottieAnimation(invalidLottie), Text("No Groups in common")],
                                            ),
                                          )));
                                }
                              }):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                //  "${chatDetailSnapshot.data!.data()!["members"].length} Participants",
                                  "Group Participants",
                                  style: GoogleFonts.inter(textStyle: textStyle(fontSize: 14.sp, fontWeight: FontWeight.w700
                                      ,color:Color.fromRGBO(0, 163, 255, 1)))),
                              SizedBox(height:15.h),
                              GestureDetector(
                                onTap:() async{
                                  if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                    return await scaffoldAlertDialogBox(
                                        context: context,
                                        page: SearchPage(
                                          sizingInformation: sizingInformation,
                                          gid: widget.puid,
                                          state: 5,
                                          participants: chatDetailSnapshot.data!.data()!["members"].keys.toList(),
                                        ));
                                  } else {
                                    List<String> participantIds = [];
                                    chatDetailSnapshot.data!.data()!["members"].forEach((key, value) {
                                      if (value["isRemoved"] == false) {
                                        participantIds.add(key);
                                      }
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchPage(sizingInformation: sizingInformation, gid: widget.puid, state: 5, participants: participantIds)));
                                  }
                                },
                                child: Row(children:[Container(
                                    height:44.h,width:44.w,decoration:BoxDecoration(color:Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle),
                                    child:SvgPicture.asset('assets/group_info/add_participants.svg',height: 50,width: 50,)),
                                  SizedBox(width:26.w),
                                  Text('Add participants',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w700,
                                      fontSize:16.sp, color:Colors.black)))]),
                              ),
                              SizedBox(height:24.h),

                              Row(children:[Container(padding:EdgeInsets.all(15),
                                  height:44.h,width:44.w,decoration:BoxDecoration(color:Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle),
                                  child:SvgPicture.asset('assets/icons_assets/invite_link.svg')),
                                SizedBox(width:24.w),
                                Text('Invite via link',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w700,
                                    fontSize:16.sp, color:Colors.black)))]),

                              (chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                  ?SizedBox()
                                  :SizedBox(height:0.h),
                              SizedBox(height:12.h),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: chatDetailSnapshot.data!.data()!["members"].length,
                                  itemBuilder: (context, index) => GestureDetector(
                                    onTap: (){
                                      instance.collection("group-detail").doc('EMpxsZbQXLppZE2Oit9H67ZodZjtED').update(
                                          {
                                            'description' : "dont judge",
                                          }
                                      );
                                      print("Group mamber list${chatDetailSnapshot.data!.data()!["members"].keys.elementAt(index)["isRemoved"]}");

                                    },
                                    child: buildItem(
                                        index: index,
                                        pic: (chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["pic"] != null)
                                            ? chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["pic"]
                                            : null,
                                        name: chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["name"],
                                        description: chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["claim"],
                                        chatDetailSnapshot: chatDetailSnapshot,
                                        id: chatDetailSnapshot.data!.data()!["members"].keys.elementAt(index)),
                                  )),

                            ],
                          ),
                          (widget.state == 1) ? Divider() :SizedBox(),
                        ],
                      ),
                    ),
                  )
                      : SingleChildScrollView(
                    child: Container(padding:EdgeInsets.fromLTRB(12.w,22.h,12.w,0.h),
                      child: Column(crossAxisAlignment:CrossAxisAlignment.center,
                        children: [Stack(
                            children: [
                              (chatDetailSnapshot.data!.data()!["pic"] != null)?
                              CachedNetworkImage(
                                imageUrl: chatDetailSnapshot.data!.data()!["pic"],
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 80.0.w,
                                  height: 80.0.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ):
                              SvgPicture.asset((widget.state == 0) ? "assets/invite_friends/profilepicture.svg" : "assets/invite_friends/profilepicture.svg", fit: BoxFit.cover,
                                height:80.h,
                                width: 80.w,
                              ),
                              (widget.state == 0)?SizedBox():Positioned(right:0.w,top:1.h,
                                child: Container(
                                  height: 28.h,
                                  width: 28.w,
                                  child: GestureDetector(
                                    onTap: () async {
                                      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

                                      return await gallery().then((value) async {
                                        if (value != null && value.files.first.size<52428800) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AssetPageView(
                                                    fileList: value.files,
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(
                                                          guid: widget.puid,
                                                          file: value.files.first.bytes!,
                                                          fileName: timestamp,
                                                          contentType: "image/" + value.files.first.extension!);
                                                      String url = await taskSnapshot.ref.getDownloadURL();

                                                      await instance
                                                          .collection("group-detail")
                                                          .doc(widget.puid)
                                                          .set({"pic": url, "updatedAt": DateTime.now().millisecondsSinceEpoch.toString()}, SetOptions(merge: true));
                                                    },
                                                  )));
                                        } else {
                                          final snackBar = snackbar(content: "File size is greater than 50MB");
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/profile_assets/edittoolblack.svg',
                                            height: 15,
                                            width: 15),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(248, 206, 97, 1),
                                      border: Border.all(color: Color.fromRGBO(255, 255, 255, 1),width: 1),
                                      shape: BoxShape.circle),
                                ),
                              ),
                            ]
                        ),
                          SizedBox(height:11.h),
                          Row(mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Text((widget.state == 0) ? (peerName == null)?fPhone:peerName : chatDetailSnapshot.data!.data()!["title"],
                                  textAlign: TextAlign.center, style: GoogleFonts.inter(textStyle: textStyle(fontSize:20.sp,
                                      fontWeight:FontWeight.w700))),
                              SizedBox(width:4.w),
                              (widget.state == 1 && chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                  ?  Container(
                                height: 20.h,
                                width: 20.w,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                      return await scaffoldAlertDialogBox(
                                          context: context,page: ChatDetailsUpdate(
                                          state: 0, text: chatDetailSnapshot.data!.data()!["title"], guid: chatDetailSnapshot.data!.data()!["gid"]));
                                    } else {
                                      Navigator.push(context,MaterialPageRoute(
                                          builder: (context) => ChatDetailsUpdate(
                                              state: 0, text: chatDetailSnapshot.data!.data()!["title"], guid: chatDetailSnapshot.data!.data()!["gid"])));
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/profile_assets/edittoolblack.svg',
                                          height: 12.h,
                                          width: 12.w),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                        248, 206, 97, 1),
                                    border: Border.all(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 1),
                                        width: 1),
                                    shape: BoxShape.circle),
                              )
                                  : SizedBox(height:0)
                            ],
                          ),
                          SizedBox(height:20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     // Image(
                              //     //   image: AssetImage(
                              //     //     'assets/group_info/calls.png',
                              //     //   ),
                              //     //   width: 42.w,
                              //     // ),
                              //     SvgPicture.asset(
                              //         'assets/group_info/calls icon.svg'),
                              //
                              //     SizedBox(height: 11.h),
                              //     Text(
                              //       'Call',
                              //       style: GoogleFonts.inter(
                              //           textStyle: TextStyle(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.w700,
                              //               color: Colors.black)),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(width: 42.w),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     SvgPicture.asset(
                              //         'assets/group_info/video image.svg'),
                              //     SizedBox(height: 11.h),
                              //     Text(
                              //       'Video',
                              //       style: GoogleFonts.inter(
                              //           textStyle: TextStyle(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.w700,
                              //               color: Colors.black)),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(width: 42.w),
                              GestureDetector(onTap:() async {
                                if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                  return await scaffoldAlertDialogBox(
                                      context: context,
                                      page: SearchPage(
                                        sizingInformation: sizingInformation,
                                        gid: widget.puid,
                                        state: 5,
                                        participants: chatDetailSnapshot.data!.data()!["members"].keys.toList(),
                                      ));
                                } else {
                                  List<String> participantIds = [];
                                  chatDetailSnapshot.data!.data()!["members"].forEach((key, value) {
                                    if (value["isRemoved"] == false) {
                                      participantIds.add(key);
                                    }
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchPage(sizingInformation: sizingInformation, gid: widget.puid, state: 5, participants: participantIds)));
                                }
                              },
                                child: (widget.state==1)?Column(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/group_info/add_participants.svg'),
                                    SizedBox(height: 11.h),
                                    Text('Add',
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ):SizedBox(),
                              )
                            ],
                          ),
                          SizedBox(height:18.h),
                          Divider(),
                          SizedBox(height:11.h),
                          (widget.state == 0) ?
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: instance.collection("group-detail").where("members.${widget.uid}.isRemoved", isEqualTo: false).where("members.${widget.puid}.isRemoved", isEqualTo: false).snapshots(),
                              // stream: instance.collection("group-detail").where("gid", whereIn: ids).snapshots(),
                              builder: (context, groupDetailSnapshot) {
                                if (groupDetailSnapshot.hasData && groupDetailSnapshot.connectionState == ConnectionState.active) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${groupDetailSnapshot.data!.docs.length} Group in Common",
                                          style: GoogleFonts.inter(textStyle:TextStyle(fontSize: 16.sp,
                                              fontWeight: FontWeight.w600))),
                                      SizedBox(height:24.h),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: groupDetailSnapshot.data!.docs.length,
                                        itemBuilder: (context, index) => buildItem(
                                            index: index,
                                            description: groupDetailSnapshot.data!.docs[index]["members"].length.toString(),
                                            pic: (groupDetailSnapshot.data!.docs[index]["pic"] != null) ? groupDetailSnapshot.data!.docs[index]["pic"] : null,
                                            chatDetailSnapshot: chatDetailSnapshot,
                                            name: groupDetailSnapshot.data!.docs[index]["title"],
                                            id: groupDetailSnapshot.data!.docs[index]["gid"]),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container(
                                      child: Center(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [lottieAnimation(invalidLottie), Text("No Groups in common")],
                                            ),
                                          )));
                                }
                              }):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                //  "${chatDetailSnapshot.data!.data()!["members"].length} Participants",
                                  "Group Participants",
                                  style: GoogleFonts.inter(textStyle: textStyle(fontSize: 14.sp, fontWeight: FontWeight.w700
                                      ,color:Color.fromRGBO(0, 163, 255, 1)))),
                              SizedBox(height:15.h),
                              GestureDetector(
                                onTap:() async{
                                  if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                    return await scaffoldAlertDialogBox(
                                        context: context,
                                        page: SearchPage(
                                          sizingInformation: sizingInformation,
                                          gid: widget.puid,
                                          state: 5,
                                          participants: chatDetailSnapshot.data!.data()!["members"].keys.toList(),
                                        ));
                                  } else {
                                    List<String> participantIds = [];
                                    chatDetailSnapshot.data!.data()!["members"].forEach((key, value) {
                                      if (value["isRemoved"] == false) {
                                        participantIds.add(key);
                                      }
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchPage(sizingInformation: sizingInformation, gid: widget.puid, state: 5, participants: participantIds)));
                                  }
                                },
                                child: Row(children:[Container(
                                    height:44.h,width:44.w,decoration:BoxDecoration(color:Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle),
                                    child:SvgPicture.asset('assets/group_info/add_participants.svg',height: 50,width: 50,)),
                                  SizedBox(width:26.w),
                                  Text('Add participants',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w700,
                                      fontSize:16.sp, color:Colors.black)))]),
                              ),
                              SizedBox(height:24.h),

                              Row(children:[Container(padding:EdgeInsets.all(15),
                                  height:44.h,width:44.w,decoration:BoxDecoration(color:Color.fromRGBO(248, 206, 97, 1),shape:BoxShape.circle),
                                  child:SvgPicture.asset('assets/icons_assets/invite_link.svg')),
                                SizedBox(width:24.w),
                                Text('Invite via link',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w700,
                                    fontSize:16.sp, color:Colors.black)))]),

                              (chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                  ?SizedBox()
                                  :SizedBox(height:0.h),
                              SizedBox(height:12.h),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: chatDetailSnapshot.data!.data()!["members"].length,
                                  itemBuilder: (context, index) => GestureDetector(
                                    onTap: (){
                                      instance.collection("group-detail").doc('EMpxsZbQXLppZE2Oit9H67ZodZjtED').update(
                                          {
                                            'description' : "dont judge",
                                          }
                                      );
                                      print("Group mamber list${chatDetailSnapshot.data!.data()!["members"].keys.elementAt(index)["isRemoved"]}");

                                    },
                                    child: buildItem(
                                        index: index,
                                        pic: (chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["pic"] != null)
                                            ? chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["pic"]
                                            : null,
                                        name: chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["name"],
                                        description: chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["claim"],
                                        chatDetailSnapshot: chatDetailSnapshot,
                                        id: chatDetailSnapshot.data!.data()!["members"].keys.elementAt(index)),
                                  )),

                            ],
                          ),
                          (widget.state == 1) ? Divider() :SizedBox(),
                        ],
                      ),
                    ),
                  )
                // Container(
                //     child: Center(
                //         child: SingleChildScrollView(
                //           child: Column(
                //             children: [
                //               lottieAnimation(notFoundLottie),
                //               Text("You have been removed from the group", style: GoogleFonts.inter(textStyle:
                //               TextStyle(fontSize:16.sp, fontWeight:FontWeight.w500))),
                //               flatButton(
                //                   onPressed: () {
                //                     Navigator.pop(context);
                //                   },
                //                   child: Text("Go Back"))
                //             ],
                //           ),
                //         )))
              );
            });
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
  Widget buildItem(
      {required String? pic,
        required String name,
        required String id,
        required int index,
        required String description,
        required AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> chatDetailSnapshot}) {
    if (widget.state == 1 && description == "removed") {
      return SizedBox(height:0.h);
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (widget.uid != id)
            ? (widget.state == 0)
            ? () {
          //TODO Navigate to Group Chat
        }
            : (chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
            ? () async {
          showDialog(context: context, builder:(context) {
            return AlertDialog(
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
              content: Container(height:168.h,width:366.w,
                child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:10.h),
                    GestureDetector(onTap:() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(uid: widget.uid, puid: id, state: 0),));

                    },
                      child: Text(
                        'Ping $name',
                        style: GoogleFonts.inter(
                            textStyle: textStyle(fontSize: 16.sp, fontWeight: FontWeight.w400,
                                color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height:22.h),
                    GestureDetector(onTap:() {},
                      child: Text(
                        'View profile',
                        style: GoogleFonts.inter(
                            textStyle: textStyle(fontSize: 16.sp, fontWeight: FontWeight.w400,
                                color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height:22.h),
                    GestureDetector(onTap:()async{
                      await changeClaim(type: (description != "admin") ? 0 : 1, uid: id);
                      Navigator.pop(context);
                    },
                      child: Text(
                        (description != 'admin') ? 'Make group admin' : 'Dismiss as admin',
                        style: GoogleFonts.inter(
                            textStyle: textStyle(fontSize: 16.sp, fontWeight: FontWeight.w400,
                                color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height:22.h),
                    GestureDetector(onTap:()async{
                      await changeClaim(type: 2, uid: id);
                      Navigator.pop(context);
                    },
                      child: Text(
                        'Remove $name',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(color:Color.fromRGBO(239, 50, 50, 1),
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),

            );
          },);
          //TODO Navigate to User Chat
        }
            : null
            : null,
        child: Container(padding:EdgeInsets.fromLTRB(0.w,12.h,0.w,12.h),
          child: Row(
            children: [
              Container(
                child: (pic != null)
                    ?   CachedNetworkImage(
                  imageUrl: pic,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 44.0.w,
                    height: 44.0.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Container(
                        width: 44.0.w,
                        height: 44.0.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/noProfile.jpg")
                            )
                        ),
                      ),

                ):
                SvgPicture.asset((widget.state == 0) ? "assets/invite_friends/profilepicture.svg" : "assets/invite_friends/profilepicture.svg", fit: BoxFit.cover,
                  height:44.h,
                  width: 44.w,
                ),
              ),
              SizedBox(width:26.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(textStyle:TextStyle(fontSize:16.sp, fontWeight:FontWeight.w700)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                    SizedBox(height:5.h),
                    Text(
                      (widget.state == 0) ? "$description Participants" : "$description",
                      style: GoogleFonts.inter(textStyle:TextStyle(fontSize:12.sp,fontWeight:FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 0.5))),
                      overflow: TextOverflow.ellipsis,
                      maxLines:1,
                      softWrap: true,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}