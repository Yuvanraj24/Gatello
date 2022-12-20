import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:tuple/tuple.dart';
import '../../Authentication/Authentication.dart';
import '../../Firebase/FirebaseNotifications.dart';
import '../../Firebase/Writes.dart';
import '../../Helpers/GetContactHelper.dart';
import '../../Others/Routers.dart';
import '../../Others/Structure.dart';
import '../../Others/components/LottieComposition.dart';
import '../../Others/exception_string.dart';
import '../../Others/lottie_strings.dart';
import '../../Style/Colors.dart';
import '../../Style/Text.dart';
import '../../components/ScaffoldDialog.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../core/models/pings_chat_model/pings_chats_list_model.dart';
import '../../handler/LifeCycle.dart';
import '../../handler/Network.dart';
import '../../handler/Notification.dart';
import '../../main.dart';
import '../../utils/DynamicLinkParser.dart';
import '../contact_list.dart';
import 'dart:developer' as dev;
import '../invitefriends.dart';
import '../profile/profile_details.dart';
import '../settings/settings_home_screen.dart';
import '../status/status_test.dart';
import 'Delete1Dialog.dart';
import '/core/models/profile_detail.dart' as profileDetailsModel;
import 'chats/personal_chat_screen/ChatPage.dart';
class Tabbar extends StatefulWidget {
  var uid;
  Tabbar({this.uid});
  @override
  State<Tabbar> createState() => _TabState();
}
class _TabState extends State<Tabbar> {
  GlobalKey<_PingsChatViewState> globalKey = GlobalKey();
  //late GlobalKey _pingsChatViewState;
  TextEditingController searchChat = TextEditingController();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  //String nameSearch='';
  int pos=1;
  bool isSelected = false;
  var lifecycleEventHandler;
  int overallUnreadChatList = 18;
  Future? _future;
  String? userId;
  bool tabSearch = false;

  List<Contact> contacts = [];
  int conLen=0;
  List<String> contactNames = [];

  Future<List<Contact>> getContacts() async {
    PermissionStatus contactpermission = await Permission.contacts.request();
    if (contactpermission.isGranted || contactpermission.isLimited) {
      contacts = await FastContacts.allContacts;
      conLen=contacts.length;
      for(int i=0;i<contacts.length;i++)
      {
        contactNames.add(contacts[i].displayName);
      }
      setState(() {
        conLen=contacts.length;
      });

      getDataList();

    } else {

    }
    return contacts;// return contactList;
  }
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
  List fBPhone=[];
  List contacts1 = [];
  List contacts2 = [];
  List contactNumber = [];
  List contactName = [];
  List conNames=[];
  Map <String,String> conMap = Map();
  getDataList() async {

    print("Contact Size:${contacts.length}");
    print("FBPhone Size:${fBPhone.length}");

    int x=0;

    for(x=0;x<contacts.length;x++)
    {
      try {
        String mob = contacts[x].phones[0];
        mob=mob.replaceAll(" ", "");
        mob=mob.replaceAll("-", "");
        print("Mob:${mob}(${x}) Size:(${mob.length})");

        if(mob.length>10 && mob.length==12)
        {
          print("ifdrop");
          mob=mob.substring(2,12);
          print(mob);
          contacts1.add(mob);
        }
        else if(mob.length>10 && mob.length==13)
        {
          print("ifdrop");
          mob=mob.substring(3,13);
          print(mob);
          contacts1.add(mob);
        }
        else
        {
          contacts1.add(mob);
        }

      }
      catch(e)
      {
        print("Exception${e}");
      }

    }

    print("Con1${contacts1}");
    setState(() {

    });
    int i=0,j=0;

    for(i=0;i<contacts1.length;i++)
    {
      for(j=0;j<fBPhone.length;j++)
      {
        if(contacts1[i]==fBPhone[j])
        {
          var x=contacts2.contains(fBPhone[j]);
          print("Contact Check : ${x}");

          if(x==false) {
            contacts2.add(contacts1[i]);
            conNames.add(contactNames[i]);
          }
        }
      }
    }
    // print("contactNumber:${contacts2} ${conNames}");
    contactNumber = LinkedHashSet<String>.from(contacts2).toList();
    contactName = LinkedHashSet<String>.from(conNames).toList();
    print("{contactNumber${contactNumber}");
    print("contactName${contactName}");
    print("conMap${conMap}");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String encodedMap = json.encode(conMap);
    print(encodedMap);

    String encodedMap1 = json.encode(contactName);
    print(encodedMap1);

    String encodedMap2 = json.encode(contactNumber);
    print(encodedMap2);

    prefs.setString('conMap', encodedMap);
    prefs.setString('conNames', encodedMap1);
    prefs.setString('conNums', encodedMap2);
  }


  bool _isRequesting = false;
  bool _isFinish = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
  List conId=[];
  Future userChatList({required String searchQuery, int limit = 50}) async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      _isRequesting = true;
      if (body.isEmpty) {

        querySnapshot = await instance
            .collection("user-detail")
            .where("name",
            isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name",
            isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
                '\uf8ff')
            .orderBy("name")
            .limit(limit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("user-detail")
            .where("name",
            isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name",
            isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
                '\uf8ff')
            .orderBy("name")
            .startAfterDocument(body[body.length - 1])
            .limit(limit)
            .get();
      }
      if (querySnapshot != null) {

        if (!mounted) return;
        setState(() {
          // print("QS Len: ${querySnapshot.docs.length}");
          body.addAll(querySnapshot.docs);
          print("Body Added ${querySnapshot.docs}");

          String phone,name,id;
          Stream<QuerySnapshot> chatRef = instance.collection("user-detail").snapshots();
          chatRef.forEach((field) {
            field.docs.asMap().forEach((index, data) {
              // print("Con:${field.docs[index]["phone"]}");
              phone=field.docs[index]["phone"];
              name=field.docs[index]["name"];
              id=field.docs[index]["uid"];

              phone=phone.replaceAll(" ", "");
              print("Con:${phone}(${phone.length})");
              print("ConName:${name}(${name.length})");

              if(phone.length>10 && phone.length<=13)
              {
                print("ifdrop");
                phone=phone.substring(3,13);
                print(phone);
                fBPhone.add(phone);
                // conMap[phone]=name;
                // conId.add(id);
                conMap[phone]=id;


              }
              else
              {
                fBPhone.add(phone);
                conMap[phone]=id;

              }

              // print(fBPhone);




            });
            print("ConMap:${conMap}");
            print("ConIds:${conId}");
            setState(() {
              getDataList();
            });
          });

        });
        if (querySnapshot.docs.length < limit) {
          print('Lotus777${querySnapshot.docs}');
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }







//  String? puid;
  final ScrollController storyScrollController = ScrollController();
  ValueNotifier<Tuple4> profileDetailsValueNotifier = ValueNotifier<Tuple4>(
      Tuple4(0, exceptionFromJson(loading), "Loading", null));
  // Future profileDetailsApiCall() async {
  //   print('dhina3333:${userId} ');
  //   return await ApiHandler().apiHandler(
  //     valueNotifier: profileDetailsValueNotifier,
  //     jsonModel: profileDetailsModel.profileDetailsFromJson,
  //     url: 'http://3.110.105.86:4000/view/profile',
  //     requestMethod: 1,
  //     // body: {"user_id": (userId != null) ? userId : userId, "followee_id": ""},
  //     body: {
  //       "user_id": (widget.userId != null)
  //           ? widget.userId
  //           : userId,
  //       "followee_id": ""
  //     },
  //   );
  // }

  Future lifecycleInit() async {
    String? uid = userId;
    FirebaseFirestore instance = FirebaseFirestore.instance;

    await instance.collection("user-detail").doc(uid).update(
        {"status": "online", "chattingWith": null, "callStatus": false});
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
      WidgetsBinding.instance.addObserver(lifecycleEventHandler);
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
    final data3 = await lifecycleInit();
    final data4 = await fcmMain();
    final data5 = await getDataList();
    final data6 = await getContacts();

    // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {


    var userSnap = instance.collection("user-detail").doc(widget.uid).snapshots();
    return [data1, data3, data4,userSnap,data5,data6];
  }
  Future profileDetailsApiCall() async {
    print('dhina:${userId} ');
    return await ApiHandler().apiHandler(
      valueNotifier: profileDetailsValueNotifier,
      jsonModel: profileDetailsModel.profileDetailsFromJson,
      url: 'http://3.110.105.86:4000/view/profile',
      requestMethod: 1,
      body: {"user_id": (userId != null) ? userId : userId, "followee_id": ""},
    );
  }
  bool callBack() {
    print('working');
    setState(() {
      isSelected = !isSelected;
      print('Lotus7${isSelected}');
    });
    return isSelected;
    print('working1');
  }
  late Future<List<Contact>> _contacts;
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
   // fireBaseBlockList1();
    _future = sendData();
    getFCMToken().then((value) => print("fcm token:" + value));
    FirebaseMessaging.onMessage.listen(firebaseMessagingHandler);
    userChatList(searchQuery: searchTextEditingController.text);
    _contacts = getContacts();
    getDataList();


    // PingsChatViewKey = GlobalKey<_PingsChatViewState>();
    // _pingsChatViewState=GlobalKey();
    super.initState();
  }

  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'com.deejos.gatello', 'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  BigPictureStyleInformation? bigPictureStyleInformation;

  Future fcmMain() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              return DefaultTabController(
                initialIndex: 0,
                length: 3,
                child: ResponsiveBuilder(builder: (context, sizingInformation) {
                  var pic ='http://3.110.105.86:4000/${profileDetailsValueNotifier
                      .value
                      .item2.result
                      .profileDetails
                      .profileUrl.toString()}';

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
                                  isSelected == false
                                      ? Expanded(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              bottom: 8,
                                              right: 12,
                                              top: 4),
                                          //color: Colors.blue,
                                          child: tabSearch == false
                                              ? Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                //  Image.asset('assets/gatello_asset/briefLogo.png'),
                                                //    Image.asset(
                                                //      "assets/briefLogo.png",
                                                //      height: 20,
                                                //    ),
                                                Text('Gatello',
                                                    style:
                                                    GoogleFonts.inter(
                                                        textStyle:
                                                        TextStyle(
                                                          fontSize: 30.sp,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          color:
                                                          Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                        ))),
                                                SizedBox(width: 120.w),

                                                // GestureDetector(
                                                //   onTap: () {
                                                //     Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (context) =>
                                                //               Profile()
                                                //
                                                //         //  feedsValueNotifier.value.item2.result[index].userId
                                                //
                                                //       ),
                                                //     );
                                                //   },
                                                //   child: Container(
                                                //     height: 35.h,
                                                //     width: 35.w,
                                                //     decoration: BoxDecoration(
                                                //         color: Colors.pink,
                                                //         shape: BoxShape.circle,
                                                //         image: DecorationImage(
                                                //             image:
                                                //             NetworkImage(
                                                //                 profileDetailsValueNotifier.value.item2.result.profileDetails.profileUrl),
                                                //             fit: BoxFit.cover)
                                                //     ),
                                                //   ),
                                                // ),
                                                GestureDetector( onTap:(){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Profile(userId:userId.toString())

                                                      //  feedsValueNotifier.value.item2.result[index].userId

                                                    ),
                                                  );
                                                },child:

                                                (pic != null)
                                                    ? CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  fadeInDuration:
                                                  const Duration(
                                                      milliseconds:
                                                      400),
                                                  imageBuilder:
                                                      (context,
                                                      imageProvider) =>
                                                      Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          shape: BoxShape
                                                              .circle,
                                                          image: DecorationImage(
                                                              image:
                                                              imageProvider,
                                                              fit: BoxFit
                                                                  .cover),
                                                        ),
                                                      ),
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                      downloadProgress) =>
                                                      Center(
                                                        child: CircularProgressIndicator(
                                                            value: downloadProgress
                                                                .progress),
                                                      ),
                                                  imageUrl: pic,
                                                  errorWidget:
                                                      (context, url,
                                                      error) =>
                                                      Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/noProfile.jpg")
                                                            )
                                                        ),
                                                      ),
                                                )
                                                    :
                                                Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape
                                                          .circle,
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/noProfile.jpg"),
                                                          fit: BoxFit
                                                              .cover)),
                                                  //   child: Image.asset("assets/noProfile.jpg")
                                                ),),
                                                SizedBox(
                                                  width: 25.w,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      tabSearch = true;
                                                    });
                                                  },
                                                  child: SvgPicture.asset(
                                                      'assets/tabbar_icons/Tabbar_search.svg'),
                                                ),
                                                Spacer(),
                                                SizedBox(
                                                  width: 20,
                                                  child: PopupMenuButton(
                                                      onSelected:
                                                          (value) async {
                                                        switch (value) {
                                                          case 1:
                                                            {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => SearchPage(
                                                                        sizingInformation: sizingInformation,
                                                                        state: 4,
                                                                      )));
                                                            }
                                                            break;
                                                          case 2:
                                                            {}
                                                            break;
                                                          case 3:
                                                            {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          InviteFriends(state: 0, Getstarted: '',)));
                                                            }
                                                            break;
                                                          case 4:
                                                            {
                                                              Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        Setting()),
                                                              );
                                                            }
                                                        }
                                                      },
                                                      //   icon: Icons.menu,
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          right: 0),
                                                      iconSize: 25.h,
                                                      itemBuilder:
                                                          (BuildContext
                                                      context) =>
                                                      [
                                                        PopupMenuItem(
                                                            value:
                                                            1,
                                                            child:
                                                            Row(children: [
                                                              SvgPicture.asset('assets/tabbar_icons/tab_view_main/new group tab.svg'),
                                                              SizedBox(
                                                                width: 12.w,
                                                              ),
                                                              Text("New Group",
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                        fontSize: 14.sp,
                                                                        color: Color.fromRGBO(0, 0, 0, 1),
                                                                      )))
                                                            ])),
                                                        PopupMenuItem(
                                                            value:
                                                            2,
                                                            child:
                                                            Row(
                                                              children: [
                                                                SvgPicture.asset('assets/tabbar_icons/tab_view_main/linked devices tab.svg'),
                                                                SizedBox(
                                                                  width: 12.w,
                                                                ),
                                                                Text("Linked devices",
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontSize: 14.sp,
                                                                          color: Color.fromRGBO(0, 0, 0, 1),
                                                                        )))
                                                              ],
                                                            )),
                                                        PopupMenuItem(
                                                          value:
                                                          3,
                                                          child:
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset('assets/tabbar_icons/tab_view_main/invite frds tab.svg'),
                                                              SizedBox(
                                                                width: 12.w,
                                                              ),
                                                              Text("Invite friends",
                                                                  style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                        fontSize: 14.sp,
                                                                        color: Color.fromRGBO(0, 0, 0, 1),
                                                                      )))
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                            value:
                                                            4,
                                                            child:
                                                            Row(
                                                              children: [
                                                                SvgPicture.asset('assets/tabbar_icons/tab_view_main/settings_icon.svg'),
                                                                SizedBox(
                                                                  width: 12.w,
                                                                ),
                                                                Text("Settings",
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontSize: 14.sp,
                                                                          color: Color.fromRGBO(0, 0, 0, 1),
                                                                        )))
                                                              ],
                                                            ))
                                                      ]),
                                                ),
                                              ])
                                              : searchBar()))
                                      : Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 8,
                                            top: 5),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                //    callBack();
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/tabbar_icons/tab_view_main/back_icon.svg',
                                                  width: 16.w),
                                            ),
                                            SizedBox(width: 14.w),
                                            Text(
                                                '${globalKey.currentState!.selectedItems!.length} items selected',
                                                style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color:
                                                      Color.fromRGBO(0, 0, 0, 1),
                                                    ))),
                                            Spacer(),
                                            InkWell(
                                              child: SvgPicture.asset(
                                                  'assets/tabbar_icons/tab_view_main/downarchieved.svg'),
                                              onTap: () {},
                                            ),
                                            SizedBox(width: 28.w),
                                            InkWell(
                                              child: SvgPicture.asset(
                                                  'assets/tabbar_icons/tab_view_main/chats_image/per_chat_ontap_icons/delete.svg'),
                                              onTap: () {
                                                Future<void>.delayed(
                                                    Duration(),
                                                        ()=> showDialog(context: context, barrierColor: Colors.black26,builder: (context)=>
                                                        AlertDialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                          insetPadding: EdgeInsets.only(left: 12, right: 12),
                                                          titlePadding: EdgeInsets.all(0),
                                                          title: Container(
                                                            width: 380.w,
                                                            padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 0,right: 12.w),
                                                            child: Column(       mainAxisSize: MainAxisSize.min,children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Delete this chat?',
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                            fontSize: 16.sp,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: Color.fromRGBO(0, 0, 0, 1))),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 20.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Chat messages will only be removed from\nthis device',
                                                                    style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                            fontSize: 15.sp,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Color.fromRGBO(157, 157, 157, 1))),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 20.h),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Color.fromRGBO(0, 163, 255, 1))),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      globalKey.currentState
                                                                          ?.deletefun();
                                                                      globalKey.currentState
                                                                          ?.deletefun1();
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text("Delete chat", style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                            fontSize: 16.sp,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: Colors.red)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],),
                                                          ),
                                                        )
                                                    )
                                                );
                                              },
                                            ),
                                            SizedBox(width: 26.w),
                                            SizedBox(
                                              width: 20,
                                              child: PopupMenuButton(
                                                  onSelected: (value) async {
                                                    switch (value) {
                                                      case 1:
                                                        {}
                                                        break;
                                                      case 2:
                                                        {
                                                          globalKey.currentState
                                                              ?.selectAllFun();
                                                        }
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.more_vert_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        value: 1,
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "View profile",
                                                            style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                    16.sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1))),
                                                          ),
                                                        )),
                                                    PopupMenuItem(
                                                        value: 2,
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 10),
                                                          child: Text(
                                                            "Select all",
                                                            style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                    16.sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1))),
                                                          ),
                                                        )),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 4, bottom: 3, right: 3),
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
                                        indicatorColor:
                                        Color.fromRGBO(255, 255, 255, 1),
                                        tabs: [
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
                                                              color: Color.fromRGBO(
                                                                  0, 0, 0, 1),
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                              FontWeight.w400)),
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
                                                          fontWeight:
                                                          FontWeight.w400)),
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
                                                          fontWeight:
                                                          FontWeight.w400)),
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
                                    PingsChatView(
                                      uid: userId.toString(),
                                      callBack: callBack,
                                      key: globalKey,
                                      isForward: false,),
                                    // Center(
                                    //   child: Text("Pops...!"),
                                    // ),
                                    Story(scrollController: storyScrollController),
                                    Status(uid: userId.toString(), profilePic: pic,
                                      // profilePic:profileDetailsValueNotifier.value.item2.result.
                                      // profileDetails.profileUrl.toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  );
                }),
              );
            } else {
              return Scaffold(
                body: Container(
                    color: (themedata.value.index == 0)
                        ? Color(white)
                        : Color(materialBlack),
                    child: Center(
                        // child : Text("Loading...")
                        child : Image.asset("assets/gatellologo1.gif")

                        ),
                    ),
              );
            }
          }),
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
  Widget searchBar() {
    bool folded = false;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              tabSearch = false;
            });
          },
          child: SvgPicture.asset(
            'assets/pops_asset/back_button.svg',
            height: 30.h,
            width: 30.w,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 40.h,
          width: folded == true ? 10.w : 300.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.white),
          child: TextField(
            onChanged: (value) {
              setState(() {
                globalKey.currentState!.nameSearch = value;
              });
            },
            controller: globalKey.currentState?.searchChat,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent))),
          ),
        ),
      ],
    );
  }
}


