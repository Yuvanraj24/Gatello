import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  bool changed = false;

  @override
  //TestHello
  Widget build(BuildContext context) {
    initSP();

    return SafeArea(
      child: DefaultTabController(
        initialIndex: 1,
        length: 5,
        child: SafeArea(
          child: Scaffold(
<<<<<<< HEAD
              appBar: changed == false
                  ? AppBar(
                      toolbarHeight: 79.h,
                      elevation: 20,
                      //  shadowColor: Colors.black,
                      // leading: Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Gatello',
                      //       style:
                      //           TextStyle(fontSize: 16.sp, color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                      actionsIconTheme:
                          IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
                      actions: [
=======
            appBar: AppBar(

              toolbarHeight: 79.h,
              elevation: 20,
              //  shadowColor: Colors.black,
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gatello',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                ],
              ),
              actionsIconTheme:
              IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
              actions: [
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                              AssetImage('assets/per_chat_icons/dp_image.png'),
                              fit: BoxFit.fitWidth)),
                    ),

                    SizedBox(width: 15.w,),
                    Image.asset('assets/group_info/search.png'),
                  ],
                ),
                // CircleAvatar(
                //     radius: 22.h,
                //     backgroundImage: NetworkImage(
                //         "https://c4.wallpaperflare.com/wallpaper/611/838/413/spiderman-hd-4k-superheroes-wallpaper-preview.jpg")),

                // GestureDetector(
                //     onTap: () {},
                //     child: Image.asset(
                //       "assets/icons_assets/search_icon.png",
                //       width: 14.w,
                //       height: 13.99.h,
                //     )),
                //SizedBox(width: 25.w),

                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton(

                      iconSize: 25.h,
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            child: Container(
                              width: 130.w,
                              child: Row(
                                children: [
                                  Image.asset(
                                      "assets/icons_assets/chat_icon_floating.png"),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Text("New Group",
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          )))
                                ],
                              ),
                            )),
                        PopupMenuItem(
                            child: Container(
                              width: 130.w,
                              child: Row(
                                children: [
                                  Image.asset(
                                      "assets/icons_assets/chat_icon_floating.png"),
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
                              ),
                            )),
                        PopupMenuItem(
                            child: Container(
                              width: 130.w,
                              child: Row(
                                children: [
                                  Image.asset(
                                      "assets/icons_assets/chat_icon_floating.png"),
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
                            )),
                        PopupMenuItem(
                            child: Container(
                              width: 130.w,
                              child: Row(
                                children: [
                                  Image.asset(
                                      "assets/icons_assets/chat_icon_floating.png"),
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
                              ),
                            ))
                      ]),
                ),
              ],
              bottom: TabBar(
                labelPadding: EdgeInsets.all(0),
                indicatorColor: Color.fromRGBO(255, 255, 255, 1),
                tabs: [
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                            image: AssetImage(
                                "assets/tabbar_icons/getit_icon.png")),
                        Text(
                          "Get it",
                          style: GoogleFonts.fredoka(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.w400)),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                            image: AssetImage(
                                "assets/tabbar_icons/pings_icon.png")),
>>>>>>> bbb46757159787ec2bc3272155e7e3c34769b57f
                        Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 35.w,
                              decoration: BoxDecoration(
<<<<<<< HEAD
                                  color: Colors.black,
=======
                                // borderRadius: BorderRadius.circular(15),
>>>>>>> bbb46757159787ec2bc3272155e7e3c34769b57f
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/per_chat_icons/dp_image.png'),
                                      fit: BoxFit.fitWidth)),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Image.asset('assets/group_info/search.png'),
                          ],
                        ),
                        // CircleAvatar(
                        //     radius: 22.h,
                        //     backgroundImage: NetworkImage(
                        //         "https://c4.wallpaperflare.com/wallpaper/611/838/413/spiderman-hd-4k-superheroes-wallpaper-preview.jpg")),

                        // GestureDetector(
                        //     onTap: () {},
                        //     child: Image.asset(
                        //       "assets/icons_assets/search_icon.png",
                        //       width: 14.w,
                        //       height: 13.99.h,
                        //     )),
                        //SizedBox(width: 25.w),

                        Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton(
                              iconSize: 25.h,
                              itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                        child: Container(
                                      width: 130.w,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/icons_assets/chat_icon_floating.png"),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Text("New Group",
                                              style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              )))
                                        ],
                                      ),
                                    )),
                                    PopupMenuItem(
                                        child: Container(
                                      width: 130.w,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/icons_assets/chat_icon_floating.png"),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Text("Linked devices",
                                              style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              )))
                                        ],
                                      ),
                                    )),
                                    PopupMenuItem(
                                        child: Container(
                                      width: 130.w,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/icons_assets/chat_icon_floating.png"),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Text("Invite friends",
                                              style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              )))
                                        ],
                                      ),
                                    )),
                                    PopupMenuItem(
                                        child: Container(
                                      width: 130.w,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/icons_assets/chat_icon_floating.png"),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Text("Settings",
                                              style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              )))
                                        ],
                                      ),
                                    ))
                                  ]),
                        ),
                      ],
                      bottom: TabBar(
                        labelPadding: EdgeInsets.all(0),
                        indicatorColor: Color.fromRGBO(255, 255, 255, 1),
                        tabs: [
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                    image: AssetImage(
                                        "assets/tabbar_icons/getit_icon.png")),
                                Text(
                                  "Get it",
                                  style: GoogleFonts.fredoka(
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                    image: AssetImage(
                                        "assets/tabbar_icons/pings_icon.png")),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Pings",
                                      style: GoogleFonts.fredoka(
                                          textStyle: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(15),
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      width: 15,
                                      height: 15,
                                      child: Center(
                                          child: Text("${5}",
                                              style: GoogleFonts.fredoka(
                                                  textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1))))),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                    image: AssetImage(
                                        "assets/tabbar_icons/pings_icon.png")),
                                Text(
                                  "Pops",
                                  style: GoogleFonts.fredoka(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                    image: AssetImage(
                                        "assets/tabbar_icons/status_icon.png")),
                                Text(
                                  "Status",
                                  style: GoogleFonts.fredoka(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                    image: AssetImage(
                                        "assets/tabbar_icons/call_icon.png")),
                                Text(
                                  "Calls",
                                  style: GoogleFonts.fredoka(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : AppBar(
                      toolbarHeight: 168.h,
                      centerTitle: false,
                      title: Column(
                        children: [
                          Row(
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
                          SizedBox(height: 14.h,),
                          Row(
                            children: [
                              // Container(
                              //   height: 31.h,
                              //   width: 81.w,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(30),
                              //       color: Color.fromRGBO(255, 255, 255, 1)),
                              //   child: Row(),
                              // )
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:Color.fromRGBO(255, 255, 255, 1) ,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      minimumSize: Size(81, 35)),
                                  onPressed: () {},
                                  child: Row(
                                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Icon(Icons.photo_size_select_actual_outlined,
                                      size: 18,color: Color.fromRGBO(167, 167, 167, 1)),
                                      SizedBox(width: 5.w,),
                                      // SvgPicture.asset(
                                      //     'assets/tabbar_icons/tab_view_main/chats_image/video_search.svg'),
                                      Text(
                                        'Photos',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8))),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 18.w,),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:Color.fromRGBO(255, 255, 255, 1) ,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      minimumSize: Size(81, 35)),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.videocam ,size: 20,color: Color.fromRGBO(167, 167, 167, 1)),
                                      SizedBox(width: 5.w,),
                                      // SvgPicture.asset(
                                      //     'assets/tabbar_icons/tab_view_main/chats_image/video_search.svg'),
                                      Text(
                                        'Videos',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8))),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 18.w,),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:Color.fromRGBO(255, 255, 255, 1) ,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      minimumSize: Size(81, 35)),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.link_sharp, size: 20,color: Color.fromRGBO(167, 167, 167, 1)),
                                      SizedBox(width: 5.w,),
                                      // SvgPicture.asset(
                                      //     'assets/tabbar_icons/tab_view_main/chats_image/video_search.svg'),
                                      Text(
                                        'Links',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8))),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          Row(


                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:Color.fromRGBO(255, 255, 255, 1) ,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      minimumSize: Size(81, 35)),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.gif_box_outlined, size: 20,color: Color.fromRGBO(167, 167, 167, 1)),
                                      SizedBox(width: 5.w,),
                                      // SvgPicture.asset(
                                      //     'assets/tabbar_icons/tab_view_main/chats_image/video_search.svg'),
                                      Text(
                                        'GIFs',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8))),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 18.w,),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:Color.fromRGBO(255, 255, 255, 1) ,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      minimumSize: Size(81, 35)),
                                  onPressed: () {},
                                  child: Row(
                                    children: [

                                      Icon(Icons.headphones_rounded, size: 20,color: Color.fromRGBO(167, 167, 167, 1)),
                                      SizedBox(width: 5.w,),
                                      // SvgPicture.asset(
                                      //     'assets/tabbar_icons/tab_view_main/chats_image/video_search.svg'),
                                      Text(
                                        'Audio',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8))),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 18.w,),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:Color.fromRGBO(255, 255, 255, 1) ,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      minimumSize: Size(81, 35)),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
