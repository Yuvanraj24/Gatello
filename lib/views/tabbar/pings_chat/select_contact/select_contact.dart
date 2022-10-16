import 'dart:async';
import 'dart:collection';
import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/tabbar/test_code/UserDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../../../../Firebase/FirebaseNotifications.dart';
import '../../../../Firebase/Writes.dart';
import '../../../../Others/Structure.dart';
import '../../../../Others/components/LottieComposition.dart';
import '../../../../Others/lottie_strings.dart';
import '../../../../Style/Colors.dart';
import '../../../../Style/Text.dart';
import '../../../../components/ScaffoldDialog.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/TextField.dart';
import '../../../../main.dart';
import '../../../database_data.dart';
import '../../../invitefriends.dart';
import '../../../profile/user_proflle.dart';
import '../../chats/group_personal_screen/test_code2/CreateGroup.dart';
import '../../chats/personal_chat_screen/ChatPage.dart';
class SearchPage extends StatefulWidget {
  //state ==1 is not possible..
  ///* 0->personal chat,1->group chat,
  ///2->personal call
  ///,3->group call,
  ///4->create group,
  ///5->add group participants,
  ///6->story search,
  ///7->add call participants
  final int state;
  final SizingInformation sizingInformation;
  final String? gid;
  final List<String>? participants;
  final bool video;
  final String? channelName;
  const SearchPage({Key? key, required this.state,required  this.sizingInformation,
    this.gid, this.participants, this.video = false, this.channelName}) : super(key: key);
  @override

  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {

  DatabaseUpdate dbUpdate = new DatabaseUpdate();

  List mergeUserContact = [];
  bool _isRequesting = false;
  bool _isFinish = false;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextEditingController = TextEditingController();
  TextEditingController searchController= TextEditingController();
  TextEditingController searchContactcontroller= TextEditingController();
  Timer? _debounce;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
  List fBPhone=[];
  bool isLoading = false;
  List contactsAll=[];
  List<Contact> contacts = [];
  List contacts1 = [];
  List contacts2 = [];
  List<String> contactNames = [];
  bool searching=false;
  int conLen=0;
  List con2 = [];
  List conNames2 = [];

  //Map merge = ();
  List test1=[1,2];
  List test2=[3,4];

  Map <String,String> conMap=Map();

  List conNames=[];
  List conId=[];
  String nameSearch= '';
  List searchConNames=[];
  List searchConId=[];
  List searchConPhones=[];


  // var test3=List.from(test1)..addAll(test2);
  // final List<int> c = List.from(body)..addAll(test2);
  // newList = [...test1, ...test2].toSet().toList();
  // var totalList=body+contacts!;

  List<Map<String, dynamic>> groupMemberList = [];

  List<String> selectedContactsId = [];
  List selectedContacts = [];
  late Future<List<Contact>> _contacts;

  List <Contact> filteredContacts=[];
  var listData;

  // List<String> groupMemberList = [];
  String? uid;
  List<String> memberList = [];

  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    uid = sharedPrefs.getString("userid").toString();
    print("ShardPref ${uid}");
  }
  filterContacts(){
    List<Contact> _contact=[];
    _contact.addAll(contacts);
    if ( searchContactcontroller.text.isNotEmpty){
      _contact.retainWhere( (contact){
        String searchTerm = searchContactcontroller.text.toLowerCase();
        String contactName = searchContactcontroller.text.toLowerCase();
        return contactName.contains(searchTerm);
      });
      setState(() {
        filteredContacts=_contact;
        for(var i=0; i<filteredContacts.length; i++){
          print("vanthuru :${filteredContacts[i].displayName}");
          listData = filteredContacts[i].displayName;
        }
      });
    }
    print("SIZE: ${listData.length}");
    print("SIZE: ${listData}");
  }

  @override
  void initState() {
    _getUID();
    userChatList(searchQuery: searchTextEditingController.text);
    _contacts = getContacts();
    searchContactcontroller.addListener(() {
      filterContacts();
    });
    dbUpdate.initDB();
    super.initState();
  }
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