//----------------------------------- Second File Class --------------------------------------


class PingsChatView extends StatefulWidget {
  final Map<int, DocumentSnapshot<Map<String, dynamic>>>? messages;
  final String? postDescription;
  final String? postId;
  final String? postTitle;
  final bool isForward;
  final String? postUrl;
  final int? state;
  final String uid;
  final int? storyContentType;
  Function? callBack;
  final String? search;
  PingsChatView(
      {Key? key,
       required this.isForward,
        this.postTitle,
        this.postId,
        this.postDescription,
        this.postUrl,
        this.storyContentType,
        this.state,
        this.messages,
        required this.uid,
        this.callBack,
        this.search})
      : super(key: key);
  @override
  _PingsChatViewState createState() => _PingsChatViewState();
}
class _PingsChatViewState extends State<PingsChatView> with SingleTickerProviderStateMixin {
  List<String> selectlen = [];
  bool isSent = false;

  List blockedByList = [];

  blockedByListFromFireBase(uid) async {
    await instance.collection("user-detail").doc(uid).get().then(
            (doc) {
          print("hello Bro>>>");
          print(doc.data()!['name']);
          var fal = doc.data()!['blockedByList'].length;
          var fList = doc.data()!['blockedByList'];
          print("The user block by Deatails... ${fList}");
          print("Blocked By List in FireStore ${fal}");
          for(int i=0; i<fal; i++){
            print("Loop is Called");
            blockedByList.add(doc.data()!['blockedByList'][i]);
            print(" Local Blocked By List : ${blockedByList[i]}");
          }
          print("Total final BL By : ${blockedByList}");

        }
    );
  }

  List blockedList=[];
  fireBaseBlockList1()async{

    print("Getting Block List for ${puid}");

    await instance.collection("user-detail").doc("${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}").get().then(
            (doc) {
          var fal = doc.data()!['blockList'].length;
          var fList = doc.data()!['blockList'];
          print("The user block Deatails... ${fList}");
          print("BlockList in FireStore ${fal}");
          for(int i=0; i<=fal-1; i++){
            print("Loop is Called");
            blockedList.add(doc.data()!['blockList'][i]);
            print(" Local Block List : ${blockedList[i]}");
          }
          print("Total final BL : ${blockedList}");

        }
    ).whenComplete((){
      // block();
    });


  }





  var name;
  var peerName;
  int index = 0;
  String nameSearch = '';
  var heroImg;
  late TabController tabController;
  bool sel = false;
  bool typing = false;
  final instance = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? puid;
  bool isChatting = false;
  List<PingsChatListModel> tileData = [];
  final _isSelected = Map();
  final _isSelected1 = Map();
  bool selects = false;
  TextEditingController searchChat = TextEditingController();
  bool change = false;
  bool longPressedFlag = false;
  bool longPressedFlag1 = false;
  late List? selectedItems = [];
  late List? selectedItems1 = [];
  bool isFirstTime = true;
  bool isFirstTime1 = true;
  bool isChatListLoaded = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
  List selectedDocs = [];
  List filteredChats = [];
  var listData;
  int totalUnreadCount = 0;
  List unreadTabCount = [];
  Future? _future;


