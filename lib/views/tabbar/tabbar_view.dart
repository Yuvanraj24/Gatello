import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/contact_list.dart';
import 'package:gatello/views/status/status.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:gatello/views/tabbar/pops/circle_indicator.dart';
import 'package:gatello/views/tabbar/pops/newpost.dart';
import 'package:gatello/views/tabbar/pops/pops.dart';
import 'package:gatello/views/tabbar/pops/pops.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import '../../Others/Routers.dart';
import '../../Others/components/LottieComposition.dart';
import '../../Others/exception_string.dart';
import '../../Others/lottie_strings.dart';
import '../../Style/Colors.dart';
import '../../components/ScaffoldDialog.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/LifeCycle.dart';
import '../../handler/Network.dart';
import '../../main.dart';

import '../contact_list.dart';

import '../invitefriends.dart';
import '../profile/profile_details.dart';
import '../settings/settings_home_screen.dart';
import 'Delete1Dialog.dart';
import '/core/models/profile_detail.dart'as profileDetailsModel;
class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);
  @override
  State<Tabbar> createState() => _TabState();
}
class _TabState extends State<Tabbar> {
  TextEditingController searchChat= TextEditingController();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  String nameSearch='';
  bool isSelected=false;
  var lifecycleEventHandler;
  int overallUnreadChatList = 18;
  Future? _future;
  String? userId;
  bool tabSearch=false;

//  String? puid;
  final ScrollController storyScrollController = ScrollController();
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(Tuple4(0,
      exceptionFromJson(loading), "Loading", null));
  Future profileDetailsApiCall() async {
    print('dhina:${userId} ');
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: profileDetailsModel.profileDetailsFromJson,
      url: profileDetailsUrl,
      requestMethod: 1,
      body: {"user_id": (userId != null) ? userId : userId, "followee_id": ""},
    );
  }
  Future lifecycleInit() async {
    String? uid = userId;
    FirebaseFirestore instance = FirebaseFirestore.instance;

    await instance.collection("user-detail").doc(uid).update({"status": "online", "chattingWith": null, "callStatus": false});
    if (uid != null && WidgetsBinding.instance != null) {
      lifecycleEventHandler = LifecycleEventHandler(detachedCallBack: () async {
        try {
          await instance.collection("user-detail").doc(uid).update({
            "status": DateTime.now().millisecondsSinceEpoch.toString(),
            "chattingWith": null,
          });
        } catch (e) {
          log(e.toString());
        }
      }, resumeCallBack: () async {
        try {
          await instance.collection("user-detail").doc(uid).update({
            "status": "online",
          });
        } catch (e) {
          log(e.toString());
        }
      });
      WidgetsBinding.instance!.addObserver(lifecycleEventHandler);
    }
  }
  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userId = sharedPrefs.getString("userid");
    print("ShardPref ${userId}");
  }
  Future<dynamic> sendData() async {
    final data1 = await _getUID();
    final data2 = await profileDetailsApiCall();
    final data3= await lifecycleInit();
    final data4 = await fcmMain();
    return [data1, data2,data3,data4];
  }
  bool callBack(){
    print('working');
    setState(() {
      isSelected=!isSelected;
      print('Lotus7${isSelected}');
    });
    return isSelected;
    print('working1');
  }
  @override
  void initState() {
    _future = sendData();

    super.initState();
  }


  AndroidNotificationChannel channel = AndroidNotificationChannel('com.deejos.gatello', 'High Importance Notifications',
      description: 'This channel is used for important notifications.', importance: Importance.high, playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  BigPictureStyleInformation? bigPictureStyleInformation;

  Future fcmMain() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: FutureBuilder(
          future:_future,
          builder: (context,snap) {

            if(snap.hasData) {
              return DefaultTabController(
                initialIndex: 0,
                length: 5,
                child: ResponsiveBuilder(
                    builder: (context,sizingInformation) {
                      return Scaffold(
                          body: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 107.h,
                                  width: double.infinity,
                                  color: Color.fromRGBO(248, 206, 97, 1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      isSelected == false ?
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 12,
                                                bottom: 8,
                                                right: 12,
                                                top: 4),
                                            //color: Colors.blue,
                                            child:tabSearch==false? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                             //  Image.asset('assets/gatello_asset/briefLogo.png'),
                                             //    Image.asset(
                                             //      "assets/briefLogo.png",
                                             //      height: 20,
                                             //    ),
                                                Text('Gatello',
                                                    style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          fontSize: 30.sp,
                                                          fontWeight: FontWeight
                                                              .w700,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                        ))),
                                                SizedBox(width: 120.w),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile()

                                                        //  feedsValueNotifier.value.item2.result[index].userId

                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 35.h,
                                                    width: 35.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                            NetworkImage(
                                                                profileDetailsValueNotifier
                                                                    .value.item2
                                                                    .result
                                                                    .profileDetails
                                                                    .profileUrl),
                                                            fit: BoxFit.cover)
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 25.w,
                                                ),
                                                GestureDetector(onTap: () {
                                                setState(() {
                                                  tabSearch=true;
                                                });
                                                },
                                                  child: SvgPicture.asset(
                                                      'assets/tabbar_icons/Tabbar_search.svg'
                                                  ),
                                                ),Spacer(),
                                                SizedBox(
                                                  width: 20,
                                                  child: PopupMenuButton(
                                                    //   icon: Icons.menu,
                                                      padding: EdgeInsets.only(
                                                          left: 0, right: 0),
                                                      iconSize: 25.h,
                                                      itemBuilder: (
                                                          BuildContext context) =>
                                                      [
                                                        PopupMenuItem(

                                                            child: GestureDetector(
                                                              onTap:(){
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => SearchPage(
                                                                          sizingInformation: sizingInformation,
                                                                          state: 4,
                                                                        )));
                                                              },
                                                              child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                        'assets/tabbar_icons/tab_view_main/new group tab.svg'),
                                                                    SizedBox(
                                                                      width: 12.w,
                                                                    ),
                                                                    Text("New Group",
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                            textStyle: TextStyle(
                                                                              fontSize: 14
                                                                                  .sp,
                                                                              color: Color
                                                                                  .fromRGBO(
                                                                                  0, 0,
                                                                                  0, 1),
                                                                            )))
                                                                  ]
                                                              ),
                                                            )),
                                                        PopupMenuItem(
                                                            child: Container(
                                                              width: 150.w,
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      'assets/tabbar_icons/tab_view_main/linked devices tab.svg'),
                                                                  SizedBox(
                                                                    width: 12.w,
                                                                  ),
                                                                  Text(
                                                                      "Linked devices",
                                                                      style: GoogleFonts
                                                                          .inter(
                                                                          textStyle: TextStyle(
                                                                            fontSize: 14
                                                                                .sp,
                                                                            color: Color
                                                                                .fromRGBO(
                                                                                0, 0,
                                                                                0, 1),
                                                                          )))
                                                                ],
                                                              ),
                                                            )),
                                                        PopupMenuItem(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            InviteFriends(state: 0)));
                                                              },
                                                              child: Container(
                                                                width: 150.w,
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                        'assets/tabbar_icons/tab_view_main/invite frds tab.svg'),
                                                                    SizedBox(
                                                                      width: 12.w,
                                                                    ),
                                                                    Text(
                                                                        "Invite friends",
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                            textStyle: TextStyle(
                                                                              fontSize: 14
                                                                                  .sp,
                                                                              color: Color
                                                                                  .fromRGBO(
                                                                                  0,
                                                                                  0,
                                                                                  0,
                                                                                  1),
                                                                            )))
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                        PopupMenuItem(

                                                            child: GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>Setting()

                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                width: 150.w,
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                        'assets/tabbar_icons/tab_view_main/settings_icon.svg'),
                                                                    SizedBox(
                                                                      width: 12.w,
                                                                    ),
                                                                    Text("Settings",
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                            textStyle: TextStyle(
                                                                              fontSize: 14
                                                                                  .sp,
                                                                              color: Color
                                                                                  .fromRGBO(
                                                                                  0, 0,
                                                                                  0, 1),
                                                                            )))
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                      ]),
                                                ),
                                          ]):  searchBar()

                                          ) ):
                                      Expanded(child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, bottom: 8, top: 5),
                                        child: Row(children: [
                                          SvgPicture.asset(
                                              'assets/tabbar_icons/tab_view_main/back_icon.svg',
                                              width: 16.w),

                                          SizedBox(width: 14.w),
                                          Text("1",
                                              style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),))),
                                          Spacer(),
                                          InkWell(
                                            child: SvgPicture.asset(
                                                'assets/tabbar_icons/tab_view_main/downarchieved.svg'),
                                            onTap: () {

                                            },
                                          ),
                                          SizedBox(width: 28.w),
                                          InkWell(
                                            child: SvgPicture.asset(
                                                'assets/tabbar_icons/tab_view_main/chats_image/per_chat_ontap_icons/delete.svg'),
                                            onTap: () {

                                            },
                                          ),
                                          SizedBox(width: 26.w),
                                          SizedBox(
                                            width: 20,
                                            child: PopupMenuButton(
                                                child: Icon(
                                                  Icons.more_vert_outlined,
                                                  color: Colors.black,
                                                ),
                                                itemBuilder: (context) =>
                                                [
                                                  PopupMenuItem(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          "View profile",
                                                          style: GoogleFonts.inter(
                                                              textStyle: TextStyle(
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      0, 0, 0, 1))),
                                                        ),
                                                      )),
                                                  PopupMenuItem(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          "Select all",
                                                          style: GoogleFonts.inter(
                                                              textStyle: TextStyle(
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      0, 0, 0, 1))),
                                                        ),
                                                      )),
                                                ]),
                                          ),
                                        ],),)),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(left: 4, bottom: 3, right: 3),
                                        child: Container(
                                          height: 57,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(248, 206, 97, 1),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                spreadRadius: 6,
                                                blurRadius: 10,
                                                //  offset: Offset(10, 10), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: TabBar(
                                            labelPadding: EdgeInsets.all(0),
                                            indicatorColor: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            tabs: [
                                              Tab(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/tabbar_icons/pops_getit.svg",

                                                    ),
                                                    Text(
                                                      "Get it",
                                                      style: GoogleFonts.fredoka(
                                                          textStyle: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 1),
                                                              fontWeight: FontWeight
                                                                  .w400)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Tab(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/tabbar_icons/pings_icon.svg",
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Pings",
                                                          style: GoogleFonts.fredoka(
                                                              textStyle: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      0, 0, 0, 1),
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight
                                                                      .w400)),
                                                        ),
                                                        SizedBox(width: 5),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Tab(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/tabbar_icons/Pops_icon.svg",

                                                    ),
                                                    Text(
                                                      "Pops",
                                                      style: GoogleFonts.fredoka(
                                                          textStyle: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 1),
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight
                                                                  .w400)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Tab(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/tabbar_icons/status_icon.svg",

                                                    ),
                                                    Text(
                                                      "Status",
                                                      style: GoogleFonts.fredoka(
                                                          textStyle: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 1),
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight
                                                                  .w400)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Tab(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/tabbar_icons/pops_call.svg",
                                                    ),
                                                    Text(
                                                      "Calls",
                                                      style: GoogleFonts.fredoka(
                                                          textStyle: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 1),
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight
                                                                  .w400)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    //  height:637.h,
                                    // width:double.infinity ,
                                    child: TabBarView(
                                      children: [


                                        Center(
                                          child: Text("Get it...!"),
                                        ),
                                        PingsChatView(uid:userId.toString(),callBack:callBack ),
                                        Center(
                                          child: Text("Pops...!"),
                                        ),
                                        // Story(
                                        //     scrollController: storyScrollController),
                                        Status(),

                                        Center(
                                          child: Text("Calls...!"),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )

                      );
                    }
                ),
              );
            }
            else{
              return Scaffold(
                body: Container(
                    color: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
                    child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [lottieAnimation(loadingLottie), Text("Loading")],
                          ),
                        ))),
              );
            }
          }
      ),
    );
  }
  showDeleteDialog2(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Delete1Dialog();
      },
    );
  }
  Widget searchBar(){
    bool folded=false;
    return Row(
      children: [  GestureDetector(onTap: () {
        setState(() {
          tabSearch=false;
        });
      },
        child: SvgPicture.asset(
          'assets/pops_asset/back_button.svg',
          height: 30.h,
          width: 30.w,),
      ),
        AnimatedContainer(duration:Duration(milliseconds:100),
          height:40.h,width:folded==true?10.w:300.w,
          decoration:BoxDecoration(borderRadius:BorderRadius.circular(40),color:Colors.white),
          child:   TextField(controller:searchChat,
            decoration:InputDecoration(focusedBorder:OutlineInputBorder(
                borderSide:BorderSide(color:Colors.transparent)
            ),
                enabledBorder:OutlineInputBorder(
                    borderSide:BorderSide(color:Colors.transparent)
                )),

          ),
        ),
      ],
    );
  }

}

