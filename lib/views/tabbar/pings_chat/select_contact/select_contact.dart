// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
// import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact_model.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'button_card.dart';
// import 'contact_card.dart';
//
// class SelectContact extends StatefulWidget {
//   const SelectContact({Key? key}) : super(key: key);
//
//   @override
//   State<SelectContact> createState() => _SelectContactState();
// }
//
// class _SelectContactState extends State<SelectContact> {
//   int chng = 0;
//   List<SelectContactModel> contacts = [
//     SelectContactModel(
//         dp: 'assets/select_contact/new group.svg',
//         isSelected: false,
//         name: 'New group',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/select_contact/new contact.svg',
//         isSelected: false,
//         name: 'New contact',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/select_contact/invite friends.svg',
//         isSelected: false,
//         name: 'Invite friends',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//     SelectContactModel(
//         dp: 'assets/per_chat_icons/dp_image.svg',
//         isSelected: false,
//         name: 'Elumalai',
//         account: 'Business account'),
//   ];
//
//   // List tileData = [];
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   tileData = selectInfoListData();
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:chng==0
//
//       ? AppBar(
//         leading: Padding(
//           padding: EdgeInsets.only(
//             left: 13.w,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               InkWell(
//                 child: Image(
//                   image: AssetImage(
//                     'assets/per_chat_icons/back_icon.png',
//                   ),
//                   width: 20.w,
//                 ),
//                 onTap: () {
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => Group_Info()));
//                 },
//               ),
//             ],
//           ),
//         ),
//         centerTitle: false,
//         titleSpacing: -3.5.w,
//         title: Padding(
//           padding: EdgeInsets.only(top: 10.h, bottom: 7.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                 'Select contact',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black)),
//               ),
//               SizedBox(height: 3.h),
//               Text(
//                 '260 contacts',
//                 style: GoogleFonts.inter(
//                     textStyle: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black)),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(top: 17.h, bottom: 15.h),
//             child: Row(
//               children: [
//                 InkWell(
//                   child: Image.asset('assets/group_info/search.png'),
//                   onTap: () {
//                     showSearch(
//                       context: context,
//                       delegate: CustomSearchDelegate(),
//                     );
//                   },
//                 ),
//                 SizedBox(
//                   width: 18.w,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 12),
//                   child: PopupMenuButton(
//                       child: Icon(
//                         Icons.more_vert_outlined,
//                         color: Colors.black,
//                       ),
//                       itemBuilder: (context) => [
//                             PopupMenuItem(
//                                 child: Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: Text(
//                                 "Refresh",
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                             )),
//                             PopupMenuItem(
//                                 child: Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: Text(
//                                 "Help",
//                                 style: GoogleFonts.inter(
//                                     textStyle: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color.fromRGBO(0, 0, 0, 1))),
//                               ),
//                             )),
//                           ]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ) :AppBar(
// centerTitle: false,
//       title:  Row(
//           children: [
//             InkWell(
//               child: Image(
//                 image: AssetImage(
//                   'assets/per_chat_icons/back_icon.png',
//                 ),
//                 width: 16.w,
//               ),
//               onTap: () {},
//             ),
//             SizedBox(width: 29.w,),
//             Container(
//               height: 40.h,
//               width: 285.w,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: Color.fromRGBO(255, 255, 255, 1)
//                 // color: Colors.blue,
//               ),
//               child: TextFormField(
//                   decoration: InputDecoration(
//                       contentPadding: EdgeInsets.only(left: 14,bottom: 2),
//                       border: InputBorder.none
//                   )
//               ),
//             )
//           ],
//         ),
//       ),
//
//               //: AppBar(
//       //  leading: InkWell(
//       //     child: Image(
//       //       image: AssetImage(
//       //         'assets/per_chat_icons/back_icon.png',
//       //       ),
//       //       width: 20.w,
//       //     ),
//       //     onTap: () {
//       //
//       //     },
//       //   ),
//       //   title:Container(
//       //     height: 50.h,
//       //     width: 250.w,
//       //     decoration:BoxDecoration(
//       //       color: Color.fromRGBO(255, 255, 255, 1),
//       //       borderRadius: BorderRadius.circular(50)
//       //     ),
//       //
//       //   ) ,
//       // ),
//       body: Container(
//         padding: EdgeInsets.only(top: 5),
//         color: Colors.white,
//         child: Expanded(
//           child: ListView.builder(
//               itemCount: contacts.length,
//               itemBuilder: (context, index) {
//                 // return ContactCard(contacts:contacts[index] );
//                 if (index == 0) {
//                   return ButtonCard(contacts: contacts[index]);
//                 } else if (index == 1) {
//                   return ButtonCard(contacts: contacts[index]);
//                 } else if (index == 2) {
//                   return ButtonCard(contacts: contacts[index]);
//                 } else {
//                   return ContactCard(contacts: contacts[index]);
//                 }
//               }),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomSearchDelegate extends SearchDelegate {
//   List<String> searchContents = [
//     'Apple',
//     'Banana',
//     'Watermelon',
//     ' Grapes',
//   ];
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(onPressed: () {}, icon: Icon(Icons.account_balance))];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(onPressed: () {}, icon: Icon(Icons.account_tree));
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var fruit in searchContents) {
//       if (fruit.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(fruit);
//       }
//     }
//     return ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(
//             title: Text(result),
//           );
//         });
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var fruit in searchContents) {
//       if (fruit.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(fruit);
//       }
//     }
//     return ListView.builder(
//         itemCount: matchQuery.length,
//         itemBuilder: (context, index) {
//           var result = matchQuery[index];
//           return ListTile(
//             title: Text(result),
//           );
//         });
//   }
// }


//------------------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../Authentication/Authentication.dart';
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
import '../../../ContactList.dart';
import '../../chats/group_personal_screen/test_code2/CreateGroup.dart';
import '../../chats/personal_chat_screen/ChatPage.dart';

class SearchPage extends StatefulWidget {
  //state ==1 is not possible..
  ///* 0->personal chat,1->group chat,2->personal call,3->group call,4->create group,5->add group participants,6->story search,7->add call participants

  final int state;
  final SizingInformation sizingInformation;
  final String? gid;
  final List<String>? participants;
  final bool video;
  final String? channelName;
  const SearchPage({Key? key, required this.state, required this.sizingInformation, this.gid, this.participants, this.video = false, this.channelName}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isRequesting = false;
  bool _isFinish = false;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextEditingController = TextEditingController();
  Timer? _debounce;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
  bool isLoading = false;
  List<Map<String, dynamic>> groupMemberList = [];
  // List<String> groupMemberList = [];
  String uid =  getUID();
  List<String> memberList = [];

  @override
  void initState() {
    // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
    userChatList(searchQuery: searchTextEditingController.text);
    // } else if (widget.state == 5) {
    //   newParticipantSearch(searchQuery: searchTextEditingController.text);
    // }
    super.initState();
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
            .where("name", isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name", isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery + '\uf8ff')
            .orderBy("name")
            .limit(limit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("user-detail")
            .where("name", isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name", isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery + '\uf8ff')
            .orderBy("name")
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: (widget.state == 4 || widget.state == 5)
              ? FloatingActionButton(
            onPressed: () async {
              if (groupMemberList.isNotEmpty && memberList.isNotEmpty) {
                if (widget.state == 4) {
                  if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                    return await scaffoldAlertDialogBox(context: context, page: CreateGroup(members: groupMemberList));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup(members: groupMemberList)));
                  }
                } else if (widget.state == 5) {
                  WriteBatch writeBatch = instance.batch();
                  writeBatch.set(
                      instance.collection("group-detail").doc(widget.gid),
                      {
                        "members": addGroupMembersMap(members: groupMemberList),
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
              : null,
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
                ? null
                : [
              PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ContactList(state: 0)));
                        }
                        break;
                      default:
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Invite a friend"),
                      value: 1,
                    ),
                  ])
            ],
            title: Text(
              (widget.state == 0)
                  ? "Search Contact Name"
              // : (widget.state == 1)
              //     ? "Search Group Name"
                  : (widget.state == 4)
                  ? (memberList.isEmpty)
                  ? "Search Contact Name"
                  : "${memberList.length}/49 Selected"
                  : (widget.state == 5)
                  ? "${memberList.length + widget.participants!.length}/50 Selected"
                  : (widget.state == 6)
                  ? "Search Account"
                  : (widget.state == 7)
                  ? "Search Participant"
                  : "",
              style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
          body: NestedScrollView(
            controller: scrollController,
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    centerTitle: false,
                    floating: true,
                    pinned: false,
                    snap: true,
                    forceElevated: innerBoxIsScrolled,
                    automaticallyImplyLeading: false,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(30.0),
                      child: Text(''),
                    ),
                    flexibleSpace: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: textField(
                            textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14)),
                            border: false,
                            textEditingController: searchTextEditingController,
                            hintText: (widget.state == 0)
                                ? "Search Contact"
                            // : (widget.state == 1)
                            //     ? "Search Group"
                                : (widget.state == 4)
                                ? "Search Members"
                                : (widget.state == 5)
                                ? "Search Members"
                                : (widget.state == 6)
                                ? "Search Account"
                                : (widget.state == 7)
                                ? "Search Participant"
                                : "",
                            hintStyle: GoogleFonts.poppins(textStyle: textStyle(color: Color(grey))),
                            onChanged: (value) async {
                              if (_debounce?.isActive ?? false) _debounce?.cancel();
                              _debounce = Timer(const Duration(milliseconds: 100), () async {
                                body.clear();
                                _isRequesting = false;
                                _isFinish = false;
                                // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
                                return await userChatList(searchQuery: value);
                                // }
                                // else if (widget.state == 1) {
                                //   return await groupChatList(searchQuery: value);
                                // }
                                // else if (widget.state == 5) {
                                //   return await newParticipantSearch(searchQuery: value);
                                // }
                              });
                            },
                            onSubmitted: (value) async {
                              body.clear();
                              _isRequesting = false;
                              _isFinish = false;
                              // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
                              return await userChatList(searchQuery: value);
                              // }
                              // else if (widget.state == 1) {
                              //   return await groupChatList(searchQuery: value);
                              // }
                              // else if (widget.state == 5) {
                              // return await newParticipantSearch(searchQuery: value);
                              // }
                            },
                            suffixIcon: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onPressed: () async {
                                body.clear();
                                _isRequesting = false;
                                _isFinish = false;
                                // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
                                return await userChatList(searchQuery: searchTextEditingController.text);
                                // }
                                // else if (widget.state == 1) {
                                //   return await groupChatList(searchQuery: searchTextEditingController.text);
                                // }
                                // else if (widget.state == 5) {
                                //   return await newParticipantSearch(searchQuery: searchTextEditingController.text);
                                // }
                              },
                              icon: Icon(
                                Icons.search,
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                )
              ];
            },
            body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if ((isLoading == false && notification.metrics.axisDirection == AxisDirection.down && notification.metrics.pixels == notification.metrics.maxScrollExtent) ==
                      true) {
                    if (!mounted) return false;
                    setState(() {
                      isLoading = true;
                    });
                    // if (widget.state == 0 || widget.state == 4 || widget.state == 6) {
                    this.userChatList(searchQuery: searchTextEditingController.text);
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
                  return true;
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: (body.isNotEmpty)
                      ? Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            // if (widget.state == 0 || widget.state == 4 || widget.state == 5 || widget.state == 6) {
                            if (uid != body[index].data()["uid"]) {
                              return Divider(
                                thickness: 1,
                                // height: 1,
                                color: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
                              );
                            } else {
                              return Container();
                            }
                            // } else {
                            //   return Divider(
                            //     // thickness: 1,
                            //     height: 1,
                            //     color: (themedata.value.index == 0) ? Color(lightGrey) : Color(lightBlack),
                            //   );
                            // }
                          },
                          itemCount: body.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (widget.state == 0 || widget.state == 6) {
                              return buildItem(
                                  pic: (body[index].data()["pic"] != null) ? body[index].data()["pic"] : null,
                                  name: body[index].data()["name"],
                                  id: body[index].data()["uid"]);
                            }
                            // else if (widget.state == 1) {
                            //   return buildItem(
                            //       pic: (body[index].data()["pic"] != null) ? body[index].data()["pic"] : null,
                            //       name: body[index].data()["title"],
                            //       id: body[index].data()["gid"]);
                            // }
                            else if (widget.state == 4 || widget.state == 5 || widget.state == 7) {
                              return buildItem(
                                  pic: (body[index].data()["pic"] != null) ? body[index].data()["pic"] : null,
                                  name: body[index].data()["name"],
                                  id: body[index].data()["uid"],
                                  document: body[index].data());
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        height: (isLoading == true) ? 20.0 : 0,
                        color: Colors.transparent,
                        child: Center(
                          child: new LinearProgressIndicator(
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
                                Text((widget.state == 0 || widget.state == 4 || widget.state == 5 || widget.state == 7)
                                    ? "No Contacts"
                                    : (widget.state == 6)
                                    ? "No Account"
                                    : "")
                              ],
                            ),
                          ))),
                )),
          ),
        );
      }),
    );
  }

  Widget buildItem({required String? pic, required String name, required String id, Map<String, dynamic>? document}) {
    if (uid == id) {
      return Container();
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          switch (widget.state) {
            case 0:
              {
                if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                  Navigator.pop(context, id);
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                            state: 0,
                            uid: getUID(),
                            puid: id,
                          )));
                }
              }
              break;

          // case 1:
          //   {
          //     if (widget.sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          //       Navigator.pop(context, id);
          //     } else {
          //       Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => ChatPage(
          //                     state: 1,
          //                     uid: getUID(),
          //                     puid: id,
          //                   )));
          //     }
          //   }
          //   break;

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
                    final snackBar = snackbar(content: "Group can contain only 50 members");
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
                    if ((groupMemberList.length + widget.participants!.length) <= 50) {
                      if (!mounted) return;
                      setState(() {
                        memberList.add(id);
                        groupMemberList.add(document!);
                      });
                    } else {
                      final snackBar = snackbar(content: "Group can contain only 50 members");
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
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => UserDetails(
                //           uid: id,
                //         )));
              }
              break;
            case 7:
              {
                if (document!["token"] != null) {
                  if (document["callStatus"] == false) {
                    FirebaseFirestore instance = FirebaseFirestore.instance;
                    DocumentSnapshot<Map<String, dynamic>> userDoc = await instance.collection("call-logs").doc(widget.gid!).get();
                    if (userDoc.exists) {
                      await sendNotificationForCall(
                          userTokens: [document["token"]],
                          id: widget.channelName!,
                          timestamp: widget.gid!,
                          video: widget.video,
                          phoneNumber: userDoc.data()!["callerId"],
                          pic: userDoc.data()!["members"]["${userDoc.data()!["channelId"]}"]["pic"],
                          state: 0,
                          name: userDoc.data()!["members"]["${userDoc.data()!["channelId"]}"]["name"]);
                      await UpdateWriteLog(documentId: widget.gid!, uid: document["uid"], userDetailDoc: document);
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
                            : Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                      )),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (widget.state == 5 && widget.participants!.contains(id)) ? Icon(Icons.done_all) : Container(),
            ((widget.state == 4 || widget.state == 5) && memberList.contains(id)) ? Icon(Icons.done) : Container()
          ],
        ),
      );
    }
  }
}