  deletefun() {
    print('LOtus777777');
    for (int i = 0; i < selectedItems!.length; i++) {
      var sell = instance
          .collection("personal-chat-room-detail")
          .doc("${docs[selectedItems![i]].id}");
      print("${docs[selectedItems![i]].id}");
      sell.update({"members.${widget.uid}.delete": true});
      //selectedItems!.remove;

    }
    selectedItems = [];

    print(docs[index].data()["members"]
    ["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]);

    print("Uid is a $puid");
  }
  var peerN=Map();
  var peerMob=Map();
  getLocalPeerName(name){

    instance.collection("user-detail").doc(name).get().then((doc) {
      var fPhone = doc.data()!['phone'];
      peerMob[name]=fPhone;
      print("fPhone ${fPhone}");
      getContactName(fPhone).then((value) {
        print("peer b4 print");
        peerN[name] =  (value == null)? fPhone: value;

        print("peer after print ${peerN}");
      }).then((value) {
        print("value is : ${peerName}");
      });
    });
  }
  deletefun1() {
    print('LOtus777777');
    for (int i = 0; i < selectedItems1!.length; i++) {
      var sell = instance
          .collection("personal-chat-room-detail")
          .doc("${docs[selectedItems1![i]].id}");
      print("${docs[selectedItems1![i]].id}");
      sell.update({"members.${widget.uid}.delete": true});
      //selectedItems!.remove;

    }
    selectedItems1 = [];

    print(docs[index].data()["members"]
    ["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]);

    print("Uid is a $puid");
  }
  selectAllFun() {
    print('gggg');    for (int i = 0; i < docs.length; i++) {
      longPressedFlag = true;
      selectedItems!.add(i);
      print("Document Data... ${i}");
      print("Document Data... ${selectedItems}");
    }

  }

  List<Contact> contacts = [];
  int conLen=0;
  List<String> contactNames = [];

  Future<List<Contact>> getContacts() async {
    PermissionStatus contactpermission = await Permission.contacts.request();
    if (contactpermission.isGranted || contactpermission.isLimited) {
      contacts = await FastContacts.allContacts;
      conLen=contacts.length;
      for(int i=0;i<contacts.length;i++)
      {
        contactNames.add(contacts[i].displayName);
      }
      setState(() {
        conLen=contacts.length;
      });

      getDataList();

    } else {

    }
    return contacts;// return contactList;
  }

  List fBPhone=[];
  List contacts1 = [];
  List contacts2 = [];
  List contactNumber = [];
  List contactName = [];
  List conNames=[];
  Map <String,String> conMap = Map();
  getDataList() async {

    print("Contact Size:${contacts.length}");
    print("FBPhone Size:${fBPhone.length}");

    int x=0;

    for(x=0;x<contacts.length;x++)
    {
      try {
        String mob = contacts[x].phones[0];
        mob=mob.replaceAll(" ", "");
        mob=mob.replaceAll("-", "");
        print("Mob:${mob}(${x}) Size:(${mob.length})");

        if(mob.length>10 && mob.length==12)
        {
          print("ifdrop");
          mob=mob.substring(2,12);
          print(mob);
          contacts1.add(mob);
        }
        else if(mob.length>10 && mob.length==13)
        {
          print("ifdrop");
          mob=mob.substring(3,13);
          print(mob);
          contacts1.add(mob);
        }
        else
        {
          contacts1.add(mob);
        }

      }
      catch(e)
      {
        print("Exception${e}");
      }

    }

    print("Con1${contacts1}");
    setState(() {

    });
    int i=0,j=0;

    for(i=0;i<contacts1.length;i++)
    {
      for(j=0;j<fBPhone.length;j++)
      {
        if(contacts1[i]==fBPhone[j])
        {
          var x=contacts2.contains(fBPhone[j]);
          print("Contact Check : ${x}");

          if(x==false) {
            contacts2.add(contacts1[i]);
            conNames.add(contactNames[i]);
          }
        }
      }
    }
    // print("contactNumber:${contacts2} ${conNames}");
    contactNumber = LinkedHashSet<String>.from(contacts2).toList();
    contactName = LinkedHashSet<String>.from(conNames).toList();
    print("{contactNumber${contactNumber}");
    print("contactName${contactName}");
    print("conMap${conMap}");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String encodedMap = json.encode(conMap);
    print(encodedMap);

    String encodedMap1 = json.encode(contactName);
    print(encodedMap1);

    String encodedMap2 = json.encode(contactNumber);
    print(encodedMap2);

    prefs.setString('conMap', encodedMap);
    prefs.setString('conNames', encodedMap1);
    prefs.setString('conNums', encodedMap2);
  }


  bool _isRequesting = false;
  bool _isFinish = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
  List conId=[];
  Future userChatList({required String searchQuery, int limit = 50}) async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      _isRequesting = true;
      if (body.isEmpty) {

        querySnapshot = await instance
            .collection("user-detail")
            .where("name",
            isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name",
            isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
                '\uf8ff')
            .orderBy("name")
            .limit(limit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("user-detail")
            .where("name",
            isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name",
            isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
                '\uf8ff')
            .orderBy("name")
            .startAfterDocument(body[body.length - 1])
            .limit(limit)
            .get();
      }
      if (querySnapshot != null) {

        if (!mounted) return;
        setState(() {
          // print("QS Len: ${querySnapshot.docs.length}");
          body.addAll(querySnapshot.docs);
          print("Body Added ${querySnapshot.docs}");

          String phone,name,id;
          Stream<QuerySnapshot> chatRef = instance.collection("user-detail").snapshots();
          chatRef.forEach((field) {
            field.docs.asMap().forEach((index, data) {
              // print("Con:${field.docs[index]["phone"]}");
              phone=field.docs[index]["phone"];
              name=field.docs[index]["name"];
              id=field.docs[index]["uid"];

              phone=phone.replaceAll(" ", "");
              print("Con:${phone}(${phone.length})");
              print("ConName:${name}(${name.length})");

              if(phone.length>10 && phone.length<=13)
              {
                print("ifdrop");
                phone=phone.substring(3,13);
                print(phone);
                fBPhone.add(phone);
                // conMap[phone]=name;
                // conId.add(id);
                conMap[phone]=id;


              }
              else
              {
                fBPhone.add(phone);
                conMap[phone]=id;

              }

              // print(fBPhone);




            });
            print("ConMap:${conMap}");
            print("ConIds:${conId}");
            setState(() {
              getDataList();
            });
          });

        });
        if (querySnapshot.docs.length < limit) {
          print('Lotus777${querySnapshot.docs}');
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }

  late Future<List<Contact>> _contacts;
  TextEditingController searchTextEditingController = TextEditingController();
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _future = sendData();
    userChatList(searchQuery: searchTextEditingController.text);
    _contacts = getContacts();
    getDataList();
    getLocalPeerName(name);
    tabController = TabController(vsync: this, length: 2);
    fireBaseBlockList1();


    super.initState();
    tileData = pingsChatListData();
  }


  Future<dynamic> sendData() async {
    final data1 = await fcmMain();
    final data2 = await getDataList();
    final data3 = await getContacts();

    var pinglistDetail =  instance.collection("personal-chat-room-detail").where("members.${widget.uid}.delete", isEqualTo: false).snapshots();

    var userSnap = instance.collection("user-detail").doc(widget.uid).snapshots();
    return [pinglistDetail,data1, data2, data3,userSnap];
  }

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
          "Personal", style: GoogleFonts.poppins(
              textStyle: textStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black)),
        ),
      ),
      Tab(
        child: Text("Group", style: GoogleFonts.poppins(textStyle: textStyle(
                  fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black)),
        ),
      )
    ];


    Widget getChatList(SizingInformation sizingInformation) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: instance.collection("personal-chat-room-detail").where("members.${widget.uid}.delete", isEqualTo: false).snapshots(),
          builder: (context, chatRoomdetailsnap) {
            if (chatRoomdetailsnap.connectionState == ConnectionState.active &&
                chatRoomdetailsnap.hasData &&
                chatRoomdetailsnap.data != null &&
                chatRoomdetailsnap.data!.docs.isNotEmpty) {
              getLocalPeerName(name);
              docs = chatRoomdetailsnap.data!.docs;
              docs.sort((b, a) => getDateTimeSinceEpoch(
                  datetime: a.data()["timestamp"])
                  .compareTo(
                  getDateTimeSinceEpoch(datetime: b.data()["timestamp"])));

              print("TOTAL UNREAD:${totalUnreadCount}");
              print(
                  "TOTAL UNREAD1:${docs[index].data()["members"]["${widget.uid}"]["unreadCount"] + totalUnreadCount}");
              print(
                  'dheee  :  ${unreadTabCount.indexOf(docs[index].data()["members"]["${widget.uid}"]["unreadCount"] + totalUnreadCount)}');
              return FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 200)),
                builder: (context,_) {
                  return FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 100)),
                    builder: (context,_) {
                      return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            if (!_isSelected.containsKey(index)) {
                              // important
                              _isSelected[index] = false;
                            }
                            // var userSnap = instance.collection("user-detail").doc(widget.uid).collection("blockList").get();
                            blockedByListFromFireBase(widget.uid);
                            var puids = "JhRKwvnKe4Wxu1nYaucwZVurRlt1";
                            name = docs[index].data()["members"]["${widget.uid}"]["peeruid"];
                            print('puid is print : ${name}');
                            getLocalPeerName(name);

                            print("Map of puid is : ${peerN}");
                            // getContacts().then((value) => print("Contact List : ${value}"));
                            var pic = docs[index].data()["members"][
                            "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                            ["pic"];
                            var id = docs[index].data()["members"]["${widget.uid}"]
                            ["peeruid"];
                            var members = docs[index].data()["members"];
                            if (nameSearch.isEmpty) {
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: ListTile(
                                      selected: _isSelected[index],
                                      tileColor: Colors.white,
                                      selectedTileColor:
                                      Color.fromRGBO(248, 206, 97, 0.31),
                                      onLongPress:(widget.isForward==false)? () {
                                        setState(() {
                                          _isSelected[index] = !_isSelected[index];
                                          if (isFirstTime) {
                                            if (selectedItems!.isEmpty) {
                                              widget.callBack!();
                                              selectedItems!.add(index);
                                              isFirstTime = false;
                                              longPressedFlag = true;
                                            }
                                          } else {
                                            if (selectedItems!.contains(index)) {
                                              print("EXISTS So removing...");
                                              selectedItems!.remove(index);
                                              print("Selected$index");
                                              print("Selected items$selectedItems");
                                              if (selectedItems!.length == 0) {
                                                widget.callBack!();
                                              }
                                            } else {
                                              selectedItems!.add(index);
                                              print("Selected$index");
                                              print("Selected items$selectedItems");
                                              print("Long Press Triggers");
                                              longPressedFlag = true;
                                            }

                                            if (selectedItems!.isEmpty &&
                                                isFirstTime == false) {
                                              print("Deselect all");
                                              isFirstTime = true;
                                              longPressedFlag = false;
                                            }
                                          }
                                        });

                                        print('Lotus78${selectedItems?.length}');
                                        selectedItems?.length.toString();
                                      }:null,
                                      onTap:(widget.isForward==false)?  () {
                                        print("Long Press Flag:${longPressedFlag}");
                                        if (longPressedFlag) {
                                          setState(() {
                                            _isSelected[index] = !_isSelected[index];
                                            if (selectedItems!.isEmpty) {
                                              longPressedFlag = false;
                                            } else {
                                              print("Tapping...x");

                                              if (selectedItems!.contains(index)) {
                                                print("EXISTS So removing...");
                                                selectedItems!.remove(index);
                                                print("Selected$index");
                                                print("Selected items$selectedItems");
                                                if (selectedItems!.length == 0) {
                                                  widget.callBack!();
                                                }
                                              } else {
                                                selectedItems!.add(index);
                                                print("Selected$index");
                                                print("Selected items$selectedItems");
                                                print("Tap Triggers");
                                                longPressedFlag = true;
                                              }
                                            }
                                          });

                                          if (selectedItems!.isEmpty &&
                                              isFirstTime == false) {
                                            print("Deselect all");
                                            isFirstTime = true;
                                            longPressedFlag = false;
                                          }
                                        } else {
                                          print("Page Open");
                                          Navigator.push(context, PageTransition(
                                              duration: Duration(milliseconds: 120),
                                              type: PageTransitionType.rightToLeft, child: ChatPage(
                                              state: 0,
                                              uid: widget.uid,
                                              puid: docs[index].data()["members"]
                                              ["${widget.uid}"]
                                              ["peeruid"])));
                                        }
                                      }: null,
                                      contentPadding: EdgeInsets.only(
                                          left: 10, right: 10, top: 4, bottom: 4),
                                      leading: GestureDetector(
                                        onTap:(widget.isForward==false)?  () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (BuildContext context) {

                                                return AlertDialog(title:  ProfileDP(imgHero: heroImg, pername: peerN[name].toString()),titlePadding:
                                                  EdgeInsets.all(0),);
                                              },
                                              barrierColor: Colors.transparent);
                                          heroImg = docs[index].data()["members"][
                                          "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                                          ["pic"];
                                        }: null,
                                        child:
                                        Container(
                                          child: ((docs[index].data()["members"]["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]["pic"] == null)||  (blockedByList.contains(docs[index].data()["members"]["${widget.uid}"]["peeruid"])))
                                              ?  SvgPicture.asset(
                                            (widget.state == 0)
                                                ? "assets/invite_friends/profilepicture.svg"
                                                : "assets/invite_friends/profilepicture.svg",
                                            fit: BoxFit.cover,
                                            height: 50.h,
                                            width: 50.w,
                                          ):
                                          CachedNetworkImage(
                                            imageUrl: docs[index]
                                                .data()["members"][
                                            "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                                            ["pic"],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),

                                        ),
                                      ),
                                      title: SubstringHighlight(
                                        textStyleHighlight:TextStyle(color:Colors.black),
                                        caseSensitive     : false,
                                        text: (peerN[name].toString().contains('null'))?"Gatello User":(!peerN[name].toString().contains('null'))?peerN[name].toString():peerMob[name].toString(),
                                        textStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                color: Color.fromRGBO(0, 0, 0, 1),
                                                fontWeight: FontWeight.w700)),
                                        term: searchChat.text,
                                      ),
                                      subtitle: SubstringHighlight(
                                        textStyleHighlight:TextStyle(color:Colors.black),
                                        text: docs[index].data()["lastMessage"],
                                        textStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                color: Color.fromRGBO(12, 16, 29, 0.6),
                                                fontWeight: FontWeight.w400)),
                                        term: searchChat.text,
                                      ),
                                      trailing: (widget.state == null) ? Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Column(children: [
                                          InkWell(
                                            onTap: (){
                                              print('Lotus77${docs[index].data()}');
                                            },
                                            child: Text(
                                                readTimestamp(int.parse(docs[index]
                                                    .data()["timestamp"])),
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ),
                                          SizedBox(height: 3.h),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (docs[index].data()["members"][
                                              "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                                              ["mute"] ==
                                                  true)
                                                  ? Icon(
                                                  Icons.volume_off_outlined)
                                                  : SizedBox(),
                                              // docs[index].data()["members"]["$uid"]["unreadCount"].toString(),
                                              (docs[index].data()["members"]
                                              ["${widget.uid}"]
                                              ["unreadCount"] ==
                                                  0)
                                                  ? SizedBox()
                                                  : Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Color.fromRGBO(
                                                            255, 202, 40, 1),
                                                      ),
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(
                                                          255, 202, 40, 1)),
                                                  width: 22.w,
                                                  height: 22.h,
                                                  child: Center(
                                                    child: Text(
                                                        "${docs[index].data()["members"]["${widget.uid}"]["unreadCount"]}",
                                                        style:
                                                        GoogleFonts.inter(
                                                          textStyle: TextStyle(
                                                              fontSize: 11.sp,
                                                              color: Color
                                                                  .fromRGBO(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  1),
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                        )),
                                                  )),
                                            ],
                                          ),
                                        ]),
                                      ) : Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  onPrimary: Colors.black,
                                                  minimumSize: Size(60.w, 30.h),
                                                  primary: Color.fromRGBO(
                                                      248, 206, 97, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  )),
                                              onPressed: (widget.state == 0)
                                                  ? () async {
                                                print('Lotus1');
                                                // if (id.length == 28) {
                                                //   await writeUserShareMessage(type: 5, peerName: name, peerPic: pic, uid: uid!, puid: id);
                                                // } else {
                                                //   await writeGroupShareMessage(type: 5, groupName: name, groupPic: pic, members: members!, uid: uid!, puid: id);
                                                // }
                                                String storyUrl =
                                                    postDetailsUrl +
                                                        "?post_id=" +
                                                        widget.postId!;
                                                ShareableLink _shareableLink =
                                                ShareableLink(
                                                    widget.postTitle!,
                                                    widget
                                                        .postDescription!,
                                                    storyUrl,
                                                    (widget.postUrl!
                                                        .contains(
                                                        "mp4") ||
                                                        widget
                                                            .postUrl!
                                                            .contains(
                                                            "mpeg4"))
                                                        ? null
                                                        : widget.postUrl);
                                                Uri _link =
                                                await _shareableLink
                                                    .createDynamicLink(
                                                    short: false);
                                                if (id.length == 28) {
                                                  print('Lotus2');
                                                  await writeUserMessage(
                                                      type: 5,
                                                      peerName: peerN[name],
                                                      peerPic: pic,
                                                      uid: widget.uid,
                                                      puid: id,
                                                      state: 0,
                                                      forwardCount: 0,
                                                      storyContentType: widget
                                                          .storyContentType,
                                                      storyContentUrl:
                                                      widget.postUrl,
                                                      storyDescription: widget
                                                          .postDescription,
                                                      storyUrl:
                                                      _link.toString());
                                                } else {
                                                  print('Lotus3');
                                                  await writeGroupMessage(
                                                      type: 5,
                                                      groupName: name,
                                                      groupPic: pic,
                                                      members: members!,
                                                      uid: widget.uid,
                                                      puid: id,
                                                      forwardCount: 0,
                                                      state: 1,
                                                      storyContentType: widget
                                                          .storyContentType,
                                                      storyContentUrl:
                                                      widget.postUrl,
                                                      storyDescription: widget
                                                          .postDescription,
                                                      storyUrl:
                                                      _link.toString());
                                                }
                                              }
                                                  : () {
                                                widget.messages!.forEach(
                                                        (key, value) async {
                                                      print('Lotus5');
                                                      dev.log(key.toString());
                                                      String getUrl(int type) {
                                                        print('Lotus6');
                                                        switch (type) {
                                                          case 1:
                                                            return value.data()![
                                                            "data"]["image"];
                                                          case 2:
                                                            return value.data()![
                                                            "data"]["video"];
                                                          case 3:
                                                            return value.data()![
                                                            "data"]["audio"];
                                                          case 4:
                                                            return value.data()![
                                                            "data"]
                                                            ["document"];
                                                          default:
                                                            return "";
                                                        }
                                                      }
                                                      String? getMessage(
                                                          int type) {
                                                        print('Lotus7');
                                                        switch (type) {
                                                          case 0:
                                                            return value.data()![
                                                            "data"]["text"];
                                                          case 6:
                                                            return value.data()![
                                                            "data"]["gif"];
                                                          case 7:
                                                            return value.data()![
                                                            "data"]
                                                            ["location"];
                                                          case 8:
                                                            return value.data()![
                                                            "data"]
                                                            ["contact"];
                                                          default:
                                                            return null;
                                                        }
                                                      }

                                                      Uint8List? file =
                                                      await downloadToBytes(
                                                          getUrl(dataTypeMap
                                                              .inverse[
                                                          value.data()![
                                                          "type"]]!));
                                                      if (!selectedDocs
                                                          .contains(id)) {
                                                        selectedDocs.add(id);

                                                        if (id.length == 28) {
                                                          print('works');
                                                          await writeUserMessage(
                                                            type: dataTypeMap
                                                                .inverse[
                                                            value.data()![
                                                            "type"]]!,
                                                            peerName: peerN[name],
                                                            peerPic: pic,
                                                            uid: widget.uid,
                                                            puid: id,
                                                            state: 0,
                                                            forwardCount: value
                                                                .data()![
                                                            "forwardCount"],
                                                            message: getMessage(
                                                                dataTypeMap
                                                                    .inverse[value
                                                                    .data()![
                                                                "type"]]!),
                                                            file: file,
                                                            // replyMap: (value.data()!["reply"] != null) ? Map.from(value.data()!["reply"]) : null,
                                                            contentType: value
                                                                .data()![
                                                            "contentType"],
                                                            storyContentType: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? 0
                                                                : 1
                                                                : null,
                                                            storyContentUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? value.data()![
                                                            "data"]
                                                            ["image"]
                                                                : value.data()![
                                                            "data"]
                                                            ["video"]
                                                                : null,
                                                            storyDescription: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["text"]
                                                                : null,
                                                            storyUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["story"]
                                                                : null,
                                                          );
                                                        }
                                                        else if (selectedDocs
                                                            .contains(id)) {
                                                          print(
                                                              'Lotus77${selectedDocs}');
                                                          print('Lotus9');
                                                          await writeGroupMessage(
                                                            type: dataTypeMap
                                                                .inverse[
                                                            value.data()![
                                                            "type"]]!,
                                                            groupName: name,
                                                            groupPic: pic,
                                                            members: members!,
                                                            uid: widget.uid,
                                                            puid: id,
                                                            state: 1,
                                                            // replyMap: (value.data()!["reply"]!=null)?Map.from(value.data()!["reply"]):null,
                                                            forwardCount: value
                                                                .data()![
                                                            "forwardCount"],
                                                            message: getMessage(
                                                                dataTypeMap
                                                                    .inverse[value
                                                                    .data()![
                                                                "type"]]!),
                                                            file: file,
                                                            contentType: value
                                                                .data()![
                                                            "contentType"],
                                                            storyContentType: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? 0
                                                                : 1
                                                                : null,
                                                            storyContentUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? value.data()![
                                                            "data"]
                                                            ["image"]
                                                                : value.data()![
                                                            "data"]
                                                            ["video"]
                                                                : null,
                                                            storyDescription: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["text"]
                                                                : null,
                                                            storyUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["story"]
                                                                : null,
                                                          );
                                                        }
                                                      } else {
                                                        print(
                                                            'ffffffffffffffffffff');
                                                      }
                                                    });
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                                //     state: 0,
                                                //     uid: widget.uid,
                                                //     puid: docs[index].data()["members"]
                                                //     ["${widget.uid}"]["peeruid"])));
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'send',
                                                style: GoogleFonts.poppins(
                                                    textStyle:
                                                    textStyle(fontSize: 10)),
                                              )
                                          )
                                      )
                                  ));
                            }
                            if (peerN[name].toString().toLowerCase().contains(nameSearch.toLowerCase())) {
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: ListTile(
                                      selected: _isSelected[index],
                                      tileColor: Colors.white,
                                      selectedTileColor:
                                      Color.fromRGBO(248, 206, 97, 0.31),
                                      onLongPress:(widget.isForward==false)? () {
                                        setState(() {
                                          _isSelected[index] = !_isSelected[index];
                                          if (isFirstTime) {
                                            if (selectedItems!.isEmpty) {
                                              widget.callBack!();
                                              selectedItems!.add(index);
                                              isFirstTime = false;
                                              longPressedFlag = true;
                                            }
                                          } else {
                                            if (selectedItems!.contains(index)) {
                                              print("EXISTS So removing...");
                                              selectedItems!.remove(index);
                                              print("Selected$index");
                                              print("Selected items$selectedItems");
                                              if (selectedItems!.length == 0) {
                                                widget.callBack!();
                                              }
                                            } else {
                                              selectedItems!.add(index);
                                              print("Selected$index");
                                              print("Selected items$selectedItems");
                                              print("Long Press Triggers");
                                              longPressedFlag = true;
                                            }

                                            if (selectedItems!.isEmpty &&
                                                isFirstTime == false) {
                                              print("Deselect all");
                                              isFirstTime = true;
                                              longPressedFlag = false;
                                            }
                                          }
                                        });

                                        print('Lotus78${selectedItems?.length}');
                                        selectedItems?.length.toString();
                                      }:null,
                                      onTap:(widget.isForward==false)?  () {
                                        print("Long Press Flag:${longPressedFlag}");
                                        if (longPressedFlag) {
                                          setState(() {
                                            _isSelected[index] = !_isSelected[index];
                                            if (selectedItems!.isEmpty) {
                                              longPressedFlag = false;
                                            } else {
                                              print("Tapping...x");

                                              if (selectedItems!.contains(index)) {
                                                print("EXISTS So removing...");
                                                selectedItems!.remove(index);
                                                print("Selected$index");
                                                print("Selected items$selectedItems");
                                                if (selectedItems!.length == 0) {
                                                  widget.callBack!();
                                                }
                                              } else {
                                                selectedItems!.add(index);
                                                print("Selected$index");
                                                print("Selected items$selectedItems");
                                                print("Tap Triggers");
                                                longPressedFlag = true;
                                              }
                                            }
                                          });

                                          if (selectedItems!.isEmpty &&
                                              isFirstTime == false) {
                                            print("Deselect all");
                                            isFirstTime = true;
                                            longPressedFlag = false;
                                          }
                                        } else {
                                          print("Page Open");
                                          Navigator.push(context, PageTransition(
                                              duration: Duration(milliseconds: 120),
                                              type: PageTransitionType.rightToLeft, child: ChatPage(
                                              state: 0,
                                              uid: widget.uid,
                                              puid: docs[index].data()["members"]
                                              ["${widget.uid}"]
                                              ["peeruid"])));
                                        }
                                      }: null,
                                      contentPadding: EdgeInsets.only(
                                          left: 10, right: 10, top: 4, bottom: 4),
                                      leading: GestureDetector(
                                        onTap:(widget.isForward==false)?  () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(title:  ProfileDP(imgHero: heroImg, pername: peerN[name].toString()),titlePadding:
                                                EdgeInsets.all(0),);
                                              },
                                              barrierColor: Colors.transparent);
                                          heroImg = docs[index].data()["members"][
                                          "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                                          ["pic"];
                                        }: null,
                                        child:
                                        Container(
                                          child: ((docs[index].data()["members"]["${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]["pic"] == null)||  (blockedByList.contains(docs[index].data()["members"]["${widget.uid}"]["peeruid"])))
                                              ?  SvgPicture.asset(
                                            (widget.state == 0)
                                                ? "assets/invite_friends/profilepicture.svg"
                                                : "assets/invite_friends/profilepicture.svg",
                                            fit: BoxFit.cover,
                                            height: 50.h,
                                            width: 50.w,
                                          ):
                                          CachedNetworkImage(
                                            imageUrl: docs[index]
                                                .data()["members"][
                                            "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                                            ["pic"],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),

                                        ),
                                      ),
                                      title: SubstringHighlight(
                                        textStyleHighlight:TextStyle(color:Colors.black),
                                        caseSensitive     : false,
                                        text: (peerN[name].toString().contains('null'))?"Gatello User":(!peerN[name].toString().contains('null'))?peerN[name].toString():peerMob[name].toString(),
                                        textStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 16.sp,
                                                color: Color.fromRGBO(0, 0, 0, 1),
                                                fontWeight: FontWeight.w700)),
                                        term: searchChat.text,
                                      ),
                                      subtitle: SubstringHighlight(
                                        textStyleHighlight:TextStyle(color:Colors.black),
                                        text: docs[index].data()["lastMessage"],
                                        textStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                color: Color.fromRGBO(12, 16, 29, 0.6),
                                                fontWeight: FontWeight.w400)),
                                        term: searchChat.text,
                                      ),
                                      trailing: (widget.state == null) ? Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Column(children: [
                                          InkWell(
                                            onTap: (){
                                              print('Lotus77${docs[index].data()}');
                                            },
                                            child: Text(
                                                readTimestamp(int.parse(docs[index]
                                                    .data()["timestamp"])),
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ),
                                          SizedBox(height: 3.h),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (docs[index].data()["members"][
                                              "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]
                                              ["mute"] ==
                                                  true)
                                                  ? Icon(
                                                  Icons.volume_off_outlined)
                                                  : SizedBox(),
                                              // docs[index].data()["members"]["$uid"]["unreadCount"].toString(),
                                              (docs[index].data()["members"]
                                              ["${widget.uid}"]
                                              ["unreadCount"] ==
                                                  0)
                                                  ? SizedBox()
                                                  : Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Color.fromRGBO(
                                                            255, 202, 40, 1),
                                                      ),
                                                      shape: BoxShape.circle,
                                                      color: Color.fromRGBO(
                                                          255, 202, 40, 1)),
                                                  width: 22.w,
                                                  height: 22.h,
                                                  child: Center(
                                                    child: Text(
                                                        "${docs[index].data()["members"]["${widget.uid}"]["unreadCount"]}",
                                                        style:
                                                        GoogleFonts.inter(
                                                          textStyle: TextStyle(
                                                              fontSize: 11.sp,
                                                              color: Color
                                                                  .fromRGBO(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  1),
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                        )),
                                                  )),
                                            ],
                                          ),
                                        ]),
                                      ) : Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  onPrimary: Colors.black,
                                                  minimumSize: Size(60.w, 30.h),
                                                  primary: Color.fromRGBO(
                                                      248, 206, 97, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  )),
                                              onPressed: (widget.state == 0)
                                                  ? () async {
                                                print('Lotus1');
                                                // if (id.length == 28) {
                                                //   await writeUserShareMessage(type: 5, peerName: name, peerPic: pic, uid: uid!, puid: id);
                                                // } else {
                                                //   await writeGroupShareMessage(type: 5, groupName: name, groupPic: pic, members: members!, uid: uid!, puid: id);
                                                // }
                                                String storyUrl =
                                                    postDetailsUrl +
                                                        "?post_id=" +
                                                        widget.postId!;
                                                ShareableLink _shareableLink =
                                                ShareableLink(
                                                    widget.postTitle!,
                                                    widget
                                                        .postDescription!,
                                                    storyUrl,
                                                    (widget.postUrl!
                                                        .contains(
                                                        "mp4") ||
                                                        widget
                                                            .postUrl!
                                                            .contains(
                                                            "mpeg4"))
                                                        ? null
                                                        : widget.postUrl);
                                                Uri _link =
                                                await _shareableLink
                                                    .createDynamicLink(
                                                    short: false);
                                                if (id.length == 28) {
                                                  print('Lotus2');
                                                  await writeUserMessage(
                                                      type: 5,
                                                      peerName: peerN[name],
                                                      peerPic: pic,
                                                      uid: widget.uid,
                                                      puid: id,
                                                      state: 0,
                                                      forwardCount: 0,
                                                      storyContentType: widget
                                                          .storyContentType,
                                                      storyContentUrl:
                                                      widget.postUrl,
                                                      storyDescription: widget
                                                          .postDescription,
                                                      storyUrl:
                                                      _link.toString());
                                                } else {
                                                  print('Lotus3');
                                                  await writeGroupMessage(
                                                      type: 5,
                                                      groupName: name,
                                                      groupPic: pic,
                                                      members: members!,
                                                      uid: widget.uid,
                                                      puid: id,
                                                      forwardCount: 0,
                                                      state: 1,
                                                      storyContentType: widget
                                                          .storyContentType,
                                                      storyContentUrl:
                                                      widget.postUrl,
                                                      storyDescription: widget
                                                          .postDescription,
                                                      storyUrl:
                                                      _link.toString());
                                                }
                                              }
                                                  : () {
                                                widget.messages!.forEach(
                                                        (key, value) async {
                                                      print('Lotus5');
                                                      dev.log(key.toString());
                                                      String getUrl(int type) {
                                                        print('Lotus6');
                                                        switch (type) {
                                                          case 1:
                                                            return value.data()![
                                                            "data"]["image"];
                                                          case 2:
                                                            return value.data()![
                                                            "data"]["video"];
                                                          case 3:
                                                            return value.data()![
                                                            "data"]["audio"];
                                                          case 4:
                                                            return value.data()![
                                                            "data"]
                                                            ["document"];
                                                          default:
                                                            return "";
                                                        }
                                                      }
                                                      String? getMessage(
                                                          int type) {
                                                        print('Lotus7');
                                                        switch (type) {
                                                          case 0:
                                                            return value.data()![
                                                            "data"]["text"];
                                                          case 6:
                                                            return value.data()![
                                                            "data"]["gif"];
                                                          case 7:
                                                            return value.data()![
                                                            "data"]
                                                            ["location"];
                                                          case 8:
                                                            return value.data()![
                                                            "data"]
                                                            ["contact"];
                                                          default:
                                                            return null;
                                                        }
                                                      }

                                                      Uint8List? file =
                                                      await downloadToBytes(
                                                          getUrl(dataTypeMap
                                                              .inverse[
                                                          value.data()![
                                                          "type"]]!));
                                                      if (!selectedDocs
                                                          .contains(id)) {
                                                        selectedDocs.add(id);

                                                        if (id.length == 28) {
                                                          print('works');
                                                          await writeUserMessage(
                                                            type: dataTypeMap
                                                                .inverse[
                                                            value.data()![
                                                            "type"]]!,
                                                            peerName: peerN[name],
                                                            peerPic: pic,
                                                            uid: widget.uid,
                                                            puid: id,
                                                            state: 0,
                                                            forwardCount: value
                                                                .data()![
                                                            "forwardCount"],
                                                            message: getMessage(
                                                                dataTypeMap
                                                                    .inverse[value
                                                                    .data()![
                                                                "type"]]!),
                                                            file: file,
                                                            // replyMap: (value.data()!["reply"] != null) ? Map.from(value.data()!["reply"]) : null,
                                                            contentType: value
                                                                .data()![
                                                            "contentType"],
                                                            storyContentType: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? 0
                                                                : 1
                                                                : null,
                                                            storyContentUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? value.data()![
                                                            "data"]
                                                            ["image"]
                                                                : value.data()![
                                                            "data"]
                                                            ["video"]
                                                                : null,
                                                            storyDescription: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["text"]
                                                                : null,
                                                            storyUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["story"]
                                                                : null,
                                                          );
                                                        }
                                                        else if (selectedDocs
                                                            .contains(id)) {
                                                          print(
                                                              'Lotus77${selectedDocs}');
                                                          print('Lotus9');
                                                          await writeGroupMessage(
                                                            type: dataTypeMap
                                                                .inverse[
                                                            value.data()![
                                                            "type"]]!,
                                                            groupName: name,
                                                            groupPic: pic,
                                                            members: members!,
                                                            uid: widget.uid,
                                                            puid: id,
                                                            state: 1,
                                                            // replyMap: (value.data()!["reply"]!=null)?Map.from(value.data()!["reply"]):null,
                                                            forwardCount: value
                                                                .data()![
                                                            "forwardCount"],
                                                            message: getMessage(
                                                                dataTypeMap
                                                                    .inverse[value
                                                                    .data()![
                                                                "type"]]!),
                                                            file: file,
                                                            contentType: value
                                                                .data()![
                                                            "contentType"],
                                                            storyContentType: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? 0
                                                                : 1
                                                                : null,
                                                            storyContentUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? (value.data()![
                                                            "data"]
                                                            [
                                                            "image"] !=
                                                                null)
                                                                ? value.data()![
                                                            "data"]
                                                            ["image"]
                                                                : value.data()![
                                                            "data"]
                                                            ["video"]
                                                                : null,
                                                            storyDescription: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["text"]
                                                                : null,
                                                            storyUrl: (dataTypeMap
                                                                .inverse[value
                                                                .data()![
                                                            "type"]] ==
                                                                5)
                                                                ? value.data()![
                                                            "data"]
                                                            ["story"]
                                                                : null,
                                                          );
                                                        }
                                                      } else {
                                                        print(
                                                            'ffffffffffffffffffff');
                                                      }
                                                    });
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                                //     state: 0,
                                                //     uid: widget.uid,
                                                //     puid: docs[index].data()["members"]
                                                //     ["${widget.uid}"]["peeruid"])));
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'send',
                                                style: GoogleFonts.poppins(
                                                    textStyle:
                                                    textStyle(fontSize: 10)),
                                              )
                                          )
                                      )
                                  ));
                            }
                            return Container();
                          });
                    }
                  );
                }
              );
            }
            else if(chatRoomdetailsnap.connectionState == ConnectionState.waiting){
              return CircleIndicator();
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
          });
    }

    Widget personalGroupList(SizingInformation sizingInformation) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: instance.collection("group-detail").where("members.${widget.uid}.delete", isEqualTo: false).snapshots(),
          builder: (context, groupRoomDetailSnapshot) {
            if (groupRoomDetailSnapshot.connectionState ==
                ConnectionState.active &&
                groupRoomDetailSnapshot.hasData &&
                groupRoomDetailSnapshot.data != null &&
                groupRoomDetailSnapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                  groupRoomDetailSnapshot.data!.docs;
              docs.sort((b, a) => getDateTimeSinceEpoch(
                  datetime: a.data()["timestamp"])
                  .compareTo(
                  getDateTimeSinceEpoch(datetime: b.data()["timestamp"])));

              return ListView.builder(
                  itemCount: docs.length,

                  itemBuilder: (context, index1) {
                    if (!_isSelected1.containsKey(index1)) {
                      // important
                      _isSelected1[index1] = false;
                    }
                    var groupName = docs[index1].data()["title"];
                    // var name=docs[index].data()["title"];
                    var pic = docs[index1].data()["pic"];
                    var id = docs[index1].data()["gid"];
                    var members = docs[index1].data()["members"];

                    if (nameSearch.isEmpty) {
                      return ListTile(
                          selected: _isSelected1[index1],
                          tileColor: Colors.white,
                          selectedTileColor: Color.fromRGBO(248, 206, 97, 0.31),
                          onLongPress: () {
                            setState(() {
                              _isSelected1[index1] = !_isSelected1[index1];
                              if (isFirstTime1) {
                                if (selectedItems1!.isEmpty) {
                                  widget.callBack!();
                                  selectedItems1!.add(index1);
                                  isFirstTime1 = false;
                                  longPressedFlag1 = true;
                                }
                              } else {
                                if (selectedItems1!.contains(index1)) {
                                  print("EXISTS So removing...");
                                  selectedItems1!.remove(index1);
                                  print("Selected$index1");
                                  print("Selected items$selectedItems1");
                                  if (selectedItems1!.length == 0) {
                                    widget.callBack!();
                                  }
                                } else {
                                  selectedItems1!.add(index1);
                                  print("Selected$index1");
                                  print("Selected items$selectedItems1");
                                  print("Long Press Triggers");
                                  longPressedFlag1 = true;
                                }

                                if (selectedItems1!.isEmpty &&
                                    isFirstTime1 == false) {
                                  print("Deselect all");
                                  isFirstTime1 = true;
                                  longPressedFlag1 = false;
                                }
                              }
                            });
                          },
                          onTap: () {
                            print("Long Press Flag:${longPressedFlag1}");
                            if (longPressedFlag1) {
                              setState(() {
                                _isSelected1[index1] = !_isSelected1[index1];
                                if (selectedItems1!.isEmpty) {
                                  longPressedFlag1 = false;
                                } else {
                                  print("Tapping...x");

                                  if (selectedItems1!.contains(index1)) {
                                    print("EXISTS So removing...");
                                    selectedItems1!.remove(index1);
                                    print("Selected$index1");
                                    print("Selected items$selectedItems1");
                                    if (selectedItems1!.length == 0) {
                                      widget.callBack!();
                                    }
                                  } else {
                                    selectedItems1!.add(index1);
                                    print("Selected$index1");
                                    print("Selected items$selectedItems1");
                                    print("Tap Triggers");
                                    longPressedFlag1 = true;
                                  }
                                }
                              });

                              if (selectedItems1!.isEmpty &&
                                  isFirstTime1 == false) {
                                print("Deselect all");
                                isFirstTime1 = true;
                                longPressedFlag1 = false;
                              }
                            } else {
                              print("Page Open");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          state: 1,
                                          uid: widget.uid,
                                          puid: docs[index1].data()["gid"])));
                            }
                          },
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 4, bottom: 4),
                          //  contentPadding: EdgeInsets.all(10),
                          leading: GestureDetector(onTap:() {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(title:groupDp(grpimg: pic, grpname:groupName),titlePadding:
                                  EdgeInsets.all(0),);
                                },
                                barrierColor: Colors.transparent);
                          },
                            child: Container(
                              child: (docs[index1].data()["pic"] != null)
                                  ? CachedNetworkImage(
                                imageUrl:pic,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                                  : SvgPicture.asset(
                                (widget.state == 0)
                                    ? "assets/invite_friends/profilepicture.svg"
                                    : "assets/invite_friends/profilepicture.svg",
                                fit: BoxFit.cover,
                                height: 50.h,
                                width: 50.w,
                              ),
                            ),
                          ),


                          title: SubstringHighlight(
                            textStyleHighlight:TextStyle(color:Colors.black),
                            caseSensitive: false,
                            text: docs[index1].data()["title"],
                            textStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w700)),
                            term: searchChat.text,
                          ),
                          subtitle: SubstringHighlight(
                            textStyleHighlight:TextStyle(color:Colors.black),
                            text:(docs[index1].data()["lastMessage"]!=null)? docs[index1].data()["lastMessage"]:'',
                            textStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color.fromRGBO(12, 16, 29, 0.6),
                                    fontWeight: FontWeight.w400)),
                            term: searchChat.text,
                          ),
                          trailing: (widget.state == null)
                              ? Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Text(
                                    readTimestamp(int.parse(
                                        docs[index1].data()["timestamp"])),
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 10.sp,
                                          color:
                                          Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w400),
                                    )),
                                SizedBox(height: 3.h),

                                // docs[index].data()["members"]["$uid"]["unreadCount"].toString(),
                                (docs[index1].data()["members"]
                                ["${widget.uid}"]
                                ["unreadCount"] ==
                                    0)
                                    ? SizedBox()
                                    : Container(
                                    decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Color.fromRGBO(
                                              255, 202, 40, 1),
                                        ),
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(
                                            255, 202, 40, 1)),
                                    width: 22.w,
                                    height: 22.h,
                                    child: Center(
                                      child: Text(
                                          "${docs[index1].data()["members"]["${widget.uid}"]["unreadCount"]}",
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 11.sp,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1),
                                                fontWeight:
                                                FontWeight.w400),
                                          )),
                                    )),
                              ],
                            ),
                          )
                              : Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      onPrimary: Colors.black,
                                      minimumSize: Size(60.w, 30.h),
                                      primary:
                                      Color.fromRGBO(248, 206, 97, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      )),
                                  onPressed: (widget.state == 0)
                                      ? () async {
                                    print('Lotus1');
                                    // if (id.length == 28) {
                                    //   await writeUserShareMessage(type: 5, peerName: name, peerPic: pic, uid: uid!, puid: id);
                                    // } else {
                                    //   await writeGroupShareMessage(type: 5, groupName: name, groupPic: pic, members: members!, uid: uid!, puid: id);
                                    // }
                                    String storyUrl = postDetailsUrl +
                                        "?post_id=" +
                                        widget.postId!;

                                    ShareableLink _shareableLink =
                                    ShareableLink(
                                        widget.postTitle!,
                                        widget.postDescription!,
                                        storyUrl,
                                        (widget.postUrl!.contains(
                                            "mp4") ||
                                            widget.postUrl!
                                                .contains(
                                                "mpeg4"))
                                            ? null
                                            : widget.postUrl);
                                    Uri _link = await _shareableLink
                                        .createDynamicLink(
                                        short: false);
                                    if (id.length == 28) {
                                      print('Lotus2');
                                      await writeUserMessage(
                                          type: 5,
                                          peerName: groupName,
                                          peerPic: pic,
                                          uid: widget.uid,
                                          puid: id,
                                          state: 0,
                                          forwardCount: 0,
                                          storyContentType:
                                          widget.storyContentType,
                                          storyContentUrl:
                                          widget.postUrl,
                                          storyDescription:
                                          widget.postDescription,
                                          storyUrl: _link.toString());
                                    } else {
                                      print('Lotus3');
                                      await writeGroupMessage(
                                          type: 5,
                                          groupName: groupName,
                                          groupPic: pic,
                                          members: members!,
                                          uid: widget.uid,
                                          puid: id,
                                          forwardCount: 0,
                                          state: 1,
                                          storyContentType:
                                          widget.storyContentType,
                                          storyContentUrl:
                                          widget.postUrl,
                                          storyDescription:
                                          widget.postDescription,
                                          storyUrl: _link.toString());
                                    }
                                  }
                                      : () {
                                    widget.messages!
                                        .forEach((key, value) async {
                                      print('Lotus5');
                                      dev.log(key.toString());
                                      String getUrl(int type) {
                                        print('Lotus6');
                                        switch (type) {
                                          case 1:
                                            return value
                                                .data()!["data"]
                                            ["image"];
                                          case 2:
                                            return value
                                                .data()!["data"]
                                            ["video"];
                                          case 3:
                                            return value
                                                .data()!["data"]
                                            ["audio"];
                                          case 4:
                                            return value
                                                .data()!["data"]
                                            ["document"];
                                          default:
                                            return "";
                                        }
                                      }

                                      String? getMessage(int type) {
                                        print('Lotus7');
                                        switch (type) {
                                          case 0:
                                            return value
                                                .data()!["data"]
                                            ["text"];
                                          case 6:
                                            return value
                                                .data()!["data"]
                                            ["gif"];
                                          case 7:
                                            return value
                                                .data()!["data"]
                                            ["location"];
                                          case 8:
                                            return value
                                                .data()!["data"]
                                            ["contact"];
                                          default:
                                            return null;
                                        }
                                      }

                                      Uint8List? file =
                                      await downloadToBytes(
                                          getUrl(dataTypeMap
                                              .inverse[
                                          value.data()![
                                          "type"]]!));
                                      if (!selectedDocs
                                          .contains(id)) {
                                        selectedDocs.add(id);

                                        if (id.length == 28) {
                                          print('works');
                                          await writeUserMessage(
                                            type: dataTypeMap.inverse[
                                            value.data()![
                                            "type"]]!,
                                            peerName: groupName,
                                            peerPic: pic,
                                            uid: widget.uid,
                                            puid: id,
                                            state: 0,
                                            forwardCount:
                                            value.data()![
                                            "forwardCount"],
                                            message: getMessage(
                                                dataTypeMap.inverse[
                                                value.data()![
                                                "type"]]!),
                                            file: file,
                                            // replyMap: (value.data()!["reply"] != null) ? Map.from(value.data()!["reply"]) : null,
                                            contentType:
                                            value.data()![
                                            "contentType"],
                                            storyContentType: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? 0
                                                : 1
                                                : null,
                                            storyContentUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? value.data()![
                                            "data"]
                                            ["image"]
                                                : value.data()!
                                            ["video"]
                                                : null,
                                            storyDescription: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["text"]
                                                : null,
                                            storyUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["story"]
                                                : null,
                                          );
                                        }

                                        // setState(() {
                                        //   if(!selectedDocs.contains(id)){
                                        //     selectedDocs.add(id);
                                        //   }
                                        //   else{
                                        //     print("this already entered..................");
                                        //   }
                                        //   print('Lotus8:${selectedDocs}');
                                        //   });
                                        // setState(() {
                                        //   if(selectedDocs.contains(docs[index].toString())){
                                        //
                                        //
                                        //   }
                                        //   else{
                                        //     print('22222222222222');
                                        //     selectedDocs.add(docs[index].toString());
                                        //
                                        //   }
                                        // });
                                        // print('Lotus1:${selectedDocs.toString()}');

                                        else if (selectedDocs
                                            .contains(id)) {
                                          print(
                                              'Lotus77${selectedDocs}');
                                          print('Lotus9');
                                          await writeGroupMessage(
                                            type: dataTypeMap.inverse[
                                            value.data()![
                                            "type"]]!,
                                            groupName: groupName,
                                            groupPic: pic,
                                            members: members!,
                                            uid: widget.uid,
                                            puid: id,
                                            state: 1,
                                            // replyMap: (value.data()!["reply"]!=null)?Map.from(value.data()!["reply"]):null,
                                            forwardCount:
                                            value.data()![
                                            "forwardCount"],
                                            message: getMessage(
                                                dataTypeMap.inverse[
                                                value.data()![
                                                "type"]]!),
                                            file: file,
                                            contentType:
                                            value.data()![
                                            "contentType"],
                                            storyContentType: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? 0
                                                : 1
                                                : null,
                                            storyContentUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? value.data()![
                                            "data"]
                                            ["image"]
                                                : value.data()![
                                            "data"]
                                            ["video"]
                                                : null,
                                            storyDescription: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["text"]
                                                : null,
                                            storyUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["story"]
                                                : null,
                                          );
                                        }
                                      } else {
                                        print('ffffffffffffffffffff');
                                      }
                                    });
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => ChatPage(
                                    //             state: 1,
                                    //             uid: widget.uid,
                                    //             puid: docs[index1].data()["gid"])));
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'send',
                                    style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 10)),
                                  )
                              )));
                    }
                    if (groupName.toString().toLowerCase().startsWith(nameSearch.toLowerCase())) {
                      return ListTile(
                          selected: _isSelected1[index1],
                          tileColor: Colors.white,
                          selectedTileColor: Color.fromRGBO(248, 206, 97, 0.31),
                          onLongPress: () {
                            setState(() {
                              _isSelected1[index1] = !_isSelected1[index1];
                              if (isFirstTime1) {
                                if (selectedItems1!.isEmpty) {
                                  widget.callBack!();
                                  selectedItems1!.add(index1);
                                  isFirstTime1 = false;
                                  longPressedFlag1 = true;
                                }
                              } else {
                                if (selectedItems1!.contains(index1)) {
                                  print("EXISTS So removing...");
                                  selectedItems1!.remove(index1);
                                  print("Selected$index1");
                                  print("Selected items$selectedItems1");
                                  if (selectedItems1!.length == 0) {
                                    widget.callBack!();
                                  }
                                } else {
                                  selectedItems1!.add(index1);
                                  print("Selected$index1");
                                  print("Selected items$selectedItems1");
                                  print("Long Press Triggers");
                                  longPressedFlag1 = true;
                                }

                                if (selectedItems1!.isEmpty &&
                                    isFirstTime1 == false) {
                                  print("Deselect all");
                                  isFirstTime1 = true;
                                  longPressedFlag1 = false;
                                }
                              }
                            });
                          },
                          onTap: () {
                            print("Long Press Flag:${longPressedFlag1}");
                            if (longPressedFlag1) {
                              setState(() {
                                _isSelected1[index1] = !_isSelected1[index1];
                                if (selectedItems1!.isEmpty) {
                                  longPressedFlag1 = false;
                                } else {
                                  print("Tapping...x");

                                  if (selectedItems1!.contains(index1)) {
                                    print("EXISTS So removing...");
                                    selectedItems1!.remove(index1);
                                    print("Selected$index1");
                                    print("Selected items$selectedItems1");
                                    if (selectedItems1!.length == 0) {
                                      widget.callBack!();
                                    }
                                  } else {
                                    selectedItems1!.add(index1);
                                    print("Selected$index1");
                                    print("Selected items$selectedItems1");
                                    print("Tap Triggers");
                                    longPressedFlag1 = true;
                                  }
                                }
                              });

                              if (selectedItems1!.isEmpty &&
                                  isFirstTime1 == false) {
                                print("Deselect all");
                                isFirstTime1 = true;
                                longPressedFlag1 = false;
                              }
                            } else {
                              print("Page Open");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          state: 1,
                                          uid: widget.uid,
                                          puid: docs[index1].data()["gid"])));
                            }
                          },
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 4, bottom: 4),
                          //  contentPadding: EdgeInsets.all(10),
                          leading: GestureDetector(onTap:() {
                            print("group profile");
                          },
                            child: Container(
                              child: (docs[index1].data()["pic"] != null)
                                  ? CachedNetworkImage(
                                imageUrl: docs[index1].data()["pic"],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                                  : SvgPicture.asset(
                                (widget.state == 0)
                                    ? "assets/invite_friends/profilepicture.svg"
                                    : "assets/invite_friends/profilepicture.svg",
                                fit: BoxFit.cover,
                                height: 50.h,
                                width: 50.w,
                              ),
                            ),
                          ),
                          //  leading: CircleAvatar(
                          //    radius: 25.5.h,
                          //    backgroundImage: docs[index].data()["pic"],
                          //  ),

                          title: SubstringHighlight(
                            textStyleHighlight:TextStyle(color:Colors.black),
                            caseSensitive: false,
                            text: docs[index1].data()["title"],
                            textStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w700)),
                            term: searchChat.text,
                          ),
                          // subtitle: SubstringHighlight(
                          //   text: docs[index].data()["lastMessage"],
                          //   textStyle: GoogleFonts.inter(
                          //       textStyle: TextStyle(
                          //           fontSize: 14.sp,
                          //           color: Color.fromRGBO(12, 16, 29, 0.6),
                          //           fontWeight: FontWeight.w400)),
                          //   term: searchChat.text,
                          // ),
                          trailing: (widget.state == null)
                              ? Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Text(
                                    readTimestamp(int.parse(
                                        docs[index1].data()["timestamp"])),
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 10.sp,
                                          color:
                                          Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w400),
                                    )),
                                SizedBox(height: 3.h),

                                // docs[index1].data()["members"]["$uid"]["unreadCount"].toString(),
                                (docs[index1].data()["members"]
                                ["${widget.uid}"]
                                ["unreadCount"] ==
                                    0)
                                    ? SizedBox()
                                    : Container(
                                    decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Color.fromRGBO(
                                              255, 202, 40, 1),
                                        ),
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(
                                            255, 202, 40, 1)),
                                    width: 22.w,
                                    height: 22.h,
                                    child: Center(
                                      child: Text(
                                          "${docs[index1].data()["members"]["${widget.uid}"]["unreadCount"]}",
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 11.sp,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1),
                                                fontWeight:
                                                FontWeight.w400),
                                          )),
                                    )),
                              ],
                            ),
                          )
                              : Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      onPrimary: Colors.black,
                                      minimumSize: Size(60.w, 30.h),
                                      primary:
                                      Color.fromRGBO(248, 206, 97, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      )),
                                  onPressed: (widget.state == 0)
                                      ? () async {
                                    print('Lotus1');
                                    // if (id.length == 28) {
                                    //   await writeUserShareMessage(type: 5, peerName: name, peerPic: pic, uid: uid!, puid: id);
                                    // } else {
                                    //   await writeGroupShareMessage(type: 5, groupName: name, groupPic: pic, members: members!, uid: uid!, puid: id);
                                    // }
                                    String storyUrl = postDetailsUrl +
                                        "?post_id=" +
                                        widget.postId!;
                                    ShareableLink _shareableLink =
                                    ShareableLink(
                                        widget.postTitle!,
                                        widget.postDescription!,
                                        storyUrl,
                                        (widget.postUrl!.contains(
                                            "mp4") ||
                                            widget.postUrl!
                                                .contains(
                                                "mpeg4"))
                                            ? null
                                            : widget.postUrl);
                                    Uri _link = await _shareableLink
                                        .createDynamicLink(
                                        short: false);
                                    if (id.length == 28) {
                                      print('Lotus2');
                                      await writeUserMessage(
                                          type: 5,
                                          peerName: groupName,
                                          peerPic: pic,
                                          uid: widget.uid,
                                          puid: id,
                                          state: 0,
                                          forwardCount: 0,
                                          storyContentType:
                                          widget.storyContentType,
                                          storyContentUrl:
                                          widget.postUrl,
                                          storyDescription:
                                          widget.postDescription,
                                          storyUrl: _link.toString());
                                    } else {
                                      print('Lotus3');
                                      await writeGroupMessage(
                                          type: 5,
                                          groupName: groupName,
                                          groupPic: pic,
                                          members: members!,
                                          uid: widget.uid,
                                          puid: id,
                                          forwardCount: 0,
                                          state: 1,
                                          storyContentType:
                                          widget.storyContentType,
                                          storyContentUrl:
                                          widget.postUrl,
                                          storyDescription:
                                          widget.postDescription,
                                          storyUrl: _link.toString());
                                    }
                                  }
                                      : () {
                                    widget.messages!
                                        .forEach((key, value) async {
                                      print('Lotus5');
                                      dev.log(key.toString());
                                      String getUrl(int type) {
                                        print('Lotus6');
                                        switch (type) {
                                          case 1:
                                            return value
                                                .data()!["data"]
                                            ["image"];
                                          case 2:
                                            return value
                                                .data()!["data"]
                                            ["video"];
                                          case 3:
                                            return value
                                                .data()!["data"]
                                            ["audio"];
                                          case 4:
                                            return value
                                                .data()!["data"]
                                            ["document"];
                                          default:
                                            return "";
                                        }
                                      }

                                      String? getMessage(int type) {
                                        print('Lotus7');
                                        switch (type) {
                                          case 0:
                                            return value
                                                .data()!["data"]
                                            ["text"];
                                          case 6:
                                            return value
                                                .data()!["data"]
                                            ["gif"];
                                          case 7:
                                            return value
                                                .data()!["data"]
                                            ["location"];
                                          case 8:
                                            return value
                                                .data()!["data"]
                                            ["contact"];
                                          default:
                                            return null;
                                        }
                                      }

                                      Uint8List? file =
                                      await downloadToBytes(
                                          getUrl(dataTypeMap
                                              .inverse[
                                          value.data()![
                                          "type"]]!));
                                      if (!selectedDocs
                                          .contains(id)) {
                                        selectedDocs.add(id);

                                        if (id.length == 28) {
                                          print('works');
                                          await writeUserMessage(
                                            type: dataTypeMap.inverse[
                                            value.data()![
                                            "type"]]!,
                                            peerName: groupName,
                                            peerPic: pic,
                                            uid: widget.uid,
                                            puid: id,
                                            state: 0,
                                            forwardCount:
                                            value.data()![
                                            "forwardCount"],
                                            message: getMessage(
                                                dataTypeMap.inverse[
                                                value.data()![
                                                "type"]]!),
                                            file: file,
                                            // replyMap: (value.data()!["reply"] != null) ? Map.from(value.data()!["reply"]) : null,
                                            contentType:
                                            value.data()![
                                            "contentType"],
                                            storyContentType: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? 0
                                                : 1
                                                : null,
                                            storyContentUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? value.data()![
                                            "data"]
                                            ["image"]
                                                : value.data()![
                                            "data"]
                                            ["video"]
                                                : null,
                                            storyDescription: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["text"]
                                                : null,
                                            storyUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["story"]
                                                : null,
                                          );
                                        }

                                        // setState(() {
                                        //   if(!selectedDocs.contains(id)){
                                        //     selectedDocs.add(id);
                                        //   }
                                        //   else{
                                        //     print("this already entered..................");
                                        //   }
                                        //   print('Lotus8:${selectedDocs}');
                                        //   });
                                        // setState(() {
                                        //   if(selectedDocs.contains(docs[index].toString())){
                                        //
                                        //
                                        //   }
                                        //   else{
                                        //     print('22222222222222');
                                        //     selectedDocs.add(docs[index].toString());
                                        //
                                        //   }
                                        // });
                                        // print('Lotus1:${selectedDocs.toString()}');

                                        else if (selectedDocs
                                            .contains(id)) {
                                          print(
                                              'Lotus77${selectedDocs}');
                                          print('Lotus9');
                                          await writeGroupMessage(
                                            type: dataTypeMap.inverse[
                                            value.data()![
                                            "type"]]!,
                                            groupName: groupName,
                                            groupPic: pic,
                                            members: members!,
                                            uid: widget.uid,
                                            puid: id,
                                            state: 1,
                                            // replyMap: (value.data()!["reply"]!=null)?Map.from(value.data()!["reply"]):null,
                                            forwardCount:
                                            value.data()![
                                            "forwardCount"],
                                            message: getMessage(
                                                dataTypeMap.inverse[
                                                value.data()![
                                                "type"]]!),
                                            file: file,
                                            contentType:
                                            value.data()![
                                            "contentType"],
                                            storyContentType: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? 0
                                                : 1
                                                : null,
                                            storyContentUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? (value.data()![
                                            "data"]
                                            [
                                            "image"] !=
                                                null)
                                                ? value.data()![
                                            "data"]
                                            ["image"]
                                                : value.data()![
                                            "data"]
                                            ["video"]
                                                : null,
                                            storyDescription: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["text"]
                                                : null,
                                            storyUrl: (dataTypeMap
                                                .inverse[value
                                                .data()![
                                            "type"]] ==
                                                5)
                                                ? value.data()![
                                            "data"]["story"]
                                                : null,
                                          );
                                        }
                                      } else {
                                        print('ffffffffffffffffffff');
                                      }
                                    });

                                    // setState(() {
                                    //   onChange[];
                                    // });
                                    // print('L0tus66:${onChange}');
                                    //
                                    // setState(() {
                                    //   if(selectedDocs.contains(docs[index].toString())){
                                    //     print('11111111111${selectedDocs}');
                                    //
                                    //   }
                                    //   else{
                                    //     print('22222222222222');
                                    //     selectedDocs.add(docs[index].toString());
                                    //
                                    //   }
                                    // });
                                    // print('Lotus1:${selectedDocs.toString()}');
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                    //     state: 0,
                                    //     uid: widget.uid,
                                    //     puid: docs[index].data()["members"]
                                    //     ["${widget.uid}"]["peeruid"])));
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'send',
                                    style: GoogleFonts.poppins(
                                        textStyle: textStyle(fontSize: 10)),
                                  ))));
                    }
                    print('TEXTFIELD IS EMPTY');
                    return SizedBox();
                  }
              );
            } else {
              return Container(
                  child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            lottieAnimation(emptyChatLottie),
                            Text(
                                "Your shelves are empty ! \nCreate a group to start the conversation")
                          ],
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
                    constraints: BoxConstraints(
                        minHeight: kToolbarHeight,
                        maxHeight: 175.0,
                        maxWidth: 350.0),
                    child: Material(
                      color: (themedata.value.index == 0)
                          ? Color(white)
                          : Color(materialBlack),
                      child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: (themedata.value.index == 0)
                            ? Color(black)
                            : Color(white),
                        unselectedLabelColor: (themedata.value.index == 0)
                            ? Color(grey)
                            : Color(lightGrey),
                        indicatorColor: (themedata.value.index == 0)
                            ? Color(black)
                            : Color(white),
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
                                  : Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/pops_asset/back_button.svg',
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                ],
                              ),
                              elevation: 0,
                              title: (widget.state == null)
                                  ? null
                                  : Text(
                                  (widget.state == 0)
                                      ? "Share Post"
                                      : "Forward Message",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      (themedata.value.index == 0)
                                          ? Color(black)
                                          : Color(white))),
                              backgroundColor:
                              (themedata.value.index == 0)
                                  ? Color(lightGrey)
                                  : Color(materialBlack),
                              actions: (widget.state == null)
                                  ? [
                                (index == 1)
                                    ? IconButton(
                                    splashColor:
                                    Colors.transparent,
                                    highlightColor:
                                    Colors.transparent,
                                    hoverColor:
                                    Colors.transparent,
                                    onPressed: () async {
                                      if (sizingInformation
                                          .deviceScreenType ==
                                          DeviceScreenType
                                              .desktop) {
                                        return await scaffoldAlertDialogBox(
                                            context: context,
                                            page: SearchPage(
                                              state: 4,
                                              sizingInformation:
                                              sizingInformation,
                                            ));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    SearchPage(
                                                      sizingInformation:
                                                      sizingInformation,
                                                      state:
                                                      4,
                                                    )));
                                      }
                                    },
                                    icon: Icon(Icons.add))
                                    : Container(),
                              ]
                                  : null,
                            ),
                            floatingActionButton: Column(
                              children: [
                                FloatingActionButton(
                                    child: Text("Select all"),
                                    onPressed: () {
                                      longPressedFlag1 = true;
                                      for (int i = 0;
                                      i < docs.length;
                                      i++) {
                                        selectedItems1!.add(i);
                                        print("Document Data... ${i}");
                                        print(
                                            "Document Data... ${selectedItems1}");
                                      }
                                    }),
                                FloatingActionButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      for (int i = 0;
                                      i < selectedItems1!.length;
                                      i++) {
                                        var sell = instance
                                            .collection(
                                            "personal-chat-room-detail")
                                            .doc(
                                            "${docs[selectedItems1![i]].id}");
                                        print(
                                            "${docs[selectedItems1![i]].id}");
                                        sell.update({
                                          "members.${widget.uid}.delete":
                                          true
                                        });
                                        //selectedItems!.remove;

                                      }
                                      selectedItems1 = [];

                                      print(docs[index].data()["members"][
                                      "${docs[index].data()["members"]["${widget.uid}"]["peeruid"]}"]);

                                      print("Uid is a $puid");
                                      //print("this is select index $sell");
                                    }),
                                FloatingActionButton(
                                    onPressed: () async {
                                      if (sizingInformation
                                          .deviceScreenType ==
                                          DeviceScreenType.desktop) {
                                        return await scaffoldAlertDialogBox(
                                            context: context,
                                            page: SearchPage(
                                              state: 0,
                                              sizingInformation:
                                              sizingInformation,
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
                                                builder: (context) =>
                                                    SearchPage(
                                                      state: 0,
                                                      sizingInformation:
                                                      sizingInformation,
                                                    )));
                                      }
                                    },
                                    backgroundColor:
                                    Color.fromRGBO(248, 206, 97, 1),
                                    child: SvgPicture.asset(
                                        "assets/icons_assets/chat_icon_floating.svg")),
                              ],
                            ),
                            body: TabBarView(
                                controller: tabController,
                                children: [
                                  getChatList(sizingInformation),
                                  personalGroupList(sizingInformation)
                                ]),
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
                            backgroundColor:
                            (themedata.value.index == 0)
                                ? Color(white)
                                : Color(materialBlack),
                            body: Center(
                              child: Text(
                                  "Select a chat to start chatting"),
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
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/pops_asset/back_button.svg',
                      height: 35,
                      width: 35),
                ],
              ),
            ),
            title: Text(
                (widget.state == 0)
                    ? "Share Post"
                    : "Forward Messages",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white)
                )
            ),
          ),
          floatingActionButton: (widget.state == null)
              ? (index == 0)
              ? FloatingActionButton(
              onPressed: () async {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return await scaffoldAlertDialogBox(
                      context: context,
                      page: SearchPage(
                        state: 4,
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
                            sizingInformation:
                            sizingInformation,
                          )));
                }
              },
              backgroundColor: Color.fromRGBO(248, 206, 97, 1),
              child: SvgPicture.asset(
                  "assets/icons_assets/chat_icon_floating.svg"))
              : FloatingActionButton(
              onPressed: () async {
                print("index is ${index}");
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
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
                            sizingInformation:
                            sizingInformation,
                            state: 4,
                          )));
                }
              },
              backgroundColor: Color.fromRGBO(248, 206, 97, 1),
              child: SvgPicture.asset(
                  "assets/icons_assets/chat_icon_floating.svg"))
              : null,
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                widget.search == "empty" ? searchBar() : SizedBox(),
                Container(
                  constraints: BoxConstraints(maxHeight: 150.0),
                  child: Material(
                    color: (themedata.value.index == 0)
                        ? Color(white)
                        : Color(materialBlack),
                    child: TabBar(
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white),
                      tabs: tabs,
                    ),
                  ),
                ),
                Expanded(
                    child: TabBarView(
                        controller: tabController,
                        children: [
                          getChatList(sizingInformation),
                          personalGroupList(sizingInformation)
                        ])),
              ],
            ),
          ),
        );
      }),
    ) ;

  }

  Future readData() async {
    print("Reading");
    // await db.collection("personal-chat-room-detail").get().then((event) {
    await instance
        .collection("personal-chat-room-detail")
        .where("members.${widget.uid}.isblocked")
        .get()
        .then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

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
      taskSnapshot = await Write(uid: widget.uid).personalChat(
          roomId: roomid,
          file: file,
          fileName: timestamp,
          contentType: contentType);
          url = await taskSnapshot.ref.getDownloadURL();
    } else if ((type == 6 || type == 7 || type == 8) && message != null) {
      url = message;
    }
    dev.log(url.toString());
    WriteBatch writeBatch = instance.batch();
    try {
      DocumentSnapshot<Map<String, dynamic>> personalChatRoomDoc =
      await instance
          .collection("personal-chat-room-detail")
          .doc(roomid)
          .get();
      if (personalChatRoomDoc.exists) {
        writeBatch.set(
            instance
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
                  ? dataMap(
                  index: type,
                  data: (type == 0) ? message! : url.toString())
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
            instance.collection("personal-chat-room-detail").doc(roomid), {
          "timestamp": timestamp,
          "messageBy": "${uid}",
          "lastMessage": (type == 0) ? message.toString() : dataTypeMap[type],
          "delete": false,
          "members.${puid}.unreadCount": FieldValue.increment(1),
        });
        writeBatch.commit();
        DocumentSnapshot<Map<String, dynamic>> peerDocSnap =
        await instance.collection("user-detail").doc(puid).get();
        DocumentSnapshot<Map<String, dynamic>> userDocSnap =
        await instance.collection("user-detail").doc(uid).get();
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
      }
      else {
        Future<DocumentSnapshot<Map<String, dynamic>>> userDetail =
        instance.collection("user-detail").doc(uid).get();
        await userDetail.then((value) async {
          if (value.exists && value.data() != null) {
            writeBatch.set(
                instance.collection("personal-chat-room-detail").doc(roomid), {
              "roomId": roomid,
              "timestamp": timestamp,
              "lastMessage":
              (type == 0) ? message.toString() : dataTypeMap[type],
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
                instance
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
                      index: type,
                      data:
                      (type == 0) ? message.toString() : url.toString())
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
            await instance.collection("user-detail").doc(puid).get();
            DocumentSnapshot<Map<String, dynamic>> userDocSnap =
            await instance.collection("user-detail").doc(uid).get();
            if (peerDocSnap.data()!["chattingWith"] != uid &&
                peerDocSnap["token"] != null) {
              return await sendNotificationForChat(
                  userTokens: [peerDocSnap["token"]],
                  name: userDocSnap["name"],
                  message:
                  (type == 0) ? message.toString() : dataTypeMap[type]!,
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
      taskSnapshot = await Write(uid: widget.uid).groupChat(
          guid: puid,
          file: file,
          fileName: timestamp,
          contentType: contentType);
      url = await taskSnapshot.ref.getDownloadURL();
    } else if ((type == 6 || type == 7 || type == 8) && message != null) {
      url = message;
    }
    WriteBatch writeBatch = instance.batch();
    try {
      writeBatch.set(
          instance
              .collection("group-chat")
              .doc(puid)
              .collection("messages")
              .doc(timestamp),
          {
            "from": uid,
            "timestamp": timestamp,
            "type": dataTypeMap[type],
            "data": (type != 5)
                ? dataMap(
                index: type,
                data: (type == 0) ? message.toString() : url.toString())
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
          instance.collection("group-detail").doc(puid),
          {
            "timestamp": timestamp,
            "messageBy": "${uid}",
            "lastMessage": (type == 0) ? message.toString() : dataTypeMap[type],
            "delete": false,
            "members": groupWriteMessageMembersMap(members: members, uid: widget.uid),
          },
          SetOptions(merge: true));
      writeBatch.commit();
      DocumentSnapshot<Map<String, dynamic>> userDocSnap =
      await instance.collection("user-detail").doc(uid).get();
      List<String> userToken = [];
      members.forEach((key, value) async {
        DocumentSnapshot<Map<String, dynamic>> peerDocSnap =
        await instance.collection("user-detail").doc(key).get();
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

  Future readChat() async {
    final db = FirebaseFirestore.instance;
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
    var format = new DateFormat('HH:mm');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
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

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      height: 40.h,
      width: 320.w,
      child: TextField(
        autofocus: true,
        cursorColor: Colors.black,
        cursorHeight: 20.h,
        controller: searchChat,
        decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(232, 232, 232, 1),
            hintText: 'Search...',
            contentPadding: EdgeInsets.only(top: 10.h),
            hintStyle: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Colors.black)),
            prefixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/tabbar_icons/Tabbar_search.svg'),
              ],
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                icon: Icon(Icons.close, color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent))),
        onChanged: (value) {
          setState(() {
            nameSearch = value;
          });
        },
      ),
    );
  }

  Widget groupDp({required var grpimg, required var grpname}){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Container( height:40.h,width:double.infinity,color:Color.fromRGBO(0, 0, 0, 0.20),
              padding:  EdgeInsets.only(left:25.w,top: 10.h),
              child: Text(grpname)),
          GestureDetector(onTap:() => print("peername : ${peerName}"),
            child: Center(
                child: GestureDetector(onTap:() {
                 Navigator.push(context,MaterialPageRoute(builder:(context) =>
                   dppreviewGroup(grpimg:grpimg, grpname: grpname)));
                },
                  child : Container(
                    child: (grpimg != null)?
                    CachedNetworkImage(fit:BoxFit.cover,
                      imageUrl: grpimg,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity.w,
                        height: 240.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ) : SvgPicture.asset(
                      "assets/invite_friends/profilepicture.svg",
                      fit: BoxFit.cover,
                      width: 200.w,
                      height: 200.h,
                    ),
                  ),
                )),
          ),
          Container(padding:EdgeInsets.symmetric(horizontal:65.w),
            height: 40.h,
            color: Colors.white,
            width: 300.w,
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              state: 0,
                              uid: widget.uid,
                              puid: docs[index].data()["members"]
                              ["${widget.uid}"]["peeruid"])));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      "assets/tabbar_icons/pings_icon.svg",
                    ),
                    Text(
                      "Pings",
                      style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400)),
                    )
                  ],
                ),
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.info_outlined,size:20),
                  Text(
                    "Info",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400)),
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget ProfileDP({
    required var imgHero,
    required var pername,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Container( height:40.h,width:double.infinity,color:Color.fromRGBO(0, 0, 0, 0.20),
              padding:  EdgeInsets.only(left:25.w,top: 10.h),
            // child: Text(peerN[name].toString())

          ),
          GestureDetector(onTap:() => print("peername : ${peerName}"),
            child: Center(
                child: Hero(
                  tag: "my image",
                  child: GestureDetector(onTap:() {
                   print("imgHero : ${imgHero}");
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>dpPreview(imgHero: imgHero)));
                  },
                   child : Container(color:Colors.yellow,
                      child: (imgHero != null)?
                         CachedNetworkImage(
                        imageUrl: imgHero,
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity.w,
                          height: 240.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill),
                            ),
                        ),
                        placeholder: (context, url) =>
                              CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ) : SvgPicture.asset(
                        "assets/invite_friends/profilepicture.svg",
                        fit: BoxFit.cover,
                        width: 200.w,
                        height: 200.h,
                      ),
                    ),
                  ),
                )),
          ),
          Container(padding:EdgeInsets.symmetric(horizontal:65.w),
            height: 40.h,
            color: Colors.white,
            width: 300.w,
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              state: 0,
                              uid: widget.uid,
                              puid: docs[index].data()["members"]
                              ["${widget.uid}"]["peeruid"])));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      "assets/tabbar_icons/pings_icon.svg",
                    ),
                    Text(
                      "Pings",
                      style: GoogleFonts.fredoka(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400)),
                    )
                  ],
                ),
              ),
           Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
             Icon(Icons.info_outlined,size:20),
                  Text(
                    "Info",
                    style: GoogleFonts.fredoka(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400)),
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }

  dpPreview({required var imgHero}){
   return SafeArea(
     child: Scaffold(backgroundColor:Colors.black,
      body:
      Column(
        children: [
          SizedBox(height:10.h,),
          Row(children: [
            SizedBox(width:13.w),
            GestureDetector(onTap:() {
              Navigator.pop(context);
            },
              child: SvgPicture.asset(
                  'assets/pops_asset/back_button.svg',color:Colors.white,
                  height: 35,
                  width: 35),
            ),
            SizedBox(width:20.w),
            Text( peerN[name].toString(), style:
            GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight:
                  FontWeight.w400,
                  color:Colors.white
                )))
          ]),
          SizedBox(height:180.h,),
        Container(color:Colors.yellow,
          child: (imgHero != null)?
          CachedNetworkImage(
            imageUrl: imgHero,
            imageBuilder: (context, imageProvider) => Container(
              width: double.infinity.w,
              height: 350.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) =>
                CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ) : SvgPicture.asset(
            "assets/invite_friends/profilepicture.svg",
            fit: BoxFit.cover,
            width: 200.w,
            height: 200.h,
          ),
        )
      ],)

         ),
   );
  }
  dppreviewGroup({required var grpimg,required var grpname}){
    return SafeArea(
      child: Scaffold(backgroundColor:Colors.black,
          body:
          Column(
            children: [
              SizedBox(height:10.h,),
              Row(children: [
                SizedBox(width:13.w),
                GestureDetector(onTap:() {
                  Navigator.pop(context);
                },
                  child: SvgPicture.asset(
                      'assets/pops_asset/back_button.svg',color:Colors.white,
                      height: 35,
                      width: 35),
                ),
                SizedBox(width:20.w),
                Text(grpname, style:
                GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight:
                        FontWeight.w400,
                        color:Colors.white
                    )))
              ]),
              SizedBox(height:180.h,),
              Container(color:Colors.yellow,
                child: (grpimg != null)?
                CachedNetworkImage(
                  imageUrl: grpimg,
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity.w,
                    height: 350.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ) : SvgPicture.asset(
                  "assets/invite_friends/profilepicture.svg",
                  fit: BoxFit.cover,
                  width: 200.w,
                  height: 200.h,
                ),
              )
            ],)

      ),
    );
  }
}
