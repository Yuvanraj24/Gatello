import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/Authentication/Authentication.dart';
import 'package:gatello/core/models/pings_chat_model/pings_chats_list_model.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/ChatPage.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/ScaffoldDialog.dart';
import '../../../firebase_options.dart';
import '../chats/personal_chat_screen/pesrsonal_chat.dart';


class PingsChatView extends StatefulWidget {
  final Map<int, DocumentSnapshot<Map<String, dynamic>>>? messages;
  final int? state;
  PingsChatView({
   this.state,
   this.messages
});

  @override
  State<PingsChatView> createState() => _PingsChatViewState();
}

class _PingsChatViewState extends State<PingsChatView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? uid;
  String? puid;
  bool isChatting = false;
  List<PingsChatListModel> tileData = [];
  final _isSelected = Map();
  bool selects = false;
  bool change = false;

  bool longPressedFlag=false;
  late List? selectedItems=[];
  bool isFirstTime=true;
  bool isChatListLoaded=false;

  @override
  void initState(){
    super.initState();
    // uid=_getUID() as String?;
    print("Current UID:${uid}");
    tileData = pingsChatListData();

  }
  void initSP()
  async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    uid=prefs.getString("userid");

    // isChatListLoaded=true;

    Fluttertoast.showToast(msg: prefs.getString("userid").toString(), toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }
  final db=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    // readChat();
    // readData();
    // getChatList();

    return StreamBuilder(
      stream: Stream.value(_getUID()),
        builder: (context, snapshot)
      {
        if(snapshot.hasData)
          {
          return ResponsiveBuilder(builder: (context, sizingInformation) {
              return Scaffold(
              backgroundColor: Color.fromRGBO(26, 52, 130, 0.06),
              // body: isChatListLoaded?getChatList():getChatList(),
              body: getChatList(),

              floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                      return await scaffoldAlertDialogBox(
                          context: context,
                          page: SearchPage(
                            state: 0,
                            sizingInformation: sizingInformation,
                          )).then((value) {
                        if (value != null) {
                          if (!mounted) return;
                          setState(() {
                            isChatting = true;
                            puid = value;
                          });
                        }
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage(
                                state: 0,
                                sizingInformation: sizingInformation,
                              )));
                    }
                  },

                  // onPressed: () {
              //
              // Navigator.push(context,
              // MaterialPageRoute(builder: (context) => SelectContact()));
              // },
              backgroundColor: Color.fromRGBO(248, 206, 97, 1),
              child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg")),
              );
            }
          );
          }
        return getChatList();
      },);
  }





  Future readData()
  async{

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
            // print(docs.toString());
            // print("LENGTH:${docs.length}");
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                if (!_isSelected.containsKey(index)) // important
                  _isSelected[index] = false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: ListTile(
                    selected: _isSelected[index],
                    tileColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(248, 206, 97, 0.31),
                    // onLongPress: () {
                    //   setState((){
                    //     _isSelected[index] = !_isSelected[index];
                    //     print("OP: ${_isSelected[index]}=!${_isSelected} ");
                    //     selects = true;
                    //     print("Long Press");
                    //   });
                    //
                    // }
                      onLongPress: () {
                        setState((){
                          _isSelected[index] = !_isSelected[index];

                          if(isFirstTime) {
                            if (selectedItems!.isEmpty) {
                              print("First Time Long Pressing...x");
                              selectedItems!.add(index);
                              isFirstTime=false;
                              longPressedFlag=true;
                            }
                          }
                          else {
                            if (selectedItems!.contains(index)) {
                              print("EXISTS So removing...");
                              selectedItems!.remove(index);
                              print("Selected$index");
                              print("Selected items$selectedItems");
                            }
                            else{
                              selectedItems!.add(index);
                              print("Selected$index");
                              print("Selected items$selectedItems");
                              print("Long Press Triggers");
                              longPressedFlag=true;
                            }

                            if(selectedItems!.isEmpty && isFirstTime==false)
                              {
                                print("Deselect all");
                                isFirstTime=true;
                                longPressedFlag=false;
                              }

                          }

                        });
                      }
                      ,

                    onTap: ()
                    {
                      print("Long Press Flag:${longPressedFlag}");
                      if(longPressedFlag)
                        {
                        setState(() {
                          _isSelected[index] = !_isSelected[index];
                          if(selectedItems!.isEmpty)
                            {
                              longPressedFlag=false;
                            }
                          else{
                            print("Tapping...x");

                            if (selectedItems!.contains(index)) {
                              print("EXISTS So removing...");
                              selectedItems!.remove(index);
                              print("Selected$index");
                              print("Selected items$selectedItems");
                            }
                            else
                              {
                                selectedItems!.add(index);
                                print("Selected$index");
                                print("Selected items$selectedItems");
                                print("Tap Triggers");
                                longPressedFlag=true;
                              }
                          }
                        });

                        if(selectedItems!.isEmpty && isFirstTime==false)
                        {
                          print("Deselect all");
                          isFirstTime=true;
                          longPressedFlag=false;
                        }
                        }
                      else
                        {
                          print("Page Open");
                          Navigator.push(
                                        context,
                                        MaterialPageRoute(

                                            builder: (context) =>
                                                ChatPage(state: 0,
                                                    uid: uid.toString(),
                                                    puid: docs[index]
                                                        .data()["members"]["$uid"]["peeruid"])));
                         }

                      // Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //
                      //                   builder: (context) =>
                      //                       PersonalChat(state: 0,
                      //                           uid: uid!,
                      //                           puid: docs[index]
                      //                               .data()["members"]["$uid"]["peeruid"])));
                    },

                    // onTap: () {
                    //
                    //   print("Array LENGTH: ${_isSelected.length}");
                    //   if(_isSelected.length==0)
                    //     {
                    //       selects=false;
                    //     }
                    //   else {
                    //     if (selects == true) {
                    //       setState(() {
                    //         _isSelected[index] = !_isSelected[index];
                    //         print("Tile Selected1");
                    //
                    //         //_isSelected.removeWhere((key, value) => true);
                    //       });
                    //     }
                    //     else {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //
                    //               builder: (context) =>
                    //                   PersonalChat(state: 0,
                    //                       uid: uid!,
                    //                       puid: docs[index]
                    //                           .data()["members"]["$uid"]["peeruid"])));
                    //     }
                    //   }
                    //   },

                    contentPadding: EdgeInsets.only(
                        left: 10, right: 10, top: 4, bottom: 4),
                    //  contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 25.5.h,
                      backgroundImage: NetworkImage(tileData[index].dp),
                    ),


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
                          Text(readTimestamp(int.parse(docs[index].data()["timestamp"])),
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w400),
                              )),
                          SizedBox(height: 3.h),

                         // docs[index].data()["members"]["$uid"]["unreadCount"].toString(),
                         (docs[index].data()["members"]["${docs[index].data()["members"]["$uid"]["peeruid"]}"]["unreadCount"]==0)?
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
                                   docs[index].data()["members"]["${docs[index].data()["members"]["$uid"]["peeruid"]}"]["unreadCount"].toString(),
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
                );
              },
            );
          }
          else {
            return Container(
                padding: EdgeInsets.only(top: 110),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                          "assets/tabbar_icons/tab_view_main/chats_image/emptyChat.png"),
                      Text("No Conversation",
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700))),
                      Text(
                        "You don't made any conversation yet",
                        style: GoogleFonts.raleway(
                            color: Color.fromRGBO(122, 122, 122, 1),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ));
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
    print(DateTime.fromMillisecondsSinceEpoch(int.parse(datetime)));
    return DateTime.fromMillisecondsSinceEpoch(int.parse(datetime));
  }
  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';


    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }


    // print("Time:$time");

    return time;
  }

  Future<void> _getUID() async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid=sharedPrefs.getString("userid");
  }
}