  @override
  void dispose() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
    searchTextEditingController.dispose();
    searchContactcontroller.dispose();
    super.dispose();
  }
  Future newParticipantSearch({required String searchQuery, int limit = 50}) async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      _isRequesting = true;
      //* as per firestore "You can't order your query by a field included in an equality (==) or in clause."
      //* so i think we can use orderby to sort by name
      if (body.isEmpty) {
        querySnapshot = await instance
            .collection("user-detail")
            .where("name", isGreaterThanOrEqualTo: searchQuery)
            .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .orderBy("name")
            .limit(limit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("user-detail")
            .where("name", isGreaterThanOrEqualTo: searchQuery)
            .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .orderBy("name")
            .startAfterDocument(body[body.length - 1])
            .limit(limit)
            .get();
      }
      if (querySnapshot != null && querySnapshot.docs.first.id != body.last.id) {
        if (!mounted) return;
        setState(() {
          body.addAll(querySnapshot.docs);
        });
        if (querySnapshot.docs.length < limit) {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
  //FIXME.. only user can search accepted group
  Future groupChatList({required String searchQuery, int limit = 50}) async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      _isRequesting = true;
      if (body.isEmpty) {
        querySnapshot = await instance

            .collection("group-detail")
            .where("title", isGreaterThanOrEqualTo: searchQuery)
            .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .orderBy("title")
            .limit(limit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("group-detail")
            .where("title", isGreaterThanOrEqualTo: searchQuery)
            .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .orderBy("title")
            .startAfterDocument(body[body.length - 1])
            .limit(limit)
            .get();
      }
      if (querySnapshot != null) {
        if (!mounted) return;
        setState(() {
          body.addAll(querySnapshot.docs);
        });
        if (querySnapshot.docs.length < limit) {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
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
          // // body.addAll(querySnapshot.docs);

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

  @override
  Widget build(BuildContext context) {

    bool isSearching = searchContactcontroller.text.isNotEmpty;
    // Contact contact = isSearching==true? filteredContacts.elementAt():contacts.elementAt(1);
    //  print('Lotus77${filteredContacts.elementAt(1)}');
    return SafeArea(
      child: FutureBuilder(
          future: _getUID(),
          builder: (context, _) {
            return ResponsiveBuilder(builder: (context, sizingInformation) {
              //    print('Lotus6${filteredContacts.elementAt(0).phones}');


              return Scaffold(
                resizeToAvoidBottomInset: false,
                floatingActionButton: (widget.state == 4 || widget.state == 5)
                    ? FloatingActionButton(
                  onPressed: () async {
                    if (groupMemberList.isNotEmpty && memberList.isNotEmpty) {
                      if (widget.state == 4) {
                        if (sizingInformation.deviceScreenType ==
                            DeviceScreenType.desktop) {
                          return await scaffoldAlertDialogBox(context: context,
                              page: CreateGroup(members: groupMemberList, uid: uid.toString(),));
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  CreateGroup(members: groupMemberList,uid: uid.toString())));
                        }
                      } else if (widget.state == 5) {
                        WriteBatch writeBatch = instance.batch();
                        writeBatch.set(
                            instance.collection("group-detail").doc(widget.gid),
                            {
                              "members": addGroupMembersMap(
                                  members: groupMemberList),
                              // "membersList": FieldValue.arrayUnion(groupMemberList),
                            },
                            SetOptions(merge: true));
                        // for (String uid in groupMemberList) {
                        //   writeBatch.set(
                        //       instance.collection("personal-group-list").doc(uid),
                        //       {
                        //         "groupList": FieldValue.arrayUnion([widget.gid])
                        //       },
                        //       SetOptions(merge: true));
                        // }
                        writeBatch.commit();
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Icon(Icons.done),
                )
                    : FloatingActionButton(
                  backgroundColor: Color.fromRGBO(248, 206, 97, 1) ,
                  onPressed: () {

                  },
                  child: SvgPicture.asset(
                    'assets/select_contact/right_arrow.svg',height:21.h,width:21.w,
                  ),
                ),
                // appBar:AppBar(
                //   centerTitle: false,
                //   automaticallyImplyLeading: false,
                //   elevation: 0,
                //   leading: GestureDetector(
                //       onTap:(){
                //         Navigator.pop(context);
                //       },
                //       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment:CrossAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset('assets/pops_asset/back_button.svg',height:35.h,
                //             width:35.w,),
                //         ],
                //       )),
                //   actions:
                //   [
                //     GestureDetector(onTap: () {
                //       setState(() {
                //         searching=true;
                //         print('yeah');
                //       });
                //     },
                //       child: SvgPicture.asset(
                //         'assets/tabbar_icons/Tabbar_search.svg',height:21.h,width:21.w,
                //       ),
                //     ),
                //     SizedBox(width:22.w),
                //     PopupMenuButton(
                //         icon:Icon(Icons.more_vert_rounded,color:Colors.black),
                //         iconSize:30,
                //         onSelected: (value) {
                //           switch (value) {
                //             case 1:
                //               {
                //                 Navigator.push(context, MaterialPageRoute(
                //                     builder: (context) =>
                //                         InviteFriends(state: 0)));
                //               }
                //               break;
                //             default:
                //           }
                //         },
                //         itemBuilder: (context) =>
                //         [
                //           PopupMenuItem(
                //             child: Text("Refresh",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                //                 fontSize:12.sp,color:Colors.black))),
                //
                //             value: 1,
                //           ),PopupMenuItem(child:Text("Help",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                //             fontSize:12.sp,color:Colors.black))))
                //         ])
                //   ],
                //   title: Column(crossAxisAlignment:CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         (widget.state == 0)
                //             ? "Select contact"
                //         // : (widget.state == 1)
                //         //     ? "Search Group Name"
                //         //     : (widget.state == 4)
                //         //     ? (memberList.isEmpty)
                //         //     ? "Select contact"
                //         //     : "${memberList.length}/49 Selected"
                //         //     : (widget.state == 5)
                //         //     ? "${memberList.length +
                //         //     widget.participants!.length}/50 Selected"
                //         //     : (widget.state == 6)
                //         //     ? "Search Account"
                //         //     : (widget.state == 7)
                //         //     ? "Search Participant"
                //             : "",
                //         style: GoogleFonts.inter(textStyle:TextStyle(
                //             fontSize: 16.sp, fontWeight: FontWeight.w400,color:Colors.black)),
                //       ),
                //       SizedBox(height:2.h),
                //       Text('${conLen} contacts',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                //           fontSize:12.sp,color:Colors.black)),)
                //     ],
                //   ),
                // ),
                body: NestedScrollView(
                  controller: scrollController,
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (BuildContext context,
                      bool innerBoxIsScrolled) {
                    return <Widget>[];
                  },
                  body: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if ((isLoading == false &&
                            notification.metrics.axisDirection ==
                                AxisDirection.down &&
                            notification.metrics.pixels ==
                                notification.metrics.maxScrollExtent) ==
                            true) {
                          if (!mounted) return false;
                          setState(() {
                            isLoading = true;
                          });
                          // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
                          this.userChatList(
                              searchQuery: searchTextEditingController.text);
                          if (!mounted) return false;
                          setState(() {
                            isLoading = false;
                          });
                        }
                        print("constat:${con2.isNotEmpty}");
                        return true;
                      },
                      child: (con2.isNotEmpty)
                          ? Column(children: [
                        Container(height:50.h,width:double.infinity.w,color:Color.fromRGBO(248, 206, 97, 1),
                          child:searching==false? Row(
                              children: [
                                SizedBox(width:22.w),
                                GestureDetector(
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
                                SizedBox(width:21.w),
                                Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:
                                CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (widget.state == 0)
                                          ? "Select contact"
                                          : (widget.state == 1)
                                          ? "Search Group Name"
                                          : (widget.state == 4)
                                          ? (memberList.isEmpty)
                                          ? "Select contact"
                                          : "${memberList.length}/49 Selected"
                                          : (widget.state == 5)
                                          ? "${memberList.length +
                                          widget.participants!.length}/50 Selected"
                                          : (widget.state == 6)
                                          ? "Search Account"
                                          : (widget.state == 7)
                                          ? "Search Participant"
                                          : "",
                                      style: GoogleFonts.inter(textStyle:TextStyle(
                                          fontSize: 16.sp, fontWeight: FontWeight.w400,color:Colors.black)),
                                    ),
                                    SizedBox(height:2.h),
                                    Text('${conLen} contacts',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                        fontSize:12.sp,color:Colors.black)),)
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(onTap: () {
                                  setState(() {
                                    searching=true;
                                    print('yeah');
                                  });
                                },
                                  child: SvgPicture.asset(
                                    'assets/tabbar_icons/Tabbar_search.svg',height:21.h,width:21.w,
                                  ),
                                ),
                                SizedBox(width:22.w),
                                PopupMenuButton(
                                    icon:Icon(Icons.more_vert_rounded,color:Colors.black),
                                    iconSize:30,
                                    // onSelected: (value) {
                                    //   switch (value) {
                                    //     case 1:
                                    //       {
                                    //         Navigator.push(context, MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 InviteFriends(state: 0)));
                                    //       }
                                    //       break;
                                    //     default:
                                    //   }
                                    // },
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(
                                        child: Text("Refresh",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                            fontSize:12.sp,color:Colors.black))),

                                        value: 1,
                                      ),
                                      PopupMenuItem(
                                          child:Text("Help",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                              fontSize:12.sp,color:Colors.black))))
                                    ]),
                                SizedBox(width:6.w),
                              ]):searchBar(),
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                              itemCount:isSearching?filteredContacts.length:con2.length,
                              itemBuilder: (context, index){
                                var name =conNames2[index];
                                if(nameSearch.isEmpty){return Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: ListTile(

                                    onTap: () async {
                                      // print("this is body : ${body[index].data()}");
                                      print("this text click");
                                      print("this is body : ${con2[index]}");
                                      switch (widget.state) {
                                        case 0:
                                          {
                                            print('HELLO MAN');
                                            if (widget.sizingInformation.deviceScreenType ==
                                                DeviceScreenType.desktop) {
                                              print("this is callled 1");
                                              Navigator.pop(context, conMap[contacts1[index]]);
                                            } else {
                                              print("else is called");
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                            state: 0,
                                                            uid: uid.toString(),
                                                            puid: conMap[con2[index]].toString(),
                                                          )));
                                            }
                                          }
                                          break;

                                        case 1:
                                          {
                                            if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                              Navigator.pop(context, conMap[contacts1[index]]);
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ChatPage(
                                                        state: 1,
                                                        uid: uid.toString(),
                                                        puid: conMap[contacts1[index]].toString(),
                                                      )));
                                            }
                                          }
                                          break;

                                        case 4:
                                          {
                                            if (memberList.contains(conMap[contacts1[index]]) == false) {
                                              if (groupMemberList.length <= 49) {
                                                if (!mounted) return;
                                                setState(() {
                                                  memberList.add(conMap[contacts1[index]].toString());
                                                  groupMemberList.add(body[index].data());
                                                });
                                              } else {
                                                final snackBar = snackbar(
                                                    content: "Group can contain only 50 members");
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              }
                                            } else {
                                              if (!mounted) return;
                                              setState(() {
                                                memberList.remove(conMap[contacts1[index]]);
                                                groupMemberList.remove(body[index].data());
                                              });
                                            }
                                          }
                                          break;
                                        case 5:
                                          {
                                            if (!widget.participants!.contains(conMap[contacts1[index]])) {
                                              if (memberList.contains(conMap[contacts1[index]]) == false) {
                                                if ((groupMemberList.length +
                                                    widget.participants!.length) <= 50) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    memberList.add(conMap[contacts1[index]].toString());
                                                    groupMemberList.add(body[index].data());
                                                  });
                                                } else {
                                                  final snackBar = snackbar(
                                                      content: "Group can contain only 50 members");
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  memberList.remove(conMap[contacts1[index]]);
                                                  groupMemberList.remove(body[index].data());
                                                });
                                              }
                                            }
                                          }
                                          break;
                                        case 6:
                                          {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => UserProfile(
                                                      uid: uid.toString(),
                                                    )));
                                          }
                                          break;
                                        case 7:
                                          {
                                            if (body[index].data()["token"] != null) {
                                              if (body[index].data()["callStatus"] == false) {
                                                FirebaseFirestore instance = FirebaseFirestore.instance;
                                                DocumentSnapshot<
                                                    Map<String, dynamic>> userDoc = await instance
                                                    .collection("call-logs").doc(widget.gid!).get();
                                                if (userDoc.exists) {
                                                  await sendNotificationForCall(
                                                      userTokens: [body[index].data()["token"]],
                                                      id: widget.channelName!,
                                                      timestamp: widget.gid!,
                                                      video: widget.video,
                                                      phoneNumber: userDoc.data()!["callerId"],
                                                      pic: userDoc.data()!["members"]["${userDoc
                                                          .data()!["channelId"]}"]["pic"],
                                                      state: 0,
                                                      name: userDoc.data()!["members"]["${userDoc
                                                          .data()!["channelId"]}"]["name"]);
                                                  await UpdateWriteLog(documentId: widget.gid!,
                                                      uid: body[index].data()["uid"],
                                                      userDetailDoc: body[index].data());
                                                  Navigator.pop(context);
                                                }
                                              } else {
                                                toast("User is busy right now!");
                                              }
                                              // QuerySnapshot<Map<String, dynamic>> callDoc = await instance.collection("call-log").where("channelId", isEqualTo: widget.channelName).get();
                                            } else {
                                              toast("User has logged out!");
                                              // final snackBar = snackbar(content: "User has no token");
                                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          }
                                          break;
                                        default:
                                          {
                                            print("Invalid choice");
                                          }
                                          break;
                                      }
                                      print("Chat to : ${conMap[con2[index]]}");

                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(state: 0,uid: uid.toString(),puid: conMap[con2[index]].toString())));

                                    },
                                    contentPadding: EdgeInsets.only(left: 0),
                                    leading: Padding(
                                      padding:  EdgeInsets.only(left: 14.w),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage("assets/noProfile.jpg"),
                                        radius: 25.w,
                                      ),
                                    ),
                                    title: SubstringHighlight(text:name,
                                      term:searchContactcontroller.text,),
                                  ),
                                );}
                                if(name.toString().toLowerCase().contains(nameSearch.toLowerCase())){
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      onTap: () async {
                                        print("this is body : ${body[index].data()}");
                                        switch (widget.state) {
                                          case 0:
                                            {
                                              if (widget.sizingInformation.deviceScreenType ==
                                                  DeviceScreenType.desktop) {
                                                Navigator.pop(context, conMap[contacts1[index]]);
                                              } else {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatPage(
                                                              state: 0,
                                                              uid: uid.toString(),
                                                              puid: conMap[contacts1[index]].toString(),
                                                            )));
                                              }
                                            }
                                            break;

                                          case 1:
                                            {
                                              if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                                Navigator.pop(context, conMap[contacts1[index]]);
                                              } else {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ChatPage(
                                                          state: 1,
                                                          uid: uid.toString(),
                                                          puid: conMap[contacts1[index]].toString(),
                                                        )));
                                              }
                                            }
                                            break;

                                          case 4:
                                            {
                                              if (memberList.contains(conMap[contacts1[index]]) == false) {
                                                if (groupMemberList.length <= 49) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    memberList.add(conMap[contacts1[index]].toString());
                                                    groupMemberList.add(body[index].data());
                                                  });
                                                } else {
                                                  final snackBar = snackbar(
                                                      content: "Group can contain only 50 members");
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  memberList.remove(conMap[contacts1[index]]);
                                                  groupMemberList.remove(body[index].data());
                                                });
                                              }
                                            }
                                            break;
                                          case 5:
                                            {
                                              if (!widget.participants!.contains(conMap[contacts1[index]])) {
                                                if (memberList.contains(conMap[contacts1[index]]) == false) {
                                                  if ((groupMemberList.length +
                                                      widget.participants!.length) <= 50) {
                                                    if (!mounted) return;
                                                    setState(() {
                                                      memberList.add(conMap[contacts1[index]].toString());
                                                      groupMemberList.add(body[index].data());
                                                    });
                                                  } else {
                                                    final snackBar = snackbar(
                                                        content: "Group can contain only 50 members");
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  }
                                                } else {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    memberList.remove(conMap[contacts1[index]]);
                                                    groupMemberList.remove(body[index].data());
                                                  });
                                                }
                                              }
                                            }
                                            break;
                                          case 6:
                                            {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => UserProfile(
                                                        uid: uid.toString(),
                                                      )));
                                            }
                                            break;
                                          case 7:
                                            {
                                              if (body[index].data()["token"] != null) {
                                                if (body[index].data()["callStatus"] == false) {
                                                  FirebaseFirestore instance = FirebaseFirestore.instance;
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>> userDoc = await instance
                                                      .collection("call-logs").doc(widget.gid!).get();
                                                  if (userDoc.exists) {
                                                    await sendNotificationForCall(
                                                        userTokens: [body[index].data()["token"]],
                                                        id: widget.channelName!,
                                                        timestamp: widget.gid!,
                                                        video: widget.video,
                                                        phoneNumber: userDoc.data()!["callerId"],
                                                        pic: userDoc.data()!["members"]["${userDoc
                                                            .data()!["channelId"]}"]["pic"],
                                                        state: 0,
                                                        name: userDoc.data()!["members"]["${userDoc
                                                            .data()!["channelId"]}"]["name"]);
                                                    await UpdateWriteLog(documentId: widget.gid!,
                                                        uid: body[index].data()["uid"],
                                                        userDetailDoc: body[index].data());
                                                    Navigator.pop(context);
                                                  }
                                                } else {
                                                  toast("User is busy right now!");
                                                }
                                                // QuerySnapshot<Map<String, dynamic>> callDoc = await instance.collection("call-log").where("channelId", isEqualTo: widget.channelName).get();
                                              } else {
                                                toast("User has logged out!");
                                                // final snackBar = snackbar(content: "User has no token");
                                                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              }
                                            }
                                            break;
                                          default:
                                            {
                                              print("Invalid choice");
                                            }
                                            break;
                                        }
                                        print("Chat to : ${conMap[con2[index]]}");
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(state: 0,uid: uid.toString(),puid: conMap[con2[index]].toString())));
                                      },
                                      contentPadding: EdgeInsets.only(left: 0),
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage("assets/noProfile.jpg"),
                                        radius: 25.w,
                                      ),
                                      title: SubstringHighlight(text: '${conNames2[index]}',
                                        term:searchContactcontroller.text,),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    onTap: () async {
                                      print("this is body : ${body[index].data()}");
                                      switch (widget.state) {
                                        case 0:
                                          {
                                            if (widget.sizingInformation.deviceScreenType ==
                                                DeviceScreenType.desktop) {
                                              Navigator.pop(context, conMap[contacts1[index]]);
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                            state: 0,
                                                            uid: uid.toString(),
                                                            puid: conMap[contacts1[index]].toString(),
                                                          )));
                                            }
                                          }
                                          break;

                                        case 1:
                                          {
                                            if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                              Navigator.pop(context, conMap[contacts1[index]]);
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ChatPage(
                                                        state: 1,
                                                        uid: uid.toString(),
                                                        puid: conMap[contacts1[index]].toString(),
                                                      )));
                                            }
                                          }
                                          break;

                                        case 4:
                                          {
                                            if (memberList.contains(conMap[contacts1[index]]) == false) {
                                              if (groupMemberList.length <= 49) {
                                                if (!mounted) return;
                                                setState(() {
                                                  memberList.add(conMap[contacts1[index]].toString());
                                                  groupMemberList.add(body[index].data());
                                                });
                                              } else {
                                                final snackBar = snackbar(
                                                    content: "Group can contain only 50 members");
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              }
                                            } else {
                                              if (!mounted) return;
                                              setState(() {
                                                memberList.remove(conMap[contacts1[index]]);
                                                groupMemberList.remove(body[index].data());
                                              });
                                            }
                                          }
                                          break;
                                        case 5:
                                          {
                                            if (!widget.participants!.contains(conMap[contacts1[index]])) {
                                              if (memberList.contains(conMap[contacts1[index]]) == false) {
                                                if ((groupMemberList.length +
                                                    widget.participants!.length) <= 50) {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    memberList.add(conMap[contacts1[index]].toString());
                                                    groupMemberList.add(body[index].data());
                                                  });
                                                } else {
                                                  final snackBar = snackbar(
                                                      content: "Group can contain only 50 members");
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  memberList.remove(conMap[contacts1[index]]);
                                                  groupMemberList.remove(body[index].data());
                                                });
                                              }
                                            }
                                          }
                                          break;
                                        case 6:
                                          {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => UserProfile(
                                                      uid: uid.toString(),
                                                    )));
                                          }
                                          break;
                                        case 7:
                                          {
                                            if (body[index].data()["token"] != null) {
                                              if (body[index].data()["callStatus"] == false) {
                                                FirebaseFirestore instance = FirebaseFirestore.instance;
                                                DocumentSnapshot<
                                                    Map<String, dynamic>> userDoc = await instance
                                                    .collection("call-logs").doc(widget.gid!).get();
                                                if (userDoc.exists) {
                                                  await sendNotificationForCall(
                                                      userTokens: [body[index].data()["token"]],
                                                      id: widget.channelName!,
                                                      timestamp: widget.gid!,
                                                      video: widget.video,
                                                      phoneNumber: userDoc.data()!["callerId"],
                                                      pic: userDoc.data()!["members"]["${userDoc
                                                          .data()!["channelId"]}"]["pic"],
                                                      state: 0,
                                                      name: userDoc.data()!["members"]["${userDoc
                                                          .data()!["channelId"]}"]["name"]);
                                                  await UpdateWriteLog(documentId: widget.gid!,
                                                      uid: body[index].data()["uid"],
                                                      userDetailDoc: body[index].data());
                                                  Navigator.pop(context);
                                                }
                                              } else {
                                                toast("User is busy right now!");
                                              }
                                              // QuerySnapshot<Map<String, dynamic>> callDoc = await instance.collection("call-log").where("channelId", isEqualTo: widget.channelName).get();
                                            } else {
                                              toast("User has logged out!");
                                              // final snackBar = snackbar(content: "User has no token");
                                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          }
                                          break;
                                        default:
                                          {
                                            print("Invalid choice");
                                          }
                                          break;
                                      }
                                      print("Chat to : ${conMap[con2[index]]}");

                                    },
                                    contentPadding: EdgeInsets.only(left: 0),
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage("assets/noProfile.jpg"),
                                      radius: 25.w,
                                    ),
                                    title: SubstringHighlight(text: '${conNames2[index]}',
                                      term:searchContactcontroller.text,),
                                    trailing: ((widget.state == 4 || widget.state == 5) && memberList.contains(id)) ? Icon(Icons.done) : Container(),
                                  ),
                                );} ),
                        ),
                        Container(
                          height: (isLoading == true) ? 20.0 : 0,
                          color: Colors.transparent,
                          child: Center(
                            child: LinearProgressIndicator(
                              color: Color(accent),
                            ),
                          ),
                        ),
                      ],
                      )
                          : Container(
                          child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    lottieAnimation(invalidLottie),
                                    Text((widget.state == 0 ||
                                        widget.state == 4 ||
                                        widget.state == 5 ||
                                        widget.state == 7)
                                        ? "No Contacts"
                                        : (widget.state == 6)
                                        ? "No Account"
                                        : "")
                                  ],
                                ),
                              )))),
                ),
              );
            });
          }
      ),
    );
  }

  Widget itemBuild(index){
    return ListTile(
      onTap: (){
        print("Chat to : ${conMap[con2[index]]}");

        //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(state: 0,uid: uid.toString(),puid: conMap[con2[index]].toString())));

      },
      contentPadding: EdgeInsets.only(left: 0),
      leading: CircleAvatar(

        backgroundImage: AssetImage("assets/noProfile.jpg"),
        radius: 25.w,
      ),
      title: Text("${conNames2[index]}"),
    );
  }

  Widget buildItem(
      {required String? pic, required String name,required String id, Map<
          String,
          dynamic>? document}) {

    if (uid == id) {
      return Container(

      );
    } else {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            switch (widget.state) {
              case 0:
                {
                  if (widget.sizingInformation.deviceScreenType ==
                      DeviceScreenType.desktop) {
                    Navigator.pop(context, id);
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(
                                  state: 0,
                                  uid: uid.toString(),
                                  puid: id,
                                )));
                  }
                }
                break;

              case 1:
                {
                  if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                    Navigator.pop(context, id);
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                              state: 1,
                              uid: uid.toString(),
                              puid: id,
                            )));
                  }
                }
                break;

              case 4:
                {
                  if (memberList.contains(id) == false) {
                    if (groupMemberList.length <= 49) {
                      if (!mounted) return;
                      setState(() {
                        memberList.add(id);
                        groupMemberList.add(document!);
                      });
                    } else {
                      final snackBar = snackbar(
                          content: "Group can contain only 50 members");
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    if (!mounted) return;
                    setState(() {
                      memberList.remove(id);
                      groupMemberList.remove(document!);
                    });
                  }
                }
                break;
              case 5:
                {
                  if (!widget.participants!.contains(id)) {
                    if (memberList.contains(id) == false) {
                      if ((groupMemberList.length +
                          widget.participants!.length) <= 50) {
                        if (!mounted) return;
                        setState(() {
                          memberList.add(id);
                          groupMemberList.add(document!);
                        });
                      } else {
                        final snackBar = snackbar(
                            content: "Group can contain only 50 members");
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      if (!mounted) return;
                      setState(() {
                        memberList.remove(id);
                        groupMemberList.remove(document!);
                      });
                    }
                  }
                }
                break;
              case 6:
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(
                            uid: id,
                          )));
                }
                break;
              case 7:
                {
                  if (document!["token"] != null) {
                    if (document["callStatus"] == false) {
                      FirebaseFirestore instance = FirebaseFirestore.instance;
                      DocumentSnapshot<
                          Map<String, dynamic>> userDoc = await instance
                          .collection("call-logs").doc(widget.gid!).get();
                      if (userDoc.exists) {
                        await sendNotificationForCall(
                            userTokens: [document["token"]],
                            id: widget.channelName!,
                            timestamp: widget.gid!,
                            video: widget.video,
                            phoneNumber: userDoc.data()!["callerId"],
                            pic: userDoc.data()!["members"]["${userDoc
                                .data()!["channelId"]}"]["pic"],
                            state: 0,
                            name: userDoc.data()!["members"]["${userDoc
                                .data()!["channelId"]}"]["name"]);
                        await UpdateWriteLog(documentId: widget.gid!,
                            uid: document["uid"],
                            userDetailDoc: document);
                        Navigator.pop(context);
                      }
                    } else {
                      toast("User is busy right now!");
                    }
                    // QuerySnapshot<Map<String, dynamic>> callDoc = await instance.collection("call-log").where("channelId", isEqualTo: widget.channelName).get();
                  } else {
                    toast("User has logged out!");
                    // final snackBar = snackbar(content: "User has no token");
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                break;
              default:
                {
                  print("Invalid choice");
                }
                break;
            }
          },
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
                          // ? Image.network(
                          //     pic,
                          //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          //       if (loadingProgress == null) return child;
                          //       return Center(
                          //         child: CircularProgressIndicator(
                          //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                          //         ),
                          //       );
                          //     },
                          //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                          //   )
                              ? CachedNetworkImage(


                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 400),
                            progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                                Center(
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                ),
                            imageUrl: pic,
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/noProfile.jpg", fit: BoxFit
                                    .cover),
                          )
                              : Image.asset(
                              "assets/noProfile.jpg", fit: BoxFit.cover),
                        )),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(textStyle: textStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ),
                    ),
                    // Text(name1)
                  ],
                ),
              ),
              (widget.state == 5 && widget.participants!.contains(id)) ? Icon(
                  Icons.done_all) : Container(),
              ((widget.state == 4 || widget.state == 5) &&
                  memberList.contains(id)) ? Icon(Icons.done) : Container()
            ],
          )
      );
    }
  }
  getDataList(){



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
            dbUpdate.writeDb(contactNames[i], conMap[contacts1[i]]!, contacts1[i]);

          }
        }
      }
    }

    // print("Con2:${contacts2} ${conNames}");
    con2 = LinkedHashSet<String>.from(contacts2).toList();
    conNames2 = LinkedHashSet<String>.from(conNames).toList();
    print(con2);
    print(conNames2);
    print(conMap);

    print(con2.length);



    // for(int i=0; i<contacts.length; i++){
    //   print("contact:${contacts[i].phones}");
    //   for(int j=0; j<body.length; j++){
    //     print("body ${j} ${body[j]}");
    //     print("body length ${body.length}");
    //     print("body data ${body[j].data()["phone"]}");
    //     if(contacts[i].phones ==  body[j].data()["phone"].toString()){
    //       print("equal succes");
    //       mergeUserContact.add(body[j].data()["phone"].toString());
    //     }
    //     else{
    //       print('NOt working');
    //     }
    //   }
    //   print("${i} - ${mergeUserContact}");
    // }
  }
  Widget searchBar(){
    bool folded=false;
    return Row(
      children: [  GestureDetector(onTap: () {
        setState(() {
          searching=false;
        });
      },
        child: SvgPicture.asset(
          'assets/pops_asset/back_button.svg',
          height: 30.h,
          width: 30.w,),
      ),
        AnimatedContainer(duration:Duration(milliseconds:100),
          height:40.h,width:folded==true?10.w:300.w,
          decoration:BoxDecoration(borderRadius:BorderRadius.circular(15),color:Colors.white),
          child:   TextField(
            onChanged: (value){
              String nameX=searchContactcontroller.text.toLowerCase();
              print(nameX);
              for(int x=0;x<conNames2.length;x++) {
                print("CNDN:${conNames2.contains(nameX)}");
                if (conNames2.contains(nameX)) {
                  print("FOUND:${conNames2[x]}");
                  // searchConNames.add(conNames2);
                }
              }
              setState(() {


              });
            },
            autofocus:true,
            cursorColor:Colors.black,cursorHeight:20.h,
            controller:searchContactcontroller,
            decoration:InputDecoration(hintText:'Search...',contentPadding:EdgeInsets.only(
                top:10.h
            ),
                hintStyle:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w500,
                    fontSize:14.sp,color:Colors.black)),
                prefixIcon:Column(mainAxisAlignment:MainAxisAlignment.center,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        'assets/tabbar_icons/Tabbar_search.svg'
                    ),
                  ],
                ),
                focusedBorder:OutlineInputBorder(
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
// import 'dart:async';
// // import 'package:cached_network_image/cached_network_image.dart';
//
// //------------------------------------------------------------------------------------------
// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'dart:developer';
// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gatello/views/tabbar/test_code/UserDetails.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// //
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:responsive_builder/responsive_builder.dart';
//
// import '../../../../Firebase/FirebaseNotifications.dart';
// import '../../../../Firebase/Writes.dart';
// import '../../../../Others/Structure.dart';
// import '../../../../Others/components/LottieComposition.dart';
// import '../../../../Others/lottie_strings.dart';
// import '../../../../Style/Colors.dart';
// import '../../../../Style/Text.dart';
// import '../../../../components/ScaffoldDialog.dart';
// import '../../../../components/SnackBar.dart';
// import '../../../../components/TextField.dart';
// import '../../../../main.dart';
// import '../../../contact_list.dart';
// import '../../../profile/user_proflle.dart';
// import '../../chats/group_personal_screen/test_code2/CreateGroup.dart';
// import '../../chats/personal_chat_screen/ChatPage.dart';
//
// class SearchPage extends StatefulWidget {
//   //state ==1 is not possible..
//   ///* 0->personal chat,
//   ///1->group chat,
//   ///2->personal call
//   ///,3->group call,
//   ///4->create group,
//   ///5->add group participants,
//   ///6->story search,
//   ///7->add call participants
//   final int state;
//   final SizingInformation sizingInformation;
//   final String? gid;
//   final List<String>? participants;
//   final bool video;
//   final String? channelName;
//   const SearchPage({Key? key, required this.state,required  this.sizingInformation,
//     this.gid, this.participants, this.video = false, this.channelName}) : super(key: key);
//
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   bool _isRequesting = false;
//   bool _isFinish = false;
//   FirebaseFirestore instance = FirebaseFirestore.instance;
//   ScrollController scrollController = ScrollController();
//   TextEditingController searchTextEditingController = TextEditingController();
//   Timer? _debounce;
//   List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
//   bool isLoading = false;
//   List<Map<String, dynamic>> groupMemberList = [];
//
//   // List<String> groupMemberList = [];
//   String? uid;
//   List<String> memberList = [];
//
//   Future<void> _getUID() async {
//     print('uidapi');
//     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//     uid = sharedPrefs.getString("userid").toString();
//     print("ShardPref ${uid}");
//   }
//
//   @override
//   void initState() {
//     _getUID();
//     // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
//     userChatList(searchQuery: searchTextEditingController.text);
//     // } else if (widget.state == 5) {
//     //   newParticipantSearch(searchQuery: searchTextEditingController.text);
//     // }
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (_debounce != null) {
//       _debounce!.cancel();
//     }
//     searchTextEditingController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   // Future newParticipantSearch({required String searchQuery, int limit = 50}) async {
//   //   if (!_isRequesting && !_isFinish) {
//   //     QuerySnapshot<Map<String, dynamic>> querySnapshot;
//   //     _isRequesting = true;
//   //     //* as per firestore "You can't order your query by a field included in an equality (==) or in clause."
//   //     //* so i think we can use orderby to sort by name
//   //     if (body.isEmpty) {
//   //       querySnapshot = await instance
//   //           .collection("user-detail")
//   //           .where("name", isGreaterThanOrEqualTo: searchQuery)
//   //           .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
//   //           .orderBy("name")
//   //           .limit(limit)
//   //           .get();
//   //     } else {
//   //       querySnapshot = await instance
//   //           .collection("user-detail")
//   //           .where("name", isGreaterThanOrEqualTo: searchQuery)
//   //           .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
//   //           .orderBy("name")
//   //           .startAfterDocument(body[body.length - 1])
//   //           .limit(limit)
//   //           .get();
//   //     }
//   //     if (querySnapshot != null && querySnapshot.docs.first.id != body.last.id) {
//   //       if (!mounted) return;
//   //       setState(() {
//   //         body.addAll(querySnapshot.docs);
//   //       });
//   //       if (querySnapshot.docs.length < limit) {
//   //         _isFinish = true;
//   //       }
//   //     }
//   //     _isRequesting = false;
//   //   }
//   // }
//
//   // //FIXME.. only user can search accepted group
//   // Future groupChatList({required String searchQuery, int limit = 50}) async {
//   //   if (!_isRequesting && !_isFinish) {
//   //     QuerySnapshot<Map<String, dynamic>> querySnapshot;
//   //     _isRequesting = true;
//   //     if (body.isEmpty) {
//   //       querySnapshot = await instance
//   //           .collection("group-detail")
//   //           .where("title", isGreaterThanOrEqualTo: searchQuery)
//   //           .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff')
//   //           .orderBy("title")
//   //           .limit(limit)
//   //           .get();
//   //     } else {
//   //       querySnapshot = await instance
//   //           .collection("group-detail")
//   //           .where("title", isGreaterThanOrEqualTo: searchQuery)
//   //           .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff')
//   //           .orderBy("title")
//   //           .startAfterDocument(body[body.length - 1])
//   //           .limit(limit)
//   //           .get();
//   //     }
//   //     if (querySnapshot != null) {
//   //       if (!mounted) return;
//   //       setState(() {
//   //         body.addAll(querySnapshot.docs);
//   //       });
//   //       if (querySnapshot.docs.length < limit) {
//   //         _isFinish = true;
//   //       }
//   //     }
//   //     _isRequesting = false;
//   //   }
//   // }
//
//   Future userChatList({required String searchQuery, int limit = 50}) async {
//     if (!_isRequesting && !_isFinish) {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot;
//       _isRequesting = true;
//       if (body.isEmpty) {
//         querySnapshot = await instance
//             .collection("user-detail")
//             .where("name",
//             isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
//             .where("name",
//             isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
//                 '\uf8ff')
//             .orderBy("name")
//             .limit(limit)
//             .get();
//       } else {
//         querySnapshot = await instance
//             .collection("user-detail")
//             .where("name",
//             isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
//             .where("name",
//             isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
//                 '\uf8ff')
//             .orderBy("name")
//             .startAfterDocument(body[body.length - 1])
//             .limit(limit)
//             .get();
//       }
//       if (querySnapshot != null) {
//         if (!mounted) return;
//         setState(() {
//           body.addAll(querySnapshot.docs);
//         });
//         if (querySnapshot.docs.length < limit) {
//           _isFinish = true;
//         }
//       }
//       _isRequesting = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FutureBuilder(
//           future: _getUID(),
//           builder: (context, _) {
//             return ResponsiveBuilder(builder: (context, sizingInformation) {
//               return Scaffold(
//                 resizeToAvoidBottomInset: false,
//                 floatingActionButton: (widget.state == 4 || widget.state == 5)
//                     ? FloatingActionButton(
//                   onPressed: () async {
//                     if (groupMemberList.isNotEmpty && memberList.isNotEmpty) {
//                       if (widget.state == 4) {
//                         if (sizingInformation.deviceScreenType ==
//                             DeviceScreenType.desktop) {
//                           return await scaffoldAlertDialogBox(context: context,
//                               page: CreateGroup(members: groupMemberList, uid: uid.toString(),));
//                         } else {
//                           Navigator.push(context, MaterialPageRoute(
//                               builder: (context) =>
//                                   CreateGroup(members: groupMemberList,uid: uid.toString())));
//                         }
//                       } else if (widget.state == 5) {
//                         WriteBatch writeBatch = instance.batch();
//                         writeBatch.set(
//                             instance.collection("group-detail").doc(widget.gid),
//                             {
//                               "members": addGroupMembersMap(
//                                   members: groupMemberList),
//                               // "membersList": FieldValue.arrayUnion(groupMemberList),
//                             },
//                             SetOptions(merge: true));
//                         // for (String uid in groupMemberList) {
//                         //   writeBatch.set(
//                         //       instance.collection("personal-group-list").doc(uid),
//                         //       {
//                         //         "groupList": FieldValue.arrayUnion([widget.gid])
//                         //       },
//                         //       SetOptions(merge: true));
//                         // }
//                         writeBatch.commit();
//                         Navigator.pop(context);
//                       }
//                     }
//                   },
//                   child: Icon(Icons.done),
//                 )
//                     : null,
//                 appBar: AppBar(
//                   centerTitle: false,
//                   automaticallyImplyLeading: false,
//                   elevation: 0,
//                   leading: GestureDetector(
//                       onTap:(){
//                         Navigator.pop(context);
//                       },
//                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment:CrossAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset('assets/pops_asset/back_button.svg',height:35.h,
//                             width:35.w,),
//                         ],
//                       )),
//                   actions:
//                   // (sizingInformation.deviceScreenType ==
//                   //     DeviceScreenType.desktop)
//                   //     ? null :
//                   [
//                     SvgPicture.asset(
//                       'assets/tabbar_icons/Tabbar_search.svg',height:21.h,width:21.w,
//                     ),
//                     SizedBox(width:22.w),
//                     PopupMenuButton(
//                         icon:Icon(Icons.more_vert_rounded,color:Colors.black),
//                         iconSize:30,
//                         onSelected: (value) {
//                           switch (value) {
//                             case 1:
//                               {
//                                 Navigator.push(context, MaterialPageRoute(
//                                     builder: (context) =>
//                                         ContactList(state: 0)));
//                               }
//                               break;
//                             default:
//                           }
//                         },
//                         itemBuilder: (context) =>
//                         [
//                           PopupMenuItem(
//                             child: Text("Refresh",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
//                                 fontSize:12.sp,color:Colors.black))),
//
//                             value: 1,
//                           ),PopupMenuItem(child:Text("Help",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
//                             fontSize:12.sp,color:Colors.black))))
//                         ])
//                   ],
//                   title: Column(crossAxisAlignment:CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         (widget.state == 0)
//                             ? "Select contact"
//                         // : (widget.state == 1)
//                         //     ? "Search Group Name"
//                         //     : (widget.state == 4)
//                         //     ? (memberList.isEmpty)
//                         //     ? "Select contact"
//                         //     : "${memberList.length}/49 Selected"
//                         //     : (widget.state == 5)
//                         //     ? "${memberList.length +
//                         //     widget.participants!.length}/50 Selected"
//                         //     : (widget.state == 6)
//                         //     ? "Search Account"
//                         //     : (widget.state == 7)
//                         //     ? "Search Participant"
//                             : "",
//                         style: GoogleFonts.inter(textStyle:TextStyle(
//                             fontSize: 16.sp, fontWeight: FontWeight.w400,color:Colors.black)),
//                       ),
//                       SizedBox(height:2.h),
//                       Text('260 contacts',style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
//                           fontSize:12.sp,color:Colors.black)),)
//                     ],
//                   ),
//                 ),
//                 body: NestedScrollView(
//                   controller: scrollController,
//                   floatHeaderSlivers: true,
//                   headerSliverBuilder: (BuildContext context,
//                       bool innerBoxIsScrolled) {
//                     return <Widget>[
//                       SliverOverlapAbsorber(
//                         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                             context),
//                         sliver: SliverAppBar(
//                           centerTitle: false,
//                           floating: true,
//                           pinned: false,
//                           snap: true,
//                           forceElevated: innerBoxIsScrolled,
//                           automaticallyImplyLeading: false,
//                           bottom: PreferredSize(
//                             preferredSize: Size.fromHeight(30.0),
//                             child: Text(''),
//                           ),
//                           flexibleSpace: Center(
//                             child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 20, right: 20),
//                                 child: textField(
//                                   textStyle: GoogleFonts.poppins(
//                                       textStyle: textStyle(fontSize: 14)),
//                                   border: false,
//                                   textEditingController: searchTextEditingController,
//                                   hintText: (widget.state == 0)
//                                       ? "Search Contact"
//                                   // : (widget.state == 1)
//                                   //     ? "Search Group"
//                                       : (widget.state == 4)
//                                       ? "Search Members"
//                                       : (widget.state == 5)
//                                       ? "Search Members"
//                                       : (widget.state == 6)
//                                       ? "Search Account"
//                                       : (widget.state == 7)
//                                       ? "Search Participant"
//                                       : "",
//                                   hintStyle: GoogleFonts.poppins(
//                                       textStyle: textStyle(color: Color(grey))),
//                                   onChanged: (value) async {
//                                     if (_debounce?.isActive ?? false) _debounce
//                                         ?.cancel();
//                                     _debounce = Timer(const Duration(
//                                         milliseconds: 100), () async {
//                                       body.clear();
//                                       _isRequesting = false;
//                                       _isFinish = false;
//                                       // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
//                                       return await userChatList(
//                                           searchQuery: value);
//                                       // }
//                                       // else if (widget.state == 1) {
//                                       //   return await groupChatList(searchQuery: value);
//                                       // }
//                                       // else if (widget.state == 5) {
//                                       //   return await newParticipantSearch(searchQuery: value);
//                                       // }
//                                     });
//                                   },
//                                   onSubmitted: (value) async {
//                                     body.clear();
//                                     _isRequesting = false;
//                                     _isFinish = false;
//                                     // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
//                                     return await userChatList(
//                                         searchQuery: value);
//                                     // }
//                                     // else if (widget.state == 1) {
//                                     //   return await groupChatList(searchQuery: value);
//                                     // }
//                                     // else if (widget.state == 5) {
//                                     // return await newParticipantSearch(searchQuery: value);
//                                     // }
//                                   },
//                                   suffixIcon: IconButton(
//                                     splashColor: Colors.transparent,
//                                     highlightColor: Colors.transparent,
//                                     hoverColor: Colors.transparent,
//                                     onPressed: () async {
//                                       body.clear();
//                                       _isRequesting = false;
//                                       _isFinish = false;
//                                       // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
//                                       return await userChatList(
//                                           searchQuery: searchTextEditingController
//                                               .text);
//                                       // }
//                                       // else if (widget.state == 1) {
//                                       //   return await groupChatList(searchQuery: searchTextEditingController.text);
//                                       // }
//                                       // else if (widget.state == 5) {
//                                       //   return await newParticipantSearch(searchQuery: searchTextEditingController.text);
//                                       // }
//                                     },
//                                     icon: Icon(
//                                       Icons.search,
//                                     ),
//                                   ),
//                                 )
//                             ),
//                           ),
//                         ),
//                       )
//                     ];
//                   },
//                   body: NotificationListener<ScrollNotification>(
//                       onNotification: (notification) {
//                         if ((isLoading == false &&
//                             notification.metrics.axisDirection ==
//                                 AxisDirection.down &&
//                             notification.metrics.pixels ==
//                                 notification.metrics.maxScrollExtent) ==
//                             true) {
//                           if (!mounted) return false;
//                           setState(() {
//                             isLoading = true;
//                           });
//                           // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
//                           this.userChatList(
//                               searchQuery: searchTextEditingController.text);
//                           // }
//                           // else if (widget.state == 1) {
//                           //   this.groupChatList(searchQuery: searchTextEditingController.text);
//                           // }
//                           // else if (widget.state == 5) {
//                           //   this.newParticipantSearch(searchQuery: searchTextEditingController.text);
//                           // }
//                           if (!mounted) return false;
//                           setState(() {
//                             isLoading = false;
//                           });
//                         }
//                         return true;
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 20, right: 20),
//                         child: (body.isNotEmpty)
//                             ? Column(
//                           children: [
//
//                             Expanded(
//                               child: ListView.separated(
//                                 separatorBuilder: (context, index) {
//                                   // if (widget.state == 0 || widget.state == 4 || widget.state == 5 || widget.state == 6) {
//                                   if (uid != body[index].data()["uid"]) {
//                                     return Divider(
//                                       thickness: 1,
//                                       // height: 1,
//                                       color: (themedata.value.index == 0)
//                                           ? Color(lightGrey)
//                                           : Color(lightBlack),
//                                     );
//                                   } else {
//                                     return Container();
//                                   }
//                                   // } else {
//                                   //   return Divider(
//                                   //     // thickness: 1,
//                                   //     height: 1,
//                                   //     color: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
//                                   //   );
//                                   // }
//                                 },
//                                 itemCount: body.length,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, index) {
//                                   if (widget.state == 0 || widget.state == 6) {
//                                     return buildItem(
//                                         pic: (body[index].data()["pic"] != null)
//                                             ? body[index].data()["pic"]
//                                             : null,
//                                         name: body[index].data()["name"],
//                                         id: body[index].data()["uid"]);
//                                   }
//                                   // else if (widget.state == 1) {
//                                   //   return buildItem(
//                                   //       pic: (body[index].data()["pic"] != null) ? body[index].data()["pic"] : null,
//                                   //       name: body[index].data()["title"],
//                                   //       id: body[index].data()["gid"]);
//                                   // }
//                                   else
//                                   if (widget.state == 4 || widget.state == 5 ||
//                                       widget.state == 7) {
//                                     return buildItem(
//                                         pic: (body[index].data()["pic"] != null)
//                                             ? body[index].data()["pic"]
//                                             : null,
//                                         name: body[index].data()["name"],
//                                         id: body[index].data()["uid"],
//                                         document: body[index].data());
//                                   } else {
//                                     return Container();
//                                   }
//                                 },
//                               ),
//                             ),
//                             Container(
//                               height: (isLoading == true) ? 20.0 : 0,
//                               color: Colors.transparent,
//                               child: Center(
//                                 child: new LinearProgressIndicator(
//                                   color: Color(accent),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                             : Container(
//                             child: Center(
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       lottieAnimation(invalidLottie),
//                                       Text((widget.state == 0 ||
//                                           widget.state == 4 ||
//                                           widget.state == 5 ||
//                                           widget.state == 7)
//                                           ? "No Contacts"
//                                           : (widget.state == 6)
//                                           ? "No Account"
//                                           : "")
//                                     ],
//                                   ),
//                                 ))),
//                       )),
//                 ),
//               );
//             });
//           }
//       ),
//     );
//   }
//
//   Widget buildItem(
//       {required String? pic, required String name, required String id, Map<
//           String,
//           dynamic>? document}) {
//     if (uid == id) {
//       return Container(
//
//       );
//     } else {
//       return GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () async {
//             switch (widget.state) {
//               case 0:
//                 {
//                   if (widget.sizingInformation.deviceScreenType ==
//                       DeviceScreenType.desktop) {
//                     Navigator.pop(context, id);
//                   } else {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 ChatPage(
//                                   state: 0,
//                                   uid: uid.toString(),
//                                   puid: id,
//                                 )));
//                   }
//                 }
//                 break;
//
//               case 1:
//                 {
//                   if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//                     Navigator.pop(context, id);
//                   } else {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ChatPage(
//                               state: 1,
//                               uid: uid.toString(),
//                               puid: id,
//                             )));
//                   }
//                 }
//                 break;
//
//               case 4:
//                 {
//                   if (memberList.contains(id) == false) {
//                     if (groupMemberList.length <= 49) {
//                       if (!mounted) return;
//                       setState(() {
//                         memberList.add(id);
//                         groupMemberList.add(document!);
//                       });
//                     } else {
//                       final snackBar = snackbar(
//                           content: "Group can contain only 50 members");
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     }
//                   } else {
//                     if (!mounted) return;
//                     setState(() {
//                       memberList.remove(id);
//                       groupMemberList.remove(document!);
//                     });
//                   }
//                 }
//                 break;
//               case 5:
//                 {
//                   if (!widget.participants!.contains(id)) {
//                     if (memberList.contains(id) == false) {
//                       if ((groupMemberList.length +
//                           widget.participants!.length) <= 50) {
//                         if (!mounted) return;
//                         setState(() {
//                           memberList.add(id);
//                           groupMemberList.add(document!);
//                         });
//                       } else {
//                         final snackBar = snackbar(
//                             content: "Group can contain only 50 members");
//                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                       }
//                     } else {
//                       if (!mounted) return;
//                       setState(() {
//                         memberList.remove(id);
//                         groupMemberList.remove(document!);
//                       });
//                     }
//                   }
//                 }
//                 break;
//               case 6:
//                 {
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => UserProfile(
//                             uid: id,
//                           )));
//                 }
//                 break;
//               case 7:
//                 {
//                   if (document!["token"] != null) {
//                     if (document["callStatus"] == false) {
//                       FirebaseFirestore instance = FirebaseFirestore.instance;
//                       DocumentSnapshot<
//                           Map<String, dynamic>> userDoc = await instance
//                           .collection("call-logs").doc(widget.gid!).get();
//                       if (userDoc.exists) {
//                         await sendNotificationForCall(
//                             userTokens: [document["token"]],
//                             id: widget.channelName!,
//                             timestamp: widget.gid!,
//                             video: widget.video,
//                             phoneNumber: userDoc.data()!["callerId"],
//                             pic: userDoc.data()!["members"]["${userDoc
//                                 .data()!["channelId"]}"]["pic"],
//                             state: 0,
//                             name: userDoc.data()!["members"]["${userDoc
//                                 .data()!["channelId"]}"]["name"]);
//                         await UpdateWriteLog(documentId: widget.gid!,
//                             uid: document["uid"],
//                             userDetailDoc: document);
//                         Navigator.pop(context);
//                       }
//                     } else {
//                       toast("User is busy right now!");
//                     }
//                     // QuerySnapshot<Map<String, dynamic>> callDoc = await instance.collection("call-log").where("channelId", isEqualTo: widget.channelName).get();
//                   } else {
//                     toast("User has logged out!");
//                     // final snackBar = snackbar(content: "User has no token");
//                     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   }
//                 }
//                 break;
//               default:
//                 {
//                   print("Invalid choice");
//                 }
//                 break;
//             }
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Row(
//                   children: [
//                     Container(
//                         width: 50,
//                         height: 50,
//                         child: ClipOval(
//                           child: (pic != null)
//                           // ? Image.network(
//                           //     pic,
//                           //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                           //       if (loadingProgress == null) return child;
//                           //       return Center(
//                           //         child: CircularProgressIndicator(
//                           //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
//                           //         ),
//                           //       );
//                           //     },
//                           //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
//                           //   )
//                               ? CachedNetworkImage(
//
//
//                             fit: BoxFit.cover,
//                             fadeInDuration: const Duration(milliseconds: 400),
//                             progressIndicatorBuilder: (context, url,
//                                 downloadProgress) =>
//                                 Center(
//                                   child: Container(
//                                     width: 20.0,
//                                     height: 20.0,
//                                     child: CircularProgressIndicator(
//                                         value: downloadProgress.progress),
//                                   ),
//                                 ),
//                             imageUrl: pic,
//                             errorWidget: (context, url, error) =>
//                                 Image.asset("assets/noProfile.jpg", fit: BoxFit
//                                     .cover),
//                           )
//                               : Image.asset(
//                               "assets/noProfile.jpg", fit: BoxFit.cover),
//                         )),
//                     Flexible(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10),
//                         child: Text(
//                           name,
//                           style: GoogleFonts.poppins(textStyle: textStyle(
//                               fontSize: 14, fontWeight: FontWeight.w500)),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           softWrap: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               (widget.state == 5 && widget.participants!.contains(id)) ? Icon(
//                   Icons.done_all) : Container(),
//               ((widget.state == 4 || widget.state == 5) &&
//                   memberList.contains(id)) ? Icon(Icons.done) : Container()
//             ],
//           )
//       );
//     }
//   }
// }