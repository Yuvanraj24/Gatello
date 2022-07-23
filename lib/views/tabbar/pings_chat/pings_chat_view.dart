import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/core/models/pings_chat_model/pings_chats_list_model.dart';
import 'package:gatello/views/tabbar/chats/pesrsonal_chat.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase_options.dart';

class PingsChatView extends StatefulWidget {
  const PingsChatView({Key? key}) : super(key: key);

  @override
  State<PingsChatView> createState() => _PingsChatViewState();
}

class _PingsChatViewState extends State<PingsChatView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? uid;
  List<PingsChatListModel> tileData = [];
  var isSelected = false;
  var mycolor = Colors.white;

  @override
  void initState(){
    super.initState();
    tileData = pingsChatListData();

  }
  void initSP()
  async{

  }
  final db=FirebaseFirestore.instance;
  bool change = false;
  @override
  Widget build(BuildContext context) {

    // readChat();
    // readData();
    // getChatList();
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 52, 130, 0.06),
      // body: change == true
      //     ? Container(
      //         padding: EdgeInsets.only(top: 110),
      //         child: Center(
      //           child: Column(
      //             children: [
      //               Image.asset(
      //                   "assets/tabbar_icons/chats_image/chats_empty.png"),
      //               Text("No Conversation",
      //                   style: GoogleFonts.raleway(
      //                       textStyle: TextStyle(
      //                           color: Color.fromRGBO(0, 0, 0, 1),
      //                           fontSize: 22,
      //                           fontWeight: FontWeight.w700))),
      //               Text(
      //                 "You don't made any conversation yet",
      //                 style: GoogleFonts.raleway(
      //                     color: Color.fromRGBO(122, 122, 122, 1),
      //                     fontSize: 14),
      //               ),
      //             ],
      //           ),
      //         ))
      //     : Container(
      //         color: Color.fromRGBO(26, 52, 130, 0.06),
      //         child: ListView.builder(
      //           itemCount: tileData.length,
      //           itemBuilder: (context, index) {
      //             return Padding(
      //               padding: const EdgeInsets.only(bottom: 2),
      //               child: InkWell(
      //                 onTap: () {},
      //                 onLongPress: () {},
      //                 child: Container(
      //                   // color: (tileData.contains(index))
      //                   //                   ? Colors.blue.withOpacity(0.5)
      //                   //                   : Colors.transparent,
      //
      //                   child: ListTile(
      //                     onLongPress: () {
      //                       toggleSelection();
      //                     },
      //                     onTap: () {u
      //                       if (tileData.contains(index)) {
      //                         setState(() {
      //                           tileData.removeWhere((val) => val == index);
      //                         });
      //                       } else {
      //                         Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) => PersonalChat()));
      //                       }
      //                     },
      //                     tileColor: Colors.white,
      //                     contentPadding: EdgeInsets.only(
      //                         left: 10, right: 10, top: 6, bottom: 6),
      //                     //  contentPadding: EdgeInsets.all(10),
      //                     leading: CircleAvatar(
      //                       radius: 25.5.h,
      //                       backgroundImage: NetworkImage(tileData[index].dp),
      //                     ),
      //                     selected: isSelected,
      //
      //                     title: Text(
      //                       tileData[index].name,
      //                       style: GoogleFonts.inter(
      //                           textStyle: TextStyle(
      //                               fontSize: 16.sp,
      //                               color: Color.fromRGBO(0, 0, 0, 1),
      //                               fontWeight: FontWeight.w700)),
      //                     ),
      //                     subtitle: Text(tileData[index].lasttext,
      //                         style: GoogleFonts.inter(
      //                             textStyle: TextStyle(
      //                                 fontSize: 14.sp,
      //                                 color: Color.fromRGBO(12, 16, 29, 0.6),
      //                                 fontWeight: FontWeight.w400))),
      //                     trailing: Padding(
      //                       padding: EdgeInsets.only(top: 8),
      //                       child: Column(
      //                         children: [
      //                           Text("${11}:${20} AM",
      //                               style: GoogleFonts.inter(
      //                                 textStyle: TextStyle(
      //                                     fontSize: 10.sp,
      //                                     color: Color.fromRGBO(0, 0, 0, 1),
      //                                     fontWeight: FontWeight.w400),
      //                               )),
      //                           SizedBox(height: 3.h),
      //                           Container(
      //                               decoration: BoxDecoration(
      //                                   //borderRadius: BorderRadius.circular(15),
      //                                   border: Border.all(
      //                                     color:
      //                                         Color.fromRGBO(255, 202, 40, 1),
      //                                   ),
      //                                   shape: BoxShape.circle,
      //                                   color: Color.fromRGBO(255, 202, 40, 1)),
      //                               width: 22.w,
      //                               height: 22.h,
      //                               child: Center(
      //                                 child: Text(
      //                                     tileData[index].unreadMsg.toString(),
      //                                     style: GoogleFonts.inter(
      //                                       textStyle: TextStyle(
      //                                           fontSize: 11.sp,
      //                                           color:
      //                                               Color.fromRGBO(0, 0, 0, 1),
      //                                           fontWeight: FontWeight.w400),
      //                                     )),
      //                               )),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => SelectContact()));
      //     },
      //     backgroundColor: Color.fromRGBO(248, 206, 97, 1),
      //     child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg")),
      body: getChatList(),
    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.red;
        isSelected = true;
      }
    });
  }

  Future readData()
  async{
    String uid="plPttbFnMVPvf741ZQJ9GzkTP6V2";
    print("Reading");
    // await db.collection("personal-chat-room-detail").get().then((event) {
    await db.collection("personal-chat-room-detail").where("members.$uid.isblocked").get().then((event) {

      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }

    });

  }

  // final SharedPreferences prefs = await _prefs;

  Widget getChatList()
  {

    uid="HSS4BBvICHbB5BFQ4zu9OUDgOTn2";
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>
      (

        stream: db.collection("personal-chat-room-detail").where("members.$uid.isBlocked", isNotEqualTo: true).snapshots(),
        builder: (context,chatRoomdetailsnap) {
          if (chatRoomdetailsnap.connectionState == ConnectionState.active &&
              chatRoomdetailsnap.hasData &&
              chatRoomdetailsnap.data != null &&
              chatRoomdetailsnap.data!.docs.isNotEmpty) {
            List<QueryDocumentSnapshot<
                Map<String, dynamic>>> docs = chatRoomdetailsnap.data!.docs;
            docs.sort((b, a) =>
                getDateTimeSinceEpoch(datetime: a.data()["timestamp"])
                    .compareTo(
                    getDateTimeSinceEpoch(datetime: b.data()["timestamp"])));
            print(docs.toString());
            print("LENGTH:${docs.length}");
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: InkWell(
                    onTap: () {},
                    onLongPress: () {},
                    child: Container(
                      // color: (tileData.contains(index))
                      //                   ? Colors.blue.withOpacity(0.5)
                      //                   : Colors.transparent,

                      child: ListTile(
                        onLongPress: () {
                          toggleSelection();
                        },
                        onTap: () {
                          if (tileData.contains(index)) {
                            setState(() {
                              tileData.removeWhere((val) => val == index);
                            });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => PersonalChat(state: 0,
                                      uid: uid!,
                                      puid: docs[index].data()["members"]["$uid"]["peeruid"])));
                          }
                        },
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        //  contentPadding: EdgeInsets.all(10),
                        leading: CircleAvatar(
                          radius: 25.5.h,
                          backgroundImage: NetworkImage(tileData[index].dp),
                        ),
                        selected: isSelected,

                        title: Text(
                          docs[index].data()["members"]["${docs[index].data()["members"]["$uid"]["peeruid"]}"]["name"],
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.w700)),
                        ),
                        subtitle: Text(docs[index].data()["lastMessage"],
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color.fromRGBO(12, 16, 29, 0.6),
                                    fontWeight: FontWeight.w400))),
                        trailing: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Text("${11}:${20} AM",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 10.sp,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontWeight: FontWeight.w400),
                                  )),
                              SizedBox(height: 3.h),
                             // docs[index].data()["members"]["$uid"]["unreadCount"].toString(),
                             (docs[index].data()["members"]["$uid"]["unreadCount"]==0)?
                                 SizedBox():
                             Container(
                                 decoration: BoxDecoration(
                                   //borderRadius: BorderRadius.circular(15),
                                     border: Border.all(
                                       color:
                                       Color.fromRGBO(255, 202, 40, 1),
                                     ),
                                     shape: BoxShape.circle,
                                     color: Color.fromRGBO(255, 202, 40, 1)),
                                 width: 22.w,
                                 height: 22.h,
                                 child: Center(
                                   child:
                                   Text(
                                       docs[index].data()["members"]["$uid"]["unreadCount"].toString(),
                                       style: GoogleFonts.inter(
                                         textStyle: TextStyle(
                                             fontSize: 11.sp,
                                             color:
                                             Color.fromRGBO(0, 0, 0, 1),
                                             fontWeight: FontWeight.w400),
                                       )),
                                 )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else {
            return Container(
                child: Center(
                    child: SingleChildScrollView(
                      // child: Column(
                      //   children: [lottieAnimation(emptyChatLottie), Text("Your shelves are empty !\nAdd people to start the conversation")],
                      // ),
                      child: Text("Empty"),
                    )));
          }
        }
            );
  }




  Future readChat() async{
    final db=FirebaseFirestore.instance;
    print("CHAT DATA");


    await db.collection("personal-chat-room-details").get().then((event) {
    // await db.collection("personal-chat-room-detail").where("members.$uid.isblocked").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  DateTime getDateTimeSinceEpoch({required String datetime}) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(datetime));
  }
}
