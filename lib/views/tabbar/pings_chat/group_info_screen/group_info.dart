

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:gatello/group_info_screen/participants.dart';
import 'package:gatello/views/tabbar/chats/personal_chat_screen/pesrsonal_chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

// import '../select_contact/contact_card.dart';
// import '../select_contact/select_contact.dart';
// import '../select_contact/contact_card.dart';

import 'button_card.dart';
import 'contact_card.dart';
import 'group_info_list_model.dart';

class Group_Info extends StatefulWidget {
  const Group_Info({Key? key}) : super(key: key);

  @override
  State<Group_Info> createState() => _Group_InfoState();
}

class _Group_InfoState extends State<Group_Info> {
  // List tileData = [];
  // @override
  // void initState() {
  //   super.initState();
  //   tileData = groupInfoListData();
  // }
  List<GroupContactModel> contacts = [
    GroupContactModel(
        dp: 'assets/select_contact/new group.svg',
        isSelected: false,
        name: 'New group',
        account: 'Business account'),
    GroupContactModel(
        dp: 'assets/select_contact/new contact.svg',
        isSelected: false,
        name: 'New contact',
        account: 'Business account'),
    GroupContactModel(
        dp: 'assets/select_contact/invite friends.svg',
        isSelected: false,
        name: 'Invite friends',
        account: 'Business account'),
    GroupContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    GroupContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    GroupContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),
    GroupContactModel(
        dp: 'assets/per_chat_icons/dp_image.svg',
        isSelected: false,
        name: 'Elumalai',
        account: 'Business account'),

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Color.fromRGBO(12, 16, 29, 1)),
          leading:
              //
              Padding(
            padding: EdgeInsets.only(left: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  child: Image(
                    image: AssetImage(
                      'assets/per_chat_icons/back_icon.png',
                    ),
                    width: 16.w,
                  ),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Group_Info()));
                  },
                ),
              ],
            ),
          ),
          centerTitle: false,
          titleSpacing: -1.w,
          title: Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 7.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Group Info',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
                SizedBox(height: 3.h),
                // Text(
                //   '260 Participants',
                //   style: GoogleFonts.inter(
                //       textStyle: TextStyle(
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black)),
                // ),
              ],
            ),
          ),

          //  actionsIconTheme: IconThemeData(color: Colors.black),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          padding: EdgeInsets.only(left: 20),
                          child: Container(
                            width: 130.w,
                            child: Text(
                              "Exit group",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(255, 0, 0, 1))),
                            ),
                          )),
                      PopupMenuItem(
                          padding: EdgeInsets.only(left: 20),
                          child: Container(
                            width: 130.w,
                            child: Text(
                              "Report group",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(255, 0, 0, 1))),
                            ),
                          )),
                    ]),
          ],
        ),

        body: Column(
          children: [
            Container(
             // color: Colors.brown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 260.h,
                    child: Column(
                      children: [
                        SizedBox(height: 23.h),

                        Container(
                          height: 70.h,
                          width: 80.w,
                          child: Stack(
                            children: [
                              Container(
                                height: 80.h,
                                width: 70.w,
                                child: SvgPicture.asset(
                                    'assets/per_chat_icons/dp_image.svg'),
                              ),
                              Positioned(
                                left: 56.w,
                                top: 10.h,
                                //  bottom: 10.h,
                                child: SvgPicture.asset(
                                    'assets/group_info/edit icon.svg'),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 120.h,
                        //   width: 120.w,
                        //   child: Stack(
                        //     children: [
                        //       SvgPicture.asset(
                        //           'assets/per_chat_icons/dp_image.svg'),
                        //       SvgPicture.asset(
                        //           'assets/per_chat_icons/dp_image.svg'),
                        //     ],
                        //   ),
                        //   decoration: BoxDecoration(shape: BoxShape.circle),
                        // ),
                        SizedBox(height: 11.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Name',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black)),
                            ),
SizedBox(width: 3.w,),
                            SvgPicture.asset(
                                'assets/group_info/edit icon.svg',width: 16.w,),
                          ],
                        ),
                        SizedBox(height: 19.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Image(
                                //   image: AssetImage(
                                //     'assets/group_info/calls.png',
                                //   ),
                                //   width: 42.w,
                                // ),
                                SvgPicture.asset(
                                    'assets/group_info/calls icon.svg'),

                                SizedBox(height: 11.h),
                                Text(
                                  'Call',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                            SizedBox(width: 42.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                    'assets/group_info/video image.svg'),
                                SizedBox(height: 11.h),
                                Text(
                                  'Video',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                            SizedBox(width: 42.w),
                            Column(
                              children: [
                                SvgPicture.asset(
                                    'assets/group_info/add contact.svg'),
                                SizedBox(height: 11.h),
                                Text(
                                  'Add',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                ),
                              ],
                            )
                          ],
                        ),
                       Spacer(),
                        Divider(
                            thickness: 0.1.w,
                            color: Colors.black,
                            indent: 12.w,
                            endIndent: 12.w),
                               Text('38 Participants', style:GoogleFonts.inter(
                                   textStyle: TextStyle(
                                       fontSize: 14.sp,
                                       fontWeight: FontWeight.w700,
                                       color: Color.fromRGBO(0, 163, 255, 1))), ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
       //  height: 465.h,
         //    width: 375.w,

              Expanded(
                child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      // return ContactCard(contacts:contacts[index] );
                      if (index == 0) {
                        return ButtonCard1(contacts: contacts[index]);
                      } else if (index == 1) {
                        return ButtonCard1(contacts: contacts[index]);
                      } else if (index == 2) {
                        return ButtonCard1(contacts: contacts[index]);
                      } else {
                        return ContactCard1(contacts: contacts[index]);
                      }
                    }),
              ),
        //   Container(height: 300,width: 300,color: Colors.blue,)
          ],
        ),
      ),
    );
  }
}

