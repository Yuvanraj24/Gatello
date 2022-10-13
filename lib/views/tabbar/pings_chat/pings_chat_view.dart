// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gatello/core/models/pings_chat_model/pings_chats_list_model.dart';
// import 'package:gatello/views/tabbar/chats/personal_chat_screen/ChatPage.dart';
// import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:substring_highlight/substring_highlight.dart';
// import '../../../Firebase/FirebaseNotifications.dart';
// import '../../../Firebase/Writes.dart';
// import '../../../Helpers/DateTimeHelper.dart';
// import '../../../Others/Routers.dart';
// import '../../../Others/Structure.dart';
// import '../../../Others/components/LottieComposition.dart';
// import '../../../Others/lottie_strings.dart';
// import '../../../Style/Colors.dart';
// import '../../../Style/Text.dart';
// import '../../../components/ScaffoldDialog.dart';
// import '../../../components/flatButton.dart';
// import 'dart:developer' as dev;
// import '../../../main.dart';
// import '../../../utils/DynamicLinkParser.dart';
// floatingActionButton:
// Column(
// children: [
// FloatingActionButton(
// child: Text("Select all"),
// onPressed: (){
// longPressedFlag = true;
// for(int i =0; i<docs.length; i++){
//
// selectedItems!.add(i);
// print("Document Data... ${i}");
// print("Document Data... ${selectedItems}");
// }
// }),
// FloatingActionButton(
// child: Text("Delete"),
// onPressed: (){
//
// for (int i = 0; i < selectedItems!.length; i++) {
// var sell = db.collection("personal-chat-room-detail")
//     .doc(
// "${docs[selectedItems![i]].id}"
//
// );
// print("${docs[selectedItems![i]].id}");
// sell.update({"members.$uid.delete" : true});
// //selectedItems!.remove;
//
// }
// selectedItems = [];
//
//
// print(docs[index].data()["members"]["${docs[index].data()["members"]["$uid"]["peeruid"]}"]);
//
//
// print("Uid is a $puid");
// //print("this is select index $sell");
// }),
// FloatingActionButton(
// onPressed: () async {
// if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
// return await scaffoldAlertDialogBox(
// context: context,
// page: SearchPage(
// state: 0,
// sizingInformation: sizingInformation,
// )).then((value) {
// if (value != null) {
// if (!mounted) return;
// setState(() {
// isChatting = true;
// puid = value;
// });
// }
// });
// } else {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => SearchPage(
// state: 0,
// sizingInformation: sizingInformation,
// )));
// }
// },
//
// // onPressed: () {
// //
// // Navigator.push(context,
// // MaterialPageRoute(builder: (context) => SelectContact()));
// // },
// backgroundColor: Color.fromRGBO(248, 206, 97, 1),
// child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg")),
// ],
//),