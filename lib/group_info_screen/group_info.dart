import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/group_info_screen/participants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Group_Info extends StatefulWidget {
  const Group_Info({Key? key}) : super(key: key);

  @override
  State<Group_Info> createState() => _Group_InfoState();
}

class _Group_InfoState extends State<Group_Info> {
  List listes = [Participants(name: 'Angelina', acount: 'Business acount')];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                  onTap: () {},
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
                  Image.asset('assets/group_info/search.png'),
                  SizedBox(
                    width: 24.5.w,
                  ),
                  Image.asset('assets/per_chat_icons/menu_icon.png'),
                  SizedBox(
                    width: 18.w,
                  )
                ],
              ),
            ),
          ],
        ),
        // body: Container(
        //   child: Column(
        //     children: [
        //       SizedBox(height: 23.h),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Container(
        //             height: 68.h,
        //             width: 68.w,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 image: DecorationImage(
        //                     image: AssetImage(
        //                         'assets/per_chat_icons/Group 752.png'),
        //                     fit: BoxFit.cover)),
        //           ),
        //         ],
        //       ),
        //       // SizedBox(height: 11.h),
        //       // Text(
        //       //   'Name',
        //       //   style: GoogleFonts.inter(
        //       //       textStyle: TextStyle(
        //       //           fontSize: 20.sp,
        //       //           fontWeight: FontWeight.w700,
        //       //           color: Colors.black)),
        //       // ),
        //       // SizedBox(height: 19.h),
        //       // Row(
        //       //   mainAxisAlignment: MainAxisAlignment.center,
        //       //   children: [
        //       //     Column(
        //       //       children: [
        //       //         Image(
        //       //           image: AssetImage(
        //       //             'assets/per_chat_icons/mic_icon.png',
        //       //           ),
        //       //           width: 42.w,
        //       //         ),
        //       //         SizedBox(height: 11.h),
        //       //         Text(
        //       //           'Call',
        //       //           style: GoogleFonts.inter(
        //       //               textStyle: TextStyle(
        //       //                   fontSize: 16.sp,
        //       //                   fontWeight: FontWeight.w700,
        //       //                   color: Colors.black)),
        //       //         ),
        //       //       ],
        //       //     ),
        //       //     SizedBox(width: 42.w),
        //       //     Column(
        //       //       children: [
        //       //         Image(
        //       //           image: AssetImage(
        //       //             'assets/per_chat_icons/mic_icon.png',
        //       //           ),
        //       //           width: 42.w,
        //       //         ),
        //       //         SizedBox(height: 11.h),
        //       //         Text(
        //       //           'Video',
        //       //           style: GoogleFonts.inter(
        //       //               textStyle: TextStyle(
        //       //                   fontSize: 16.sp,
        //       //                   fontWeight: FontWeight.w700,
        //       //                   color: Colors.black)),
        //       //         ),
        //       //       ],
        //       //     ),
        //       //     SizedBox(width: 42.w),
        //       //     Column(
        //       //       children: [
        //       //         Image(
        //       //           image: AssetImage(
        //       //             'assets/per_chat_icons/mic_icon.png',
        //       //           ),
        //       //           width: 42.w,
        //       //         ),
        //       //         SizedBox(height: 11.h),
        //       //         Text(
        //       //           'Add',
        //       //           style: GoogleFonts.inter(
        //       //               textStyle: TextStyle(
        //       //                   fontSize: 16.sp,
        //       //                   fontWeight: FontWeight.w700,
        //       //                   color: Colors.black)),
        //       //         ),
                
        //       //       ],
        //       //     )
        //       //   ],
        //       // ),
        //       // SizedBox(height: 29.h),
              
        //      Column(
        //         children: [
        //       //     Text(
        //       //       '38 Participants',
        //       //       style: GoogleFonts.inter(
        //       //           textStyle: TextStyle(
        //       //               fontSize: 14.sp,
        //       //               fontWeight: FontWeight.w700,
        //       //               color: HexColor('#00A3FF'))),
        //       //     ),
        //       //     SizedBox(height: 15.h),
        //       //     Spacer(),
        //           // Container(
                
        //           //   height: 100,
        //           //   color: Colors.green,
        //           //   child: ListView.builder(
        //           //       itemCount: listes.length,
        //           //       itemBuilder: (context, index) {
        //           //         return ListTile(
        //           //           leading: Image(
        //           //               image: NetworkImage(
        //           //                   'data:image/jpeg;base64,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')),
        //           //         );
        //           //       }),
        //           // )
        //         ],
        //       )
        //     ],
        //   ),
        // ),

        body: Container(


          child: Column(
children: [

     SizedBox(height: 23.h),
  Image.asset('assets/dp_image/dp_icon_male.png'),

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
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/per_chat_icons/mic_icon.png',
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
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/per_chat_icons/mic_icon.png',
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
                      Image(
                        image: AssetImage(
                          'assets/per_chat_icons/mic_icon.png',
                        ),
                        width: 42.w,
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

                SizedBox(height: 29.h),
                          Text(
                    '38 Participants',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: HexColor('#00A3FF'))),
                  ),
                  SizedBox(height: 15.h),
],

          ),
        ),
      ),
    );
  }
}
