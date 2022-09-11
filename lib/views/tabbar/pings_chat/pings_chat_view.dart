import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import '../../../Firebase/FirebaseNotifications.dart';
import '../../../Firebase/Writes.dart';
import '../../../Helpers/DateTimeHelper.dart';
import '../../../Others/Routers.dart';
import '../../../Others/Structure.dart';
import '../../../Others/components/LottieComposition.dart';
import '../../../Others/lottie_strings.dart';
import '../../../Style/Colors.dart';
import '../../../Style/Text.dart';
import '../../../components/ScaffoldDialog.dart';
import '../../../components/flatButton.dart';
import '../../../firebase_options.dart';
import 'dart:developer' as dev;


import '../../../main.dart';
import '../../../utils/DynamicLinkParser.dart';
import '../chats/personal_chat_screen/pesrsonal_chat.dart';


class PingsChatView extends StatefulWidget {

  final Map<int, DocumentSnapshot<Map<String, dynamic>>>? messages;
  final String? postDescription;
  final String? postId;
  final String? postTitle;
  final String? postUrl;
  final int? state;
  final String uid;
  final int? storyContentType;
  PingsChatView({
    Key? key,
    this.postTitle,
    this.postId,
    this.postDescription,
    this.postUrl,
    this.storyContentType,
    this.state,
    this.messages,
    required this.uid,

  });

  @override
  State<PingsChatView> createState() =>
      _PingsChatViewState();
}

