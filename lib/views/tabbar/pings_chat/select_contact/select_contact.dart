import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'button_card.dart';
import 'contact_card.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  int chng = 0;
  List<SelectContactModel> contacts = [
    SelectContactModel(
        dp: 'assets/select_contact/new group.svg',
        isSelected: false,
        name: 'New group',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/select_contact/new contact.svg',
        isSelected: false,
        name: 'New contact',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/select_contact/invite friends.svg',
        isSelected: false,
        name: 'Invite friends',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    SelectContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
  ];

  // List tileData = [];
  // @override
  // void initState() {
  //   super.initState();
  //   tileData = selectInfoListData();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:chng==0

      ? AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
            left: 13.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: Image(
                  image: AssetImage(
                    'assets/per_chat_icons/back_icon.png',
                  ),
                  width: 20.w,
                ),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Group_Info()));
                },
              ),
            ],
          ),
        ),
        centerTitle: false,
        titleSpacing: -3.5.w,
        title: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 7.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Select contact',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
              SizedBox(height: 3.h),
              Text(
                '260 contacts',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 17.h, bottom: 15.h),
            child: Row(
              children: [
                InkWell(
                  child: Image.asset('assets/group_info/search.png'),
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                ),
                SizedBox(
                  width: 18.w,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: PopupMenuButton(
                      child: Icon(
                        Icons.more_vert_outlined,
                        color: Colors.black,
                      ),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Refresh",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(0, 0, 0, 1))),
                              ),
                            )),
                            PopupMenuItem(
                                child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Help",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(0, 0, 0, 1))),
                              ),
                            )),
                          ]),
                ),
              ],
            ),
          ),
        ],
      ) :AppBar(
centerTitle: false,
      title:  Row(
          children: [
            InkWell(
              child: Image(
                image: AssetImage(
                  'assets/per_chat_icons/back_icon.png',
                ),
                width: 16.w,
              ),
              onTap: () {},
            ),
            SizedBox(width: 29.w,),
            Container(
              height: 40.h,
              width: 285.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromRGBO(255, 255, 255, 1)
                // color: Colors.blue,
              ),
              child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 14,bottom: 2),
                      border: InputBorder.none
                  )
              ),
            )
          ],
        ),
      ),

              //: AppBar(
      //  leading: InkWell(
      //     child: Image(
      //       image: AssetImage(
      //         'assets/per_chat_icons/back_icon.png',
      //       ),
      //       width: 20.w,
      //     ),
      //     onTap: () {
      //
      //     },
      //   ),
      //   title:Container(
      //     height: 50.h,
      //     width: 250.w,
      //     decoration:BoxDecoration(
      //       color: Color.fromRGBO(255, 255, 255, 1),
      //       borderRadius: BorderRadius.circular(50)
      //     ),
      //
      //   ) ,
      // ),
      body: Container(
        padding: EdgeInsets.only(top: 5),
        color: Colors.white,
        child: Expanded(
          child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                // return ContactCard(contacts:contacts[index] );
                if (index == 0) {
                  return ButtonCard(contacts: contacts[index]);
                } else if (index == 1) {
                  return ButtonCard(contacts: contacts[index]);
                } else if (index == 2) {
                  return ButtonCard(contacts: contacts[index]);
                } else {
                  return ContactCard(contacts: contacts[index]);
                }
              }),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchContents = [
    'Apple',
    'Banana',
    'Watermelon',
    ' Grapes',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.account_balance))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.account_tree));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchContents) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchContents) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }
}