SvgPicture.asset('assets/tabbar_icons/tab_view_main/chats_image/doc_search.svg', color: Color.fromRGBO(167, 167, 167, 1)),
                                      SizedBox(width: 5.w,),
                                     // Icon(Icons.videocam),
                                      // SvgPicture.asset(
                                      //     'assets/tabbar_icons/tab_view_main/chats_image/video_search.svg'),
                                      Text(
                                        'Documents',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.8))),
                                      ),
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
              // body: Container(
              //   padding: const EdgeInsets.all(8.0),
              //   color: Colors.blue,
              //   width: 200,
              //   height: 300,
              //   child: ContainedTabBarView(
              //     tabs: [
              //       TabBar(
              //         labelPadding: EdgeInsets.all(0),
              //         indicatorColor: Color.fromRGBO(255, 255, 255, 1),
              //         tabs: [
              //           Tab(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Image(
              //                     image: AssetImage(
              //                         "assets/tabbar_icons/getit_icon.png")),
              //                 Text(
              //                   "Get it",
              //                   style: GoogleFonts.fredoka(
              //                       textStyle: TextStyle(
              //                           color: Color.fromRGBO(0, 0, 0, 1),
              //                           fontWeight: FontWeight.w400)),
              //                 )
              //               ],
              //             ),
              //           ),
              //           Tab(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Image(
              //                     image: AssetImage(
              //                         "assets/tabbar_icons/pings_icon.png")),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Text(
              //                       "Pings",
              //                       style: GoogleFonts.fredoka(
              //                           textStyle: TextStyle(
              //                               color: Color.fromRGBO(0, 0, 0, 1),
              //                               fontWeight: FontWeight.w400)),
              //                     ),
              //                     SizedBox(width: 5),
              //                     Container(
              //                       decoration: BoxDecoration(
              //                           // borderRadius: BorderRadius.circular(15),
              //                           shape: BoxShape.circle,
              //                           color: Colors.white),
              //                       width: 15,
              //                       height: 15,
              //                       child: Center(
              //                           child: Text("${5}",
              //                               style: GoogleFonts.fredoka(
              //                                   textStyle: TextStyle(
              //                                       fontSize: 12,
              //                                       fontWeight: FontWeight.w400,
              //                                       color: Color.fromRGBO(
              //                                           0, 0, 0, 1))))),
              //                     ),
              //                   ],
              //                 )
              //               ],
              //             ),
              //           ),
              //           Tab(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Image(
              //                     image: AssetImage(
              //                         "assets/tabbar_icons/pings_icon.png")),
              //                 Text(
              //                   "Pops",
              //                   style: GoogleFonts.fredoka(
              //                       textStyle: TextStyle(
              //                           color: Color.fromRGBO(0, 0, 0, 1),
              //                           fontWeight: FontWeight.w400)),
              //                 )
              //               ],
              //             ),
              //           ),
              //           Tab(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Image(
              //                     image: AssetImage(
              //                         "assets/tabbar_icons/status_icon.png")),
              //                 Text(
              //                   "Status",
              //                   style: GoogleFonts.fredoka(
              //                       textStyle: TextStyle(
              //                           color: Color.fromRGBO(0, 0, 0, 1),
              //                           fontWeight: FontWeight.w400)),
              //                 )
              //               ],
              //             ),
              //           ),
              //           Tab(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Image(
              //                     image: AssetImage(
              //                         "assets/tabbar_icons/call_icon.png")),
              //                 Text(
              //                   "Calls",
              //                   style: GoogleFonts.fredoka(
              //                       textStyle: TextStyle(
              //                           color: Color.fromRGBO(0, 0, 0, 1),
              //                           fontWeight: FontWeight.w400)),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //     views: [
              //       TabBarView(
              //         children: [
              //           Center(
              //             child: Text("Get it...!"),
              //           ),
              //           PingsChatView(),
              //           Center(
              //             child: Text("Pops...!"),
              //           ),
              //           Center(
              //             child: Text("Status...!"),
              //           ),
              //           Center(
              //             child: Text("Calls...!"),
              //           ),
              //         ],
              //       ),
              //     ],
              //     onChange: (index) => print(index),
              //   ),
              // ),
              body: TabBarView(
                children: [
                  Center(
                    child: Text("Get it...!"),
                  ),
                  PingsChatView(),
                  Center(
                    child: Text("Pops...!"),
                  ),
                  Center(
                    child: Text("Status...!"),
                  ),
                  Center(
                    child: Text("Calls...!"),
                  ),
                ],
              ),
              ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  void initSP() async {
=======
  void initSP()
  async {
>>>>>>> bbb46757159787ec2bc3272155e7e3c34769b57f
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.getString("email");
    Fluttertoast.showToast(
        msg: prefs.getString("email").toString(),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }
}