class _PingsChatViewState extends State<PingsChatView> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController tabController;

  final db=FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // String? uid;
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
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    tabController = TabController(vsync: this, length: 2);

    super.initState();
    // uid=_getUID() as String?;

    tileData = pingsChatListData();

  }

  // void initSP()
  // async {
  //   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   final SharedPreferences prefs = await _prefs;
  //   uid=prefs.getString("userid");
  //
  //   // isChatListLoaded=true;
  //
  //   Fluttertoast.showToast(msg: prefs.getString("userid").toString(), toastLength: Toast.LENGTH_LONG,
  //       timeInSecForIosWeb: 1);
  // }


  @override
  Widget build(BuildContext context) {
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        if (!mounted) return;
        setState(() {
          isChatting = false;
          index = tabController.index;
        });
      }
    });
    List<Widget> tabs = [
      Tab(
        child: Text(
          "Personal",
          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,color: Colors.black)),
        ),
      ),
      Tab(
        child: Text(
          "Group",
          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,color: Colors.black)),
        ),
      )
    ];
    Widget getChatList(SizingInformation sizingInformation) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.collection("personal-chat-room-detail").where("members.${widget.uid}.isBlocked", isNotEqualTo: true).snapshots(),
          builder: (context, chatRoomDetailSnapshot) {
            if (chatRoomDetailSnapshot.connectionState == ConnectionState.active &&
                chatRoomDetailSnapshot.hasData &&
                chatRoomDetailSnapshot.data != null &&
                chatRoomDetailSnapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = chatRoomDetailSnapshot.data!.docs;
              docs.sort((b, a) => getDateTimeSinceEpoch(datetime: a.data()["timestamp"]).compareTo(getDateTimeSinceEpoch(datetime: b.data()["timestamp"])));

              return ListView.separated(
                  itemCount: docs.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
                    ),
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (widget.state == null)
                          ? () {
                        if (!mounted) return;
                        setState(() {
                          isChatting = false;
                          puid = docs[index].data()["members"]["${widget.uid}"]["peeruid"];
                          isChatting = true;
                        });
                        if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    state: 0,
                                    uid: widget.uid,
                                    puid: puid!,
                                  ))).then((value) {
                            if (value == true) {
                              if (!mounted) return;
                              setState(() {
                                isChatting = false;
                                puid = null;
                              });
                            }
                          });
                        }
                      }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: buildItem(
                          id: docs[index].data()["members"]["${widget.uid}"]["peeruid"],
                          pic: docs[index].data()["members"]["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]["pic"],
                          name: docs[index].data()["members"]["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]["name"],
                          lastMessage: docs[index].data()["lastMessage"],
                          timestamp: docs[index].data()["timestamp"],
                          lastRead: docs[index].data()["members"]["${widget.uid}"]["lastRead"],
                          peerLastRead: docs[index].data()["members"]["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]["lastRead"],
                          unreadCount: docs[index].data()["members"]["${widget.uid}"]["unreadCount"],
                          messageBy: docs[index].data()["messageBy"],
                          document: docs[index],
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                  child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [lottieAnimation(emptyChatLottie), Text("Your shelves are empty !\nAdd people to start the conversation")],
                        ),
                      )));
            }
          });
    }

    Widget personalGroupList(SizingInformation sizingInformation) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.collection("group-detail").where("members.${widget.uid}.claim", isNotEqualTo: "removed").snapshots(),
          builder: (context, groupRoomDetailSnapshot) {
            if (groupRoomDetailSnapshot.connectionState == ConnectionState.active &&
                groupRoomDetailSnapshot.hasData &&
                groupRoomDetailSnapshot.data != null &&
                groupRoomDetailSnapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = groupRoomDetailSnapshot.data!.docs;
              docs.sort((b, a) => getDateTimeSinceEpoch(datetime: a.data()["timestamp"]).compareTo(getDateTimeSinceEpoch(datetime: b.data()["timestamp"])));

              return ListView.separated(
                  itemCount: docs.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
                    ),
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (widget.state == null)
                          ? () {
                        isChatting = false;

                        puid = docs[index].data()["gid"];
                        isChatting = true;
                        if (!mounted) return;
                        setState(() {});
                        if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    state: 1,
                                    uid: widget.uid,
                                    puid: puid!,
                                  ))).then((value) {
                            if (value == true) {
                              if (!mounted) return;
                              setState(() {
                                isChatting = false;
                                puid = null;
                              });
                            }
                          });
                        }
                      }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: buildItem(
                          id: docs[index].data()["gid"],
                          pic: docs[index].data()["pic"],
                          name: docs[index].data()["title"],
                          lastMessage: docs[index].data()["lastMessage"],
                          timestamp: docs[index].data()["timestamp"],
                          messageBy: docs[index].data()["messageBy"],
                          members: docs[index].data()["members"],
                          lastRead: docs[index].data()["members"][widget.uid]["lastRead"],
                          unreadCount: docs[index].data()["members"][widget.uid]["unreadCount"],
                          document: docs[index],
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                  child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [lottieAnimation(emptyChatLottie), Text("Your shelves are empty ! \nCreate a group to start the conversation")],
                        ),
                      )));
            }
          });
    }

    return SafeArea(
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        return (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
            ? Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(minHeight: kToolbarHeight, maxHeight: 175.0, maxWidth: 350.0),
                    child: Material(
                      color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                      child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: (themedata.value.index == 0) ? Color(black) : Color(white),
                        unselectedLabelColor: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey),
                        indicatorColor: (themedata.value.index == 0) ? Color(black) : Color(white),
                        tabs: tabs,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Scaffold(
                            appBar: AppBar(
                              centerTitle: false,
                              automaticallyImplyLeading: false,
                              leading: (widget.state == null)
                                  ? null
                                  : IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              elevation: 0,
                              title: (widget.state == null)
                                  ? null
                                  : Text((widget.state == 0) ? "Share Post" : "Forward Message",
                                  style:
                                  GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                              backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                              actions: (widget.state == null)
                                  ? [
                                (index == 1)
                                    ? IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onPressed: () async {
                                      if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                        return await scaffoldAlertDialogBox(
                                            context: context,
                                            page: SearchPage(
                                              state: 4,
                                              sizingInformation: sizingInformation,
                                            ));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SearchPage(
                                                  sizingInformation: sizingInformation,
                                                  state: 4,
                                                )));
                                      }
                                    },
                                    icon: Icon(Icons.add))
                                    : Container(),
                              ]
                                  : null,
                            ),
                            floatingActionButton: (widget.state == null)
                                ? (index == 0)
                                ?   FloatingActionButton(
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
                                child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg"))
                                : null
                                : null,
                            body: TabBarView(controller: tabController, children: [getChatList( sizingInformation),personalGroupList(sizingInformation)]),
                          ),
                        ),
                        VerticalDivider(
                          color: Color(lightGrey),
                          width: 1,
                          thickness: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: (isChatting != false && puid != null)
                              ? ChatPage(
                            state: (index == 0) ? 0 : 1,
                            uid: widget.uid,
                            puid: puid!,
                          )
                              : Scaffold(
                            backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                            body: Center(
                              child: Text("Select a chat to start chatting"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : Scaffold(
          appBar: (widget.state == null)
              ? null
              : AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text((widget.state == 0) ? "Share Post" : "Forward Messages",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
          ),
          floatingActionButton: (widget.state == null)
              ? (index == 0)
              ? FloatingActionButton(
            backgroundColor: Color.fromRGBO(248, 206, 97, 1),
            child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg"),
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
          )
              : FloatingActionButton(
              onPressed: () async {
                if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                  return await scaffoldAlertDialogBox(
                      context: context,
                      page: SearchPage(
                        state: 4,
                        sizingInformation: sizingInformation,
                      ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                            sizingInformation: sizingInformation,
                            state: 4,
                          )));
                }
              },
              backgroundColor: Color.fromRGBO(248, 206, 97, 1),
              child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg"))
              : null,
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 150.0),
                  child: Material(
                    color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                    child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: (themedata.value.index == 0) ? Color(black) : Color(white),
                      tabs: tabs,
                    ),
                  ),
                ),
                Expanded(child: TabBarView(controller: tabController, children: [getChatList( sizingInformation), personalGroupList(sizingInformation)])),
              ],
            ),
          ),
        );
      }),
    );
    //  return ResponsiveBuilder(builder: (context, sizingInformation) {
    // return Scaffold(body: SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       getChatList(),
    //       personalGroupList(sizingInformation),
    //     ],
    //   ),
    // ),
    //   floatingActionButton: FloatingActionButton(
    //       onPressed: () async {
    //         if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
    //           return await scaffoldAlertDialogBox(
    //               context: context,
    //               page: SearchPage(
    //                 state: 0,
    //                 sizingInformation: sizingInformation,
    //               )).then((value) {
    //             if (value != null) {
    //               if (!mounted) return;
    //               setState(() {
    //                 isChatting = true;
    //                 puid = value;
    //               });
    //             }
    //           });
    //         } else {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => SearchPage(
    //                     state: 0,
    //                     sizingInformation: sizingInformation,
    //                   )));
    //         }
    //       },
    //
    //       // onPressed: () {
    //       //
    //       // Navigator.push(context,
    //       // MaterialPageRoute(builder: (context) => SelectContact()));
    //       // },
    //       backgroundColor: Color.fromRGBO(248, 206, 97, 1),
    //       child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg")),
    // );
    //  }
    //  );

  }





  Future readData()
  async{

    print("Reading");
    // await db.collection("personal-chat-room-detail").get().then((event) {
    await db.collection("personal-chat-room-detail").where("members.${widget.uid}.isblocked").get().then((event) {

      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }

    });

  }






  Widget buildItem({
    required String? pic,
    required String name,
    required String? lastMessage,
    required String? timestamp,
    String? peerLastRead,
    Map? members,
    required String? lastRead,
    required int unreadCount,
    required String? messageBy,
    required String id,
    required QueryDocumentSnapshot<Map<String, dynamic>> document,
  }) {
    bool isRead = false;
    if (members != null && timestamp != null && index == 1) {
      isRead = groupReadReceipt(members: members, timestamp: timestamp, uid: widget.uid);
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      child: (pic != null)
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
                        imageUrl: pic,
                        errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                      )
                          : Image.asset((index == 0) ? "assets/noProfile.jpg" : "assets/noGroupProfile.jpg", fit: BoxFit.cover),
                    )),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: (lastRead == null)
                                ? Text(
                              (index == 0)
                                  ? "$name is trying to text you. Either respond back or block if the user spams around."
                                  : "You are added to $name group.Either respond back or block if it is a spam.",
                              style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: Color(accent))),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )
                                : Row(
                              children: [
                                (index == 0)
                                    ? (timestamp != null && peerLastRead != null)
                                    ? (messageBy == widget.uid)
                                    ? (getDateTimeSinceEpoch(datetime: peerLastRead).difference(getDateTimeSinceEpoch(datetime: timestamp)).inMicroseconds > 0)
                                    ? Icon(
                                  Icons.done_all,
                                  color: Color(accent),
                                )
                                    : Icon(
                                  Icons.done_all,
                                  color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey),
                                )
                                    : Container()
                                    : Container()
                                    : (timestamp != null && members != null)
                                    ? (messageBy == widget.uid)
                                    ? (isRead)
                                    ? Icon(
                                  Icons.done_all,
                                  color: Color(accent),
                                )
                                    : Icon(
                                  Icons.done_all,
                                  color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey),
                                )
                                    : Container()
                                    : Container(),
                                Flexible(
                                  child: (lastMessage != null)
                                      ? Text(
                                    (document.data()["delete"] == true)
                                        ? (messageBy == widget.uid)
                                        ? "∅ You have deleted this message"
                                        : "∅ This message have been deleted"
                                        : lastMessage,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        textStyle: textStyle(
                                          color: (themedata.value.index == 0) ? Color(grey) : Color(lightGrey),
                                        )),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  )
                                      : Text(
                                    (index == 0)
                                        ? "$name is trying to text you. Either respond back or block if the user spams around."
                                        : "You are added to $name group.Either respond back or block if it is a spam.",
                                    style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: Color(accent))),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          (widget.state == null)
              ? Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                (timestamp != null)
                    ? Text(
                  getDateTimeChat(datetime: getDateTimeSinceEpoch(datetime: timestamp)),
                  style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 10)),
                )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (unreadCount == 0)
                      ? Container()
                      : Chip(
                    backgroundColor: Color(accent),
                    label: Text(
                      unreadCount.toString(),
                      style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 10, color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack))),
                    ),
                  ),
                ),
              ],
            ),
          )
              : Padding(
            padding: EdgeInsets.only(left: 10),
            child: flatButton(
                size: Size(75, 30),
                backgroundColor: Color(accent),
                onPressed: (widget.state == 0)
                    ? () async {
                  // if (id.length == 28) {
                  //   await writeUserShareMessage(type: 5, peerName: name, peerPic: pic, uid: uid!, puid: id);
                  // } else {
                  //   await writeGroupShareMessage(type: 5, groupName: name, groupPic: pic, members: members!, uid: uid!, puid: id);
                  // }
                  String storyUrl = postDetailsUrl + "?post_id=" + widget.postId!;
                  ShareableLink _shareableLink = ShareableLink(widget.postTitle!, widget.postDescription!, storyUrl,
                      (widget.postUrl!.contains("mp4") || widget.postUrl!.contains("mpeg4")) ? null : widget.postUrl);
                  Uri _link = await _shareableLink.createDynamicLink(short: false);
                  if (id.length == 28) {
                    await writeUserMessage(
                        type: 5,
                        peerName: name,
                        peerPic: pic,
                        uid: widget.uid,
                        puid: id,
                        state: 0,
                        forwardCount: 0,
                        storyContentType: widget.storyContentType,
                        storyContentUrl: widget.postUrl,
                        storyDescription: widget.postDescription,
                        storyUrl: _link.toString());
                  } else {
                    await writeGroupMessage(
                        type: 5,
                        groupName: name,
                        groupPic: pic,
                        members: members!,
                        uid: widget.uid,
                        puid: id,
                        forwardCount: 0,
                        state: 1,
                        storyContentType: widget.storyContentType,
                        storyContentUrl: widget.postUrl,
                        storyDescription: widget.postDescription,
                        storyUrl: _link.toString());
                  }
                }
                    : () async {
                  widget.messages!.forEach((key, value) async {
                    dev.log(key.toString());
                    String getUrl(int type) {
                      switch (type) {
                        case 1:
                          return value.data()!["data"]["image"];
                        case 2:
                          return value.data()!["data"]["video"];
                        case 3:
                          return value.data()!["data"]["audio"];
                        case 4:
                          return value.data()!["data"]["document"];
                        default:
                          return "";
                      }
                    }

                    String? getMessage(int type) {
                      switch (type) {
                        case 0:
                          return value.data()!["data"]["text"];
                        case 6:
                          return value.data()!["data"]["gif"];
                        case 7:
                          return value.data()!["data"]["location"];
                        case 8:
                          return value.data()!["data"]["contact"];
                        default:
                          return null;
                      }
                    }

                    Uint8List? file = await downloadToBytes(getUrl(dataTypeMap.inverse[value.data()!["type"]]!));

                    if (id.length == 28) {
                      await writeUserMessage(
                        type: dataTypeMap.inverse[value.data()!["type"]]!,
                        peerName: name,
                        peerPic: pic,
                        uid: widget.uid,
                        puid: id,
                        state: 0,
                        forwardCount: value.data()!["forwardCount"],
                        message: getMessage(dataTypeMap.inverse[value.data()!["type"]]!),
                        file: file,
                        // replyMap: (value.data()!["reply"] != null) ? Map.from(value.data()!["reply"]) : null,
                        contentType: value.data()!["contentType"],
                        storyContentType: (dataTypeMap.inverse[value.data()!["type"]] == 5)
                            ? (value.data()!["data"]["image"] != null)
                            ? 0
                            : 1
                            : null,
                        storyContentUrl: (dataTypeMap.inverse[value.data()!["type"]] == 5)
                            ? (value.data()!["data"]["image"] != null)
                            ? value.data()!["data"]["image"]
                            : value.data()!["data"]["video"]
                            : null,
                        storyDescription: (dataTypeMap.inverse[value.data()!["type"]] == 5) ? value.data()!["data"]["text"] : null,
                        storyUrl: (dataTypeMap.inverse[value.data()!["type"]] == 5) ? value.data()!["data"]["story"] : null,
                      );
                    } else {
                      await writeGroupMessage(
                        type: dataTypeMap.inverse[value.data()!["type"]]!,
                        groupName: name,
                        groupPic: pic,
                        members: members!,
                        uid: widget.uid,
                        puid: id,
                        state: 1,
                        // replyMap: (value.data()!["reply"]!=null)?Map.from(value.data()!["reply"]):null,
                        forwardCount: value.data()!["forwardCount"],
                        message: getMessage(dataTypeMap.inverse[value.data()!["type"]]!),
                        file: file,
                        contentType: value.data()!["contentType"],
                        storyContentType: (dataTypeMap.inverse[value.data()!["type"]] == 5)
                            ? (value.data()!["data"]["image"] != null)
                            ? 0
                            : 1
                            : null,
                        storyContentUrl: (dataTypeMap.inverse[value.data()!["type"]] == 5)
                            ? (value.data()!["data"]["image"] != null)
                            ? value.data()!["data"]["image"]
                            : value.data()!["data"]["video"]
                            : null,
                        storyDescription: (dataTypeMap.inverse[value.data()!["type"]] == 5) ? value.data()!["data"]["text"] : null,
                        storyUrl: (dataTypeMap.inverse[value.data()!["type"]] == 5) ? value.data()!["data"]["story"] : null,
                      );
                    }
                  });
                },
                child: Text(
                  "Send",
                  style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 10)),
                )),
          )
        ],
      ),
    );
  }

  //-----------------------------------------
  Future writeUserMessage({
    required int type,
    String? message,
    String? storyContentUrl,
    int? storyContentType,
    String? storyDescription,
    String? storyUrl,
    Uint8List? file,
    String? contentType,
    Map? replyMap,
    required forwardCount,
    // required String? peerChattingWith,
    required String peerName,
    required String? peerPic,
    required String uid,
    required String puid,
    required int state,
  }) async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot? taskSnapshot;
    String? url;
    String roomid = roomId(uid: uid, puid: puid);
    if (file != null && type != 0 && contentType != null) {
      taskSnapshot = await Write().personalChat(
          roomId: roomid,
          file: file,
          fileName: timestamp,
          contentType: contentType);
      url = await taskSnapshot.ref.getDownloadURL();
    } else if ((type == 6 || type == 7 || type == 8) && message != null) {
      url = message;
    }
    dev.log(url.toString());
    WriteBatch writeBatch = db.batch();
    try {
      DocumentSnapshot<Map<String, dynamic>> personalChatRoomDoc =
      await db
          .collection("personal-chat-room-detail")
          .doc(roomid)
          .get();
      if (personalChatRoomDoc.exists) {
        writeBatch.set(
            db
                .collection("personal-chat")
                .doc(roomid)
                .collection("messages")
                .doc(timestamp),
            {
              "from": uid,
              "to": puid,
              "timestamp": timestamp,
              "type": dataTypeMap[type],
              "data": (type != 5)
                  ? dataMap(index: type, data: (type == 0) ? message! : url.toString())
                  : shareDataMap(
                contentType: storyContentType!,
                description: storyDescription!,
                contentUrl: storyContentUrl!,
                storyUrl: storyUrl!,
              ),
              "forwardCount": forwardCount + 1,
              "contentType": (type == 1 || type == 2 || type == 3 || type == 4)
                  ? contentType
                  : null,
              "read": {"uid": puid, "timestamp": null},
              "reply": (replyMap != null) ? replyMap : null,
              "delete": {"everyone": false, "personal": null}
            });
        writeBatch.update(
            db.collection("personal-chat-room-detail").doc(roomid), {
          "timestamp": timestamp,
          "messageBy": "${uid}",
          "lastMessage": (type == 0) ? message.toString() : dataTypeMap[type],
          "delete": false,
          "members.${puid}.unreadCount": FieldValue.increment(1),
        });
        writeBatch.commit();
        DocumentSnapshot<Map<String, dynamic>> peerDocSnap =
        await db.collection("user-detail").doc(puid).get();
        DocumentSnapshot<Map<String, dynamic>> userDocSnap =
        await db.collection("user-detail").doc(uid).get();
        if (peerDocSnap.data()!["chattingWith"] != uid &&
            peerDocSnap["token"] != null) {
          return await sendNotificationForChat(
              userTokens: [peerDocSnap["token"]],
              name: userDocSnap["name"],
              message: (type == 0) ? message.toString() : dataTypeMap[type]!,
              pic: userDocSnap["pic"],
              state: state,
              uid: uid,
              puid: puid);
        }
      } else {
        Future<DocumentSnapshot<Map<String, dynamic>>> userDetail =
        db.collection("user-detail").doc(uid).get();
        await userDetail.then((value) async {
          if (value.exists && value.data() != null) {
            writeBatch.set(
                db.collection("personal-chat-room-detail").doc(roomid), {
              "roomId": roomid,
              "timestamp": timestamp,
              "lastMessage": (type == 0) ? message.toString() : dataTypeMap[type],
              "delete": false,
              "messageBy": "${uid}",
              "members": {
                "${uid}": {
                  "isBlocked": false,
                  "peeruid": "${puid}",
                  "pic": value.data()!["pic"],
                  "name": value.data()!["name"],
                  "lastRead": null,
                  "unreadCount": 0,
                },
                "${puid}": {
                  "isBlocked": false,
                  "peeruid": "${uid}",
                  "pic": peerPic,
                  "name": peerName,
                  "lastRead": null,
                  "unreadCount": 0,
                },
              }
            });

            writeBatch.set(
                db
                    .collection("personal-chat")
                    .doc(roomid)
                    .collection("messages")
                    .doc(timestamp.toString()),
                {
                  "from": uid,
                  "to": puid,
                  "timestamp": timestamp,
                  "type": dataTypeMap[type],
                  "data": (type != 5)
                      ? dataMap(
                      index: type, data: (type == 0) ? message.toString() : url.toString())
                      : shareDataMap(
                    contentType: storyContentType!,
                    description: storyDescription!,
                    contentUrl: storyContentUrl!,
                    storyUrl: storyUrl!,
                  ),
                  "forwardCount": forwardCount + 1,
                  "contentType":
                  (type == 1 || type == 2 || type == 3 || type == 4)
                      ? contentType
                      : null,
                  "read": {"uid": puid, "timestamp": null},
                  "reply": (replyMap != null) ? replyMap : null,
                  "delete": {"everyone": false, "personal": null}
                });
            writeBatch.commit();
            DocumentSnapshot<Map<String, dynamic>> peerDocSnap =
            await db.collection("user-detail").doc(puid).get();
            DocumentSnapshot<Map<String, dynamic>> userDocSnap =
            await db.collection("user-detail").doc(uid).get();
            if (peerDocSnap.data()!["chattingWith"] != uid &&
                peerDocSnap["token"] != null) {
              return await sendNotificationForChat(
                  userTokens: [peerDocSnap["token"]],
                  name: userDocSnap["name"],
                  message: (type == 0) ? message.toString() : dataTypeMap[type]!,
                  pic: userDocSnap["pic"],
                  state: state,
                  uid: uid,
                  puid: puid);
            }
          } else {
            throw FirebaseException(
                plugin: "cloud-firestore",
                code: "no-user-exists",
                message:
                "This user document doesnt exists. Aborting transaction!.");
          }
        });
      }
    } on FirebaseException catch (e) {
      dev.log(e.toString());
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future writeGroupMessage({
    required int type,
    String? message,
    String? storyContentUrl,
    int? storyContentType,
    String? storyDescription,
    String? storyUrl,
    Uint8List? file,
    String? contentType,
    Map? replyMap,
    required forwardCount,
    required String groupName,
    required String? groupPic,
    required Map members,
    required String uid,
    required String puid,
    required int state,
  }) async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot? taskSnapshot;
    String? url;
    if (file != null && type != 0 && contentType != null) {
      taskSnapshot = await Write().groupChat(
          guid: puid,
          file: file,
          fileName: timestamp,
          contentType: contentType);
      url = await taskSnapshot.ref.getDownloadURL();
    } else if ((type == 6 || type == 7 || type == 8) && message != null) {
      url = message;
    }
    WriteBatch writeBatch = db.batch();
    try {
      writeBatch.set(
          db
              .collection("group-chat")
              .doc(puid)
              .collection("messages")
              .doc(timestamp),
          {
            "from": uid,
            "timestamp": timestamp,
            "type": dataTypeMap[type],
            "data": (type != 5)
                ? dataMap(index: type, data: (type == 0) ? message.toString() : url.toString())
                : shareDataMap(
              contentType: storyContentType!,
              description: storyDescription!,
              contentUrl: storyContentUrl!,
              storyUrl: storyUrl!,
            ),
            "forwardCount": forwardCount + 1,
            "contentType": (type == 1 || type == 2 || type == 3 || type == 4)
                ? contentType
                : null,
            "read": null,
            "reply": (replyMap != null) ? replyMap : null,
            "delete": {"everyone": false, "personal": null}
          });
      writeBatch.set(
          db.collection("group-detail").doc(puid),
          {
            "timestamp": timestamp,
            "messageBy": "${uid}",
            "lastMessage": (type == 0) ? message.toString() : dataTypeMap[type],
            "delete": false,
            "members": groupWriteMessageMembersMap(members: members),
          },
          SetOptions(merge: true));
      writeBatch.commit();
      DocumentSnapshot<Map<String, dynamic>> userDocSnap =
      await db.collection("user-detail").doc(uid).get();
      List<String> userToken = [];
      members.forEach((key, value) async {
        DocumentSnapshot<Map<String, dynamic>> peerDocSnap =
        await db.collection("user-detail").doc(key).get();
        if (peerDocSnap.data()!["chattingWith"] != puid) {
          userToken.add(peerDocSnap.data()!["uid"]);
        }
      });
      await sendNotificationForChat(
          userTokens: userToken,
          name: groupName,
          message: userDocSnap["name"] + ": " + (type == 0)
              ? message.toString()
              : dataTypeMap[type]!,
          pic: groupPic,
          state: state,
          uid: uid,
          puid: puid);
    } catch (e) {
      dev.log(e.toString());
    }
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

}


