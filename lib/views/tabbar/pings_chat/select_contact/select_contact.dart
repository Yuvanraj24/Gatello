import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../../../invitefriends.dart';
import '../../../profile/user_proflle.dart';
import '../../chats/group_personal_screen/test_code2/CreateGroup.dart';
import '../../chats/personal_chat_screen/ChatPage.dart';
class SearchPage extends StatefulWidget {
  //state ==1 is not possible..
  ///* 0->personal chat,
  ///1->group chat,
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
  List mergeUserContact = [];
  bool _isRequesting = false;
  TextEditingController searchContactcontroller= TextEditingController();
  bool searching = false;
  String nameSearch= '';
  bool _isFinish = false;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextEditingController = TextEditingController();
  TextEditingController searchController= TextEditingController();
  Timer? _debounce;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
  List fBPhone=[];
  List contactsAll=[];
  List<Contact> contacts = [];
  List contacts1 = [];
  List contacts2 = [];
  List<String> contactNames = [];

  int conLen=0;

  List contactNumber = [];
  List contactName = [];

  Map <String,String> conMap = Map();

  List conNames=[];
  List conId=[];

  bool isLoading = false;
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
    if ( searchController.text.isNotEmpty){
      _contact.retainWhere( (contact){
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();
        return contactName.contains(searchTerm);
      });
      setState(() {

        filteredContacts=_contact;
        for(var i=0; i<filteredContacts.length; i++){
          print(filteredContacts[i].displayName);
          listData = filteredContacts[i].displayName;
        }
      });
    }
  }
  initData(){

  }
  @override
  void initState() {
    _getUID();
    getDataList();
    // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
    userChatList(searchQuery: searchTextEditingController.text);
    _contacts = getContacts();

    searchController.addListener(() {
      filterContacts();
    });
    // } else if (widget.state == 5) {
    //   newParticipantSearch(searchQuery: searchTextEditingController.text);
    // }
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
    scrollController.dispose();
    super.dispose();
  }
  // Future newParticipantSearch({required String searchQuery, int limit = 50}) async {
  //   if (!_isRequesting && !_isFinish) {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot;
  //     _isRequesting = true;
  //     //* as per firestore "You can't order your query by a field included in an equality (==) or in clause."
  //     //* so i think we can use orderby to sort by name
  //     if (body.isEmpty) {
  //       querySnapshot = await instance
  //           .collection("user-detail")
  //           .where("name", isGreaterThanOrEqualTo: searchQuery)
  //           .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
  //           .orderBy("name")
  //           .limit(limit)
  //           .get();
  //     } else {
  //       querySnapshot = await instance
  //           .collection("user-detail")
  //           .where("name", isGreaterThanOrEqualTo: searchQuery)
  //           .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
  //           .orderBy("name")
  //           .startAfterDocument(body[body.length - 1])
  //           .limit(limit)
  //           .get();
  //     }
  //     if (querySnapshot != null && querySnapshot.docs.first.id != body.last.id) {
  //       if (!mounted) return;
  //       setState(() {
  //         body.addAll(querySnapshot.docs);
  //       });
  //       if (querySnapshot.docs.length < limit) {
  //         _isFinish = true;
  //       }
  //     }
  //     _isRequesting = false;
  //   }
  // }
  // //FIXME.. only user can search accepted group
  // Future groupChatList({required String searchQuery, int limit = 50}) async {
  //   if (!_isRequesting && !_isFinish) {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot;
  //     _isRequesting = true;
  //     if (body.isEmpty) {
  //       querySnapshot = await instance

  //           .collection("group-detail")
  //           .where("title", isGreaterThanOrEqualTo: searchQuery)
  //           .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff')
  //           .orderBy("title")
  //           .limit(limit)
  //           .get();
  //     } else {
  //       querySnapshot = await instance
  //           .collection("group-detail")
  //           .where("title", isGreaterThanOrEqualTo: searchQuery)
  //           .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff')
  //           .orderBy("title")
  //           .startAfterDocument(body[body.length - 1])
  //           .limit(limit)
  //           .get();
  //     }
  //     if (querySnapshot != null) {
  //       if (!mounted) return;
  //       setState(() {
  //         body.addAll(querySnapshot.docs);
  //       });
  //       if (querySnapshot.docs.length < limit) {
  //         _isFinish = true;
  //       }
  //     }
  //     _isRequesting = false;
  //   }
  // }
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

  @override
  Widget build(BuildContext context) {

    bool isSearching = searchController.text.isNotEmpty;

    return SafeArea(
      child: StreamBuilder(
          stream: Stream.value(getDataList()),
          builder: (context, _) {
            return ResponsiveBuilder(builder: (context, sizingInformation) {
              //    print('Lotus6${filteredContacts.elementAt(0).phones}');


              return Scaffold(
                resizeToAvoidBottomInset: false,
                floatingActionButton: (widget.state == 4 || widget.state == 5)
                    ? FloatingActionButton(
                  onPressed: () async {
                    if (groupMemberList.isNotEmpty && memberList.isNotEmpty) {
                      print("ML : ${memberList}");
                      print("The GroupList : ${groupMemberList}");
                      print("GroupList Count : ${groupMemberList.length}");
                      var listToSet = groupMemberList.toSet();
                      var listToSet1 = memberList.toSet();
                      print("List of list to set ${listToSet1}");
                      print("Count of list to set ${listToSet1.length}");
                      if (widget.state == 4) {
                        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                          print("Create Group came to if");
                          return await scaffoldAlertDialogBox(context: context,
                              page: CreateGroup(memberlist: listToSet1.toList(), members: listToSet.toList(), uid: uid.toString(),));
                        } else {
                          print("Create Group came to if");
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  CreateGroup(memberlist: listToSet1.toList(), members: listToSet.toList(),uid: uid.toString())));
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
                    else{
                      print("GML : ${groupMemberList}");
                      print("group list len : ${groupMemberList.length}");
                      print("The if condition is Not working came to else");
                    }
                  },
                  child: Icon(Icons.done),
                ) : null,
                body: NestedScrollView(
                  controller: scrollController,
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (BuildContext context,
                      bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context)
                      )
                    ];
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
                          // }
                          // else if (widget.state == 1) {
                          //   this.groupChatList(searchQuery: searchTextEditingController.text);
                          // }
                          // else if (widget.state == 5) {
                          //   this.newParticipantSearch(searchQuery: searchTextEditingController.text);
                          // }
                          if (!mounted) return false;
                          setState(() {
                            isLoading = false;
                          });
                        }
                        print("constant:${contactNumber.isNotEmpty}");
                        return true;
                      },
                      child: (contactNumber.isNotEmpty)
                          ? Column(
                        children: [
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
                                        // : (widget.state == 1)
                                        //     ? "Search Group Name"
                                        //     : (widget.state == 4)
                                        //     ? (memberList.isEmpty)
                                        //     ? "Select contact"
                                        //     : "${memberList.length}/49 Selected"
                                        //     : (widget.state == 5)
                                        //     ? "${memberList.length +
                                        //     widget.participants!.length}/50 Selected"
                                        //     : (widget.state == 6)
                                        //     ? "Search Account"
                                        //     : (widget.state == 7)
                                        //     ? "Search Participant"
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
                                      onSelected: (value) {
                                        switch (value) {
                                          case 1:
                                            {

                                            }
                                            break;
                                          default:
                                        }
                                      },
                                      itemBuilder: (context) =>
                                      [
                                        PopupMenuItem(
                                          child: Text("Refresh",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                              fontSize:12.sp,color:Colors.black))),

                                          value: 1,
                                        ),PopupMenuItem(child:Text("Help",style:GoogleFonts.inter(textStyle:TextStyle(fontWeight:FontWeight.w400,
                                          fontSize:12.sp,color:Colors.black))))
                                      ]),
                                  SizedBox(width:6.w),
                                ]):searchBar(),
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: ListView.builder(
                                itemCount: contactNumber.length,
                                itemBuilder: (context, index) {
                                  var name = contactName[index];
                                  if(nameSearch.isEmpty){
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10,left:20.w,right:20.w),
                                      child: ListTile(
                                        trailing: ((widget.state == 4 || widget.state == 5) && memberList.contains(conMap[contactNumber[index]])) ? Icon(Icons.done) : SizedBox(),
                                        onTap: () async {
                                          switch (widget.state) {
                                            case 0:
                                              {
                                                if (widget.sizingInformation.deviceScreenType ==
                                                    DeviceScreenType.desktop) {
                                                  Navigator.pop(context, conMap[contactNumber[index]].toString());
                                                } else {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
                                                                state: 0,
                                                                uid: uid.toString(),
                                                                puid: conMap[contactNumber[index]].toString(),
                                                              )));
                                                }
                                              }
                                              break;

                                            case 1:
                                              {
                                                if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                                  Navigator.pop(context, conMap[contactNumber[index]].toString());
                                                } else {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ChatPage(
                                                            state: 1,
                                                            uid: uid.toString(),
                                                            puid: conMap[contactNumber[index]].toString(),
                                                          )));
                                                }
                                              }
                                              break;

                                            case 4:
                                              {

                                                if (!memberList.contains(conMap[contactNumber[index]])) {
                                                  print("its entered to case : 4.....");
                                                  if (groupMemberList.length <= 49 && !groupMemberList.contains(conMap[contactNumber[index]])) {
                                                    print("Not Containes");
                                                    if (!mounted) return;

                                                    setState(() {
                                                      memberList.add(conMap[contactNumber[index]].toString());

                                                      for(int x=0;x<body.length;x++) {
                                                        if (body[x]["uid"] == conMap[contactNumber[index]] && !groupMemberList.contains(body[x].data())) {
                                                          print("Came to the Adding Group Action...");
                                                          groupMemberList.add(body[x].data());
                                                          memberList.add(conMap[contactNumber[index]]!);
                                                          print("The New print of groupList : ${groupMemberList}");
                                                          print("Data of the Body => ${body[x].data()}");
                                                          print("SELTEST : ${conMap[contactNumber[index]].toString()}==${body[x]["uid"]}");
                                                        }
                                                        else{
                                                          print("The Uid is not match with ---- Group member list..!");
                                                        }
                                                      }

                                                      print("MBList: ${memberList}");
                                                      print("Count of MBList: ${memberList.length}");
                                                      print("GPList : ${groupMemberList}");
                                                      print("Count of GPList : ${groupMemberList.length}");
                                                    });

                                                  }
                                                  else {
                                                    final snackBar = snackbar(
                                                        content: "Group can contain only 50 members");
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  }
                                                }
                                                else {
                                                  print("Came to remove from group");
                                                  // if (!mounted) return
                                                  // setState(() {
                                                  //   memberList.remove(conMap[contactNumber[index]].toString());
                                                  //   groupMemberList.remove(conMap[contactNumber[index]].toString());
                                                  // });

                                                  if (!mounted) return;

                                                  setState(() {
                                                    print("B4 MBList in remove: ${memberList}");
                                                    print("B4 Count of MBList in remove : ${memberList.length}");
                                                    print("B4 GPList in remove : ${groupMemberList}");
                                                    print("B4 Count of GPList in remove : ${groupMemberList.length}");
                                                    memberList.remove(conMap[contactNumber[index]].toString());

                                                    for(int x=0;x<body.length;x++) {
                                                      print("loop is worked in remove list");
                                                      if (body[x]["uid"] == conMap[contactNumber[index]] && !groupMemberList.contains(body[x].data())) {
                                                        print("Came to the remove Group Action...");
                                                        groupMemberList.remove(body[x].data());
                                                        memberList.remove(conMap[contactNumber[index]]!);
                                                        print("The remove New print of groupList : ${groupMemberList}");
                                                        print("Data of the Body => ${body[x].data()}");
                                                        print("SELTEST : ${conMap[contactNumber[index]].toString()}==${body[x]["uid"]}");
                                                      }
                                                      else{
                                                        print("The Uid is not match with ---- Group member list..!");
                                                      }
                                                    }

                                                    print("MBList in remove: ${memberList}");
                                                    print("Count of MBList in remove : ${memberList.length}");
                                                    print("GPList in remove : ${groupMemberList}");
                                                    print("Count of GPList in remove : ${groupMemberList.length}");
                                                  });

                                                }
                                              }
                                              break;
                                            case 5:
                                              {
                                                if (!memberList.contains(conMap[contactNumber[index]])) {
                                                  print("its entered to case : 4.....");
                                                  if (groupMemberList.length <= 49 && !groupMemberList.contains(conMap[contactNumber[index]])) {
                                                    print("Not Containes");
                                                    if (!mounted) return;

                                                    setState(() {
                                                      memberList.add(conMap[contactNumber[index]].toString());

                                                      for(int x=0;x<body.length;x++) {
                                                        if (body[x]["uid"] == conMap[contactNumber[index]] && !groupMemberList.contains(body[x].data())) {
                                                          print("Came to the Adding Group Action...");
                                                          groupMemberList.add(body[x].data());
                                                          memberList.add(conMap[contactNumber[index]]!);
                                                          print("The New print of groupList : ${groupMemberList}");
                                                          print("Data of the Body => ${body[x].data()}");
                                                          print("SELTEST : ${conMap[contactNumber[index]].toString()}==${body[x]["uid"]}");
                                                        }
                                                        else{
                                                          print("The Uid is not match with ---- Group member list..!");
                                                        }
                                                      }

                                                      print("MBList: ${memberList}");
                                                      print("Count of MBList: ${memberList.length}");
                                                      print("GPList : ${groupMemberList}");
                                                      print("Count of GPList : ${groupMemberList.length}");
                                                    });

                                                  }
                                                  else {
                                                    final snackBar = snackbar(
                                                        content: "Group can contain only 50 members");
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  }
                                                }
                                                else {
                                                  print("Came to remove from group");
                                                  // if (!mounted) return
                                                  // setState(() {
                                                  //   memberList.remove(conMap[contactNumber[index]].toString());
                                                  //   groupMemberList.remove(conMap[contactNumber[index]].toString());
                                                  // });

                                                  if (!mounted) return;

                                                  setState(() {
                                                    print("B4 MBList in remove: ${memberList}");
                                                    print("B4 Count of MBList in remove : ${memberList.length}");
                                                    print("B4 GPList in remove : ${groupMemberList}");
                                                    print("B4 Count of GPList in remove : ${groupMemberList.length}");
                                                    memberList.remove(conMap[contactNumber[index]].toString());

                                                    for(int x=0;x<body.length;x++) {
                                                      print("loop is worked in remove list");
                                                      if (body[x]["uid"] == conMap[contactNumber[index]] && !groupMemberList.contains(body[x].data())) {
                                                        print("Came to the remove Group Action...");
                                                        groupMemberList.remove(body[x].data());
                                                        memberList.remove(conMap[contactNumber[index]]!);
                                                        print("The remove New print of groupList : ${groupMemberList}");
                                                        print("Data of the Body => ${body[x].data()}");
                                                        print("SELTEST : ${conMap[contactNumber[index]].toString()}==${body[x]["uid"]}");
                                                      }
                                                      else{
                                                        print("The Uid is not match with ---- Group member list..!");
                                                      }
                                                    }

                                                    print("MBList in remove: ${memberList}");
                                                    print("Count of MBList in remove : ${memberList.length}");
                                                    print("GPList in remove : ${groupMemberList}");
                                                    print("Count of GPList in remove : ${groupMemberList.length}");
                                                  });

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
                                                if (contactNumber[index]["token"] != null) {
                                                  if (contactNumber[index]["callStatus"] == false) {
                                                    FirebaseFirestore instance = FirebaseFirestore.instance;
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>> userDoc = await instance
                                                        .collection("call-logs").doc(widget.gid!).get();
                                                    if (userDoc.exists) {
                                                      await sendNotificationForCall(
                                                          userTokens: [contactNumber[index]["token"]],
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
                                                          uid: contactNumber[index]["uid"],
                                                          userDetailDoc: contactNumber[index]);
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
                                        contentPadding: EdgeInsets.only(left: 0),
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage("assets/noProfile.jpg"),
                                          radius: 25.w,
                                        ),
                                        title: SubstringHighlight(text:name,
                                          textStyle: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  color:Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                          textStyleHighlight:TextStyle(color:Colors.black),
                                          term:searchContactcontroller.text,),
                                      ),
                                    );
                                  }
                                  if(name.toString().toLowerCase().contains(nameSearch.toLowerCase())){
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        trailing: ((widget.state == 4 || widget.state == 5) && memberList.contains(conMap[contactNumber[index]])) ? Icon(Icons.done) : SizedBox(),
                                        onTap: () async {
                                          switch (widget.state) {
                                            case 0:
                                              {
                                                if (widget.sizingInformation.deviceScreenType ==
                                                    DeviceScreenType.desktop) {
                                                  Navigator.pop(context, conMap[contactNumber[index]].toString());
                                                } else {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
                                                                state: 0,
                                                                uid: uid.toString(),
                                                                puid: conMap[contactNumber[index]].toString(),
                                                              )));
                                                }
                                              }
                                              break;

                                            case 1:
                                              {
                                                if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                                  Navigator.pop(context, conMap[contactNumber[index]].toString());
                                                } else {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ChatPage(
                                                            state: 1,
                                                            uid: uid.toString(),
                                                            puid: conMap[contactNumber[index]].toString(),
                                                          )));
                                                }
                                              }
                                              break;

                                            case 4:
                                              {

                                                print(body[0].data());
                                                print("Body Data: ${body[index].data()["name"]}");
                                                print("con check ${conMap[contactNumber[index]]}");
                                                print("member list before${memberList}");
                                                print("member list count before ${memberList.length}");
                                                print("groupmember list before${memberList}");
                                                print("groupmember list count before${groupMemberList.length}");
                                                print("CheckTest : ${memberList.contains(conMap[contactNumber[index]].toString())}");
                                                print("CheckTest : ${memberList.contains(conMap[contactNumber[index]].toString())==false}");

                                                if (!memberList.contains(conMap[contactNumber[index]])) {
                                                  if (groupMemberList.length <= 49) {
                                                    if (!mounted) return;
                                                    print("GP Member : ${memberList}");
                                                    print("GP Member : ${groupMemberList}");
                                                    setState(() {
                                                      memberList.add(conMap[contactNumber[index]].toString());

                                                      for(int x=0;x<body.length;x++) {
                                                        print(
                                                            "${body[x]["uid"]} index $x");
                                                        if (body[x]["uid"]
                                                            .toString() ==
                                                            conMap[contactNumber[index]]
                                                                .toString()) {
                                                          groupMemberList.add(body[x].data());
                                                          print("SELTEST : ${conMap[contactNumber[index]].toString()}==${body[x]["uid"]}");
                                                        }
                                                      }
                                                      print("SELTEST : ${conMap[contactNumber[index]].toString()}==${body[index]["uid"]}");
                                                      print("GP Member : ${memberList}");
                                                      print("GP Member : ${groupMemberList}");
                                                    });
                                                    print("member list ${memberList}");
                                                    print("member list count ${memberList.length}");
                                                  } else {
                                                    final snackBar = snackbar(
                                                        content: "Group can contain only 50 members");
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  }
                                                } else {
                                                  if (!mounted) return;
                                                  setState(() {
                                                    memberList.remove(conMap[contactNumber[index]].toString());
                                                    groupMemberList.remove(conMap[contactNumber[index]].toString());
                                                  });
                                                }
                                              }
                                              break;
                                            case 5:
                                              {
                                                if (!widget.participants!.contains(conMap[contactNumber[index]].toString())) {
                                                  if (memberList.contains(conMap[contactNumber[index]].toString()) == false) {
                                                    if ((groupMemberList.length +
                                                        widget.participants!.length) <= 50) {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        memberList.add(conMap[contactNumber[index]].toString());
                                                        groupMemberList.add(contactNumber[index]);
                                                      });
                                                    } else {
                                                      final snackBar = snackbar(
                                                          content: "Group can contain only 50 members");
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    }
                                                  } else {
                                                    if (!mounted) return;
                                                    setState(() {
                                                      memberList.remove(conMap[contactNumber[index]]);
                                                      groupMemberList.remove(conMap[contactNumber[index]]);
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
                                                if (contactNumber[index]["token"] != null) {
                                                  if (contactNumber[index]["callStatus"] == false) {
                                                    FirebaseFirestore instance = FirebaseFirestore.instance;
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>> userDoc = await instance
                                                        .collection("call-logs").doc(widget.gid!).get();
                                                    if (userDoc.exists) {
                                                      await sendNotificationForCall(
                                                          userTokens: [contactNumber[index]["token"]],
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
                                                          uid: contactNumber[index]["uid"],
                                                          userDetailDoc: contactNumber[index]);
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
                                        contentPadding: EdgeInsets.only(left: 0),
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage("assets/noProfile.jpg"),
                                          radius: 25.w,
                                        ),
                                        title: SubstringHighlight(text:name,
                                          textStyle: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  color:Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                          textStyleHighlight:TextStyle(color:Colors.black),
                                          term:searchContactcontroller.text,),
                                      ),
                                    );
                                  }
                                  return Container(); }),
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
            onChanged: ( value) {
              setState(() {
                nameSearch=value;
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