import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/group_info_screen/participants.dart';
import 'package:gatello/views/tabbar/chats/pesrsonal_chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../select_contact.dart';
import 'group_info_list_model.dart';

class Group_Info extends StatefulWidget {
  const Group_Info({Key? key}) : super(key: key);

  @override
  State<Group_Info> createState() => _Group_InfoState();
}

class _Group_InfoState extends State<Group_Info> {

  List tileData = [];
  @override
  void initState() {
    super.initState();
    tileData = groupInfoListData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(

           color: Color.fromRGBO(12, 16, 29, 1)
        //   color: Colors.black
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 18.w, bottom: 19.h, top: 24.h
                // right: 18.w
                ),
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

                          Navigator.pop(context);
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
                  'Group Info',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ),
                SizedBox(height: 5.h),
                Text(
                  '260 Participants',
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
              
                  SizedBox(
                    width: 24.5.w,
                  ),
                 PopupMenuButton(  itemBuilder: (context) => [
                    PopupMenuItem(child: Column(
                  
                    children: [
                      Text('Report group',
                      style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(255, 0, 0, 1)))
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                       Text('Exit group',
                      style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(255, 0, 0, 1)))
                      ),
                    ],
                    )
                 
                     )
                    ],
                               
                               ),
                  SizedBox(
                    width: 18.w,
                  )
                ],
              ),
            ),
          ],
        ),
     
        body: Column(
          children: [

            Container(
       
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 280.h,
                child: Column(
                  children: [
                    SizedBox(height: 23.h),
          

            Container(

           height:80.h,
            width:80.w,
            child: Image(
              image: AssetImage(
                'assets/dp_image/dp_icon_male.png',
              ),

              fit: BoxFit.contain,
            ),
            decoration: BoxDecoration(

              shape: BoxShape.circle
            ),

          ),
                    SizedBox(height: 11.h),
                    Text(
                      'Name',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                    ),
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/group_info/calls.png',
                              ),
                              width: 42.w,
                            ),
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
                            Image(
                              image: AssetImage(
                                'assets/dp_image/dp_icon_male.png',
                              ),
                              width: 42.w,
                            ),
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
                            InkWell(
                              child: Image(
                                image: AssetImage(
                                  'assets/group_info/add contants.png',
                                ),
                                width: 42.w,
                              ),

                              onTap: (){

                                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SelectContact()));
                              },
                            ),
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
                        endIndent: 12.w)
                  ],
                ),
              ),
       
            ],
          ),
        ),

        Text('38 Participants',  style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(0, 163, 255, 1))),),

            Expanded(
              child: ListView.builder(
                  itemCount: tileData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                   
                      leading:
                    
                    
               Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(tileData[index].dp),
                              fit: BoxFit.cover)),),

                    
                      title: 
                          Text(
                            tileData[index].name,
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(0, 0, 0, 1))),
                          ),
                       
                         subtitle:  Text(
                            tileData[index].account,
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(0, 0, 0, 5))),
                              ),
                       
                      
                    );
                  }),
            ),
          ],
        ),    
      ),
    );
  }
}
